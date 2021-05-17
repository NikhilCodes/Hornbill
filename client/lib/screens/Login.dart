import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/constants/Routes.dart';
import 'package:client/constants/StringConstants.dart';
import 'package:client/providers/User.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuthLibrary;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:provider/provider.dart';

class PreLoginScreen extends StatefulWidget {
  @override
  _PreLoginScreenState createState() => _PreLoginScreenState();
}

class _PreLoginScreenState extends State<PreLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: AssetImage('assets/images/avatar.png'),
              height: 120,
            ),
            Container(height: 20),
            Text(
              AppName,
              style: TextStyle(
                fontSize: 60,
                color: Colors.white,
                fontFamily: 'Righteous',
              ),
            ),
            Text(
              'Online calls and\nmessaging made easy',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            Container(height: 10),
            Text(
              'We provide best communication service at your fingertips\n\nJoin For Free',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white54,
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 40),
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 20),
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(20),
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(80),
                        ),
                      ),
                    ),
                    fixedSize: MaterialStateProperty.all<Size>(Size(200, 50)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.greenAccent.shade400,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.LOGIN.path);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Icon(
                        Icons.arrow_right_alt_sharp,
                        color: Colors.white,
                        size: 40,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}

// class OtpVerificationDialogInput extends StatefulWidget {
//   final FirebaseAuthLibrary.FirebaseAuth auth;
//   final verificationId;
//   final phoneNumber;
//
//   const OtpVerificationDialogInput(
//       {Key? key, required this.auth, this.verificationId, this.phoneNumber})
//       : super(key: key);
//
//   @override
//   _OtpVerificationDialogInputState createState() =>
//       _OtpVerificationDialogInputState();
// }
//
// class _OtpVerificationDialogInputState
//     extends State<OtpVerificationDialogInput> {
//   final TextEditingController _pinEditingController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(
//         'OTP Verification',
//         style: TextStyle(
//           fontWeight: FontWeight.w800,
//           color: Theme.of(context).primaryColor,
//         ),
//       ),
//       content: Container(
//         height: 50,
//         child: PinInputTextFormField(
//           pinLength: 6,
//           autoFocus: true,
//           controller: _pinEditingController,
//           decoration: UnderlineDecoration(
//             textStyle: TextStyle(
//               color: Colors.grey,
//               fontSize: 30,
//             ),
//             colorBuilder: PinListenColorBuilder(
//               Theme.of(context).primaryColor,
//               Colors.red,
//             ),
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: Text('CANCEL'),
//         ),
//         TextButton(
//           onPressed: () async {
//             try {
//               var credential = FirebaseAuthLibrary.PhoneAuthProvider.credential(
//                 verificationId: widget.verificationId,
//                 smsCode: _pinEditingController.text,
//               );
//
//               await widget.auth.signInWithCredential(credential);
//             } on FirebaseAuthLibrary.FirebaseAuthException catch (e) {
//               print(e.code);
//               if (e.code == "invalid-verification-code") {
//                 print("Invalid Code!");
//               }
//             }
//           },
//           child: Text('VERIFY'),
//         ),
//       ],
//       elevation: 20,
//     );
//   }
// }

class OtpEntryScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpEntryScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _OtpEntryScreenState createState() => _OtpEntryScreenState();
}

class _OtpEntryScreenState extends State<OtpEntryScreen> {
  final TextEditingController _pinEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(
          'Verify Phone',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_sharp,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop('');
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Code is sent to ${widget.phoneNumber}',
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
              Spacer(),
              PinInputTextFormField(
                pinLength: 6,
                autoFocus: true,
                controller: _pinEditingController,
                decoration: BoxLooseDecoration(
                  textStyle: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 30,
                  ),
                  bgColorBuilder: PinListenColorBuilder(
                    Colors.blueGrey.shade50,
                    Colors.blueGrey.shade50,
                  ),
                  strokeColorBuilder: PinListenColorBuilder(
                      Colors.blueGrey.shade50, Colors.blueGrey.shade50),
                  strokeWidth: 30,
                  gapSpace: 14,
                  radius: Radius.circular(200),
                ),
              ),
              Spacer(),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 20),
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(20),
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(80),
                      ),
                    ),
                  ),
                  fixedSize: MaterialStateProperty.all<Size>(Size(200, 50)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.greenAccent.shade400,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop(_pinEditingController.text);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Verify',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Icon(
                      Icons.arrow_right_alt_sharp,
                      color: Colors.white,
                      size: 40,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isUploadingImage = false;
  bool isAlreadyAUser = false;
  TextEditingController nameEditingController = new TextEditingController();
  TextEditingController phoneEditingController = new TextEditingController();
  FirebaseAuthLibrary.FirebaseAuth _auth =
      FirebaseAuthLibrary.FirebaseAuth.instance;
  String verificationId = '';
  bool isProvidingOtp = false;

  @override
  void initState() {
    _auth.authStateChanges().listen((FirebaseAuthLibrary.User? user) {
      if (user != null) {
        print(user.phoneNumber);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String avatarUrl = Provider.of<User>(context).avatarUrl;

    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 40,
              vertical: MediaQuery.of(context).size.height * 0.07),
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                AppName,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Righteous',
                ),
              ),
              Text(
                'Enter the following details\nand get connected...',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: !isAlreadyAUser
                        ? MainAxisAlignment.spaceEvenly
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isAlreadyAUser
                          ? Container()
                          : GestureDetector(
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
                                await Provider.of<User>(context, listen: false)
                                    .uploadAvatarImage(_image);
                                setState(() {
                                  isUploadingImage = false;
                                });
                              },
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  avatarUrl == ''
                                      ? SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Stack(
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                    'assets/images/avatar.png'),
                                                height: 100,
                                              ),
                                              isUploadingImage
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                            imageUrl: avatarUrl,
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
                      isAlreadyAUser ? Container() : Spacer(),
                      isAlreadyAUser
                          ? Container()
                          : TextField(
                              controller: nameEditingController,
                              autocorrect: false,
                              keyboardType: TextInputType.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Savage Hornbill',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade400),
                              ),
                            ),
                      isAlreadyAUser ? Container() : Spacer(),
                      // TextField(
                      //   controller: phoneEditingController,
                      //   autocorrect: false,
                      //   maxLength: 10,
                      //   maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      //   keyboardType: TextInputType.phone,
                      //   style: TextStyle(
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.w600,
                      //     letterSpacing: 1.5,
                      //   ),
                      //   decoration: InputDecoration(
                      //     hintText: 'XXXXXXXXXX',
                      //     hintStyle: TextStyle(color: Colors.grey.shade400),
                      //     prefixIconConstraints:
                      //         BoxConstraints(minWidth: 0, minHeight: 0),
                      //     prefixIcon: Text(
                      //       '+91 ',
                      //       style: TextStyle(
                      //         fontSize: 20,
                      //         fontWeight: FontWeight.w800,
                      //         letterSpacing: 1.5,
                      //         color: Colors.grey.shade600,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // isAlreadyAUser ? Container() : Spacer(),
                      TextButton(
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(horizontal: 20),
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(60),
                                bottomRight: Radius.circular(20),
                                topLeft: Radius.circular(60),
                                topRight: Radius.circular(80),
                              ),
                            ),
                          ),
                          fixedSize:
                              MaterialStateProperty.all<Size>(Size(200, 50)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.greenAccent.shade400,
                          ),
                        ),
                        onPressed: () async {
                          final providers = [
                            AuthUiProvider.phone,
                            AuthUiProvider.apple,
                          ];

                          final result = await FlutterAuthUi.startUi(
                            items: providers,
                            tosAndPrivacyPolicy: TosAndPrivacyPolicy(
                              tosUrl: "https://www.google.com",
                              privacyPolicyUrl: "https://www.google.com",
                            ),
                            androidOption: AndroidOption(
                              enableSmartLock: false, // default true
                              showLogo: true, // default false
                              overrideTheme: false, // default false
                            ),
                          );

                          if (result) {
                            _auth.currentUser?.reload();
                            if (_auth.currentUser != null) {
                              await Provider.of<User>(context, listen: false)
                                  .register(
                                nameEditingController.text,
                                (_auth.currentUser?.phoneNumber).toString(),
                              );

                              Navigator.of(context).pushNamedAndRemoveUntil(
                                Routes.HOME.path,
                                (Route<dynamic> route) => false,
                              );
                            }
                          }
                          // _auth.verifyPhoneNumber(
                          //   phoneNumber: '+91${phoneEditingController.text}',
                          //   timeout: Duration(seconds: 120),
                          //   verificationFailed: (authException) => print(
                          //       "Failed!\nMessage:\n${authException.message}"),
                          //   codeSent: (verificationId,
                          //       [forceResendingToken]) async {
                          //     this.verificationId = verificationId;
                          //     this.isProvidingOtp = true;
                          //     String otpCode = await Navigator.of(context).push(
                          //       MaterialPageRoute(
                          //         builder: (context) => OtpEntryScreen(
                          //           phoneNumber:
                          //               '+91${phoneEditingController.text}',
                          //         ),
                          //       ),
                          //     );
                          //     this.isProvidingOtp = false;
                          //     if (otpCode == '') {
                          //       return;
                          //     }
                          //
                          //     try {
                          //       var credential = FirebaseAuthLibrary
                          //           .PhoneAuthProvider.credential(
                          //         verificationId: this.verificationId,
                          //         smsCode: otpCode,
                          //       );
                          //
                          //       await _auth.signInWithCredential(credential);
                          //       if (this.isAlreadyAUser) {
                          //         await Provider.of<User>(context,
                          //                 listen: false)
                          //             .login(phoneEditingController.text);
                          //       } else {
                          //         await Provider.of<User>(context,
                          //                 listen: false)
                          //             .register(nameEditingController.text,
                          //                 phoneEditingController.text);
                          //       }
                          //       Navigator.of(context).pushNamedAndRemoveUntil(
                          //           Routes.HOME.path,
                          //               (Route<dynamic> route) => false);
                          //     } on FirebaseAuthLibrary
                          //         .FirebaseAuthException catch (e) {
                          //       print(e.code);
                          //       print(e);
                          //       if (e.code == "invalid-verification-code") {
                          //         print("Invalid Code!");
                          //       }
                          //     }
                          //   },
                          //   codeAutoRetrievalTimeout: (verificationId) {
                          //     this.verificationId = verificationId;
                          //     if (this.isProvidingOtp) {
                          //       Navigator.of(context).pop('');
                          //     }
                          //
                          //     print("Time Out!");
                          //   },
                          //   verificationCompleted:
                          //       (FirebaseAuthLibrary.PhoneAuthCredential
                          //           phoneAuthCredential) {
                          //     _auth.signInWithCredential(phoneAuthCredential);
                          //   },
                          // );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Connect',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Icon(
                              Icons.arrow_right_alt_sharp,
                              color: Colors.white,
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                child: GestureDetector(
                  onTap: () async {
                    final providers = [
                      AuthUiProvider.phone,
                      AuthUiProvider.apple,
                    ];

                    final result = await FlutterAuthUi.startUi(
                      items: providers,
                      tosAndPrivacyPolicy: TosAndPrivacyPolicy(
                        tosUrl: "https://www.google.com",
                        privacyPolicyUrl: "https://www.google.com",
                      ),
                      androidOption: AndroidOption(
                        enableSmartLock: false, // default true
                        showLogo: true, // default false
                        overrideTheme: false, // default false
                      ),
                    );
                    if (result) {
                      _auth.currentUser?.reload();
                      if (_auth.currentUser != null) {
                        await Provider.of<User>(context, listen: false)
                            .login((_auth.currentUser?.phoneNumber).toString());
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          Routes.HOME.path,
                              (Route<dynamic> route) => false,
                        );
                      }
                    }
                  },
                  child: Text(
                    'Already a user?',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                alignment: Alignment.bottomRight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
