import configparser

def load_config(app):

    parser = configparser.ConfigParser()
    parser.read("config.ini")

    app.config['UPLOAD_FOLDER'] = parser.get("config", "base_file_upload_folder")
    app.config['MAX_CONTENT_LENGTH'] = parser.getint("config", "max_file_size") * 1024 * 1024 
    app.config['ALLOWED_EXTENSIONS'] = set(parser.get("config", "allowed_extensions").split())
    app.config['PORT'] = parser.get("server", "port")

    app.config['CORS_HEADERS'] = 'Content-Type'
    app.secret_key = "secret key"
