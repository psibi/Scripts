# http://code.tutsplus.com/articles/sql-for-beginners-part-3-database-relationships--net-8561
# Three tables: Orders, Items, Items_orders

from flask import Flask
from flask.ext.sqlalchemy import SQLAlchemy
from sqlalchemy.ext.associationproxy import association_proxy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:////tmp/test11.db'
db = SQLAlchemy(app)

class Item(db.Model):

    __tablename__ = "item"
    
    id = db.Column(db.Integer, primary_key = True)
    item_name = db.Column(db.String(120))
    item_description = db.Column(db.String(200))

    items_orders = db.relationship("Items_Orders")
    orders = association_proxy("items_orders", "order")

    def __init__(self, name, desc):
        self.item_name = name
        self.item_description = desc

    def __repr__(self):
        return '<Item %s>' % self.item_name

class Order(db.Model):

    __tablename__ = "order"
    
    id = db.Column(db.Integer, primary_key = True)
    order_amount = db.Column(db.Integer)

    def __init__(self, order_amount):
        self.order_amount = order_amount

    def __repr__(self):
        return '<Order id: %s>' % self.id

class Items_Orders(db.Model):

    __tablename__ = "items_orders"

    id = db.Column(db.Integer, primary_key = True)
    order_id = db.Column(db.Integer, db.ForeignKey('order.id'))
    item_id = db.Column(db.Integer, db.ForeignKey('item.id'))

    item = db.relationship("Item")
    order = db.relationship("Order")

    def __init__(self, order_id, item_id):
        self.order_id = order_id
        self.item_id = item_id

    def __repr__(self):
        return '<order %s : item %s>' % (self.order_id, self.item_id)

db.create_all()
i1 = Item("toothpaste", "for shiny teeths")
i2 = Item("iphone", "For shiny teeths")
i3 = Item("keyboard", "gives you pinky pain")

o1 = Order(400)
o2 = Order(300)
o3 = Order(800)

data = [i1, i2, i3, o1, o2, o3]
for d in data:
    db.session.add(d)
    db.session.commit()
db.session.flush()
    
oi1 = Items_Orders(o1.id, i1.id)
oi2 = Items_Orders(o1.id, i3.id)
oi3 = Items_Orders(o2.id, i1.id)
oi4 = Items_Orders(o2.id, i2.id)
oi5 = Items_Orders(o2.id, i3.id)
oi6 = Items_Orders(o3.id, i1.id)

data = [oi1, oi2, oi3, oi4, oi5, oi6]
for d in data:
    db.session.add(d)
    db.session.commit()
# +-----+------------+----------------+
# |id   |item_name   |item_description|
# +-----+------------+----------------+
# |1    |toothpastee |For shiny teeths|
# +-----+------------+----------------+
# |2    |iphone      |nothng close to |
# |     |            |affordable rate.|
# +-----+------------+----------------+
# |3    |keyboarda   |gives you pinky |
# |     |            |pain            |
# +-----+------------+----------------+

# +-----+------------+
# |id   |order_amount|
# +-----+------------+
# |1    |400         |
# +-----+------------+
# |2    |300         |
# +-----+------------+
# |3    |800         |
# +-----+------------+

# +--------+-------+
# |order_id|item_id|
# +--------+-------+
# |1       |1      |
# +--------+-------+
# |1       |3      |
# +--------+-------+
# |2       |1      |
# +--------+-------+
# |2       |2      |
# +--------+-------+
# |2       |3      |
# +--------+-------+
# |3       |1      |
# +--------+-------+


# >>> it = Item.query.all()
# >>> it
# [<Item toothpaste>, <Item iphone>, <Item keyboard>]

# >>> it[0].items_orders
# [<order 1 : item 1>, <order 2 : item 1>, <order 3 : item 1>]

# >>> it[0].orders                  # orders property because of association_proxy
# [<Order id: 1>, <Order id: 2>, <Order id: 3>]
