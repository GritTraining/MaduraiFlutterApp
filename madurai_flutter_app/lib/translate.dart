import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: false,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController inputCtrl = TextEditingController();

  final translator = GoogleTranslator();
  String result = '';
  String selectedLanguage = 'ta'; // Default to Tamil
  final Map<String, String> languages = {
    'Tamil': 'ta',
    'Telugu': 'te', 
    'Hindi': 'hi',
    'French': 'fr'
  };

  void onLanguageChanged(String? value) {
    if (value != null) {
      setState(() {
        selectedLanguage = languages[value]!;
      });
    }
  }

  Future<Translation> translateText() async {
    var inputText = inputCtrl.text;
    Translation trans =
        await translator.translate(inputText, from: 'en', to: selectedLanguage);
    setState(() {
      result = trans.text;
    });
    return trans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Translator From English to Tamil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: languages.keys.firstWhere(
                (key) => languages[key] == selectedLanguage,
                orElse: () => 'Tamil',
              ),
              items: languages.keys.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onLanguageChanged,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: inputCtrl,
              decoration: const InputDecoration(
                  hintText: 'Enter the English Text', labelText: 'Text please'),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(result),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  translateText();
                },
                child: const Text('Translate'))
          ],
        ),
      ),
    );
  }
}