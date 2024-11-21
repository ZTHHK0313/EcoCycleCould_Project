import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/recycle_bin.dart';
import '../model/recycle_bin/capacity.dart';
import '../model/recycle_bin/location.dart';
import '../model/user_infos/user.dart';
import '../widgets/recycle_bin.dart';

final class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() {
    return _BookmarkPageState();
  }
}

enum _LongPressBookmarkAction { remove, cancel }

final class _BookmarkPageState extends State<BookmarkPage> {
  void _onLongPress(
      BuildContext context, User usr, RecycleBinLocation rbLoc) async {
    _LongPressBookmarkAction lpa = await showDialog<_LongPressBookmarkAction>(
            context: context,
            builder: (context) {
              return SimpleDialog(children: <SimpleDialogOption>[
                SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop<_LongPressBookmarkAction>(
                          context, _LongPressBookmarkAction.remove);
                    },
                    child: const Text("Remove this bookmark"))
              ]);
            }) ??
        _LongPressBookmarkAction.cancel;

    switch (lpa) {
      case _LongPressBookmarkAction.remove:
        bool performRM = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                      title: const Text(
                          "Do you want to remove this recycle bin in your bookmark?"),
                      actions: <TextButton>[
                        TextButton(
                            onPressed: () {
                              Navigator.pop<bool>(context, true);
                            },
                            child: const Text("Yes")),
                        TextButton(
                            onPressed: () {
                              Navigator.pop<bool>(context, false);
                            },
                            child: const Text("No"))
                      ]);
                }) ??
            false;

        if (!performRM) {
          break;
        }

        if (await alterRecycleBinBookmark(
            usr, rbLoc, AlterRecycleBinBookmarkAction.remove)) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: const Text("Removed"),
                    actions: <TextButton>[
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Close"))
                    ]);
              }).then((_) {
            setState(() {});
          });
        } else {
          showDialog<void>(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: const Text("Unexpected error"),
                    content: const Text("Try again later"),
                    actions: <TextButton>[
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK"))
                    ]);
              });
        }
      case _LongPressBookmarkAction.cancel:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUsr = context.read<CurrentUserManager>().current;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Bookmarked recycle bins"),
        ),
        body: SafeArea(
            child: FutureBuilder<List<(RecycleBinLocation, RemainCapacity)>>(
                future: loadBookmarkedRecycleBins(currentUsr),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return const CircularProgressIndicator();
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        final tuples = snapshot.data!;

                        return ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            shrinkWrap: true,
                            itemCount: tuples.length,
                            itemBuilder: (BuildContext context, int index) {
                              var (rbLoc, rbCap) = tuples[index];

                              return Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: GestureDetector(
                                      onLongPress: () => _onLongPress(
                                          context, currentUsr, rbLoc),
                                      child:
                                          RecycleBinStatusInfo(rbLoc, rbCap)));
                            });
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Column(children: [
                          Padding(
                              padding: EdgeInsets.all(16),
                              child: Icon(Icons.error_outline, size: 36)),
                          Text("Cannot load all bookmarked recycle bin.")
                        ]));
                      }
                    default:
                      break;
                  }
                  return const SizedBox();
                })));
  }
}
