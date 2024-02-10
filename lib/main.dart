import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:qssignment/post/post.dart';
import 'package:qssignment/settings/settings.dart';



void main() {
  runApp(const MaterialApp(
    home: MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late Post post ;
  int displayCount = 5;

  late List<Post> posts = [] ;

  bool isLoading = true ;

  void getTasks() async { 
    Response response = await get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));

    List<dynamic> responseData = jsonDecode(response.body);
    setState(() {
          for (var i = 0 ;i < responseData.length; i++)  {
            posts.add(Post(id: responseData[i]["id"], title:responseData[i]["title"], body:responseData[i]["body"], userId: responseData[i]["userId"]));
          }
          isLoading = false;

    });
  }
     @override
      void initState() {
        super.initState();
        getTasks();

      }

     @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final selectedCount = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    currentDisplayCount: displayCount,
                    onChanged: (count) {
                      setState(() {
                        displayCount = count;
                      });
                    },
                  ),
                ),
              );
              // Handle the user's selection if needed
              print('Selected display count: $selectedCount');
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: posts.length > displayCount ? displayCount : posts.length,
              itemBuilder: (context, index) {
                return _PostModel(
                  post: posts[index],
                  delete_post: () {
                    setState(() {
                      posts.removeAt(index);
                    });
                  },
                );
              },
            ),
    );
  }
}


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