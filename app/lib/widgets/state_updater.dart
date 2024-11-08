import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// A mixin that uses to remote update [State] from parent [Widget].
/// 
/// Every [StatefulWidget.new] requires [GlobalKey] attach
/// into [StatefulWidget.key] if it's [State] mixed with [StateUpdater].
mixin StateUpdater<T extends StatefulWidget> on State<T> {
  @mustCallSuper
  @override
  void initState() {
    super.initState();
    onUpdating();
  }


  @protected
  void onUpdating();

  @nonVirtual
  void updateToRecent() {
    setState(() {
      onUpdating();
    });
  }
}