import 'package:flutter/material.dart';

class MyCartoonsPage extends StatefulWidget {
  const MyCartoonsPage({Key? key}) : super(key: key);

  @override
  State<MyCartoonsPage> createState() => _MyCartoonsPageState();
}

class _MyCartoonsPageState extends State<MyCartoonsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Column(
            children: [
              ListTile(
                title: Text('Cartoon Title'),
                subtitle: Text('Cartoon Subtitle'),
              ),
              Card(
                child: ListTile(
                  title: Text('Nested Cartoon 1'),
                  subtitle: Text('Subtitle 1'),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Nested Cartoon 2'),
                  subtitle: Text('Subtitle 2'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
