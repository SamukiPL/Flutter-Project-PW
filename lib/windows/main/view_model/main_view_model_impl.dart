import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:pw_project/database/helpers/password_helper.dart';
import 'package:pw_project/models/password_model.dart';
import 'package:pw_project/windows/main/view_model/main_view_model.dart';
import 'package:sqflite/sqflite.dart';

class MainViewModelImpl extends MainViewModel {
  MainViewModelImpl() {
    _openDatabase();
  }

  PasswordDatabaseHelper databaseHelper;

  var _pinInputController = StreamController<String>.broadcast();
  var _passwordsList = StreamController<List<PasswordModel>>.broadcast();

  List<PasswordModel> passwordsList;

  @override
  Stream<List<PasswordModel>> get outputPasswordModelsList =>
      _passwordsList.stream.map((list) => list);

  @override
  Stream<bool> get isButtonEnabled =>
      _pinInputController.stream.map((pin) => pin.length == 5);

  @override
  Sink<String> get pinInput => _pinInputController;

  @override
  void dispose() {
    _passwordsList.close();
    _pinInputController.close();
    databaseHelper.close();
  }

  @override
  void getPasswords() {
    databaseHelper.getAll().then((list) {
      passwordsList = list.map((entity) => entity.toListModel()).toList();
      passwordsList.sort((a, b) {
        return a.id.compareTo(b.id);
      });
      _passwordsList.add(passwordsList);
    });
  }

  @override
  void managePasswordsVisibility(int itemId) {
    passwordsList.firstWhere((model) => model.id == itemId).changeVisibility();
    _passwordsList.add(passwordsList);
  }

  @override
  void addPassword(String serviceName, String password) {
    var newModel = PasswordModel(passwordsList.length, serviceName, password);
    databaseHelper.insert(newModel).then((id) {
      passwordsList.add(newModel.addId(id));
      _passwordsList.add(passwordsList);
    });
  }

  @override
  void editPassword(int id, String serviceName, String password) {
    var model = passwordsList
        .firstWhere((listModel) => listModel.id == id)
        .changeNameAndPassword(serviceName, password);
    databaseHelper.update(model).then((_) {
      passwordsList.removeWhere((listModel) => listModel.id == id);
      passwordsList.add(model);
      passwordsList.sort((a, b) {
        return a.itemPosition.compareTo(b.itemPosition);
      });
      _passwordsList.add(passwordsList);
    });
  }

  @override
  void deletePassword(PasswordModel model) {
    databaseHelper.delete(model.id).then((id) {
      passwordsList.remove(model);
      _passwordsList.add(passwordsList);
    });
  }

  @override
  void deleteAllPasswords() {
    databaseHelper.deleteAll().then((_) {
      passwordsList.clear();
      _passwordsList.add(passwordsList);
    });
  }

  @override
  void validatePin(String enteredPin) {
    storage.read(key: "pin").then((actualPin) {
      if (enteredPin == actualPin) {
        getPasswords();
      }
    });
  }

  Future _openDatabase() async {
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, databaseName);

    try {
      await Directory(databasePath).create(recursive: true);
    } catch (_) {}

    databaseHelper = PasswordDatabaseHelper();

    await databaseHelper.open(path);
  }
}
