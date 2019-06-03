export 'main_view_model_impl.dart';

import 'package:pw_project/models/password_model.dart';
import 'package:pw_project/windows/base/pin_view_model.dart';

abstract class MainViewModel extends PinViewModel {
  Stream<List<PasswordModel>> get outputPasswordModelsList;

  void getPasswords();
  void managePasswordsVisibility(int itemId);
  void addPassword(String serviceName, String password);
  void editPassword(int id, String serviceName, String password);
  void deletePassword(PasswordModel model);
  void deleteAllPasswords();
  void validatePin(String enteredPin);
}