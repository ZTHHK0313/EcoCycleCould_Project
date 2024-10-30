import 'package:flutter/material.dart';

/// A mixin that uses to remote update [State] from parent [Widget].
/// 
/// Every [StatefulWidget.new] requires [GlobalKey] attach
/// into [StatefulWidget.key] if it's [State] mixed with [StateUpdater].
mixin StateUpdater<T extends StatefulWidget> on State<T> {
  void updateToRecent();
}