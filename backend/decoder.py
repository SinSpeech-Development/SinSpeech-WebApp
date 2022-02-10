import os

def offline_decode(file, filename, app):
    file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))