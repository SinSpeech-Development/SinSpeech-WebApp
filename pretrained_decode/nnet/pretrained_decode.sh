# This script should be run at s5/

. ./path.sh

# process id
src=$1


# log the terminal outputs
exec >> decode_execution_${src}.log 2>&1

# ------ CREATING REQUIRED DATA ------

currentDir=$PWD

echo ""
echo "STARTING DATA GENERATION"


# data/
if [ ! -d "data"/$src ]; then
    mkdir -p data/$src
    echo "Created data/1"
fi


python3 dataGenerator.py audio_"$1" $currentDir/data/$src
echo "Created wav.scp and utt2spk files"

utils/utt2spk_to_spk2utt.pl data/$src/utt2spk > data/$src/spk2utt

echo "DATA GENERATION SUCCESSFUL"

# ------ FEATURE EXTRACTION ------

echo ""
echo "STARTING FEATURE EXTRACTION"

export train_cmd="run.pl"
export decode_cmd="utils/run.pl --mem 2G"

utils/fix_data_dir.sh data/$src

steps/make_mfcc.sh --nj 1 --mfcc-config conf/mfcc_hires.conf \
  data/$src exp/make_mfcc/$src mfcc_"$src"
steps/compute_cmvn_stats.sh data/$src exp/make_mfcc/$src mfcc_"$src"
utils/fix_data_dir.sh data/$src

steps/online/nnet2/extract_ivectors_online.sh --cmd "$train_cmd" --nj 1 \
  data/$src exp/nnet3/extractor \
  exp/nnet3/ivectors_${src}


echo "FEATURE EXTRACTION SUCCESSFULL"

# ------ DECODING ------

echo ""
echo "STARTING DECODING"

frames_per_eg=150,110,100
frames_per_chunk=$(echo $frames_per_eg | cut -d, -f1)
expDir=$currentDir/exp/chain

steps/nnet3/decode.sh \
          --acwt 1.0 --post-decode-acwt 10.0 \
          --frames-per-chunk $frames_per_chunk \
          --nj 1 --cmd "$decode_cmd"  --num-threads 1 \
          --online-ivector-dir exp/nnet3/ivectors_${src} \
          --skip_scoring true \
          $expDir/graph data/$src $expDir/decode_${src}

wait

# python3 $src/decodingExtractor.py $expDir/decode_${srcHires}/log/decode.1.log $currentDir/$src

echo "DECODING SUCCESSFUL"