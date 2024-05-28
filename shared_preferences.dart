import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
int counter = 0;

@override
void initState(){
  super.initState();
  loadCounter();
}

Future<void> loadCounter() async {
final prefs = await SharedPreferences.getInstance();

setState(() {
  counter = (prefs.getInt('counter') ?? 0);
});
}

Future<void> incrementCounter() async {
  final prefs = await SharedPreferences.getInstance();

  setState(() {
    counter += 1;
    prefs.setInt('counter', counter);
  });
}

Future<void> decrementCounter() async {
  final prefs = await SharedPreferences.getInstance();

  setState(() {
    counter -= 1;
    prefs.setInt('counter', counter);
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Shared Preferences'),
          backgroundColor: Colors.deepPurple[100],
        ),
        body: Center(
          child: Column( 
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {incrementCounter();},
                child: const Text('Increment'),
              ),
              const SizedBox(height: 30),
              Text(counter.toString()),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {decrementCounter();},
                child: const Text('Decrement'),
              )
          ]),
        ));
  }
}
