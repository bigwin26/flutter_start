import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 10-json 파싱
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HttpSampleScreen(),
    );
  }
}

//Screen
class HttpSampleScreen extends StatefulWidget {
  const HttpSampleScreen({super.key});

  @override
  State<HttpSampleScreen> createState() => _HttpSampleScreenState();
}

class _HttpSampleScreenState extends State<HttpSampleScreen> {
  final model = HttpSampleModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    model.getUiData().whenComplete(()=> setState(() {
      
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HttpSampleScreen'),
      ),
      body: Center(
        child: Text('$model.title : $model.body'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        model.getUiData();
      }),
    );
  }
}

// Model (상태 & 로직)
class HttpSampleModel{
  // State
  String _title = '';
  String _body = 'Loading';

  String get body => _body;
  String get title => _title;

  // Logic
  Future<String> _getData() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
    final response = await http.get(url);
    print(response.body);
    return response.body;
  }

  Future<void> getUiData() async {
    final jsonString = await _getData();
    final jsonMap = jsonDecode(jsonString) as Map;

    _body = jsonMap['body'];
    _title = jsonMap['title'];
  }
}
