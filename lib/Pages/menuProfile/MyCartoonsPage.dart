import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyCartoonsPage extends StatefulWidget {
  const MyCartoonsPage({Key? key}) : super(key: key);

  @override
  State<MyCartoonsPage> createState() => _MyCartoonsPageState();
}

class _MyCartoonsPageState extends State<MyCartoonsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User? _user;
  List<Widget> episodeWidgets = []; // Add this line

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    _user = _auth.currentUser;
    setState(() {});
  }

  Future<void> _getPurchasedEpisodes() async {
    try {
      if (_user != null) {
        // Get the user's data from Firestore
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _firestore.collection('users').doc(_user!.uid).get();

        if (userDoc.exists) {
          // Check if the user is logged in
          if (_user!.uid == userDoc.id) {
            var purchasedEpisodes = userDoc['purchasedEpisodes'] ?? [];

            List<Widget> episodeWidgets = [];

            for (var episode in purchasedEpisodes) {
              var episodeId = episode['episodeId'];

              // Check if 'storys' contains information for the episode
              if (userDoc['storys'] != null &&
                  userDoc['storys'].containsKey(episodeId)) {
                var storySnapshot = userDoc['storys'][episodeId];
                var title = storySnapshot['title'];
                var id = storySnapshot['id'];

                // Create a Widget for the episode
                Widget episodeWidget = Card(
                  child: ListTile(
                    title: Text(title),
                    subtitle: Text('ID: $id'),
                  ),
                );

                // Add the Widget to the list
                episodeWidgets.add(episodeWidget);
              } else {
                // Handle the case where the episode information is not found
                print('Episode Not Found');
              }
            }

            // Update the UI with the episode Widgets
            setState(() {
              episodeWidgets.add(
                ListTile(
                  title: Text('Cartoon Title'),
                  subtitle: Text('Cartoon Subtitle'),
                ),
              );

              // Wrap the episode Widgets in a Column
              episodeWidgets = [
                ...episodeWidgets,
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
              ];
            });
          } else {
            print('User not logged in');
          }
        } else {
          print('User document does not exist');
        }
      } else {
        print('User not authenticated');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cartoons'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _user != null
            ? Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _getPurchasedEpisodes();
                    },
                    child: Text('Get Purchased Episodes'),
                  ),
                  // Display the episode Widgets
                  ...episodeWidgets,
                ],
              )
            : Center(
                child: Text('Please sign in to view your cartoons.'),
              ),
      ),
    );
  }
}
