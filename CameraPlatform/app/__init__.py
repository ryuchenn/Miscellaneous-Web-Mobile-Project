###
# Library, Global Varibale all put in here
### 

from flask import Flask, render_template, request, flash
# from flask_bootstrap import Bootstrap  -> have some error
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_login import LoginManager
from config import Config

app = Flask(__name__, static_folder="public", static_url_path="/")
app.static_folder = '/'
app.config.from_object(Config)
db = SQLAlchemy(app, model_class=Config)
bcrypt = Bcrypt(app)
login = LoginManager(app)
login.init_app(app)
login.login_view = 'login'
login.login_message = 'You must login to access this page'
login.login_message_category = 'info'
title = "GBC Camera"

from app.routes import *

# ImportError: cannot import name 'User' from partially initialized module 'models' (most likely due to a circular import) (/Users/admin/Downloads/FullStackProject/models.py)
# -> Split from all code. 

