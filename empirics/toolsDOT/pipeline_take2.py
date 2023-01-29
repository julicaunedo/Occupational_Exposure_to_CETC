import DOT_parsers as dot
import ONET_tools as onet
import text_analysis as ta
import spacy
import pickle
import importlib
importlib.reload(dot)
importlib.reload(onet)
importlib.reload(ta)

#nlp = spacy.load('en')
nlp = spacy.load('en_core_web_sm')

# list of words to exclude from _last filter set based on nonspecificity of terms

to_remove = ['machine', 'accessory', 'equipment', 'system', 'kit', 'analyzer', 'unit', 'tool', 'device', 'supply', 'apparatus', 'meter', 'instrument', 'machinery', 'therapy', 'recorder', 'challenge', 'use', 'tester', 'set', 'product', 'component', 'console', 'work', 'surface', 'procedure', 'test', 'facility', 'plant', 'application', 'assist', 'chart', 'material', 'standard', 'assembly', 'environment']

# parse the relevant data files and build data structures for term matching

allj91 = dot.parse_DOT91()
dft2  = onet.read_onet_t2()
dfocc = onet.read_onet_occdata()
dft2e = onet.enhance_T2_examples(dft2, dfocc)
dfcw  = onet.read_dot_onet_crosswalk()
t2x    = onet.get_T2_Examples(dft2)
t2t    = onet.get_T2_Commodity_Titles(dft2)
lt2t   = {ta.lemmatize_text(t, nlp): t for t in t2t}
lt2x   = {ta.lemmatize_text(t, nlp): t for t in t2x}
ilt2t  = {t:lt for lt,t in lt2t.items()}
ilt2x  = {t:lt for lt,t in lt2x.items()}
lt2xlast_dict = onet.get_last_words_from_terms(lt2x, nlp, nouns_only=True, to_remove=to_remove)
lt2tlast_dict = onet.get_last_words_from_terms(lt2t, nlp, nouns_only=True, to_remove=to_remove)
lt2xlast = set(lt2xlast_dict.keys())
lt2tlast = set(lt2tlast_dict.keys())

# match definitions to terms (slow)

cxmatches = ta.match_all_definitions_to_terms(allj91, lt2x, nlp, verbose=False)
ctmatches = ta.match_all_definitions_to_terms(allj91, lt2t, nlp, verbose=False)
cxlmatches = ta.match_all_definitions_to_terms(allj91, lt2xlast, nlp, verbose=False)
ctlmatches = ta.match_all_definitions_to_terms(allj91, lt2tlast, nlp, verbose=False)

# write matches to intermediate csv based on old crosswalk (cw)

ta.write_term_matches_to_csv(allj91, dft2e, dfcw, cxmatches, lt2x, ilt2x, ctmatches, lt2t, ilt2t, cxlmatches, lt2xlast_dict, ctlmatches, lt2tlast_dict,'DOT91_term_matches_full_take2_oldcw.csv', include_last=True, include_def=False)

import reassociate_crosswalk_with_terms as reassoc

# write matches to updated csv based on updated crosswalk

dff, dff_missing = reassoc.rewrite_term_match_file('DOT91_term_matches_full_take2_oldcw.csv', 'DOT91_term_matches_full_take2_updatedcw.csv', reassoc.dfcw, reassoc.dot_mapping)

# filter full match file for subset with In_CW_T2=1 (matching in updated crosswalk)

import pandas as pd

dffull = pd.read_csv('DOT91_term_matches_full_take2_updatedcw.csv', dtype={'Document Number': str, 'Commodity Code': str})
dffull_incw = dffull[dffull['In_CW_T2']==1]
dffull_incw.to_csv('DOT91_term_matches_full_take2_updatedcw_incw.csv', index=False) 
