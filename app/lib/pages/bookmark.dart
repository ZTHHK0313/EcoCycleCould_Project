import 'package:flutter/material.dart';

final class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarked recycle bins"),
      ),
      body: SafeArea(child: Text("foo")),
    );
  }
  
}