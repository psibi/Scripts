# http://code.tutsplus.com/articles/sql-for-beginners-part-3-database-relationships--net-8561
# Two tables: Customer and Address

from flask import Flask
from flask.ext.sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:////tmp/test2.db'
db = SQLAlchemy(app)

class Address(db.Model):
    id = db.Column(db.Integer, primary_key = True)
    address = db.Column(db.String(120), unique=True)

    def __init__(self, address):
        self.address = address

    def __repr__(self):
        return '<Address %r>' % self.address

# >>> db.create_all()
# >>> a1 = Address("address 1")
# >>> db.session.add(a1)
# >>> db.session.commit()
# >>> Address.query.all()
# [<Address u'address 1'>]

class Customer(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50))

    address_id = db.Column(db.Integer, db.ForeignKey('address.id'))
    address = db.relationship('Address',
                              backref=db.backref('customer', lazy='dynamic'))

    def __init__(self, name, address):
        self.name = name
        self.address = address

    def __repr__(self):
        return '<Customer %r>' % self.name
    
    
# >>> a1 = Address.query.all()[0]
# >>> a1
# <Address u'address 1'>
# >>> c = Customer("sibi", a1)
# >>> db.session.add(c)
# >>> db.session.commit()
# >>> Customer.query.all()
# [<Customer u'sibi'>]

# >>> a1.customer
# <sqlalchemy.orm.dynamic.AppenderBaseQuery object at 0x7f58abe11f50>
# >>> a1.customer.all()
# [<Customer u'sibi'>]
# >>> c.name
# u'sibi'
# >>> c.address
# <Address u'address 1'>
# >>> c.address.address
# u'address 1'
