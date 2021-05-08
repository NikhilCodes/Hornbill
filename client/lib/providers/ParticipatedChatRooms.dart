import 'dart:convert';

import 'package:client/constants/Routes.dart';
import 'package:client/providers/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ParticipatedChatRooms extends ChangeNotifier {
  List roomParticipation = [];
  bool hasLoaded = false;

  User _userProvider;

  ParticipatedChatRooms({required User userProvider})
      : _userProvider = userProvider {
    loadRoomParticipation();
  }

  loadRoomParticipation() async {
    String userId = _userProvider.userId;

    if (userId == '') return;
    var response = (await http.get(
      Uri.parse('$API_URL/chat-room/$userId'),
    ))
        .body;

    roomParticipation = await jsonDecode(response);
    hasLoaded = true;
    notifyListeners();
  }
}
