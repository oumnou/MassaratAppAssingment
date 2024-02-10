import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../post/post.dart';

class SearchWidget extends StatefulWidget {
  final Function(String) onTextChanged;

  const SearchWidget({Key? key, required this.onTextChanged}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search by title...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onChanged: widget.onTextChanged,
      ),
    );
  }
}
