import os
import re
import csv
import spacy
import ONET_tools as onet
import DOT_parsers as dot
import importlib
importlib.reload(onet)
importlib.reload(dot)
from spacy.matcher import PhraseMatcher
from spacy.tokens import Span

#nlp = spacy.load('en_core_web_md')
#nlp = spacy.load('en')

class EntityMatcher(object):
    def __init__(self, nlp, terms, label, name='entity_matcher'):
        self.name = name
        patterns_all = [nlp(text) for text in terms]
        patterns = []
        for p in patterns_all:
            if len(p) < 10:
                patterns.append(p)
            else:
                print('removing', label, p, len(p))
        self.matcher = PhraseMatcher(nlp.vocab)
        self.matcher.add(label, None, *patterns)

    def __call__(self, doc):
        matches = self.matcher(doc)
        for match_id, start, end in matches:
            span = Span(doc, start, end, label=match_id)
            print(doc.ents)
            doc.ents = list(doc.ents) + [span]
            print(doc.ents)
        return doc

#terms = [v for v in lt2t.values() if len(v.split())<=10]
#entity_matcher = EntityMatcher(nlp, terms, 'COMMODITY_TITLE')

#nlp.add_pipe(entity_matcher, after='ner')

def lemmatize_text(text, nlp, remove_stop=False):
    doc = nlp(text)
    lemmas = []
    for token in doc:
        if remove_stop and token.is_stop:
            continue
        lemmas.append(token.lemma_)
    return ' '.join(lemmas)

#lt2t = {t: ta.lemmatize_text(t, nlp) for t in t2t}
#lt2x = {t: ta.lemmatize_text(t, nlp) for t in t2x}

def prepare_job_definition(definition, title):
    newtitle = title.replace(',' , ':').replace(' ' , '_')
    txt = definition.replace(':', '.')
    allsent = [s.strip().lower() for s in txt.split('. ')]
    all_sentences = [(newtitle + ' ' + s + '.') for s in allsent if len(s)>0]
    revised_definition = '  '.join(all_sentences).replace('..', '.')
    return revised_definition

def get_nouns_from_definition(definition, title, nlp):
    nouns = set()
    doc = nlp(definition)
    for token in doc:
        if token.tag_ in ['NN', 'NNS', 'NNP', 'NNPS']:
            if token.text != title: nouns.add(token.text)
    return nouns

def match_definition_to_commodity_titles_v0(dot91record, lemma_t2t, nlp):
    r = dot91record
    matches = []
    jdef = prepare_job_definition(dot91record['Definition'], dot91record['DOT Title'])
    jdef = lemmatize_text(jdef, nlp)
    for ctitle in lemma_t2t.values():
        for elem in ctitle.split():
            res = re.search(r'\b{}\b'.format(elem), jdef)
            if res:
                matches.append((ctitle, elem))
    if len(matches) > 0:
        return {(r['DOT Title'], r['Document Number']): matches}
    else:
        return None
    
def match_definition_to_commodity_titles(dot91record, lemma_terms, nlp):
    r = dot91record
    matches = []
    jdef = prepare_job_definition(dot91record['Definition'], dot91record['DOT Title'])
    jdef = lemmatize_text(jdef, nlp)
    for term in lemma_terms.values():
        res = re.search(r'\b{}\b'.format(term), jdef)
        if res:
            matches.append(term)
    if len(matches) > 0:
        return {(r['DOT Title'], r['Document Number']): matches}
    else:
        return None
    
def prepare_nlp_for_entity_matching(base, terms):
    nlp = spacy.load(base, disable=['ner'])
    after = 'tagger'
    for term_type, term_entries in terms.items():
        ematch = EntityMatcher(nlp, term_entries, term_type,
                                   name='matcher_'+term_type)
        nlp.add_pipe(ematch, after=after)
        after = 'matcher_'+term_type
    return nlp
    


def match_definition_to_commodity_titles_entity(dot91record, nlp):
    r = dot91record
    matches = set()
    jdef = prepare_job_definition(dot91record['Definition'], dot91record['DOT Title'])
    jdef = lemmatize_text(jdef, nlp)
    jdef = r['Definition']
    doc = nlp(jdef)
    matches = set([ent.text for ent in doc.ents if ent.label_=='COMMODITY_TITLE'])
    if len(matches) > 0:
        #return {(r['DOT Title'], r['Document Number']): matches}
        return matches
    else:
        return None

def match_definition_to_entity(dot91record, nlp):
    r = dot91record
    matches = {}
    jdef = prepare_job_definition(dot91record['Definition'], dot91record['DOT Title'])
    jdef = lemmatize_text(jdef, nlp)
    #jdef = r['Definition']
    doc = nlp(jdef)
    matchers = [n for n in nlp.pipe_names if n.startswith('matcher_')]
    for m in matchers:
        entity = m[len('matcher_'):]
        matchset = set([ent.text for ent in doc.ents if ent.label_==entity])
        if len(matchset) > 0:
            matches[entity] = matchset
    if len(matches) > 0:
        return matches
    else:
        return None
    
def match_all_definitions_to_entities(allj, nlp, maxnum=None):
    count = 0
    matches = {}
    for v in allj.values():
        if (maxnum is not None) and (count > maxnum):
            return matches
        result = match_definition_to_entity(v, nlp)
        if result:
            matches[(v['Document Number'], v['DOT Title'])] = result
        else:
            matches[(v['Document Number'], v['DOT Title'])] = None
        count += 1
    return matches

def match_definition_to_terms0(dot91record, lemma_terms, nlp, last_word=False,
                                  verbose=False):
    r = dot91record
    matches = set()
    jdef = prepare_job_definition(dot91record['Definition'], dot91record['DOT Title'])
    jdef = lemmatize_text(jdef, nlp)
    for term in lemma_terms:
        res = re.search(r'\b{}\b'.format(term), jdef)
        if res:
            matches.add(term)
        if last_word:
            words = term.split()
            last = words[-1]
            if last not in lemma_terms:
                res = re.search(r'\b{}\b'.format(words[-1]), jdef)
                if res:
                    print(term, words[-1])
                    matches.add(words[-1])
    if len(matches) > 0:
        if verbose: print({(r['DOT Title'], r['Document Number']): matches})
        return {(r['DOT Title'], r['Document Number']): matches}
    else:
        return None

def match_definition_to_terms(dot91record, lemma_terms, patterns, nlp, last_word=False,
                                  verbose=False):
    r = dot91record
    matches = set()
    jdef = prepare_job_definition(dot91record['Definition'], dot91record['DOT Title'])
    jdef = lemmatize_text(jdef, nlp)
    for term in lemma_terms:
        res = re.search(patterns[term], jdef)
        if res:
            matches.add(term)
        if last_word:
            words = term.split()
            last = words[-1]
            if last not in lemma_terms:
                res = re.search(r'\b{}\b'.format(words[-1]), jdef)
                if res:
                    print(term, words[-1])
                    matches.add(words[-1])
    if len(matches) > 0:
        if verbose: print({(r['DOT Title'], r['Document Number']): matches})
        #return {(r['DOT Title'], r['Document Number']): matches}
        return matches
    else:
        return None
    
def match_all_definitions_to_terms(allj, terms, nlp, maxnum=None, verbose=False):
    count = 0
    matches = {}
    patterns = {}
    for term in terms:
        patterns[term] = re.compile(r'\b{}\b'.format(term))
    for v in allj.values():
        if (maxnum is not None) and (count > maxnum):
            return matches
        result = match_definition_to_terms(v, terms, patterns, nlp, verbose=verbose)
        if result:
            matches[(v['DOT Title'], v['Document Number'])] = result
        else:
            matches[(v['DOT Title'], v['Document Number'])] = None
        count += 1
    return matches


def get_CommodityCodeTitle_from_term(df, term, term_lmap, term_type):
    #res = df[df[term_type].str.lower()==term_lmap[term]][['Commodity_Code', 'Commodity_Title']]
    res = df[df[term_type]==term_lmap.get(term,'MISSING')][['Commodity_Code', 'Commodity_Title']]
    if len(res) == 0:
        return [None, None]
    res = list(res.values[0])
    return res

def get_CommodityCodeTitle_from_terms(df, terms, term_lmap, term_type):
    commodities = []
    if terms is None:
        return commodities
    for term in terms:
        res = get_CommodityCodeTitle_from_term(df, term, term_lmap, term_type)
        commodities.append(res)
    return commodities

def remove_duplicate_terms(lt2t, lt2x, lt2tlast, lt2xlast):
    lt2tlast_ = lt2tlast.copy()
    lt2xlast_ = lt2xlast.copy()
    for term in lt2tlast_:
        if (term in lt2t) or (term in lt2x):
            lt2tlast.remove(term)
    for term in lt2xlast_:
        if (term in lt2t) or (term in lt2x) or (term in lt2tlast_):
            lt2xlast.remove(term)


def write_term_matches(allj, dft2, cxmatches, lt2x, ctmatches, lt2t,
                           cxlmatches, lt2xlast_dict, ctlmatches, lt2tlast_dict,
                           filename, include_def=True):
    count = 0
    f = open(filename, 'w')
    for jk in allj:
        f.write('{}\t{}\n'.format(jk, allj[jk]['DOT Title']))
        if include_def:
            f.write('{}\n'.format(allj[jk]['Definition']))
        k = (allj[jk]['DOT Title'], jk)
        match = False
        if cxmatches[k] is not None:
            ms = cxmatches[k]
            for m in ms:
                comm = get_CommodityCodeTitle_from_term(dft2, m, lt2x, 'T2_Example')
                f.write('X\t{}\t{}\t{}\n'.format(m, comm[0], comm[1]))
                match = True
        if ctmatches[k] is not None:
            ms = ctmatches[k]
            for m in ms:
                comm = get_CommodityCodeTitle_from_term(dft2, m, lt2t, 'Commodity_Title')
                f.write('T\t{}\t{}\t{}\n'.format(m, comm[0], comm[1]))
                match = True
        if cxlmatches[k] is not None:
            ms = cxlmatches[k]
            for m in ms:
                for src in lt2xlast_dict[m]:
                    comm = get_CommodityCodeTitle_from_term(dft2, src, lt2x, 'T2_Example')
                    f.write('Xl\t{}\t{}\t{}\t{}\n'.format(m, src, comm[0], comm[1]))
                    match = True
        if ctlmatches[k] is not None:
            ms = ctlmatches[k]
            for m in ms:
                for src in lt2tlast_dict[m]:
                    comm = get_CommodityCodeTitle_from_term(dft2, src, lt2t, 'Commodity_Title')
                    f.write('Tl\t{}\t{}\t{}\t{}\n'.format(m, src, comm[0], comm[1]))
                    match = True
        if not match:
            f.write('NO MATCHES\n')
        f.write('\n')
        count += 1
        if count>10:
            break
    f.close()

def write_term_matches_to_csv_0(allj, dft2, cxmatches, lt2x, ctmatches, lt2t,
                            cxlmatches, lt2xlast_dict, ctlmatches, lt2tlast_dict,
                            filename, include_def=True):
    count = 0
    f = open(filename, 'w')
    writer = csv.writer(f)
    header = ['Document Number', 'DOT Title', 'term', 'full_term', 'term_type',
                  'Commodity Code', 'Commodity Title']
    writer.writerow(header)
    for jk in sorted(allj):
        print(jk)
        row_base = [jk, allj[jk]['DOT Title']]
        row = [jk, allj[jk]['DOT Title']]
        k = (allj[jk]['DOT Title'], jk)
        matches = []
        if ctmatches[k] is not None:
            ms = ctmatches[k]
            for m in ms:
                comm = get_CommodityCodeTitle_from_term(dft2, m, lt2t, 'Commodity_Title')
                matches.append([m, m, 'Commodity_Title', comm[0], comm[1]])
        if cxmatches[k] is not None:
            ms = cxmatches[k]
            for m in ms:
                comm = get_CommodityCodeTitle_from_term(dft2, m, lt2x, 'T2_Example')
                matches.append([m, m, 'T2_Example', comm[0], comm[1]])
        if ctlmatches[k] is not None:
            ms = ctlmatches[k]
            for m in ms:
                if m in lt2tlast_dict:
                    for src in lt2tlast_dict[m]:
                        comm = get_CommodityCodeTitle_from_term(dft2, src, lt2t, 'Commodity_Title')
                        matches.append([m, src, 'Commodity_Title_last', comm[0], comm[1]])
                else:
                    print(m)
        if cxlmatches[k] is not None:
            ms = cxlmatches[k]
            for m in ms:
                if m in lt2xlast_dict:
                    for src in lt2xlast_dict[m]:
                        comm = get_CommodityCodeTitle_from_term(dft2, src, lt2x, 'T2_Example')
                        matches.append([m, src, 'T2_Example_last', comm[0], comm[1]])
                else:
                    print(m)
        if len(matches) == 0:
            row.extend([None, None, None, None])
            writer.writerow(row)
            continue
        else:
            for match in matches:
                row = row_base.copy()
                row.extend(match)
                writer.writerow(row)                
        count += 1
        if count>100:
            break
    f.close()

def write_term_matches_to_csv_1(allj, dft2, cxmatches, lt2x, ctmatches, lt2t,
                            cxlmatches, lt2xlast_dict, ctlmatches, lt2tlast_dict,
                            filename, include_last=True, include_def=True):
    count = 0
    f = open(filename, 'w')
    writer = csv.writer(f)
    header = ['Document Number', 'DOT Title', 'term', 'term_type',
                  'Commodity Code', 'Commodity Title', 'Num_Possible_Comm_Titles']
    writer.writerow(header)
    for jk in sorted(allj):
        print(jk)
        row_base = [jk, allj[jk]['DOT Title']]
        row = [jk, allj[jk]['DOT Title']]
        k = (allj[jk]['DOT Title'], jk)
        matches = []
        if ctmatches[k] is not None:
            ms = ctmatches[k]
            for m in ms:
                comm = get_CommodityCodeTitle_from_term(dft2, m, lt2t, 'Commodity_Title')
                matches.append([m, 'Commodity_Title', comm[0], comm[1], 1])
        if cxmatches[k] is not None:
            ms = cxmatches[k]
            for m in ms:
                comm = get_CommodityCodeTitle_from_term(dft2, m, lt2x, 'T2_Example')
                matches.append([m, 'T2_Example', comm[0], comm[1], 1])
        if include_last and (ctlmatches[k] is not None):
            ms = ctlmatches[k]
            for m in ms:
                if m in lt2tlast_dict:
                    num_possible = len(lt2tlast_dict[m])
                    if num_possible == 1:
                        src = lt2tlast_dict[m][0]
                        comm = get_CommodityCodeTitle_from_term(dft2, src, lt2t, 'Commodity_Title')
                        matches.append([m, 'Commodity_Title_last', comm[0], comm[1], 1])
                    else:
                        matches.append([m, 'Commodity_Title_last', None, None, num_possible])
                    #for src in lt2tlast_dict[m]:
                    #    comm = get_CommodityCodeTitle_from_term(dft2, src, lt2t, 'Commodity_Title')
                    #    matches.append([m, src, 'Commodity_Title_last', comm[0], comm[1]])
                else:
                    print(m)
        if include_last and (cxlmatches[k] is not None):
            ms = cxlmatches[k]
            for m in ms:
                if m in lt2xlast_dict:
                    num_possible = len(lt2xlast_dict[m])
                    if num_possible == 1:
                        src = lt2xlast_dict[m][0]
                        comm = get_CommodityCodeTitle_from_term(dft2, src, lt2x, 'T2_Example')
                        matches.append([m, 'T2_Example_last', comm[0], comm[1], 1])
                    else:
                        matches.append([m, 'T2_Example_last', None, None, num_possible])
                    #for src in lt2xlast_dict[m]:
                    #    comm = get_CommodityCodeTitle_from_term(dft2, src, lt2x, 'T2_Example')
                    #    matches.append([m, src, 'T2_Example_last', comm[0], comm[1]])
                else:
                    print(m)
        if len(matches) == 0:
            row.extend([None, None, None, None])
            writer.writerow(row)
            continue
        else:
            for match in matches:
                row = row_base.copy()
                row.extend(match)
                writer.writerow(row)                
        count += 1
        #if count>10:
        #    break
    f.close()

def write_term_matches_to_csv(allj, dft2e, dfcw, cxmatches, lt2x, ilt2x, ctmatches, lt2t, ilt2t, 
                            cxlmatches, lt2xlast_dict, ctlmatches, lt2tlast_dict,
                            filename, include_last=True, include_def=True):
    count = 0
    f = open(filename, 'w')
    writer = csv.writer(f)
    header = ['Document Number', 'DOT Title', 'term', 'full_term', 'term_type',
                  'Commodity Code', 'Commodity Title', 'Num_Possible_Comm_Titles', 'In_CW_T2']
    writer.writerow(header)
    for jk in sorted(allj):
        print(jk)
        subframe = onet.get_dft2e_subframe_for_DOT_from_cw(allj[jk]['DOT Code'], dft2e, dfcw)
        if subframe is not None:
            subframe_CoT = set([ilt2x.get(t,None) for t in subframe['Commodity_Title']])
            subframe_T2x = set([ilt2x.get(t,None) for t in subframe['T2_Example']])
        else:
            subframe_CoT = set()
            subframe_T2x = set()
        row_base = [jk, allj[jk]['DOT Title']]
        row = [jk, allj[jk]['DOT Title']]
        k = (allj[jk]['DOT Title'], jk)
        matches = []
        if ctmatches[k] is not None:
            ms = ctmatches[k]
            for m in ms:
                comm = get_CommodityCodeTitle_from_term(dft2e, m, lt2t, 'Commodity_Title')
                if m in subframe_CoT:
                    in_cw_t2 = 1
                else:
                    in_cw_t2 = 0
                matches.append([m, m, 'Commodity_Title', comm[0], comm[1], 1, in_cw_t2])
        if cxmatches[k] is not None:
            ms = cxmatches[k]
            for m in ms:
                comm = get_CommodityCodeTitle_from_term(dft2e, m, lt2x, 'T2_Example')
                if m in subframe_T2x:
                    in_cw_t2 = 1
                else:
                    in_cw_t2 = 0
                matches.append([m, m, 'T2_Example', comm[0], comm[1], 1, in_cw_t2])
        if include_last and (ctlmatches[k] is not None):
            ms = ctlmatches[k]
            for m in ms:
                if m in lt2tlast_dict:
                    num_possible = len(lt2tlast_dict[m])
                    #if num_possible == 1:
                    #    src = lt2tlast_dict[m][0]
                    #    comm = get_CommodityCodeTitle_from_term(dft2e, src, lt2t, 'Commodity_Title')
                    #    matches.append([m, 'Commodity_Title_last', comm[0], comm[1], 1])
                    #else:
                    #    matches.append([m, 'Commodity_Title_last', None, None, num_possible])
                    for src in lt2tlast_dict[m]:
                        comm = get_CommodityCodeTitle_from_term(dft2e, src, lt2t, 'Commodity_Title')
                        if src in subframe_CoT:
                            in_cw_t2 = 1
                        else:
                            in_cw_t2 = 0
                        matches.append([m, src, 'Commodity_Title_last', comm[0], comm[1], num_possible, in_cw_t2])
                else:
                    print(m)
        if include_last and (cxlmatches[k] is not None):
            ms = cxlmatches[k]
            for m in ms:
                if m in lt2xlast_dict:
                    num_possible = len(lt2xlast_dict[m])
                    #if num_possible == 1:
                    #    src = lt2xlast_dict[m][0]
                    #    comm = get_CommodityCodeTitle_from_term(dft2e, src, lt2x, 'T2_Example')
                    #    matches.append([m, 'T2_Example_last', comm[0], comm[1], 1])
                    #else:
                    #    matches.append([m, 'T2_Example_last', None, None, num_possible])
                    for src in lt2xlast_dict[m]:
                        comm = get_CommodityCodeTitle_from_term(dft2e, src, lt2x, 'T2_Example')
                        if src in subframe_T2x:
                            in_cw_t2 = 1
                        else:
                            in_cw_t2 = 0
                        matches.append([m, src, 'T2_Example_last', comm[0], comm[1], num_possible, in_cw_t2])
                else:
                    print(m)
        if len(matches) == 0:
            row.extend([None, None, None, None])
            writer.writerow(row)
            continue
        else:
            for match in matches:
                row = row_base.copy()
                row.extend(match)
                writer.writerow(row)                
        count += 1
        #if count>100:
        #    break
    f.close()



#terms = [v for v in lt2t.values() if len(v.split())<=10]
#entity_matcher = EntityMatcher(nlp, terms, 'COMMODITY_TITLE')

#nlp.add_pipe(entity_matcher, after='ner')

#lterms  = [v for v in lt2t.values() if len(v.split())<10]
#lxterms = [v for v in lt2x.values() if len(v.split())<10]
#nlpe = ta.prepare_nlp_for_entity_matching('en', {'COMMODITY_TITLE': lterms, 'T2_EXAMPLE': lxterms})
#ct3 = ta.match_all_definitions_to_commodity_titles(allj91, nlpe, 100)
