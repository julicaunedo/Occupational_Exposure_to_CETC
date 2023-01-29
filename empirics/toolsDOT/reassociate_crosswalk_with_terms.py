import pandas as pd

import DOT_parsers as dot
import ONET_tools as onet
import importlib
importlib.reload(dot)
importlib.reload(onet)

allj91 = dot.parse_DOT91()
dfocc = onet.read_onet_occdata()
dft2  = onet.read_onet_t2()
dft2e = onet.enhance_T2_examples(dft2, dfocc)
dfcw = pd.read_csv('data/merged_all_occ_crosswalks.csv')

def map_DOT_Titles_to_DOT_codes(allj91):
    mapping = {}
    for k,v in allj91.items():
        mapping[v['DOT Title']] = v['DOT Code']
    return mapping

dot_mapping = map_DOT_Titles_to_DOT_codes(allj91)

def ccode_isin_CW(row):
    if np.isnan(row['Commodity Code']):
        return 0
    else:
        return onet.In_CW_T2_new(int(row['Commodity Code']), int(row['DOT1991']), dft2e, dfcw)

def rewrite_term_match_file(infilename, outfilename, dfcw, dot_mapping):
    dtypes = {'Document Number': str}
    df_full = pd.read_csv(infilename, dtype=dtypes)
    df_full.rename(columns={'In_CW_T2': 'In_CW_T2_old'}, inplace=True)
    if 'Unnamed: 0' in df_full.columns:
        df_full.drop('Unnamed: 0', axis=1, inplace=True)
    df = df_full.dropna()
    df_missing = df_full[~df_full.index.isin(df.index)]
    df.reset_index(inplace=True)
    df['DOT1991'] = df['DOT Title'].apply(lambda x: dot_mapping[x])
    df['Commodity Code'] = df['Commodity Code'].astype(int)
    df['In_CW_T2_old'] = df['In_CW_T2_old'].astype(int)    
    df['Num_Possible_Comm_Titles'] = df['Num_Possible_Comm_Titles'].astype(int)
    df.drop('DOT Title', axis=1, inplace=True)
    cols = ['Document Number', 'DOT1991', 'term', 'full_term', 'term_type', \
                'Commodity Code', 'Commodity Title', 'Num_Possible_Comm_Titles', 'In_CW_T2_old']
    df = df[cols]
    df['In_CW_T2'] = df.apply(\
            lambda row: \
                onet.In_CW_T2_new(row['Commodity Code'], row['DOT1991'], dft2e, dfcw), axis=1)
    df.to_csv(outfilename)
    return df, df_missing


