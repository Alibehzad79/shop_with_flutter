class OrderModel {
  var _id;
  var _title;
  var _price;
  var _img;
  var _quantity;

  OrderModel(this._id, this._title, this._price, this._img, this._quantity);
  get id => _id;
  get title => _title;
  get price => _price;
  get img => _img;
  get quantity => _quantity;
}
