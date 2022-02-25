# This script should be run at s5/


. ./path.sh

src=$1

# log the terminal outputs
# exec >> $src/decode_execution.log 2>&1

# ------ CREATING REQUIRED DATA ------
startTotal=$(date +%s.%N)

currentDir=$PWD

echo ""
echo "STARTING DATA GENERATION"

start1=$(date +%s.%N)

python3 dataGenerator.py audio_"$1" $currentDir/data/$src
echo "Created wav.scp and utt2spk files"

utils/utt2spk_to_spk2utt.pl data/$src/utt2spk > data/$src/spk2utt

end1=$(date +%s.%N) 

echo "DATA GENERATION SUCCESSFUL"

# ------ FEATURE EXTRACTION ------

echo ""
echo "STARTING FEATURE EXTRACTION"

start2=$(date +%s.%N)

export decode_cmd="utils/run.pl --mem 2G"

utils/fix_data_dir.sh data/$src

steps/make_mfcc.sh --nj 1 data/$src exp/make_mfcc/$src mfcc_"$src"
steps/compute_cmvn_stats.sh data/$src exp/make_mfcc/$src mfcc_"$src"
utils/fix_data_dir.sh data/$src

end2=$(date +%s.%N) 

echo "FEATURE EXTRACTION SUCCESSFULL"

# ------ DECODING ------

echo ""
echo "STARTING DECODING"

start3=$(date +%s.%N)

expDir=$currentDir/exp/tri3b

steps/decode.sh --nj 1 --cmd "$decode_cmd" --skip_scoring true \
    $expDir/graph data/$src $expDir/decode_${src}

# python3 $src/decodingExtractor.py $expDir/decode_${src}/log/decode.1.log $currentDir/$src

end3=$(date +%s.%N) 

echo "DECODING SUCCESSFUL"

endTotal=$(date +%s.%N)  

runtime1=$(python -c "print(${end1} - ${start1})")
runtime2=$(python -c "print(${end2} - ${start2})")
runtime3=$(python -c "print(${end3} - ${start3})")
runtimeTotal=$(python -c "print(${endTotal} - ${startTotal})")

echo ""

echo "Runtime for Data Generation=$runtime1"
echo "Runtime for Feature Extraction=$runtime2"
echo "Runtime for Decoding=$runtime3"
echo "Total Runtime=$runtimeTotal"