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

# data/
if [ ! -d "data" ]; then
    mkdir -p data
    echo "Created data/"
fi

# exp/ exp/chain/ exp/chain/graph/
if [ ! -d "exp/chain/graph" ]; then
    mkdir -p exp/chain/graph
    echo "Created exp/chain/graph"
fi

# exp/ exp/nnet3/ exp/nnet3/extractor/
if [ ! -d "exp/nnet3/extractor" ]; then
    mkdir -p exp/nnet3/extractor
    echo "Created exp/nnet3/extractor/"
fi

mdlDir=$1
HCLGDir=$2
extractorDir=$3

cp $mdlDir/final.mdl ./exp/chain

cp -a $HCLGDir/. ./exp/chain/graph

cp -a $extractorDir/. ./exp/nnet3/extractor
if [ -f "${extractorDir}/splice_opts.txt" ]; then
    mv ./exp/nnet3/extractor/splice_opts.txt \
    ./exp/nnet3/extractor/splice_opts
fi