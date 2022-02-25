from concurrent.futures import thread
from flask import Flask, request, jsonify
from flask_cors import CORS, cross_origin
from werkzeug.utils import secure_filename
from decoder import offline_decode
from load_config import load_config
import threading

app = Flask(__name__)
cors = CORS(app)
load_config(app)

thread_lock = threading.Lock()
task_counter = { 'count' : 0 }

def allowed_file(filename):
	return '.' in filename and filename.rsplit('.', 1)[1].lower() \
			in app.config['ALLOWED_EXTENSIONS']

@app.route('/offline-decode', methods=['POST'])
@cross_origin()
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
		task_id = None
		with thread_lock:
			task_counter['count'] = task_counter['count'] + 1
			task_id = task_counter['count']

		result = offline_decode(file, filename, app, task_id)
		resp = jsonify({'message' : 'File successfully uploaded',
						'result' : result})
		resp.status_code = 201
		return resp
	else:
		resp = jsonify({'message' : 'Allowed file types are mp3, flac, wav'})
		resp.status_code = 400
		return resp

if __name__ == "__main__":
    app.run()