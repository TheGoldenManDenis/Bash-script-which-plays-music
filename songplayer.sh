#check for arguments
if [ -d $1 ]
 then
  echo "You need to specify a songfile"
  exit
fi

#load trackarrays from external file
source $1

#this array contains the frequencies for the different notes.
declare -a freqarray=(
5993
5993.228307507
6349.604207873
6727.17132203
7127.189745123
7550.994501454
8000.000000001
8475.704754875
8979.696386476
9513.656920022
10079.36839916
10678.718833361
11313.708498985
11986.456615014
12699.208415746
13454.34264406
14254.379490246
15101.989002907
16000
16951.409509749
17959.39277295
19027.313840043
20158.736798318
21357.43766672
22627.416997969
23972.913230026
25398.41683149
26908.685288118
28508.75898049
30203.978005813
31999.999999998
33902.819019496
35918.785545898
38054.627680085
40317.473596633
42714.875333438
45254.833995936
47945.82646005
50796.833662978
)

position_in_song=0
current_pattern=0
songlengthcounter=0

# this is here for testing
position_in_song=$2+0
songlengthcounter=$2+0
offset=$3+0
##########################

# print information
echo Now playing file "$1"  "$songtitle"

###################

while [[ songlengthcounter -lt songlength ]] #start main loop
do


### pattern controls #######################
if [[ patternmode -gt 0 ]]
then

 export snos=${orderlist[$current_pattern]}

 if [[ position_in_song -gt ${pattern_end[$snos]} ]]
 then
  let current_pattern=current_pattern+1
  export snos=${orderlist[$current_pattern]}  #must update 'snos' because current_pattern has changed
  position_in_song=${pattern_start[$snos]} 
 fi

fi
############################################


###### play all normal tracks ##########
current_track=1
while [[ current_track -le number_of_tracks ]]
do

 export penistos=track$current_track[$position_in_song]  

 if [[ ${!penistos} -gt 0 ]]
  then

  aplay -q samples/${tracksamples[$current_track]} -r ${freqarray[$offset+${!penistos}]} &

 fi
 let current_track=current_track+1

done
########################################


# play drum track
if [[ ${drumtrack[$position_in_song]} -gt 0 ]]
 then

 export nuts=${drumtrack[$position_in_song]}
 aplay -q samples/${drumsamples[$nuts]} -r 16000 &

fi
#################



let position_in_song=position_in_song+1 songlengthcounter=songlengthcounter+1 

sleep $tempo

#echo $position_in_song #this is here for testing

done

echo End
