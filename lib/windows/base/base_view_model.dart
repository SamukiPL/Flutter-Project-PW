import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class BaseViewModel {
  final storage = FlutterSecureStorage();

  void dispose();
}