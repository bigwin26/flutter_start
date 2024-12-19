import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const ProviderScope(child: MyApp()));
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
class HttpSampleScreen extends ConsumerWidget {
  const HttpSampleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(modelNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('HttpSampleScreen'),
      ),
      body: Center(
        child: Text('${state.title} : ${state.body}'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        ref.read(modelNotifierProvider.notifier).fetchData();
      }),
    );
  }
}

// Model (상태 & 로직)
class HttpSampleModel extends Notifier<HttpSampleState> {
  HttpSampleModel() {
    fetchData();
  }

  @override
  HttpSampleState build() => HttpSampleState();

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
    state = state.copyWith(
      title: jsonMap['title'],
      body: jsonMap['body'],
    );
  }
}

final modelNotifierProvider =
    NotifierProvider<HttpSampleModel, HttpSampleState>(HttpSampleModel.new);

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
