import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FunkyListTile extends StatefulWidget {
  final leading;
  final title;
  final onTap;

  const FunkyListTile({Key? key, this.leading, this.title, this.onTap})
      : super(key: key);

  @override
  _FunkyListTileState createState() => _FunkyListTileState();
}

class _FunkyListTileState extends State<FunkyListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Material(
          color: Colors.grey.shade900,
          child: InkWell(
            splashColor: Theme.of(context).accentColor,
            onTap: widget.onTap,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  widget.leading,
                  SizedBox(width: 15),
                  widget.title,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
