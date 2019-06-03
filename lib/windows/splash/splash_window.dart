import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:pw_project/windows/main/main_window.dart';
import 'package:pw_project/windows/new_user/new_user_window.dart';
import 'package:pw_project/windows/splash/view_model/splash_window_view_model.dart';

class SplashWindow extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _SplashWindowState();

}

class _SplashWindowState extends State<SplashWindow> {

  SplashWindowViewModel _viewModel;

  StreamSubscription skipLoginSubscription;

  @override
  void initState() {
    _viewModel = SplashWindowViewModelImpl();
    skipLoginSubscription = _viewModel.isUserNew.listen((isUserNew) {
      if (isUserNew)
        _welcomeNewUser();
      else
        _goToPasswords();
    });
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    skipLoginSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
    );
  }

  void _welcomeNewUser() {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => NewUserWindow()
    ));
  }

  void _goToPasswords() {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => MainWindow()
    ));
  }

}
