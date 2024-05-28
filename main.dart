import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Book>> fetchBooks() async {
  final response = await http.get(
      Uri.parse('https://www.googleapis.com/books/v1/volumes?q=macedonia'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>;

    if (items.isNotEmpty) {
      return items
          .map((item) => Book.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('No books found');
    }
  } else {
    throw Exception('Failed to load books');
  }
}

class Book {
  final String title;
  final String description;

  const Book({
    required this.title,
    required this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] as Map<String, dynamic>;
    return Book(
      title: volumeInfo['title'] ?? 'No title available',
      description: volumeInfo['description'] ?? 'No description available',
    );
  }
}

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Book>> futureBooks;

  @override
  void initState() {
    super.initState();
    futureBooks = fetchBooks();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.deepPurple[100],
      title: const Text('Fetching JSON Data'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(30),
      child: FutureBuilder<List<Book>>(
        future: futureBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final book = snapshot.data![index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.description),
                );
              },
            );
          } else {
            return const Center(child: Text('No books available'));
          }
        },
      ),
    ),
  );
}
}
