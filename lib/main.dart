import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Replicate pure flutter query',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Replicate pure flutter query'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String replicateApiToken = 'You Token';
  dynamic _result;

  void _incrementCounter() {
    main();
    setState(() {
      _counter++;
      _result;
    });
  }

  Future<void> main() async {
    var response = await makeRequest();
    if (response.statusCode == 201) {
      var decodedResponse = json.decode(response.body);
      setState(() {
        _result = decodedResponse['input']['text'];
        print(_result);
      });
    } else {
      setState(() {
        _result = "Request failed with status code: ${response.statusCode} ";
        print(_result);
      });
    }
  }

  Future<http.Response> makeRequest() async {
    Map data = {
      "version":
          "5c7d5dc6dd8bf75c1acaa8565735e7986bc5b66206b55cca93cb72c9bf15ccaa",
      "input": {"text": "Name"}
    };

    var body = json.encode(data);
    var response = await http.post(
        Uri.parse('https://api.replicate.com/v1/predictions'),
        headers: {
          "Authorization": "Token $replicateApiToken",
          "Content-Type": "application/json"
        },
        body: body);

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_result',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
