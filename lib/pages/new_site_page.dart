import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../viewModels/site_view_model.dart';

class NewSitePage extends StatefulWidget {
  @override
  _NewSitePageState createState() => _NewSitePageState();
}

class _NewSitePageState extends State<NewSitePage> {
  final textController = TextEditingController();
  final passController = TextEditingController();
  String genPassStr = "";
  bool specialCharacters = false;
  bool numbers = false;
  bool lowerLetters = false;
  bool upperLetters = false;

  @override
  Widget build(BuildContext context) {
    final siteService = Provider.of<siteViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add New Site')),
      body: ListView(
        children: [
          TextField(
            minLines: 1,
            maxLines: null,
            decoration: const InputDecoration(labelText: 'Site URL'),
            onChanged: (value) => siteService.changeUrl(value),
          ),
          TextField(
            minLines: 1,
            maxLines: null,
            decoration: const InputDecoration(labelText: 'Username'),
            onChanged: (value) => siteService.changeUsername(value),
          ),
          TextField(
            minLines: 1,
            maxLines: null,
            decoration: const InputDecoration(labelText: 'Password'),
            onChanged: (value) => siteService.changePassword(value),
            controller: passController,
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(
                [siteService.url, siteService.username, siteService.password]),
            child: const Text('Save Login'),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () => {generatePassword(int.parse(textController.text), siteService)},
            child: const Text('Generate Password'),
          ),
          TextField(
            minLines: 1,
            maxLines: null,
            decoration: const InputDecoration(labelText: 'Password length'),
            controller: textController,
          ),
          Row(
            children: <Widget>[
              Checkbox(
                value: specialCharacters,
                onChanged: (bool? value) {
                  setState(() {
                    specialCharacters = value!;
                  });
                },
              ),
              const Text('!@&#'),
            ],
          ),
          Row(
            children: <Widget>[
              Checkbox(
                value: numbers,
                onChanged: (bool? value) {
                  setState(() {
                    numbers = value!;
                  });
                },
              ),
              const Text('1234'),
            ],
          ),
          Row(
            children: <Widget>[
              Checkbox(
                value: lowerLetters,
                onChanged: (bool? value) {
                  setState(() {
                    lowerLetters = value!;
                  });
                },
              ),
              const Text('abcd'),
            ],
          ),
          Row(
            children: <Widget>[
              Checkbox(
                value: upperLetters,
                onChanged: (bool? value) {
                  setState(() {
                    upperLetters = value!;
                  });
                },
              ),
              const Text('ABCD'),
            ],
          ),
        ],
      ),
    );
  }

  void generatePassword(int size, siteViewModel siteService) {
    String result = "";
    bool foundChar;
    var randomClass = Random();

    for (int i = 0; i < size && (specialCharacters || numbers || upperLetters || lowerLetters); i++) {
      foundChar = false;
      while (!foundChar) {
        var rand = randomClass.nextInt(4);

        if (rand == 0 && specialCharacters) {
          result += getSpecial();
          foundChar = true;
        } else if (rand == 1 && numbers) {
          result += getNumber();
          foundChar = true;
        } else if (rand == 2 && upperLetters) {
          result += getUpper();
          foundChar = true;
        } else if (rand == 3 && lowerLetters) {
          result += getLower();
          foundChar = true;
        }
      }
    }

    if(result != "") {
      passController.text = result;
      siteService.changePassword(result);
    }
  }

  String getSpecial() {
    List<String> list = ["!","@","#","%","^","&","*","(",")","-","_","=","+","{","}","[","]",";",":","|","<",",",">",".","?","/","~","`"];
    return list[Random().nextInt(28)];
  }

  String getNumber() {
    List<String> list = ["0","1","2","3","4","5","6","7","8","9"];
    return list[Random().nextInt(10)];
  }

  String getUpper() {
    List<String> list = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
    return list[Random().nextInt(26)];
  }

  String getLower() {
    List<String> list = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
    return list[Random().nextInt(26)];
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
