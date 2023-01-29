import re, csv
import pandas as pd

def to_dot_code(codestr):
    c = codestr
    if (len(c) == 11) and (c[3]=='.') and (c[7]=='-'):
        return c
    elif len(c) != 9:
        print('codestr {} incorrect length'.format(c))
        return
    return '{}.{}-{}'.format(c[0:3], c[3:6], c[6:9])

def to_short_dot_code(codestr):
    c = codestr
    if type(c) == int:
        return c
    if (c[3]!='.') and (c[7]!='-'):
        return c
    elif len(c) != 11:
        print('codestr {} incorrect length'.format(c))
        return
    return str(int('{}{}{}'.format(c[:3], c[4:7], c[9:])))


# 1991 

DOT1991_fields = ['Document Number', 'DOT Code', 'Definition Type', 'Date of Update',\
                    'Data', 'People', 'Things', \
                    'Reasoning', 'Math', 'Language', 'Spec. Voc. Prep.',\
                    'General Learning', 'Verbal', 'Numerical', 'Spacial', 'Form Perception', \
                    'Clerical Percep.', 'Motor Coordina.', 'Finger Dexterity', 'Manual Dexterity', \
                    'Eye-Hand Coord.', 'Color Discrim.', \
                    'Work Field 1', 'Work Field 2', 'Work Field 3', \
                    'MPSMS Field 1', 'MPSMS Field 2', 'MPSMS Field 3', \
                    'Temperaments', 'GOE Code', 'SOC Code', \
                    'Strength', 'Climbing', 'Balancing', 'Stooping', 'Kneeling', \
                    'Crouching', 'Crawling', 'Reaching', 'Handling', 'Fingering', \
                    'Feeling', 'Talking', 'Hearing', 'Tasting/Smelling', \
                    'Near Acuity', 'Far Acuity', 'Depth Percept.', 'Accommodation', \
                    'Color Vision', 'Field of Vision', \
                    'Weather', 'Cold', 'Hot', 'Wet/Humid', 'Noise', 'Vibration', \
                    'Atmospheric Cond.', 'Move, Mech. Parts', 'Electric Shock', \
                    'High, Exp. Places', 'Radiation', 'Explosives', 'Tox. Caus. Chem.', \
                    'Other E. Cond.', \
                    'DOT Title', 'Designation 1', 'Designation 2', 'Designation 3', 'Designation 4', \
                    'Definition']

def parse_1991_title(jcontents):
    """
    Parse job contents from line in main job description file (DS0013)
    """
    DOT1991_fs = [7,9,1,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,3,3,3,3,3,9,6,4,\
              1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, \
              1,1,1,1,1,1,1,1,1,1,1,1,1,1,\
              68,16,16,16,16,1600]
    #
    cur = 0
    jdata = {}
    linedata = []
    for i in range(len(DOT1991_fields)):
        f = DOT1991_fields[i]
        s = DOT1991_fs[i]
        c = jcontents[cur:cur+s]
        jdata[f] = c.strip()
        linedata.append(c)
        cur += s
    return jdata, linedata

def parse_1991_misc1(mcontents):
    """
    Parse spillover job definition from line in first misc job description file (DS0011 = DEFMISC1.ASC)
    """
    fields = ['Document Number', 'Field Separator 1', 'M1 Definition', 'Field Separator 2']
    fs = [7,1,1940,1]
    #
    cur = 0
    mdata = {}
    for i in range(len(fields)):
        f = fields[i]
        s = fs[i]
        c = mcontents[cur:cur+s]
        mdata[f] = c.strip()
        cur += s
    return mdata

def parse_1991_misc2(mcontents):
    """
    Parse spillover job definition from line in second misc job description file (DS0012 = DEFMISC2.ASC)
    """
    fields = ['Document Number', 'Field Separator 1', 'M2 Definition', 'Field Separator 2']
    fs = [7,1,2000,1]
    #
    cur = 0
    mdata = {}
    for i in range(len(fields)):
        f = fields[i]
        s = fs[i]
        c = mcontents[cur:cur+s]
        mdata[f] = c.strip()
        cur += s
    return mdata

def parse_DOT91(filename1='data/All1991/ICPSR_06100/DS0013/06100-0013-Data.txt',
                    filename2='data/All1991/ICPSR_06100/DS0011/06100-0011-Data.txt',
                    filename3='data/All1991/ICPSR_06100/DS0012/06100-0012-Data.txt',
                    csv_outfile=None):
    """
    Parse all job title data from primary file and two miscellaneous spillover files.
    Return dictionary of job data keyed on DOT Title.
    """
    #
    all_m1data = {}
    with open(filename2, 'r') as f91_m1:
        for mcontents in f91_m1:
            mdata = parse_1991_misc1(mcontents)
            doc_number = mdata['Document Number']
            all_m1data[doc_number] = mdata
    #
    all_m2data = {}
    with open(filename3, 'r') as f91_m2:
        for mcontents in f91_m2:
            mdata = parse_1991_misc2(mcontents)
            doc_number = mdata['Document Number']
            all_m2data[doc_number] = mdata
    #
    all_jdata = {}
    all_linedata = []
    with open(filename1, 'r') as f91:
        for jcontents in f91:
            jdata, linedata = parse_1991_title(jcontents)
            dot_title = jdata['DOT Title'].replace(' ', '_').replace(',', '+')
            doc_number = jdata['Document Number']
            if doc_number in all_m1data:
                m1_desc = all_m1data[doc_number]['M1 Definition']
                jdata['Definition'] += m1_desc
                def_idx = DOT1991_fields.index('Definition')
                linedata[def_idx] = jdata['Definition']
            if doc_number in all_m2data:
                m2_desc = all_m2data[doc_number]['M2 Definition']
                jdata['Definition'] += m2_desc
                def_idx = DOT1991_fields.index('Definition')
                linedata[def_idx] = jdata['Definition']
            #
            all_jdata[doc_number] = jdata
            all_linedata.append(linedata)
    if csv_outfile is not None:
        with open(csv_outfile, 'w', newline='') as csvfile:
            writer = csv.writer(csvfile)
            writer.writerow(DOT1991_fields)
            for linedata in all_linedata:
                writer.writerow(linedata)
    return all_jdata

def parse_DOT91_glossary_title(gcontents):
    """
    Parse glossary definition from line in glossary file (DS0017)
    """
    DOT1991_glossary_fields = ['Document Number', 'Field Separator 1', \
                                   'Definition Type', 'Field Separator 2', \
                                   'Date of Update', 'Field Separator 3', \
                                   'Title', 'Field Separator 4', \
                                   'Definition text', 'Field Separator 5']
    DOT1991_glossary_fs = [7,1,1,1,2,1,38,1,1600,1]
    #
    cur = 0
    gdata = {}
    linedata = []
    for i in range(len(DOT1991_glossary_fields)):
        f = DOT1991_glossary_fields[i]
        s = DOT1991_glossary_fs[i]
        c = gcontents[cur:cur+s].strip()
        gdata[f] = c
        linedata.append(c)
        cur += s
    return gdata, linedata

def parse_DOT91_glossary(filename='data/All1991/ICPSR_06100/DS0017/06100-0017-Data.txt'):
    """
    Parse glossary definitions from glossary file (DS0017)
    """
    all_gdata = {}
    all_linedata = []
    with open(filename, 'r') as g91:
        for gcontents in g91:
            gdata, linedata = parse_DOT91_glossary_title(gcontents)
            g_title = gdata['Title'].replace(' ', '_').replace(',', '+')
            doc_number = gdata['Document Number']
            all_gdata[doc_number] = gdata
            all_linedata.append(linedata)
    return all_gdata

def glossary_title_to_ref(title):
    return r'$t3{}$t1'.format(title.lower())

# --------------------------------------------------------------------------------------------

# 1977

DOT1977_fields = ['Document Number', 'DOT Code', \
                    'Data', 'People', 'Things', \
                    'Record Type', 'DOT Definition Type', \
                    'Reasoning', 'Mathematics', 'Language', 'Filler', 'Spec. Voc. Prep.', \
                    'Intelligence', 'Verbal', 'Numerical', 'Spatial', 'Form Perception', \
                    'Clerical', 'Motor Coordination', 'Finger Dexterity', 'Manual Dexterity', \
                    'Eye-Foot Coordination', 'Color Discrimination', \
                    'Temperaments', 'Physical Demands', 'Environmental Conditions', \
                    'Filler1', \
                    'Mat. Prod. Subj. Matter Field 1', 'Mat. Prod. Subj. Matter Field 2', \
                    'Mat. Prod. Subj. Matter Field 3', \
                    'Filler2', \
                    'Work Field 1', 'Work Field 2', 'Work Field 3', 'Work Field 4', \
                    'Filler3', \
                    'Interests Field 1', 'Interests Field 2', 'Interests Field 3', 'Interests Field 4', \
                    'Interests Field 5', \
                    'Title Size', 'Title', \
                    'DOT Industry Code 1', 'DOT Industry Code 2', 'DOT Industry Code 3', 'DOT Industry Code 4', \
                    'Filler4', \
                    'Standard Occupation Classification', 'GOE Code', \
                    '1970 Census Code 1', '1970 Census Code 2', '1970 Census Code 3', \
                    'Text Length', 'Job Definition']

def parse_1977_title(jcontents):
    """
    Parse job contents from line in main job description file (DS0013)
    """
    DOT1977_fs = [7,9,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,\
              5,6,7,3,3,3,3,3,3,3,3,3,6,2,2,2,2,2,3,\
              149,3,3,3,3,21,4,6,3,3,3,4,6184]
    #
    cur = 0
    jdata = {}
    linedata = []
    for i in range(len(DOT1977_fields)):
        f = DOT1977_fields[i]
        s = DOT1977_fs[i]
        c = jcontents[cur:cur+s]
        jdata[f] = c.strip()
        linedata.append(c.rstrip('\n'))
        cur += s
    return jdata, linedata


def parse_DOT77(filename='data/DOT1977/cleaned_DOT1977_ed4.txt', csv_outfile=None):
    """
    Parse all job title data from file.
    Return dictionary of job data keyed on DOT Title.
    """
    #
    all_jdata = {}
    all_linedata = []
    count_bad = 0
    with open(filename, 'r') as f77:
        for jcontents in f77:
            jdata, linedata = parse_1977_title(jcontents)
            try:
                docno = int(jcontents[:7])
            except:
                #print(jcontents[0:7], len(jcontents))
                print(jcontents[:7])
                count_bad += 1
            dot_title = jdata['Title'].replace(' ', '_').replace(',', '+')
            all_jdata[jcontents[:7]] = jdata
            all_linedata.append(linedata)
    if csv_outfile is not None:
        with open(csv_outfile, 'w', newline=None) as csvfile:
            writer = csv.writer(csvfile)
            #writer.writerow(list(range(1,len(all_linedata[0])+1)))
            writer.writerow(DOT1977_fields)
            for linedata in all_linedata:
                writer.writerow(linedata)
    return all_jdata

# -------------------------------------------------------------------------------------------

def check_DOT1977_rec5_usage(alljdata):
    rec5 = [v['Title'] for k,v in alljdata.items() if v['Record Type']=='5']
    mentions = {}
    for gloss in rec5:
        mentions[gloss] = []
        for k,v in alljdata.items():
            if v['Record Type'] != '4':
                continue
            term = str.lower(gloss)
            matches = re.findall(term, v['Job Definition'])
            if len(matches) > 0:
                if gloss=='TIMER DRUM':
                    print(k,v['Title'])
                mentions[gloss].append((k,v['Title']))
    return mentions

                
        
