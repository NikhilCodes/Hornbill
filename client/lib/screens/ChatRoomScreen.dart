import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/providers/ChatRoom.dart';
import 'package:client/providers/User.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ChatBlob extends StatelessWidget {
  final String message;
  final String time;
  final bool isOutgoingMessage;
  final String? senderName;

  const ChatBlob(
      {Key? key,
      required this.message,
      required this.senderName,
      this.time = '',
      this.isOutgoingMessage = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: isOutgoingMessage
          ? EdgeInsets.only(left: 80)
          : EdgeInsets.only(right: 80),
      child: Column(
        crossAxisAlignment: isOutgoingMessage
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              right: 20,
              left: 20,
              bottom: 20,
              top: 20,
            ),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isOutgoingMessage
                  ? Theme.of(context).primaryColor
                  : Colors.white24,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
                topLeft: isOutgoingMessage
                    ? Radius.circular(30)
                    : Radius.circular(5),
                topRight: isOutgoingMessage
                    ? Radius.circular(5)
                    : Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOutgoingMessage ? 'Me' : senderName.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatRoomScreen extends StatefulWidget {
  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  TextEditingController messageTextController = new TextEditingController();
  ScrollController chatListViewController = new ScrollController();

  @override
  void initState() {
    Timer(
        Duration(milliseconds: 300),
            () => chatListViewController
            .jumpTo(chatListViewController.position.maxScrollExtent));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var messages = Provider.of<ChatRoom>(context).messages;
    String name = Provider.of<ChatRoom>(context).name;
    String chatRoomImageUrl = Provider.of<ChatRoom>(context).imageUrl;
    String userId = Provider.of<User>(context).userId;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.keyboard_arrow_left_sharp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 20),
                chatRoomImageUrl == ''
                    ? Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Icon(Icons.group_sharp),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: CachedNetworkImage(
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                          imageUrl: chatRoomImageUrl,
                        ),
                      ),
                SizedBox(width: 20),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                controller: chatListViewController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  // chatListViewController.animateTo(
                  //   0,
                  //   duration: Duration(milliseconds: 400),
                  //   curve: Curves.fastOutSlowIn,
                  // );
                  return ChatBlob(
                    message: messages[index]['message'],
                    senderName: messages[index]['senderName'],
                    time: messages[index]['time'],
                    isOutgoingMessage: messages[index]['isOutgoingMessage'] == 1 || messages[index]['isOutgoingMessage'],
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      minLines: 1,
                      controller: messageTextController,
                      style: TextStyle(fontSize: 17, color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Message',
                        hintStyle: TextStyle(
                          color: Colors.white60,
                        ),
                        prefixIcon: Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.grey,
                        ),
                        hoverColor: Colors.white12,
                        focusColor: Colors.white12,
                        fillColor: Colors.white12,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.transparent),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.transparent),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 0),
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 55,
                    margin: EdgeInsets.only(left: 10),
                    child: TextButton(
                      onPressed: () async {
                        if (messageTextController.text.trim().length == 0)
                          return;
                        Provider.of<ChatRoom>(context, listen: false)
                            .sendMessage(
                          messageTextController.text,
                          userId,
                        );
                        messageTextController.clear();
                      },
                      child: Icon(Icons.send),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
