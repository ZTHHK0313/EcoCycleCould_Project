import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Foo"),
        actions: <IconButton>[
          // For user info page
          IconButton(onPressed: () {}, icon: const Icon(Icons.person))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {}, child: const Icon(Icons.favorite_border)),
      drawer: Drawer(
          child: ListView(children: <Widget>[
        // Dismiss drawer
        Padding(
            padding: const EdgeInsets.all(12),
            child: IconButton(
                onPressed: () {
                  Navigator.pop<void>(context);
                },
                icon: const Icon(Icons.arrow_back))),
        // Show history
        ListTile(
            leading: const Icon(FontAwesomeIcons.clock),
            title: const Text("Reward history"),
            onTap: () {}),
        // Open map
        ListTile(
            leading: const Icon(FontAwesomeIcons.locationDot),
            title: const Text("Find recycle bin"),
            onTap: () {})
      ])),
    );
  }
}
