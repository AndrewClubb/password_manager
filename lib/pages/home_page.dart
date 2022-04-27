import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/pages/new_site_page.dart';
import 'package:provider/provider.dart';

import '../model/site.dart';
import '../services/auth.dart';
import '../services/my_controller.dart';
import '../viewModels/profile_picture_notifier.dart';
import '../widgets/image_select_dialog.dart';
import 'opening_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<List<Site>> _sitesFuture = MyController.getSites();
  List<Site>? _sites;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Site>>(
      future: _sitesFuture,
      builder: (context, snapshot) {
        _sites = snapshot.hasData ? snapshot.data! : [];
        return ChangeNotifierProvider(
            create: (_) => ProfilePictureNotifier(),
            builder: (context, _) => Scaffold(
                  drawer: Drawer(
                      child: SafeArea(
                          child: Column(
                    children: [
                      ListTile(
                        title: const Text('Sign out'),
                        onTap: () {
                          Auth.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => OpeningPage()),
                              (_) => false);
                        },
                      ),
                      ListTile(
                          title: context.watch<ProfilePictureNotifier>().exists
                              ? const Text('Update profile picture')
                              : const Text('Add profile picture'),
                          onTap: () async {
                            final value = await showModalBottomSheet(
                                context: context,
                                builder: (_) => ImageSelectDialog());

                            if (value is Uint8List) {
                              context
                                  .read<ProfilePictureNotifier>()
                                  .updateProfilePicture(value);
                            }
                          })
                    ],
                  ))),
                  body: ReorderableListView(
                    children: Iterable<int>.generate(_sites!.length)
                        .map(_toWidget)
                        .map<List<Widget>>(
                            (e) => [e, Divider(key: UniqueKey())])
                        .expand<Widget>((e) => e)
                        .toList(),
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex = (newIndex - 1) ~/ 2;
                        } else {
                          newIndex = (newIndex + 1) ~/ 2;
                        }
                        final Site site = _sites!.removeAt(oldIndex ~/ 2);
                        _sites!.insert(newIndex, site);
                      });
                    },
                  ),
                  appBar: AppBar(
                    title: const Text('Passwords'),
                    actions: <Widget>[
                      if (_sites!.any((site) => site.isSelected))
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _sites
                                ?.where((site) => site.isSelected)
                                .forEach(MyController.deleteSite);
                            setState(() {
                              _sites?.removeWhere((sale) => sale.isSelected);
                            });
                          },
                        ),
                      if (context.watch<ProfilePictureNotifier>().exists)
                        CircleAvatar(
                          backgroundImage: MemoryImage(
                              context.read<ProfilePictureNotifier>().data!),
                        ),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context)
                          .push(
                              MaterialPageRoute(builder: (_) => NewSitePage()))
                          .then((value) async {
                        if (value != null &&
                            value is List &&
                            value.length == 3) {
                          final site =
                              await MyController.addSite(value[0], value[1], value[2]);
                          setState(() {
                            _sites!.insert(_sites!.length, site);
                          });
                        }
                      });
                    },
                  ),
                ));
      },
    );
  }

  Widget _toWidget(int i) {
    Site s = _sites![i];
    String subText = s.username + "\n" + s.password;

    return CheckboxListTile(
      secondary: const Icon(Icons.drag_handle),
      key: ValueKey(s),
      value: s.isSelected,
      onChanged: (bool? newValue) {
        setState(() {
          s.isSelected = newValue ?? false;
        });
      },
      title: Text(s.url),
      subtitle: Text(subText),
      isThreeLine: true,
    );
  }
}
