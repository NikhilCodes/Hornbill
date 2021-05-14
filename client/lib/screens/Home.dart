import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/constants/Routes.dart';
import 'package:client/constants/StringConstants.dart';
import 'package:client/providers/ChatRoom.dart';
import 'package:client/providers/ParticipatedChatRooms.dart';
import 'package:client/providers/User.dart';
import 'package:client/screens/Login.dart';
import 'package:client/widgets/FunkyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      backgroundColor: Theme.of(context).primaryColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          elevation: 0,
          shadowColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.menu_sharp),
            onPressed: () {},
          ),
          title: Text(
            AppName,
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'Righteous',
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert_sharp,
              ),
            ),
          ],
        ),
      ),
      body: hasEncounteredError
          ? LoginScreen()
          : Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: hasLoaded
                  ? ListView.builder(
                      physics: BouncingScrollPhysics(),
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
                              title: Text(
                                chatRooms[index]['chatRoom']['name'],
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: chatRooms[index]['chatRoom']
                                          ['imageUrl'] ==
                                      ''
                                  ? Container(
                                      height: 55,
                                      width: 55,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(60),
                                      ),
                                      child: Icon(Icons.group_sharp),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: CachedNetworkImage(
                                        height: 55,
                                        width: 55,
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
