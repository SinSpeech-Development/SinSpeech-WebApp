# SinSpeech Web-App Backend

API endpoint for the offline speech decoder is implemented using flask. To setup and run the backend server follow the given steps.

## Project Setup

First run the below commands to clone and install dependencies.

```
git clone https://github.com/SinSpeech-Development/SinSpeech-WebApp.git
cd SinSpeech-WebApp/backend/

pip install -r requirements.txt
```
Then update the config.ini file accordingly.
```
base_file_upload_folder=/home/lakshan/Documents/SinSpeech-WebApp/backend ( base folder where uploaded files going to save )
max_file_size=16 ( maximum file size in MB should be int )
```

```
python app.py
```

Then the server will start on port 5000. If you want to change to port update `config.ini` file. 

## Decoding files

1. Offline Decode REST API usage
```
POST : <BASE_URL>:PORT/offline-decode

# form data
key : file
value : select the file you want to decode
```
