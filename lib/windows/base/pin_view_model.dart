import 'package:pw_project/windows/base/base_view_model.dart';

abstract class PinViewModel extends BaseViewModel {
  Sink<String> get pinInput;
  Stream<bool> get isButtonEnabled;
}