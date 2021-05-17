import 'package:flutter/material.dart';

class SelectableListTile extends StatefulWidget {
  final Function onTap;
  final title;
  final subtitle;
  final leading;

  const SelectableListTile({Key? key, required this.onTap, this.title, this.subtitle, this.leading}) : super(key: key);

  @override
  _SelectableListTileState createState() => _SelectableListTileState();
}

class _SelectableListTileState extends State<SelectableListTile> {
  var isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: widget.title,
      key: widget.key,
      subtitle: widget.subtitle,
      leading: widget.leading,
      selectedTileColor: Colors.deepPurple.withOpacity(0.5),
      selected: isSelected,
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });

        widget.onTap();
      },
    );
  }
}