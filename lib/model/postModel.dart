import 'package:flutter/material.dart';
import '../post/post.dart';


class PostModel extends StatefulWidget {


  final Post post ;
  final delete_post;
  final Color color;

  const PostModel({super.key, required this.post, required this.delete_post, required this.color});

  @override
  State<PostModel> createState() => _PostModelState();
}

class _PostModelState extends State<PostModel> {
  @override
  Widget build(BuildContext context) {

return Padding(
  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
  child: Card(
    elevation: 3,
    shadowColor: Colors.blue[100],
    shape: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10), // Set the border radius here
    ),
    borderOnForeground: true,
    color: Colors.grey[100],
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ID: ${widget.post.id}",
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            widget.post.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  _showMoreDialog(widget.post);
                },
                icon: const Icon(Icons.more_horiz_outlined),
              ),
              IconButton(
                onPressed: () {
                  widget.delete_post();
                },
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    ),
  ),
);

    
  }

  void _showMoreDialog(Post post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
         title:  Text('User ID :${post.title}',
         style: const TextStyle(color: Colors.blue),),
         content:Column(children: 
         [
          const Divider(
              height: 60.0,
              color: Colors.blue,
              ),
          Text(post.id.toString()),
          Text(post.userId.toString()),
          

          
        ]));
      },
    );
  }
}