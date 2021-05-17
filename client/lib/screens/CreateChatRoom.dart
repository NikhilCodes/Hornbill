import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/constants/Routes.dart';
import 'package:client/providers/ParticipatedChatRooms.dart';
import 'package:client/providers/User.dart';
import 'package:client/widgets/FunkyListTIle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateGroupFormScreen extends StatefulWidget {
  @override
  _CreateGroupFormScreenState createState() => _CreateGroupFormScreenState();
}

class _CreateGroupFormScreenState extends State<CreateGroupFormScreen> {
  bool isUploadingImage = false;
  String imageUrl = '';

  TextEditingController chatGroupNameEditController =
      new TextEditingController();

  Future<String> uploadGroupProfileImage(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$API_URL/chat-room/group-profile-image/upload'),
    );

    request.files.add(http.MultipartFile(
      'file',
      imageFile.readAsBytes().asStream(),
      imageFile.lengthSync(),
      filename: imageFile.path.split('/').last,
    ));

    var res = jsonDecode(await (await request.send()).stream.bytesToString());
    return res['url'];
  }

  @override
  Widget build(BuildContext context) {
    List<String> contactsToAdd =
        ModalRoute.of(context)!.settings.arguments as List<String>;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    File _image;
                    final picker = ImagePicker();
                    final pickedImage = await picker.getImage(
                      source: ImageSource.gallery,
                    );

                    if (pickedImage == null) return;
                    setState(() {
                      isUploadingImage = true;
                    });
                    _image = File(pickedImage.path);
                    uploadGroupProfileImage(_image).then((url) {
                      setState(() {
                        imageUrl = url;
                      });
                    });
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      imageUrl == ''
                          ? SizedBox(
                              height: 80,
                              width: 80,
                              child: Stack(
                                children: [
                                  Image(
                                    image:
                                        AssetImage('assets/images/avatar.png'),
                                    height: 80,
                                  ),
                                  isUploadingImage
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: CachedNetworkImage(
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                                imageUrl: imageUrl,
                              ),
                            ),
                      Container(
                        child: Center(
                          child: Icon(
                            Icons.add_a_photo,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.shade400,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: chatGroupNameEditController,
                    decoration: InputDecoration(hintText: 'Group Name'),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 40, left: 30),
              child: Text(
                '${contactsToAdd.length} contact${contactsToAdd.length == 1 ? '' : 's'} selected.',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check, size: 40),
        onPressed: () async {
          String adminContact =
              Provider.of<User>(context, listen: false).phoneNumber;
          if (!contactsToAdd.contains(adminContact)) {
            contactsToAdd.add(adminContact);
          }

          var jsonOutput = jsonDecode((await http.post(
            Uri.parse('$API_URL/chat-room'),
            body: {
              'name': chatGroupNameEditController.text,
              'imageUrl': imageUrl,
              'usersToAddByPhoneNumber': json.encode(contactsToAdd),
            },
          ))
              .body);

          Provider.of<ParticipatedChatRooms>(context, listen: false)
              .loadRoomParticipation();
          String groupId = jsonOutput['id'];
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.HOME.path, (route) => false);
        },
      ),
    );
  }
}

class CreateChatRoomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Select Contact'),
      ),
      body: ListView(
        children: [
          FunkyListTile(
            title: Text(
              'Create group',
              style: TextStyle(color: Colors.white),
            ),
            leading: Icon(
              Icons.people_sharp,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(Routes.CONTACT_SELECT.path);
            },
          ),
        ],
      ),
    );
  }
}
