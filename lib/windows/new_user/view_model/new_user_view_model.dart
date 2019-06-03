export 'new_user_view_model_impl.dart';

import 'package:pw_project/windows/base/pin_view_model.dart';

abstract class NewUserViewModel extends PinViewModel {

  Stream<bool> get shouldGoToMainWindow;

  void savePin(String pinNumber);

}