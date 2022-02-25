taskId=$1

rm -r audio_${taskId}
rm -r data/$taskId
rm -r exp/make_mfcc/$taskId
rm -r exp/chain/decode_${taskId}
rm -r exp/nnet3/ivectors_${taskId}
rm -r mfcc_${taskId}
rm decode_execution_${taskId}.log
