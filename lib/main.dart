import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:qssignment/post/post.dart';
import 'package:qssignment/settings/settings.dart';

import 'Search/search.dart';


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
  late Post post;
  int displayCount = 5;
  int pageIndex = 0; 

  late List<Post> posts = [];
  late List<Post> filteredPosts = [];

  bool isLoading = true;

  void getPosts() async {
    try {
      Response response = await get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
      print(response);

      List<dynamic> responseData = jsonDecode(response.body);
      print(responseData);
      setState(() {
        for (var i = 0; i < responseData.length; i++) {
          posts.add(Post(
              id: responseData[i]["id"],
              title: responseData[i]["title"],
              body: responseData[i]["body"],
              userId: responseData[i]["userId"]));
        }
        filteredPosts = List.from(posts);
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  void searchFunction(String query) {
    setState(() {
      filteredPosts = posts.where((post) => post.title.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data"),
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
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SearchWidget(onTextChanged: searchFunction),
                ),
                Expanded(
                  child: PageView.builder(
                    itemCount: (filteredPosts.length / displayCount).ceil(),
                    itemBuilder: (context, index) {
                      return ListView.builder(
                        itemCount: displayCount,
                        itemBuilder: (context, innerIndex) {
                          final postIndex = index * displayCount + innerIndex;
                          if (postIndex < filteredPosts.length) {
                            return _PostModel(
                              color: Colors.white,
                              post: filteredPosts[postIndex],
                              delete_post: () {
                                setState(() {
                                  posts.remove(filteredPosts[postIndex]);
                                  filteredPosts.removeAt(postIndex);
                                });
                              },
                            );
                          } else {
                            return const SizedBox(); // Return empty SizedBox if no more posts
                          }
                        },
                      );
                    },
                    onPageChanged: (index) {
                      setState(() {
                        pageIndex = ++index; // Update pageIndex when page changes
                        print(pageIndex);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    'Page: ${(pageIndex)} / ${(filteredPosts.length / displayCount).ceil()}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}





































class _PostModel extends StatefulWidget {


  final Post post ;
  final delete_post;
  final Color color;

  const _PostModel({super.key, required this.post, required this.delete_post, required this.color});

  @override
  State<_PostModel> createState() => __PostModelState();
}

class __PostModelState extends State<_PostModel> {
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
                  _showMoreDialog(widget.post.body, widget.post.userId.toString());
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

  void _showMoreDialog(String body, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text('User ID :$id'),
          content: Text(body),
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