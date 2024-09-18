# from flask import Flask, render_template, request, flash
# # from flask_bootstrap import Bootstrap  -> have some error
# from flask_sqlalchemy import SQLAlchemy
# from flask_bcrypt import Bcrypt
# from config import Config
# from forms import RegisterForm, LoginForm
# from models import User, Product, Order

# app = Flask(__name__, static_folder="public", static_url_path="/")
# app.static_folder = '/'
# app.config.from_object(Config)
# db = SQLAlchemy(app, model_class=Config)
# bcrypt = Bcrypt(app)
# # db.init_app(app)

# # bootstrap = Bootstrap(app)
# title = "GBC Camera"

# @app.route("/")
# def home():
#     paragraphs = ['Section1', 'Section2', 'Section3']
#     return render_template("index.html", title=title, data=paragraphs)

# @app.route('/cameras')
# def cameras():
#     return render_template("cameras.html", title=title)

# @app.route('/lenses')
# def lenses():
#     return render_template("lenses.html", title=title)

# @app.route('/accessories')
# def accessories():
#     return render_template("accessories.html", title=title)

# @app.route('/services')
# def services():
#     return render_template("services.html", title=title)

# @app.route('/cart')
# def cart():
#     return render_template("cart.html", title=title)

# @app.route('/register', methods=['GET', 'POST'])
# def register():
#     form = RegisterForm()
#     form2 = LoginForm()

#     if form.validate_on_submit():
#         username = form.username.data
#         email = form.email.data
#         password = bcrypt.generate_password_hash(form.password.data)  
#         user = User(username=username, email=email, password=password)
#         db.session.add(user)
#         db.session.commit()
#         flash('Congrats, resgisteration success', category='success')
#     if form2.validate_on_submit():
#         pass
#     return render_template("register.html", title=title, form=form, form2=form2)

# @app.route('/testing')
# def test():
#     return render_template("testing.html", title=title)

# if __name__ == "__main__":
#     app.run(debug=True, port=3000)
#     # app.run(debug=True)
#     # app.run(port=3000)