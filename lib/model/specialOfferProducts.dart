class SpecialOfferProduct {
  var _id;
  var _title;
  var _price;
  var _off_price;
  var _img;
  var _description;
  var _category;
  var _rating;
  var _rating_count;

  SpecialOfferProduct(this._id, this._title, this._price, this._off_price, this._img,
      this._description, this._category, this._rating, this._rating_count);

  get rating_count => _rating_count;

  get rating => _rating;

  get category => _category;

  get description => _description;

  get img => _img;

  get price => _price;
  get off_price => _off_price;

  get title => _title;

  get id => _id;
}
