# Author: Alessandro Formaggioni

import re
import ete3
import numpy as np
from ete3 import NCBITaxa
from Bio import SeqIO
import sys

# arguments: 1) blast output 2) input_trinity fasta 3) output fasta
ncbi =NCBITaxa()
in_file=sys.argv[1]
fasta=sys.argv[2]
out_file=sys.argv[3]

def first_taxid(seq):
	return seq.split(";")[0]

def retrieve_taxid(dict,key):
	seq=dict[key]
	code=""
	for a in re.split('\[|\]|\(|\)',seq):
		if ncbi.get_name_translator([a.replace("_"," ")]).values():
			code=ncbi.get_name_translator([a.replace("_"," ")]).values()
			code=[ c for d in code for c in d]
			code=code[0]
			
		if  code:
			dict[key]=code
		else:
			del dict[key]
		return dict

	

dict={}
with open(in_file) as f:
	for a in f.readlines():
		line=[ a.split("\n")[0].split('\t')[i] for i in [0, 5] ]
		dict[line[0]]=line[1]

#for a,b in zip(range(1,len(taxa2)+1),taxa2):
#	dict[a]=b

for b in [a for a in dict.keys() if dict[a].isdigit() == False ]:
	if ";" in dict[b]:
		dict[b]=first_taxid(dict[b])
	else:
		dict=retrieve_taxid(dict,b)

for b in dict.keys():
	if dict[b] == "1720309":
		dict[b]="2652724"
	if dict[b] == "6915":
		dict[b]="2585209"
	if dict[b] == "1415176":
		dict[b]="2587831"
	if dict[b] == "1385588":
		dict[b]="32008"
	if dict[b] == "595500":
		dict[b]="41899"
	if dict[b] == "206411":
		dict[b]="66713"
	if dict[b] == "984700":
		dict[b]="2609777"
	if dict[b] == "1385592":
		dict[b]="111527"
	if dict[b] == "319528":
		dict[b]="2706150"
	if dict[b] == "1737458":
		dict[b]="2715852"
	if dict[b] == "1806486":
		dict[b]="85698"
	if dict[b] == "1105325":
		dict[b]="2714763"
	if dict[b] == "12924":
		dict[b]="2652724"
	if dict[b] == "223148":
		dict[b]="2602928"
	if dict[b] == "55690":
		dict[b]="2529398"
	if dict[b] == "661997":
		dict[b]="401947"
	if dict[b] == "1940818":
		dict[b]="2548426"
	if dict[b] == "643549":
		dict[b]="2547651"
	if dict[b] == "338187":
		dict[b]="410291"
	if dict[b] == "1231340":
		dict[b]="1307908"
	if dict[b] == "1235808":
		dict[b]="267865"
	if dict[b] == "469608":
		dict[b]="244366"
	if dict[b] == "1745343":
		dict[b]="2082293"
	if dict[b] == "220390":
		dict[b]="2830794"
	if dict[b] == "418867":
		dict[b]="2282107"
	if dict[b] == "1217695":
		dict[b]="280145"
	if dict[b] == "1231339":
		dict[b]="1307904"
	if dict[b] == "1231341":
		dict[b]="1307913"
	if dict[b] == "1385589":
		dict[b]="32008"
	if dict[b] == "1804984":
		dict[b]="1417228"
	if dict[b] == "1806481":
		dict[b]="222"
	if dict[b] == "1969338":
		dict[b]="1873853"
	if dict[b] == "2036817":
		dict[b]="106590"
	if dict[b] == "330":
		dict[b]="301"
	if dict[b] == "388925":
		dict[b]="37931"
	if dict[b] == "46269":
		dict[b]="2759634"
	if dict[b] == "5421":
		dict[b]="264483"
	if dict[b] == "554133":
		dict[b]="426114"
	if dict[b] == "640511":
		dict[b]="2654982"
	if dict[b] == "667585":
		dict[b]="2654982"
	if dict[b] == "713154":
		dict[b]="2447876"
	if dict[b] == "935543":
		dict[b]="157910"
	if dict[b] == "1304902":
		dict[b]="2731756"
	if dict[b] == "1505932":
		dict[b]="408180"
	if dict[b] == "1505933":
		dict[b]="408184"
	if dict[b] == "1561081":
		dict[b]="1785128"
	if dict[b] == "1789004":
		dict[b]="416212"
	if dict[b] == "1806478":
		dict[b]="85698"
	if dict[b] == "1870948":
		dict[b]="1812935"
	if dict[b] == "339724":
		dict[b]="5037"
	if dict[b] == "340419":
		dict[b]="2302425"
	if dict[b] == "5306":
		dict[b]="2822231"
	if dict[b] == "73231":
		dict[b]="2060905"
	if dict[b] == "1038079":
		dict[b]="2653872"
	if dict[b] == "1134468":
		dict[b]="200191"
	if dict[b] == "115416":
		dict[b]="2708265"
	if dict[b] == "120563":
		dict[b]="1903489"
	if dict[b] == "1208325":
		dict[b]="1896331"
	if dict[b] == "1227475":
		dict[b]="2558026"
	if dict[b] == "1229665":
		dict[b]="2502994"
	if dict[b] == "1286365":
		dict[b]="2426"
	if dict[b] == "1296663":
		dict[b]="1470209"
	if dict[b] == "1497613":
		dict[b]="1505087"
	if dict[b] == "1519620":
		dict[b]="2746584"
	if dict[b] == "1785093":
		dict[b]="2094009"
	if dict[b] == "1834517":
		dict[b]="2599596"
	if dict[b] == "1849491":
		dict[b]="1817405"
	if dict[b] == "1881058":
		dict[b]="378404"
	if dict[b] == "1881059":
		dict[b]="1365950"
	if dict[b] == "1916993":
		dict[b]="303"
	if dict[b] == "1940809":
		dict[b]="2548426"
	if dict[b] == "1940810":
		dict[b]="2548426"
	if dict[b] == "1940812":
		dict[b]="2548426"
	if dict[b] == "1940813":
		dict[b]="2548426"
	if dict[b] == "1940814":
		dict[b]="2548426"
	if dict[b] == "1940815":
		dict[b]="2548426"
	if dict[b] == "1940816":
		dict[b]="2548426"
	if dict[b] == "1940817":
		dict[b]="2548426"
	if dict[b] == "1970462":
		dict[b]="1970738"
	if dict[b] == "1970463":
		dict[b]="1970738"
	if dict[b] == "1970473":
		dict[b]="1970738"
	if dict[b] == "2049920":
		dict[b]="2035031"
	if dict[b] == "264915":
		dict[b]="2527844"
	if dict[b] == "317913":
		dict[b]="2306593"
	if dict[b] == "431157":
		dict[b]="2558455"
	if dict[b] == "441964":
		dict[b]="2072698"
	if dict[b] == "467373":
		dict[b]="2598218"
	if dict[b] == "483983":
		dict[b]="2720087"
	if dict[b] == "48937":
		dict[b]="48935"
	if dict[b] == "56484":
		dict[b]="2754530"
	if dict[b] == "60015":
		dict[b]="73376"
	if dict[b] == "634709":
		dict[b]="2704383"
	if dict[b] == "65071":
		dict[b]="2052682"
	if dict[b] == "67004":
		dict[b]="1577725"
	if dict[b] == "8401":
		dict[b]="45623"
	if dict[b] == "97139":
		dict[b]="2044587"
	if dict[b] == "1182003":
		dict[b]="2072697"
	if dict[b] == "1266660":
		dict[b]="1072105"
	if dict[b] == "1317118":
		dict[b]="1379903"
	if dict[b] == "1449126":
		dict[b]="1712410"
	if dict[b] == "148342":
		dict[b]="2072697"
	if dict[b] == "1505936":
		dict[b]="540997"
	if dict[b] == "1705409":
		dict[b]="1705564"
	if dict[b] == "1706433":
		dict[b]="1705564"
	if dict[b] == "182745":
		dict[b]="2547956"
	if dict[b] == "1913078":
		dict[b]="1594576"
	if dict[b] == "195110":
		dict[b]="615237"
	if dict[b] == "258719":
		dict[b]="2588666"
	if dict[b] == "309567":
		dict[b]="650555"
	if dict[b] == "568277":
		dict[b]="2546181"
	if dict[b] == "6530":
		dict[b]="2315439"
	if dict[b] == "686830":
		dict[b]="536"
	if dict[b] == "1111416":
		dict[b]="1897672"
	if dict[b] == "1137832":
		dict[b]="2784324"
	if dict[b] == "1222184":
		dict[b]="2589380"
	if dict[b] == "1246674":
		dict[b]="2060906"
	if dict[b] == "2094017":
		dict[b]="620537"
	if dict[b] == "333317":
		dict[b]="2723817"
	if dict[b] == "482829":
		dict[b]="1111441"
	try:
		dict[b]=str(ncbi.get_lineage(dict[b])).replace("[","").replace("]","")
	except:
		print(dict[b])


transcripts=list(SeqIO.parse(fasta,"fasta"))

transcript_filt=[]
# Filter the transcripts retaining those that have the Metazoa taxaid in their lineage
for n in [ a for a in transcripts if a.id in dict.keys() ]:
	if "33208" in  dict[n.id].split(", "):
		transcript_filt.append(n)

with open(out_file,'w') as out_file:
	SeqIO.write(transcript_filt, out_file, "fasta")


