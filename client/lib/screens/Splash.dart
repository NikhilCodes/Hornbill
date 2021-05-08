import 'package:client/constants/Routes.dart';
import 'package:client/constants/StorageKeys.dart';
import 'package:client/providers/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class SplashScreen extends  StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final storage = new FlutterSecureStorage();
    storage.read(key: StorageKey.USER_ID.value).then((value) async {
      if (value == null
          || await storage.read(key: StorageKey.TOKEN.value) == null) {
        Navigator.of(context).pushReplacementNamed(Routes.PRE_LOGIN.path);
      } else {
        Navigator.of(context).pushReplacementNamed(Routes.HOME.path);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}