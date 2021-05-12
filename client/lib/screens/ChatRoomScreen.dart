import 'package:client/providers/ChatRoom.dart';
import 'package:client/providers/User.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                  : Colors.white,
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
                  isOutgoingMessage
                      ? 'Me'
                      : senderName.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  message,
                  style: TextStyle(
                    color: isOutgoingMessage
                        ? Colors.white
                        : Theme.of(context).primaryColor,
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

  @override
  Widget build(BuildContext context) {
    var messages = Provider.of<ChatRoom>(context).messages;
    String name = Provider.of<ChatRoom>(context).name;
    String userId = Provider.of<User>(context).userId;

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      backgroundColor: Colors.deepPurple.shade50,
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ChatBlob(
                    message: messages[index]['message'],
                    senderName: messages[index]['senderName'],
                    time: messages[index]['time'],
                    isOutgoingMessage: messages[index]['isOutgoingMessage'],
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
                      controller: messageTextController,
                      style: TextStyle(
                        fontSize: 17,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Message',
                        prefixIcon: Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.grey,
                        ),
                        hoverColor: Colors.white,
                        focusColor: Colors.white,
                        fillColor: Colors.white,
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
                      onPressed: () {
                        Provider.of<ChatRoom>(context, listen: false)
                            .sendMessage(messageTextController.text, userId);
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
