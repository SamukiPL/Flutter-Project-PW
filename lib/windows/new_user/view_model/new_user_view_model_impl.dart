import 'dart:async';

import 'package:pw_project/windows/new_user/view_model/new_user_view_model.dart';

class NewUserViewModelImpl extends NewUserViewModel {
  var _pinInputController = StreamController<String>.broadcast();
  var _goToMainWindowController = StreamController<bool>.broadcast();

  @override
  Stream<bool> get isButtonEnabled =>
      _pinInputController.stream.map((pin) => pin.length == 5);

  @override
  Stream<bool> get shouldGoToMainWindow =>
      _goToMainWindowController.stream.map((shouldGo) => shouldGo);

  @override
  Sink<String> get pinInput => _pinInputController;

  @override
  void dispose() {
    _pinInputController.close();
    _goToMainWindowController.close();
  }

  @override
  void savePin(String pinNumber) {
    storage.write(key: "pin", value: pinNumber);
    _goToMainWindowController.add(true);
  }

}