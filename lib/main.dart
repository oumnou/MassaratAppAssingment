import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:qssignment/post/post.dart';
import 'package:qssignment/settings/settings.dart';
import 'Search/search.dart';
import 'model/postModel.dart';


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
                            return PostModel(
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

