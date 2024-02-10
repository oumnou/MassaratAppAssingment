import 'package:flutter/material.dart';
import '../post/post.dart';

class _PostModel extends StatefulWidget {


  final Post post ;
  final delete_post;

  const _PostModel({super.key, required this.post, required this.delete_post});

  @override
  State<_PostModel> createState() => __PostModelState();
}

class __PostModelState extends State<_PostModel> {
  @override
  Widget build(BuildContext context) {

return  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("User ID: ${widget.post.userId}"),
            const SizedBox(height: 8),
            Text(
              widget.post.title,
              style:const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(widget.post.body),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: (){ widget.delete_post();},
                  child: const Text("Delete"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showMoreDialog(widget.post.body);
                  },
                  child: const Text("More"),
                ),
              ],
            ),
          ],
        )
);
    
  }

  void _showMoreDialog(String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("More Content"),
          content: Text(content),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.delete),
              color: Colors.red,
            ),
          ],
        );
      },
    );
  }
}