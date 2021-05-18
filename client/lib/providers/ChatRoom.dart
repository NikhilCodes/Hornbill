import 'dart:convert';

import 'package:client/constants/Routes.dart';
import 'package:client/providers/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ChatRoom extends ChangeNotifier {
  String name = '';
  String id = '';
  String imageUrl = '';
  List<Map> messages = [];
  late IO.Socket socket;
  Database? database;

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
          messages.insert(0, data);
          database!.transaction((txn) async {
            await txn.insert('Chats', {
              'senderName': data['senderName'],
              'message': data['message'],
              'time': data['time'],
              'isOutgoingMessage': 0,
              'chatRoomId': id,
            });
          });
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
    this.imageUrl = '';
    this.id = id;
    this.messages = [];

    var response = await jsonDecode((await http.get(
      Uri.parse('$API_URL/chat-room/$id'),
    ))
        .body);

    this.name = response['name'];
    this.imageUrl = response['imageUrl'];
    getDatabasesPath().then((databasesPath) async {
      String path = join(databasesPath, 'chats_offline.db');
      // await deleteDatabase(path);
      this.database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
              'CREATE TABLE Chats (id INTEGER PRIMARY KEY, senderName TEXT, message TEXT, time TEXT, chatRoomId TEXT, isOutgoingMessage INTEGER)');
        },
      );

      this.messages = (await this.database!.rawQuery(
        'SELECT * FROM Chats WHERE chatRoomId LIKE ? LIMIT 50',
        [
          '$id%'
        ], // This is weird but simple where this=that doesn't work. TODO investigate!
      ))
          .reversed
          .toList();
      notifyListeners();
    });
    notifyListeners();
    this.becomeDeafToAllRooms();
    this.listenToCurrentActiveRoom();
  }

  sendMessage(String message, String userId) {
    var now = new DateTime.now();
    String timestamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    this.messages.insert(
        0,
        new Map<String, dynamic>.from({
          'senderId': userId,
          'message': message,
          'isOutgoingMessage': true,
          'time': timestamp,
        }));
    notifyListeners();
    socket.emit(
        'message.emit.server',
        ({
          'message': message,
          'senderId': userId,
          'roomId': id,
        }));

    database!.transaction((txn) async {
      await txn.insert('Chats', {
        'senderName': 'Me',
        'message': message,
        'time': timestamp,
        'isOutgoingMessage': 1,
        'chatRoomId': id,
      });
    });
  }
}
