import DOT_parsers as dot
import importlib
import pandas as pd, numpy as np
import re

# need to merge Tools and Technology.txt with Titles in Occupation Data.txt

"""
dft2 = read_onet_t2()
t2x = get_T2_Examples(dft2)
t2t = get_T2_Commodity_Titles(dft2)
lt2t = {ta.lemmatize_text(t, nlp): t for t in t2t}
lt2x = {ta.lemmatize_text(t, nlp): t for t in t2x}
"""

#https://www.onetonline.org/crosswalk/DOT?s=709684022&g=Go

def read_onet_t2(filename = 'data/ONet/db_23_0_text/Tools and Technology.txt'):
    dft2 = pd.read_table(filename).rename(index=str,
                columns={'O*NET-SOC Code': 'OSC', 'T2 Type': 'T2_Type', 'T2 Example': 'T2_Example', 
                'Commodity Code': 'Commodity_Code', 'Commodity Title': 'Commodity_Title', 
                'Hot Technology': 'Hot_Technology'})
    dft2 = dft2[dft2.T2_Type=='Tools']
    return dft2

def read_onet_occdata(filename='data/ONet/db_23_0_text/Occupation Data.txt'):
    dfocc = pd.read_table(filename).rename(index=str, columns={'O*NET-SOC Code': 'OSC'})
    dfocc['soccode'] = dfocc.OSC.apply(lambda c: c[0:7])
    return dfocc

def read_dot_onet_crosswalk(filename='data/dotsoc10.xls'):
    dfcw = pd.read_excel(filename)
    #dfcw['OSC'] = dfcw.soccode.apply(lambda c: c+'.00')
    return dfcw

def enhance_T2_examples(dft2, dfocc):
    dft2e = dft2.copy()
    dft2e['soccode'] = dft2e.OSC.apply(lambda c: c[0:7])
    dft2e = pd.merge(dft2e, dfocc[['soccode', 'Title']])
    return dft2e

def get_T2_Examples(dft2):
    #t2_examples = [x.lower() for x in dft2[dft2.T2_Type=='Tools']['T2_Example'].unique()]
    t2_examples = [x for x in dft2[dft2.T2_Type=='Tools']['T2_Example'].unique()]
    return t2_examples

def get_T2_Commodity_Titles(dft2):
    #t2_ctitles = [x.lower() for x in dft2[dft2.T2_Type=='Tools']['Commodity_Title'].unique()]
    t2_ctitles = [x for x in dft2[dft2.T2_Type=='Tools']['Commodity_Title'].unique()]
    return t2_ctitles
    
def get_dft2e_subframe_for_DOT_from_cw(dotcode, dft2e, dfcw):
    try:
        subframe = dft2e[dft2e.soccode==dfcw[dfcw.dotcode==dot.to_dot_code(dotcode)]['soccode'].iloc[0]]
    except IndexError:
        subframe = None
    return subframe

def get_dft2e_subframe_for_DOT_from_cw_short(shortdotcode, dft2e, dfcw):
    try:
        subframe = dft2e[dft2e.soccode.isin(dfcw[dfcw.DOT1991==shortdotcode]['soccode'])]
    except IndexError:
        subframe = None
    return subframe

def In_CW_T2_new(commodity_code,shortdotcode,dft2e,dfcw):
    if np.isnan(commodity_code):
        return 0
    ccode = int(commodity_code)
    dcode = int(shortdotcode)
    subframe = get_dft2e_subframe_for_DOT_from_cw_short(dcode, dft2e, dfcw)
    if subframe is None:
        return 0
    return int(ccode in set(subframe.Commodity_Code))

def get_last_words_from_terms_v0(terms, nlp):
    last = set()
    for t in terms:
        #tdoc = nlp(t)
        tdoc = t.split()
        last.add(tdoc[-1])
    return last

to_remove = ['machine', 'accessory', 'equipment', 'system', 'kit', 'analyzer', 'unit', 'tool', 'device', 'supply', 'apparatus', 'meter', 'instrument', 'machinery', 'therapy', 'recorder', 'challenge', 'use', 'tester', 'set', 'product', 'component', 'console']

def get_last_words_from_terms(terms, nlp, nouns_only=False, to_remove=None):
    if to_remove is None:
        to_remove = []
    last_dict = {}
    for t in terms:
        doc = nlp(t)
        lw = doc[-1]
        if nouns_only and lw.tag_ not in ['NN', 'NNS', 'NNP', 'NNPS']:
            continue
        strlw = str(lw)
        if strlw in to_remove:
            continue
        if strlw not in last_dict:
            last_dict[strlw] = []
        last_dict[strlw].append(t)
    return last_dict


def match_stemmed_word_to_stemmed_tools(word_s_word, tools_s_tools):
    hits = []
    word, s_word = word_s_word
    for t in tools_s_tools.values():
        res = re.search(r'\b{}\b'.format(s_word),t)
        if res:
            hits.append(t)
    return hits

def match_stemmed_word_to_stemmed_candidates(word, candidates):
    hits = []
    for c in candidates:
        res = re.search(r'\b{}\b'.format(word), c)
        if res:
            hits.append(c)
    return hits


def get_term_hierarchies(terms):
    hierarchies = {}
    for t1 in terms:
        t1l = t1.lower()
        for t2 in terms:
            if t1 >= t2:
                continue
            t2l = t2.lower()
            if re.search(r'\b{}'.format(t1l), t2l):
                if t1l not in hierarchies:
                    hierarchies[t1l] = []
                hierarchies[t1l].append(t2l)
            elif re.search(r'\b{}'.format(t2l), t1l):
                if t2l not in hierarchies:
                    hierarchies[t2l] = []
                hierarchies[t2l].append(t1l)
    return hierarchies

def get_term_hierarchies(terms):
    hierarchies = {}
    for t1 in terms:
        t1l = t1.lower()
        for t2 in terms:
            if t1 >= t2:
                continue
            t2l = t2.lower()
            if t1l in t2l:
                if re.search(r'\b{}'.format(t1l), t2l):
                    if t1l not in hierarchies:
                        hierarchies[t1l] = []
                    hierarchies[t1l].append(t2l)
            elif t2l in t1l:
                if re.search(r'\b{}'.format(t2l), t1l):
                    if t2l not in hierarchies:
                        hierarchies[t2l] = []
                    hierarchies[t2l].append(t1l)
    return hierarchies



    
