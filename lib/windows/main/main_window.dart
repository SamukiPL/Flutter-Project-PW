import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:pw_project/models/password_model.dart';
import 'package:pw_project/windows/main/view_model/main_view_model.dart';

class MainWindow extends StatefulWidget {
  MainWindow({
    this.userEnteredPin = false,
  });

  final bool userEnteredPin;

  @override
  State<StatefulWidget> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  MainViewModel _viewModel;

  PinEditingController pinController;

  bool userEnteredPin = false;

  @override
  void initState() {
    super.initState();
    this.userEnteredPin = widget.userEnteredPin;
    _viewModel = MainViewModelImpl();
    pinController = PinEditingController(pinLength: 5, autoDispose: false);
    pinController.addListener(() {
      _viewModel.pinInput.add(pinController.text);
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                _showAuthorDialog();
              }),
          Visibility(
            child: IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () {
                  _removeAll();
                }),
            visible: userEnteredPin,
          )
        ],
      ),
      body: buildBody(),
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          onPressed: () {
            _addPasswordDialog();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        visible: userEnteredPin,
      ),
    );
  }

  Container buildBody() {
    return Container(
      child: buildListView(),
      margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
    );
  }

  StreamBuilder<List<PasswordModel>> buildListView() {
    return StreamBuilder<List<PasswordModel>>(
        stream: _viewModel.outputPasswordModelsList,
        builder: (context, snapshot) {
          if (userEnteredPin || snapshot.data != null) {
            userEnteredPin = true;
            int count = 0;
            if (snapshot.data != null) count = snapshot.data.length;
            return ListView.builder(
                itemCount: count,
                itemBuilder: (BuildContext context, int index) {
                  return _buildItem(snapshot.data[index], index == count - 1);
                });
          } else {
            return _pinInput();
          }
        });
  }

  Container _buildItem(PasswordModel model, bool lastItem) {
    return Container(
      child: Column(
        children: <Widget>[
          _buildMainItemRow(model),
          _buildHiddenItemRow(model)
        ],
      ),
      margin: EdgeInsets.fromLTRB(0, 5, 0, (lastItem) ? 60 : 5),
    );
  }

  Widget _buildMainItemRow(PasswordModel model) {
    return GestureDetector(
      child: Container(
        child: Row(
          children: <Widget>[
            Icon(
              Icons.remove_red_eye,
              size: 40,
            ),
            Expanded(
                child: Text(
              model.serviceName,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            )),
            IconButton(
              icon: Icon(
                Icons.edit,
                size: 40,
              ),
              onPressed: () {
                _addPasswordDialog(
                    id: model.id,
                    editName: model.serviceName,
                    editPassword: model.password);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                size: 40,
              ),
              onPressed: () {
                _viewModel.deletePassword(model);
              },
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
      ),
      onTap: () {
        _viewModel.managePasswordsVisibility(model.id);
      },
    );
  }

  Widget _buildHiddenItemRow(PasswordModel model) {
    return Visibility(
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                model.password,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
        ),
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      ),
      visible: model.passwordVisible,
    );
  }

  Column _pinInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("To see your passwords enter your pin number"),
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
                      _validatePin();
                    }
                  : null),
              disabledColor: Colors.grey,
            );
          },
        )
      ],
    );
  }

  void _validatePin() {
    _viewModel.validatePin(pinController.text);
  }

  void _addPasswordDialog(
      {int id = -1, String editName = "", String editPassword = ""}) {
    String serviceName = editName;
    TextEditingController passwordController =
        TextEditingController(text: editPassword);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text((editName.isEmpty) ? "Add Password" : "Edit Password"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(text: editName),
                          autofocus: true,
                          decoration: InputDecoration(labelText: "Service Name"),
                          onChanged: (change) {
                            serviceName = change;
                          },
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          autofocus: true,
                          decoration: InputDecoration(labelText: "Password"),
                          controller: passwordController,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          "Generate Password",
                          style: TextStyle(color: Colors.deepPurpleAccent),
                        ),
                        onPressed: () {
                          passwordController.text = _generatePassword();
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text((editName.isEmpty) ? "Add" : "Edit"),
                onPressed: () {
                  String password = passwordController.text;

                  if (serviceName.isNotEmpty && password.isNotEmpty) {
                    if (editName.isEmpty) {
                      _viewModel.addPassword(serviceName, password);
                    } else {
                      _viewModel.editPassword(id, serviceName, password);
                    }
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }

  String _generatePassword() {
    Random random = Random();
    String newPassword = "";
    for (int i = 0; i < 12; i++) {
      int charCode = random.nextInt(60);
      if (charCode <= 9) {
        newPassword += String.fromCharCode(charCode + 48);
      } else if (charCode > 9 && charCode <= 35) {
        newPassword += String.fromCharCode(charCode - 10 + 65);
      } else if (charCode > 35) {
        newPassword += String.fromCharCode(charCode - 36 + 97);
      }
    }
    return newPassword;
  }

  void _showAuthorDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('App Author'),
            content: const Text('Michał Kajzar ISI 1'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _removeAll() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete passwords?'),
          content: const Text('This will delete all your passwords!'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('OK'),
              onPressed: () {
                _viewModel.deleteAllPasswords();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
