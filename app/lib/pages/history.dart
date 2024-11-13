import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/transcription.dart';
import '../model/user_infos/user.dart';
import '../widgets/points.dart';

final class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() {
    return _HistoryPageState();
  }
}

final class _HistoryPageState extends State<HistoryPage> {
  late int page;

  @override
  void initState() {
    page = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUsr = context.read<CurrentUserManager>().current;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reward history"),
      ),
      body: SafeArea(
          child: FutureBuilder<PointsTranscriptionsPage>(
              future: loadPointsTranscription(currentUsr, page),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return const CircularProgressIndicator();
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      final (:transcriptions, :hasNext) = snapshot.data!;
                      VoidCallback? mvLeft = page > 1
                              ? () {
                                  setState(() {
                                    page--;
                                  });
                                }
                              : null,
                          mvRight = hasNext
                              ? () {
                                  setState(() {
                                    page++;
                                  });
                                }
                              : null;

                      return Column(
                        children: <Widget>[
                          Expanded(
                              child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  itemCount: transcriptions.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: PointsStatement(
                                            transcriptions[index]));
                                  })),
                          SizedBox(
                              height: 64,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    TextButton.icon(
                                        onPressed: mvLeft,
                                        icon: const Icon(Icons.arrow_left),
                                        label: const Text("Prev")),
                                    Text("$page",
                                        style: const TextStyle(fontSize: 18)),
                                    TextButton.icon(
                                        onPressed: mvRight,
                                        icon: const Icon(Icons.arrow_right),
                                        label: const Text("Next"))
                                  ]))
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Padding(
                              padding: EdgeInsets.all(16),
                              child: Icon(Icons.error_outline, size: 48)),
                          const Text("Data temproary unavailable"),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {});
                                },
                                child: const Text("Reload")),
                          )
                        ],
                      );
                    }
                  default:
                    break;
                }

                return const SizedBox();
              })),
    );
  }
}
