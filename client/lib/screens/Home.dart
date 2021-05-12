import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/constants/Routes.dart';
import 'package:client/providers/ChatRoom.dart';
import 'package:client/providers/ParticipatedChatRooms.dart';
import 'package:client/providers/User.dart';
import 'package:client/screens/Login.dart';
import 'package:client/widgets/FunkyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var hasEncounteredError = Provider.of<User>(context).hasEncounteredError;
    bool hasLoaded = Provider.of<ParticipatedChatRooms>(context).hasLoaded;
    List chatRooms =
        Provider.of<ParticipatedChatRooms>(context).roomParticipation;

    return Scaffold(
      appBar: PreferredSize(preferredSize: Size(0, 140), child: FunkyAppBar()),
      backgroundColor: Theme.of(context).primaryColor,
      body: hasEncounteredError
          ? LoginScreen()
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 2, color: Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                ),
              ),
              child: hasLoaded
                  ? ListView.builder(
                      itemCount: chatRooms.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: ListTileTheme(
                            minVerticalPadding: 30,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              tileColor: Colors.white,
                              onTap: () {
                                Provider.of<ChatRoom>(context, listen: false)
                                    .loadChatRoomById(
                                        chatRooms[index]['chatRoom']['id']);
                                Navigator.of(context).pushNamed(
                                    Routes.CHAT_ROOM.path,
                                    arguments: chatRooms[index]['chatRoom']
                                        ['id']);
                              },
                              title: Text(chatRooms[index]['chatRoom']['name']),
                              leading: chatRooms[index]['chatRoom']
                                          ['imageUrl'] ==
                                      ''
                                  ? SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Image(
                                        image: AssetImage(
                                            'assets/images/avatar.png'),
                                        height: 60,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: CachedNetworkImage(
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                        imageUrl: chatRooms[index]['chatRoom']
                                            ['imageUrl'],
                                      ),
                                    ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(Routes.CREATE_CHAT.path);
        },
        child: Icon(Icons.add_comment),
      ),
    );
  }
}
