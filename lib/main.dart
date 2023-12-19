import 'dart:io';

import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import 'package:path/path.dart' as pa;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                File file = File(result.files.single.path ?? "");
                var crypt = AesCrypt('hap@2023#');
                crypt.setOverwriteMode(AesCryptOwMode.on);
                String decrypted = crypt.decryptFileSync('${file.path}');
                File mFile = File(decrypted);

                OpenFile.open(mFile.path);
              }
            },
            child: Text("DECRYPT"),
          ),
          ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles();
                if (result != null) {

                  File file = File(result.files.single.path ?? "");

                  File rawFile = File(pa.join(file.path))
                    ..createSync(recursive: true)
                    ..writeAsBytesSync(file.readAsBytesSync());

                  var crypt = AesCrypt('hap@2023#');
                  crypt.setOverwriteMode(AesCryptOwMode.on);

                  crypt.encryptFileSync(file.path);
                }
              },
              child: Text("Encrypt"))
        ],
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
