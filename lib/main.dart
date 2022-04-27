import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/pages/opening_page.dart';
import 'package:provider/provider.dart';

import 'viewModels/site_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext) {
    return ChangeNotifierProvider(
      create: (context) => siteViewModel(),
      child: MaterialApp(
        title: 'Password Manager',
        home: OpeningPage(),
      ),
    );
  }
}
