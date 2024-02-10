import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:qssignment/post/post.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {


  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late Post post ;

  late List<Post> listOftasks = [] ;

  bool isLoading = true ;

  void getTasks() async { 
    Response response = await get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));

    List<dynamic> responseData = jsonDecode(response.body);
    setState(() {
          for (var i = 0 ;i < responseData.length; i++)  {
            listOftasks.add(Post(id: responseData[i]["id"], title:responseData[i]["title"], body:responseData[i]["body"], userId: responseData[i]["userId"]));
          }
          isLoading = false;

    });
  }
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}



