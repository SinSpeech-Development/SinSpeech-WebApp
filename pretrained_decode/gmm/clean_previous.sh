src="pretrained_decode"

rm -r data/$src
rm -r exp/make_mfcc/$src
rm -r exp/$src/decode_${src}

rm $src/decode_text.txt
rm mfcc/cmvn_${src}.ark
rm mfcc/cmvn_${src}.scp
rm mfcc/raw_mfcc_${src}.1.ark
rm mfcc/raw_mfcc_${src}.1.scp
rm $src/decode_execution.log

mkdir data/$src
mkdir exp/make_mfcc/$src
mkdir -p exp/$src/decode_${src}/log
touch $src/decode_execution.log