// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

import '../model/user_infos/points.dart';
import '../themes/colours.dart' show PointsRewardedColor;

enum _PointsTranscriptionAction {
  gain(PointsRewardedColor.gain),
  retain(Colors.grey),
  deduct(PointsRewardedColor.deduct);

  final Color? backgroundColor;

  const _PointsTranscriptionAction(this.backgroundColor);
}

extension _PointsTransiptionClassifier on PointsTranscription {
  _PointsTranscriptionAction _classifyAction() {
    if (totalPoints > 0) {
      return _PointsTranscriptionAction.gain;
    } else if (totalPoints < 0) {
      return _PointsTranscriptionAction.deduct;
    }

    return _PointsTranscriptionAction.retain;
  }
}

final class PointsActivity extends StatelessWidget {
  final PointsActivityTuple tuple;

  PointsActivity(this.tuple, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        isThreeLine: false,
        title: Text(tuple.description, style: const TextStyle(fontSize: 20)),
        trailing: SizedBox(
            width: 100,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Qty:${tuple.quantity}",
                      style: const TextStyle(fontSize: 16)),
                  Text("${tuple.netPoints}",
                      style: const TextStyle(fontSize: 16))
                ])));
  }
}

final class PointsStatement extends StatefulWidget {
  final PointsTranscription transcription;

  PointsStatement(this.transcription, {super.key});

  @override
  State<PointsStatement> createState() {
    return _PointsStatementState();
  }
}

final class _PointsStatementState extends State<PointsStatement> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    _PointsTranscriptionAction action = widget.transcription._classifyAction();
    int totalPts = widget.transcription.totalPoints;

    return ExpansionTile(
        onExpansionChanged: (value) {
          setState(() {
            expanded = value;
          });
        },
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6))),
        collapsedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6))),
        collapsedBackgroundColor: action.backgroundColor,
        backgroundColor: action.backgroundColor,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Text>[
              Text("Points ${action.name}",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w700)),
              Text("${totalPts > 0 ? '+' : ''}$totalPts",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w700))
            ]),
        trailing: Icon(
            expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
        children: widget.transcription.activities
            .map(PointsActivity.new)
            .toList(growable: false));
  }
}
