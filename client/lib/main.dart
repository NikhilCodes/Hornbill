import 'package:client/constants/Routes.dart';
import 'package:client/constants/StringConstants.dart';
import 'package:client/providers/ChatRoom.dart';
import 'package:client/providers/ParticipatedChatRooms.dart';
import 'package:client/providers/User.dart';
import 'package:client/screens/ChatRoomScreen.dart';
import 'package:client/screens/ContactSelection.dart';
import 'package:client/screens/CreateChatRoom.dart';
import 'package:client/screens/Home.dart';
import 'package:client/screens/Login.dart';
import 'package:client/screens/Splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(create: (_) => User()),
        // ChangeNotifierProvider<ParticipatedChatRooms>(create: (_) => ParticipatedChatRooms()),
        ChangeNotifierProxyProvider<User, ParticipatedChatRooms>(
          create: (context) {
            return ParticipatedChatRooms(
                userProvider: Provider.of<User>(context, listen: false));
          },
          update: (context, value, previous) {
            return ParticipatedChatRooms(userProvider: value);
          },
        ),
        ChangeNotifierProxyProvider<User, ChatRoom>(
          create: (context) {
            return ChatRoom(
                userProvider: Provider.of<User>(context, listen: false));
          },
          update: (context, value, previous) {
            return ChatRoom(userProvider: value);
          },
        ),
      ],
      child: MaterialApp(
        title: AppName,
        initialRoute: Routes.SPLASH.path,
        routes: {
          Routes.HOME.path: (context) => HomeScreen(),
          Routes.PRE_LOGIN.path: (context) => PreLoginScreen(),
          Routes.LOGIN.path: (context) => LoginScreen(),
          Routes.SPLASH.path: (context) => SplashScreen(),
          Routes.CREATE_CHAT.path: (context) => CreateChatRoomScreen(),
          Routes.CREATE_GROUP_FORM.path: (context) => CreateGroupFormScreen(),
          Routes.CONTACT_SELECT.path: (context) => ContactSelectionScreen(),
          Routes.CHAT_ROOM.path: (context) => ChatRoomScreen(),
        },
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.deepPurple,
          primaryColor: Colors.deepPurple.shade800,
          accentColor: Colors.purpleAccent.shade700,
          fontFamily: 'Comfortaa',
        ),
      ),
    );
  }
}
