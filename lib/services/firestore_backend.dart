import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/site.dart';
import 'my_controller.dart';
import 'storage.dart';

class FirestoreBackend implements Storage {
  static const _sites = 'sites';
  static const _url = 'url';
  static const _username = 'username';
  static const _password = 'password';
  static const _users = 'users';

  @override
  Future<List<Site>> getSites() async {
    List<Site> siteList = [];
    final userId = MyController.getUserId();
    if (userId == null) throw StateError('Not logged in');

    await FirebaseFirestore.instance
        .collection(_users)
        .doc(userId)
        .collection(_sites)
        .get()
        .then((value) => value.docs.forEach((doc) {
              siteList.add(Site(
                  id: doc.id,
                  url: doc.data()[_url],
                  password: doc.data()[_password],
                  username: doc.data()[_username]));
            }));
    return siteList;
  }

  @override
  Future<Site> insertSite(String url, String username, String password) async {
    final userId = MyController.getUserId();
    if (userId == null) throw StateError('Not logged in');

    final ref = await FirebaseFirestore.instance
        .collection(_users)
        .doc(userId)
        .collection(_sites)
        .add({_url: url, _username: username, _password: password});
    return Site(id: ref.id, url: url, username: username, password: password);
  }

  @override
  Future<void> removeSite(Site site) {
    final userId = MyController.getUserId();
    if (userId == null) throw StateError('Not logged in');

    return FirebaseFirestore.instance
        .collection(_users)
        .doc(userId)
        .collection(_sites)
        .doc(site.id)
        .delete();
  }
}
