###
# Route function put in here 
### 

from flask import Flask, redirect, render_template, request, flash, url_for
from flask_login import login_user, login_required, current_user, logout_user
from app import app, bcrypt, db, title
from app.forms import RegisterForm, LoginForm
from app.models import User, Product, Order, Cart
import csv
from datetime import datetime, timedelta
import matplotlib.pyplot as plt
import matplotlib
matplotlib.use('Agg')
import io
import base64

# Running Function
@app.route("/")
# @login_required
def index():

    paragraphs = ['Section1', 'Section2', 'Section3']
    return render_template("index.html", title=title, data=paragraphs)

@app.route('/product/<int:product_id>')
def product_detail(product_id):
    product = Product.query.get_or_404(product_id)
    plot_url = generate_plot()
    return render_template('product_detail.html', product=product, plot_url=plot_url,
                           cart=Cart.query.filter_by(user_id=current_user.id).all() 
                           if current_user.is_authenticated else [])

@app.route('/cameras')
def cameras():
    items = Product.query.filter_by(category=1)
    return render_template("cameras.html", title=title, items=items, 
                           cart=Cart.query.filter_by(user_id=current_user.id).all() 
                           if current_user.is_authenticated else [])

@app.route('/lenses')
def lenses():
    items = Product.query.filter_by(category=2)
    return render_template("lenses.html", title=title, items=items, 
                           cart=Cart.query.filter_by(user_id=current_user.id).all() 
                           if current_user.is_authenticated else [])

@app.route('/accessories')
def accessories():
    items = Product.query.filter_by(category=3)
    return render_template("accessories.html", title=title, items=items, 
                           cart=Cart.query.filter_by(user_id=current_user.id).all() 
                           if current_user.is_authenticated else [])

@app.route('/services')
def services():
    return render_template("services.html", title=title)

@app.route('/cart')
def cart():
    return render_template("cart.html", title=title)

@app.route('/register', methods=['GET', 'POST'])
def register():
    form = RegisterForm()

    if current_user.is_authenticated:
        return redirect(url_for('index'))

    # Register
    if request.method == 'POST':
        username = form.username.data
        email = form.email.data
        password = bcrypt.generate_password_hash(form.password.data) 

        with app.app_context():
            user = User(username=username, email=email, password=password)
            db.session.add(user)
            db.session.commit()
            flash('Congrats, resgisteration success', category='success')
    
    return render_template("register.html", title=title, form=form)

@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()

    if current_user.is_authenticated:
        return redirect(url_for('index'))

    # Login
    if request.method == 'POST' and form.validate_on_submit():
        username = form.username.data
        password = form.password.data
        remember = form.remember.data

        user = User.query.filter_by(username=username).first()
        if user and bcrypt.check_password_hash(user.password, password):
            login_user(user, remember=remember)
            flash('Login success', category='info')
            if request.args.get('next'):
                next_page = request.args.get('next')
                return redirect(url_for(next_page))

            return redirect(url_for("index"))
        flash('User not exists or password not match', category='danger')
    return render_template("login.html", title=title, form=form)

@app.route('/add-to-cart/<int:item_id>')
@login_required
def add_to_cart(item_id):
    item_to_add = Product.query.get(item_id)
    item_exists = Cart.query.filter_by(product_link=item_id, customer_link=current_user.id).first()
    if item_exists:
        try:
            item_exists.quantity = item_exists.quantity + 1
            db.session.commit()
            flash(f' Quantity of { item_exists.product.product_name } has been updated')
            return redirect(request.referrer)
        except Exception as e:
            print('Quantity not Updated', e)
            flash(f'Quantity of { item_exists.product.product_name } not updated')
            return redirect(request.referrer)

    new_cart_item = Cart()
    new_cart_item.quantity = 1
    new_cart_item.product_link = item_to_add.id
    new_cart_item.customer_link = current_user.id

    try:
        db.session.add(new_cart_item)
        db.session.commit()
        flash(f'{new_cart_item.product.product_name} added to cart')
    except Exception as e:
        print('Item not added to cart', e)
        flash(f'{new_cart_item.product.product_name} has not been added to cart')

    return redirect(request.referrer)



def generate_plot():
    dates = []
    prices = []
    with open('app/public/data/priceTest.csv', 'r') as csvfile:
        csvreader = csv.reader(csvfile)
        next(csvreader)  
        for row in csvreader:
            dates.append(datetime.strptime(row[0], '%Y-%m-%d'))  
            prices.append(float(row[1]))  

    weekly_dates = []
    weekly_prices = []
    current_week_dates = []
    current_week_prices = []
    current_week_number = dates[0].isocalendar()[1] 
    for date, price in zip(dates, prices):
        week_number = date.isocalendar()[1]
        if week_number == current_week_number:
            current_week_dates.append(date)
            current_week_prices.append(price)
        else:
            weekly_dates.append(current_week_dates)
            weekly_prices.append(current_week_prices)
            current_week_dates = [date]
            current_week_prices = [price]
            current_week_number = week_number

    average_weekly_prices = [sum(prices) / len(prices) for prices in weekly_prices]

    plt.plot(average_weekly_prices)
    plt.xlabel('Week')
    plt.ylabel('Average Price')
    plt.title('Average Weekly Price Trend')

    xticks_labels = []
    for week_dates in weekly_dates:
        xticks_labels.append(week_dates[-1].strftime('%m-%d'))
    plt.xticks(range(len(average_weekly_prices)), xticks_labels, rotation=45)

    img = io.BytesIO()
    plt.savefig(img, format='png')
    img.seek(0)
    plot_url = base64.b64encode(img.getvalue()).decode()
    plt.close()

    return plot_url

@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('index'))


@app.route('/testing')
def test():
    return render_template("testing.html", title=title)