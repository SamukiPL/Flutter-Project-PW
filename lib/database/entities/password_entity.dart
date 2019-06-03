import 'package:pw_project/database/helpers/password_helper.dart';
import 'package:pw_project/models/password_model.dart';

class PasswordEntity {
  PasswordEntity(this._id, this._service, this._password, this._position);

  int _id;
  String _service;
  String _password;
  int _position;

  PasswordEntity.fromMap(Map<String, dynamic> map) {
    _id = map[columnId];
    _service = map[columnService];
    _password = map[columnPassword];
    _position = map[columnPosition];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnService: _service,
      columnPassword: _password,
      columnPosition: _position
    };
    if (_id != -1) {
      map[columnId] = _id;
    }

    return map;
  }

  PasswordModel toListModel() {
    return PasswordModel(_position, _service, _password, id: _id);
  }
}
