# For Testing
from app.models import User, Product
from app import db, app

# with app.app_context():
    # # db.create_all()
    #     user = User(username='Test3', password='Test3', email='Test3@gbccamera.com')
#     db.session.add(user)
    # db.session.commit()

# with app.app_context():
#     product = Product(name='Canon EOS R5', description='', price=4000, product_picture='public/images/cameras/canon/R5.jpg', category=1)
#     db.session.add(product)
#     db.session.commit()

    # product = Product(name='Canon EOS R6 Mark II', description='', price=2300, product_picture='public/images/cameras/canon/R6MarkII.webp', category=1)
    # db.session.add(product)
    # db.session.commit()

    # product = Product(name='Sony A6400', description='', price=1050, product_picture='public/images/cameras/sony/A6400.jpg', category=1)
    # db.session.add(product)
    # db.session.commit()

    # product = Product(name='Sony a7R IV', description='', price=2800, product_picture='public/images/cameras/sony/a7r3.jpeg', category=1)
    # db.session.add(product)
    # db.session.commit()

    # product = Product(name='Nikon Z7', description='', price=3300, product_picture='public/images/cameras/nikon/Z7.webp', category=1)
    # db.session.add(product)
    # db.session.commit()

    # product = Product(name='Canon EOS M50', description='', price=899, product_picture='public/images/cameras/canon/M50.jpg', category=1)
    # db.session.add(product)
    # db.session.commit()

    # product = Product(name='Canon EOS R10', description='', price=1300, product_picture='public/images/cameras/canon/R10.jpg', category=1)
    # db.session.add(product)
    # db.session.commit()

    # product = Product(name='Canon EOS R7', description='', price=1800, product_picture='public/images/cameras/canon/R7.jpg', category=1)
    # db.session.add(product)
    # db.session.commit()

    # product = Product(name='Canon RF 24-105 F4.0', description='', price=500, product_picture='public/images/cameras/canon/RF24-105F4.jpg', category=2)
    # db.session.add(product)
    # db.session.commit()

    # product = Product(name='Canon RF 50mm F1.8', description='', price=250, product_picture='public/images/cameras/canon/RF50F1.8.jpg', category=2)
    # db.session.add(product)
    # db.session.commit()

    # product = Product(name='Canon RF 70-200mm F2.8', description='', price=3000, product_picture='public/images/cameras/canon/RF70-2002.8.jpg', category=2)
    # db.session.add(product)
    # db.session.commit()

    # product = Product(name='K&F Concept Tripod', description='', price=70, product_picture='public/images/accessories/KFTripod.jpg', category=3)
    # db.session.add(product)
    # db.session.commit()

    # product = Product(name='DJI Mini3', description='', price=599, product_picture='public/images/accessories/DJIMini3.jpg', category=3)
    # db.session.add(product)
    # db.session.commit()

    # product = Product(name='DJI RS3', description='', price=429, product_picture='public/images/accessories/RS3.jpg', category=3)
    # db.session.add(product)
    # db.session.commit()




with app.app_context():
    u = Product.query.all()
    print(u)