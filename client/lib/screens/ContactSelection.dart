import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/constants/Routes.dart';
import 'package:client/widgets/SelectableListItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ContactSelectionScreen extends StatefulWidget {
  @override
  _ContactSelectionScreenState createState() => _ContactSelectionScreenState();
}

class _ContactSelectionScreenState extends State<ContactSelectionScreen> {
  bool? _hasPermission;

  List<Widget> contacts = [];
  List<String> selectedContactNumbers = [];
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _askPermissions();
    });
  }

  Future<void> _askPermissions() async {
    PermissionStatus? permissionStatus;
    while (permissionStatus != PermissionStatus.granted) {
      try {
        permissionStatus = await _getContactPermission();
        if (permissionStatus != PermissionStatus.granted) {
          _hasPermission = false;
          _handleInvalidPermissions(permissionStatus);
        } else {
          _hasPermission = true;

          await loadRegisteredContacts();
        }
      } catch (e) {
        if (await showPlatformDialog(
                context: context,
                builder: (context) {
                  return PlatformAlertDialog(
                    title: Text('Contact Permissions'),
                    content: Text(
                        'We are having problems retrieving permissions.  Would you like to '
                        'open the app settings to fix?'),
                    actions: [
                      PlatformDialogAction(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: Text('Close'),
                      ),
                      PlatformDialogAction(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text('Settings'),
                      ),
                    ],
                  );
                }) ==
            true) {
          await openAppSettings();
        }
      }
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    final status = await Permission.contacts.status;
    if (!status.isGranted) {
      final result = await Permission.contacts.request();
      return result;
    } else {
      return status;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw PlatformException(
          code: 'PERMISSION_DENIED',
          message: 'Access to location data denied',
          details: null);
    } else if (permissionStatus == PermissionStatus.restricted) {
      throw PlatformException(
          code: 'PERMISSION_DISABLED',
          message: 'Location data is not available on device',
          details: null);
    }
  }

  Future<void> loadRegisteredContacts() async {
    socket = IO.io('$WEB_SOCKET_URL/user',
        IO.OptionBuilder().setTransports(['websocket']).build());

    socket.onConnect((data) async {
      socket.on('phone.check.isRegistered:result', (data) {
        if (data['isRegistered']) {
          setState(() {
            contacts.add(SelectableListTile(
              onTap: () {
                if (selectedContactNumbers.contains(data['phoneNumber'])) {
                  selectedContactNumbers.remove(data['phoneNumber']);
                } else {
                  selectedContactNumbers.add(data['phoneNumber']);
                }
              },
              key: Key('${data['phoneNumber']}'),
              title: Text(
                '${data['name']}',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('${data['phoneNumber']}'),
              leading: data['avatarImageUrl'] == ''
                  ? SizedBox(
                      height: 50,
                      width: 50,
                      child: Image(
                        image: AssetImage('assets/images/avatar.png'),
                        height: 60,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: CachedNetworkImage(
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                        imageUrl: data['avatarImageUrl'].toString(),
                      ),
                    ),
            ));
          });
        }
      });

      await Contacts.streamContacts().forEach((contact) {
        contact.phones.forEach((phoneNumber) {
          if (phoneNumber.value == null || phoneNumber.value == '') {
            return;
          }
          String cleanPhoneNumber = phoneNumber.value.toString();
          cleanPhoneNumber = cleanPhoneNumber.replaceAll(' ', '');
          cleanPhoneNumber = cleanPhoneNumber.startsWith('+91')
              ? cleanPhoneNumber
              : '+91$cleanPhoneNumber';

          socket.emit(
              'phone.check.isRegistered',
              ({
                'phoneNumber': cleanPhoneNumber,
              }));
        });
      });
    });
  }

  @override
  void dispose() {
    socket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Group',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              'Add participants',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return contacts[index];
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.navigate_next_sharp,
          size: 40,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(Routes.CREATE_GROUP_FORM.path,
              arguments: selectedContactNumbers);
        },
      ),
    );
  }
}
