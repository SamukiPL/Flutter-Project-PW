export 'splash_window_view_model_impl.dart';

import 'dart:async';

import 'package:pw_project/windows/base/base_view_model.dart';

abstract class SplashWindowViewModel extends BaseViewModel {
  Stream<bool> get isUserNew;
}