# This script should be run at s5/

if [ "$#" -ne 2 ]; then
    echo "Missing required arguments. Please provide the following:"
    echo "1: path to directory which has final.mdl,"
    echo "2: path to directory which has HCLG.fst"
    exit 1
fi

src="pretrained_decode"

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

# exp/ exp/tri3b/ exp/tri3b/graph/
if [ ! -d "exp/tri3b/graph" ]; then
    mkdir -p exp/tri3b/graph
    echo "Created exp/tri3b/graph"
fi

mdlDir=$1
HCLGDir=$2

cp $mdlDir/final.mdl ./exp/tri3b
cp $mdlDir/final.mat ./exp/tri3b
if [ -f "${mdlDir}/splice_opts" ]; then
    cp $mdlDir/splice_opts ./exp/tri3b
fi
if [ -f "${mdlDir}/cmvn_opts" ]; then
    cp $mdlDir/cmvn_opts ./exp/tri3b
fi
if [ -f "${mdlDir}/delta_opts" ]; then
    cp $mdlDir/delta_opts ./exp/tri3b
fi

cp -a $HCLGDir/. ./exp/tri3b/graph