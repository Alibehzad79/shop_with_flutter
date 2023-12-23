class CommentModel {
  var _id;
  var _body;
  var _user;

  CommentModel(this._id, this._body, this._user);

  get body => _body;
  get user => _user;
  get id => _id;
}
