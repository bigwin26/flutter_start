// 03-Future 사용법
// 04-동기 코드를 비동기 코드로 변경하는 예시
void main() async {
  // print(getData());
  // getData().then((value) => print(value));

  final result = await getData();

  print('end : $result');
}

Future<String> getData() async {
  // 1초 대기
  await Future.delayed(Duration(seconds: 1));
  return 'hello';
}