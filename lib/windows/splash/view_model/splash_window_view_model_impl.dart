import 'dart:async';

import 'package:pw_project/windows/splash/view_model/splash_window_view_model.dart';

class SplashWindowViewModelImpl extends SplashWindowViewModel {
  final _isUserNew = StreamController<bool>.broadcast();

  SplashWindowViewModelImpl() {
    storage.read(key: "pin").then((pin) {
      if (pin == null) {
        _isUserNew.add(true);
      } else {
        _isUserNew.add(false);
      }
    });
  }

  @override
  Stream<bool> get isUserNew => _isUserNew.stream.map((value) => value);

  @override
  void dispose() {
    _isUserNew.close();
  }
}