import 'dart:convert';

import 'package:client/constants/Routes.dart';
import 'package:client/providers/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatRoom extends ChangeNotifier {
  String name = '';
  String id = '';
  List<Map> messages = [];
  Map<String, String> mapUserIdToName = {};
  late IO.Socket socket;

  late User _userProvider;

  ChatRoom({required User userProvider}) {
    this._userProvider = userProvider;
    socket = IO.io('$WEB_SOCKET_URL/messaging',
        IO.OptionBuilder().setTransports(['websocket']).build());
    socket.onConnect((dataOnConnect) async {
      print('connected!');
      socket.on('message.emit.client', (data) {
        if (_userProvider.userId != data['senderId']) {
          data['isOutgoingMessage'] = false;
          messages.add(data);
        }
        notifyListeners();
      });
    });
  }

  becomeDeafToAllRooms() {
    socket.emit('room.leave.all');
  }

  listenToCurrentActiveRoom() {
    socket.emit('room.join', this.id);
  }

  loadChatRoomById(String id) async {
    this.name = '';
    this.id = id;
    this.messages = [];

    var response = await jsonDecode((await http.get(
      Uri.parse('$API_URL/chat-room/$id'),
    ))
        .body);

    this.name = response['name'];
    notifyListeners();
    this.becomeDeafToAllRooms();
    this.listenToCurrentActiveRoom();
  }

  sendMessage(String message, String userId) {
    var now = new DateTime.now();
    this.messages.add({
      'senderId': userId,
      'message': message,
      'isOutgoingMessage': true,
      'time':
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
    });
    notifyListeners();
    socket.emit(
        'message.emit.server',
        ({
          'message': message,
          'senderId': userId,
          'roomId': id,
        }));
  }
}
