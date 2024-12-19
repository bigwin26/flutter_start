import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// 17-Provider
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
      home: ChangeNotifierProvider<HttpSampleModel>(
        create: (_) => HttpSampleModel(),
        child: const HttpSampleScreen(),
      ),
    );
  }
}

// Screen (UI)
class HttpSampleScreen extends StatelessWidget {
  const HttpSampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<HttpSampleModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('HttpSampleScreen'),
      ),
      body: Center(
        child: Text('${model.value.title} : ${model.value.body}'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        // model.fetchData();
        context.read<HttpSampleModel>().fetchData();
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
