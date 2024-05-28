import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;

  void _selectDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: const Text("Forms"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 50, 50, 20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text("Please Enter Email:"),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Email';
                    } else if (!value.contains('@')) {
                      return 'Enter Valid Email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text('Email'),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text("Please Enter Password:"),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Password';
                    } else if (value.length < 5) {
                      return 'Password must be at least 5 characters';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text('Password'),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text('Select Date'),
                Text(_selectedDate == null ? '' : _selectedDate.toString()),
                ElevatedButton(
                    onPressed: () {
                      _selectDate();
                    },
                    child: const Text("Select Date")),
                
                const SizedBox(
                  height: 50,
                ),
                FloatingActionButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Saved!')),
                      );
                    }else if (_selectedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Select Date of Birth')),
                      );
                    }
                  },
                  child: const Text('Save'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
