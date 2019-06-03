import 'package:pw_project/database/entities/password_entity.dart';

class PasswordModel {
  PasswordModel(this.itemPosition, this.serviceName, this.password,
      {this.id = -1});

  final int id;
  final int itemPosition;
  final String serviceName;
  final String password;
  bool _passwordVisible = false;

  bool get passwordVisible => _passwordVisible;

  void changeVisibility() {
    _passwordVisible = !_passwordVisible;
  }

  PasswordEntity toEntity() {
    return PasswordEntity(id, serviceName, password, itemPosition);
  }

  PasswordModel addId(int id) {
    return PasswordModel(itemPosition, serviceName, password, id: id);
  }

  PasswordModel changeNameAndPassword(String newName, String newPassword) {
    return PasswordModel(itemPosition, newName, newPassword, id: id);
  }
}
