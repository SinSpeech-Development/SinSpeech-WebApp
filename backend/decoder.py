import os
from unittest import result
from pydub import AudioSegment
from subprocess import Popen, PIPE, STDOUT

def extract_decode_results(task_id):

    decode_log_file = 'exp/chain/decode_{}/log/decode.1.log'.format(task_id)
    path = os.path.join(os.getcwd(), decode_log_file) 

    logFile = open(path, "r")
    logLines = logFile.readlines()
    logFile.close()

    for line in logLines:
        if line.startswith("SINSPEECH_"):
            return line.strip().split('_', maxsplit=1)[1] \
                                .split(' ', maxsplit=1)[1]
    return ""

def excute_shell_command(command, wait):
    try:
        process = Popen(command, stdout=PIPE, stderr=STDOUT)
        if wait:
            process.wait()
    except Exception as e:
        print(str(e))

def convert_to_wav(full_path, format):
    audio_file = AudioSegment.from_file(full_path, format)
    wave_file = audio_file.set_frame_rate(16000)
    wave_file.export(full_path.replace( \
        ".{}".format(format), ".wav"), format="wav")

def offline_decode(file, filename, app, task_id):

    audio_dir = "audio_{}".format(task_id)
    audio_dir_path = os.path.join(app.config['UPLOAD_FOLDER'], audio_dir) 
    os.mkdir(audio_dir_path) 

    audio_path = os.path.join(app.config['UPLOAD_FOLDER'], audio_dir, filename)
    file.save(audio_path)

    convert_to_wav(audio_path, audio_path.split('.')[1])

    os.remove(audio_path)

    excute_shell_command(["bash", "nnet/pretrained_decode.sh", str(task_id)], True)

    result =  extract_decode_results(task_id)

    excute_shell_command(["bash", "nnet/clean_previous.sh", str(task_id)], False)

    return result

