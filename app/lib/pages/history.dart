import 'package:flutter/material.dart';

final class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() {
    return _HistoryPageState();
  }
}

final class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reward history"),
      ),
      body: SafeArea(child: const SizedBox()),
    );
  }
}
