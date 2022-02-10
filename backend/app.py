from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
from decoder import offline_decode
import configparser

parser = configparser.ConfigParser()
parser.read("config.ini")

base_file_upload_folder = parser.get("config", "base_file_upload_folder")
max_file_size = parser.getint("config", "max_file_size") * 1024 * 1024 
allowed_extensions = parser.get("config", "allowed_extensions")

port = parser.get("server", "port")

app = Flask(__name__)
app.secret_key = "secret key"
app.config['UPLOAD_FOLDER'] = base_file_upload_folder
app.config['MAX_CONTENT_LENGTH'] = max_file_size

ALLOWED_EXTENSIONS = set(allowed_extensions.split())

def allowed_file(filename):
	return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/offline-decode', methods=['POST'])
def upload_file():
	# check if the post request has the file part
	if 'file' not in request.files:
		resp = jsonify({'message' : 'No file part in the request'})
		resp.status_code = 400
		return resp
	file = request.files['file']
	if file.filename == '':
		resp = jsonify({'message' : 'No file selected for uploading'})
		resp.status_code = 400
		return resp
	if file and allowed_file(file.filename):
		filename = secure_filename(file.filename)
		offline_decode(file, filename, app)
		resp = jsonify({'message' : 'File successfully uploaded'})
		resp.status_code = 201
		return resp
	else:
		resp = jsonify({'message' : 'Allowed file types are mp3, flac, wav'})
		resp.status_code = 400
		return resp

if __name__ == "__main__":
    app.run(port=port)