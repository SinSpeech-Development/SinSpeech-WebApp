src="pretrained_decode"
srcHires="${src}_hires"

rm -r data/$srcHires
rm -r exp/make_mfcc/$srcHires
rm -r exp/$srcHires/pretrained_exp/decode_${srcHires}
rm -r exp/$srcHires/pretrained_exp/nnet3/ivectors_${srcHires}

rm $src/decode_text.txt
rm mfcc/cmvn_${srcHires}.ark
rm mfcc/cmvn_${srcHires}.scp
rm mfcc/raw_mfcc_${srcHires}.1.ark
rm mfcc/raw_mfcc_${srcHires}.1.scp
rm $src/decode_execution.log

mkdir data/$srcHires
mkdir exp/make_mfcc/$srcHires
mkdir -p exp/$srcHires/pretrained_exp/decode_${srcHires}/log
mkdir exp/$srcHires/pretrained_exp/nnet3/ivectors_${srcHires}
touch $src/decode_execution.log