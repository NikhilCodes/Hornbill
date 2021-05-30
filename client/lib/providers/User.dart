import 'dart:convert';
import 'dart:io';

import 'package:client/constants/Routes.dart';
import 'package:client/constants/StorageKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class User extends ChangeNotifier {
  String phoneNumber = '';
  String name = '';
  String avatarUrl = '';
  String userId = '';
  bool hasLoaded = false;
  bool hasEncounteredError = false;
  final storage = new FlutterSecureStorage();

  User() {
    autoLoadUser();
  }

  autoLoadUser() async {
    String? userId = await storage.read(key: StorageKey.USER_ID.value);
    String? token = await storage.read(key: StorageKey.TOKEN.value);
    if (userId == null || token == null) return;

    var response = (await http.post(
      Uri.parse('$API_URL/user/auto'),
      body: {
        'id': userId,
        'token': token,
      },
    ))
        .body;

    if (response == '') {
      await storage.delete(key: StorageKey.TOKEN.value);
      await storage.delete(key: StorageKey.USER_ID.value);

      this.hasEncounteredError = true;
      return;
    }

    var jsonOutput = jsonDecode(response);

    this.name = jsonOutput['username'];
    this.phoneNumber = jsonOutput['phoneNumber'];
    this.userId = jsonOutput['id'];
    this.hasLoaded = true;
    notifyListeners();
  }

  uploadAvatarImage(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$API_URL/user/avatar/upload'),
    );

    request.files.add(
      http.MultipartFile(
        'file',
        imageFile.readAsBytes().asStream(),
        imageFile.lengthSync(),
        filename: imageFile.path.split('/').last,
      ),
    );

    var res = jsonDecode(await (await request.send()).stream.bytesToString());
    avatarUrl = res['url'];
    notifyListeners();
  }

  register(String name, String phoneNumber) async {
    var jsonOutput = jsonDecode((await http.post(
      Uri.parse('$API_URL/user'),
      body: {
        'username': name,
        'phoneNumber': phoneNumber,
        'avatarImageUrl': this.avatarUrl,
      },
    ))
        .body);
    this.name = jsonOutput['username'].toString();
    this.phoneNumber = jsonOutput['phoneNumber'];
    this.userId = jsonOutput['id'];

    await storage.write(key: StorageKey.USER_ID.value, value: this.userId);
    await storage.write(
        key: StorageKey.TOKEN.value, value: jsonOutput['token']);
    this.hasLoaded = true;

    notifyListeners();
  }

  login(String phoneNumber) async {
    var jsonOutput = jsonDecode((await http.post(
      Uri.parse('$API_URL/user/login'),
      body: {
        'phoneNumber': phoneNumber,
      },
    ))
        .body);

    this.name = jsonOutput['username'];
    this.phoneNumber = jsonOutput['phoneNumber'];
    this.userId = jsonOutput['id'];

    await storage.write(key: StorageKey.USER_ID.value, value: this.userId);
    await storage.write(
        key: StorageKey.TOKEN.value, value: jsonOutput['token']);
    this.hasLoaded = true;

    notifyListeners();
  }
}
