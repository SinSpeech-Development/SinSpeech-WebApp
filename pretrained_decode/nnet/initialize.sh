# This script should be run at s5/

if [ "$#" -ne 3 ]; then
    echo "Missing required arguments. Please provide the following:"
    echo "1: path to directory which has final.mdl,"
    echo "2: path to directory which has HCLG.fst"
    echo "3: path to extractor/"
    exit 1
fi

src="pretrained_decode"
srcHires="${src}_hires"

if [ ! -f "path.sh" ]; then
    cp $src/path.sh .
    chmod +x ./path.sh
    echo "Copied path.sh"
fi

. ./path.sh

ln -s ../../wsj/s5/steps .
ln -s ../../wsj/s5/utils .
ln -s ../../../src .

# conf/

if [ ! -d "conf" ]; then
    cp -a $src/conf ./conf
    echo "Created conf/ and copied config files"
fi

# pretrained_decode/

if [ ! -d "${src}/audio" ]; then
    mkdir -p $src/audio
    echo "Created ${src}/audio/"
fi

if [ ! -f "${src}/decode_execution.log" ]; then
    touch $src/decode_execution.log
    echo "Created ${src}/decode_execution.log"
fi

# data/

if [ ! -d "data" ]; then
    mkdir -p data
    echo "Created data/"
fi

if [ ! -d "data/${srcHires}" ]; then
    mkdir -p data/$srcHires
    echo "Created data/${srcHires}"
fi

# mfcc/

if [ ! -d "mfcc" ]; then
    mkdir -p mfcc
    echo "Created mfcc/"
fi

# exp/

if [ ! -d "exp" ]; then
    mkdir -p exp
    echo "Created exp/"
fi 

if [ ! -d "exp/make_mfcc" ]; then
    mkdir -p exp/make_mfcc
    echo "Created exp/make_mfcc/"
fi

if [ ! -d "exp/${srcHires}" ]; then
    mkdir -p exp/$srcHires
    echo "Created exp/${srcHires}/"
fi

if [ ! -d "exp/${srcHires}/pretrained_exp" ]; then
    mkdir -p exp/$srcHires/pretrained_exp
    echo "Created exp/${srcHires}/pretrained_exp/"
fi

if [ ! -d "exp/${srcHires}/pretrained_exp/chain" ]; then
    mkdir -p exp/$srcHires/pretrained_exp/chain
    echo "Created exp/${srcHires}/pretrained_exp/chain"
fi

if [ ! -d "exp/${srcHires}/pretrained_exp/chain/tree_sp" ]; then
    mkdir -p exp/$srcHires/pretrained_exp/chain/tree_sp
    echo "Created exp/${srcHires}/pretrained_exp/chain/tree_sp"
fi

if [ ! -d "exp/${srcHires}/pretrained_exp/chain/tree_sp/graph" ]; then
    mkdir -p exp/$srcHires/pretrained_exp/chain/tree_sp/graph
    echo "Created exp/${srcHires}/pretrained_exp/chain/tree_sp/graph"
fi

if [ ! -d "exp/${srcHires}/pretrained_exp/graph" ]; then
    mkdir -p exp/$srcHires/pretrained_exp/graph
    echo "Created exp/${srcHires}/pretrained_exp/graph"
fi

if [ ! -d "exp/${srcHires}/pretrained_exp/nnet3" ]; then
    mkdir -p exp/$srcHires/pretrained_exp/nnet3
    echo "Created exp/${srcHires}/pretrained_exp/nnet3/"
fi

if [ ! -d "exp/${srcHires}/pretrained_exp/nnet3/extractor" ]; then
    mkdir -p exp/$srcHires/pretrained_exp/nnet3/extractor
    echo "Created exp/${srcHires}/pretrained_exp/nnet3/extractor/"
fi

if [ ! -d "exp/${srcHires}/pretrained_exp/nnet3/ivectors_${srcHires}" ]; then
    mkdir -p exp/$srcHires/pretrained_exp/nnet3/ivectors_${srcHires}
    echo "Created exp/${srcHires}/pretrained_exp/nnet3/ivectors_${srcHires}"
fi

if [ ! -d "exp/${srcHires}/pretrained_exp/decode_${srcHires}/log" ]; then
    mkdir -p exp/$srcHires/pretrained_exp/decode_${srcHires}/log
    echo "Created exp/${srcHires}/pretrained_exp/decode_${srcHires}/log/"
fi

mdlDir=$1
HCLGDir=$2

cp $mdlDir/final.mdl ./exp/$srcHires/pretrained_exp
if [ -f "${mdlDir}/final.mat" ]; then
    cp $mdlDir/final.mat ./exp/$srcHires/pretrained_exp
fi
if [ -f "${mdlDir}/splice_opts" ]; then
    cp $mdlDir/splice_opts ./exp/$srcHires/pretrained_exp
fi
if [ -f "${mdlDir}/cmvn_opts" ]; then
    cp $mdlDir/cmvn_opts ./exp/$srcHires/pretrained_exp
fi
if [ -f "${mdlDir}/delta_opts" ]; then
    cp $mdlDir/delta_opts ./exp/$srcHires/pretrained_exp
fi

cp -a $HCLGDir/. ./exp/$srcHires/pretrained_exp/graph

extractorDir=$3

cp -a $extractorDir/. ./exp/$srcHires/pretrained_exp/nnet3/extractor
if [ -d "exp/${srcHires}/pretrained_exp/nnet3/extractor/log" ]; then
    rm -r exp/$srcHires/pretrained_exp/nnet3/extractor/log
fi

cp -a $HCLGDir/. ./exp/$srcHires/pretrained_exp/chain/tree_sp/graph