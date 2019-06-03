import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:pw_project/windows/main/main_window.dart';
import 'package:pw_project/windows/new_user/view_model/new_user_view_model.dart';

class NewUserWindow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewUserWindowState();
}

class _NewUserWindowState extends State<NewUserWindow> {
  NewUserViewModel _viewModel;

  PinEditingController pinController;

  StreamSubscription goToMainWindowSubscriber;

  @override
  void initState() {
    super.initState();
    _viewModel = NewUserViewModelImpl();
    pinController = PinEditingController(pinLength: 5, autoDispose: false);
    pinController.addListener(() {
      _viewModel.pinInput.add(pinController.text);
    });

    goToMainWindowSubscriber = _viewModel.shouldGoToMainWindow.listen((shouldGo) {
      if (shouldGo) {
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (_) => MainWindow(
                userEnteredPin: shouldGo
            )
        ));
      }
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    pinController.dispose();
    goToMainWindowSubscriber.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: buildBody(),
    );
  }

  Container buildBody() {
    return Container(
      child: passwordInput(),
    );
  }

  Column passwordInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Text(
            "Insert your pin number",
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
          margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        ),
        Container(
          child: Text(
            "We will use it to make sure, that only you can see your passwords!",
            style: TextStyle(
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
          margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
        ),
        Container(
          child: PinInputTextField(
            pinLength: 5,
            textInputAction: TextInputAction.go,
            decoration: UnderlineDecoration(
                textStyle: TextStyle(color: Colors.black, fontSize: 24),
                color: Colors.deepPurpleAccent),
            pinEditingController: pinController,
          ),
          margin: EdgeInsets.fromLTRB(25, 0, 25, 25),
        ),
        StreamBuilder<bool>(
          stream: _viewModel.isButtonEnabled,
          builder: (context, snapshot) {
            return FlatButton(
              color: Colors.deepPurpleAccent,
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: ((snapshot.data != null && snapshot.data)
                  ? () {
                      _savePin();
                    }
                  : null),
              disabledColor: Colors.grey,
            );
          },
        )
      ],
    );
  }

  void _savePin() {
    _viewModel.savePin(pinController.text);
  }
}
