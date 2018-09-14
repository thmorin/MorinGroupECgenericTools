#!/bin/bash

inpath="./"
year="2015"
undersgn="_"
table="met_data_"
stringend="_9999"
filename="2016_03_15_CR3000Olen_met_data.dat"
echo $filename
echo $table$year$mon$stringend
cd $inpath

for mon in "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" ; do
#for mon in "12"; do
for i in "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26" "27" "28" "29" "30" "31" ;do

#for i in "09" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26" "27" "28"; do
	echo /$table$year$undersgn$mon$undersgn$i$stringend.dat
	head -4 $filename > $inpath/split/$table$year$undersgn$mon$undersgn$i$stringend.dat
	date_str="$year-$mon-$i"
	echo $year-$mon-$i
	grep $date_str $filename >> $inpath/split/$table$year$undersgn$mon$undersgn$i$stringend.dat 
	if [ $(head -5 $inpath/split//$table$year$undersgn$mon$undersgn$i$stringend.dat | wc -l) = 4 ] ;
	    then
	    rm -f $inpath/split//$table$year$undersgn$mon$undersgn$i$stringend.dat
	fi
    done
done
