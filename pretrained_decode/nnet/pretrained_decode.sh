# This script should be run at s5/

. ./path.sh

src="pretrained_decode"

# log the terminal outputs
exec >> $src/decode_execution.log 2>&1

# ------ CREATING REQUIRED DATA ------
startTotal=$(date +%s.%N)

currentDir=$PWD

echo ""
echo "STARTING DATA GENERATION"

start1=$(date +%s.%N)

wavPath=$currentDir/$src/audio

srcHires="${src}_hires"

python3 $src/dataGenerator.py $wavPath $currentDir/data/$srcHires
echo "Created wav.scp and utt2spk files"

utils/utt2spk_to_spk2utt.pl data/$srcHires/utt2spk > data/$srcHires/spk2utt

end1=$(date +%s.%N) 

echo "DATA GENERATION SUCCESSFUL"

# ------ FEATURE EXTRACTION ------

echo ""
echo "STARTING FEATURE EXTRACTION"

start2=$(date +%s.%N)

export train_cmd="run.pl"
export decode_cmd="utils/run.pl --mem 2G"

utils/fix_data_dir.sh data/$srcHires

steps/make_mfcc.sh --nj 1 --mfcc-config conf/mfcc_hires.conf \
  data/$srcHires exp/make_mfcc/$srcHires mfcc
steps/compute_cmvn_stats.sh data/$srcHires exp/make_mfcc/$srcHires mfcc
utils/fix_data_dir.sh data/$srcHires

steps/online/nnet2/extract_ivectors_online.sh --cmd "$train_cmd" --nj 1 \
  data/$srcHires exp/$srcHires/pretrained_exp/nnet3/extractor \
  exp/$srcHires/pretrained_exp/nnet3/ivectors_${srcHires}


end2=$(date +%s.%N) 

echo "FEATURE EXTRACTION SUCCESSFULL"

# ------ DECODING ------

echo ""
echo "STARTING DECODING"

start3=$(date +%s.%N)

frames_per_eg=150,110,100
frames_per_chunk=$(echo $frames_per_eg | cut -d, -f1)
expDir=$currentDir/exp/$srcHires/pretrained_exp
tree_dir="${expDir}/chain/tree_sp"

steps/nnet3/decode.sh \
          --acwt 1.0 --post-decode-acwt 10.0 \
          --frames-per-chunk $frames_per_chunk \
          --nj 1 --cmd "$decode_cmd"  --num-threads 1 \
          --online-ivector-dir exp/$srcHires/pretrained_exp/nnet3/ivectors_${srcHires} \
          --skip_scoring true \
          $tree_dir/graph data/$srcHires $expDir/decode_${srcHires}

wait

python3 $src/decodingExtractor.py $expDir/decode_${srcHires}/log/decode.1.log $currentDir/$src

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