import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 13-Single Value 로 상태 모으기
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

// Screen (UI)
class HttpSampleScreen extends StatefulWidget {
  const HttpSampleScreen({super.key});

  @override
  State<HttpSampleScreen> createState() => _HttpSampleScreenState();
}

class _HttpSampleScreenState extends State<HttpSampleScreen> {
  final model = HttpSampleModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HttpSampleScreen'),
      ),
      body: Center(
        child: ListenableBuilder(
          listenable: model,
          builder: (BuildContext context, Widget? child) {
            return Text('${model.state.title} : ${model.state.body}');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        model.fetchData();
      }),
    );
  }
}

// Model (상태 & 로직)
class HttpSampleModel with ChangeNotifier {
  // State (Value)
  HttpSampleState _state = HttpSampleState();

  HttpSampleState get state => _state;

  HttpSampleModel() {
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
    _state = state.copyWith(
      title: jsonMap['title'],
      body: jsonMap['body'],
    );

    // 외부에 알려주자
    notifyListeners();
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
