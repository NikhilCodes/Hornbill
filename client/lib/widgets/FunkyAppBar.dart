import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/providers/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FunkyAppBar extends StatefulWidget {
  @override
  _FunkyAppBarState createState() => _FunkyAppBarState();
}

class _FunkyAppBarState extends State<FunkyAppBar> {
  @override
  Widget build(BuildContext context) {
    Color borderColor = Theme.of(context).primaryColor;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0, color: Colors.transparent),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0, color: borderColor),
              ),
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              child: Text(
                'Chats',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 0, color: Colors.transparent),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  border: Border.all(width: 0, color: borderColor),
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(50)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 24, right: 24, bottom: 25),
                  child: TextField(
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search_sharp,
                        color: Colors.white,
                      ),
                      hoverColor: Colors.white30,
                      focusColor: Colors.white30,
                      fillColor: Colors.white30,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(60),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
