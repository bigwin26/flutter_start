import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 15-InheritedWidget 활용을 하기 위한 코드 구조 변경
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final model = HttpSampleModel();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ListenableBuilder(
        listenable: model,
        builder: (BuildContext context, Widget? child) {
          return HttpSampleScreen(
            model: model,
          );
        },
      ),
    );
  }
}

// Screen (UI)
class HttpSampleScreen extends StatelessWidget {
  final HttpSampleModel model;

  const HttpSampleScreen({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HttpSampleScreen'),
      ),
      body: Center(
        child: Text('${model.value.title} : ${model.value.body}'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        model.fetchData();
      }),
    );
  }
}

// Model (상태 & 로직)
class HttpSampleModel extends ValueNotifier<HttpSampleState> {
  HttpSampleModel() : super(HttpSampleState()) {
    fetchData();
  }

  // 로직
  Future<String> _getData() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
    final response = await http.get(url);
    print(response.body);
    return response.body;
  }

  void fetchData() async {
    final jsonString = await _getData();

    final jsonMap = jsonDecode(jsonString) as Map;

    // 상태 변경
    value = value.copyWith(
      title: jsonMap['title'],
      body: jsonMap['body'],
    );
  }
}

// State
class HttpSampleState {
  final String title;
  final String body;

  HttpSampleState({
    this.title = '',
    this.body = 'Loading',
  });

  HttpSampleState copyWith({
    String? title,
    String? body,
  }) {
    return HttpSampleState(
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
}
