import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {

  final TextEditingController _controller = TextEditingController();
  // final ScrollController _scrollController = ScrollController();


  final translator = GoogleTranslator();

  List<Map<String, String>> storedValues = [];
  String originalLanguage = 'en';
  String translatedLanguage = 'es';

  List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'ar', 'name': 'Arabic'},
    {'code': 'hi', 'name': 'Hindi'},
    {'code': 'ur', 'name': 'Urdu'},
    {'code': 'de', 'name': 'German'},
    {'code': 'it', 'name': 'Italian'},
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'fr', 'name': 'French'},
  ];

  @override
  void initState() {
    super.initState();
    _loadStoredValues();
  }

  @ override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _loadStoredValues();
  }

  Future<void> _loadStoredValues() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? storedList = prefs.getStringList('stored_values');
    if (storedList != null) {
      setState(() {
        storedValues = storedList.map((item) {
          List<String> splitItem = item.split('|');
          return {'original': splitItem[0], 'translated': splitItem[1]};
        }).toList();
      });
    }
  }

  Future<void> _saveValue() async {
    final prefs = await SharedPreferences.getInstance();
    if (_controller.text.isNotEmpty) {
      // translationController.controller
      String originalText = _controller.text; // translationController.controller
      String translatedText = await translator // translatedtext
          .translate(originalText, from: originalLanguage, to: translatedLanguage)
          .then((value) => value.text);
      storedValues.add({'original': originalText, 'translated': translatedText});
      List<String> storedList =
      storedValues.map((item) => "${item['original']}|${item['translated']}").toList();
      await prefs.setStringList('stored_values', storedList);
      _controller.clear();// translationController.controller
      setState(() {});
    }
  }

  Future<void> _resetValues() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('stored_values');
    setState(() {
      storedValues.clear();
    });
  }

  void _removeSingleResult(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      storedValues.removeAt(index);
    });
    List<String> storedList =
    storedValues.map((item) => "${item['original']}|${item['translated']}").toList();
    await prefs.setStringList('stored_values', storedList);
  }

  void _showLanguagePicker(bool isOriginal) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: languages.map((lang) {
                return ListTile(
                  title: Text(lang['name']!),
                  onTap: () async {
                    setState(() {
                      if (isOriginal) {
                        originalLanguage = lang['code']!;
                      } else {
                        translatedLanguage = lang['code']!;
                      }
                    });

                    // Re-translate all stored values
                    await _retranslateStoredValues();

                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _retranslateStoredValues() async {
    final prefs = await SharedPreferences.getInstance();

    List<Map<String, String>> updatedValues = [];

    for (var item in storedValues) {
      String newTranslation = await translator
          .translate(item['original']!,
          from: originalLanguage, to: translatedLanguage)
          .then((value) => value.text);

      updatedValues.add({'original': item['original']!, 'translated': newTranslation});
    }

    setState(() {
      storedValues = updatedValues;
    });

    // Save updated translations
    List<String> storedList = storedValues
        .map((item) => "${item['original']}|${item['translated']}")
        .toList();
    await prefs.setStringList('stored_values', storedList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Language Transsdlation")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _showLanguagePicker(true),
                  child: Text("Original: ${languages.firstWhere((lang) => lang['code'] == originalLanguage)['name']}"),
                ),
                ElevatedButton(
                  onPressed: () => _showLanguagePicker(false),
                  child: Text("Translate: ${languages.firstWhere((lang) => lang['code'] == translatedLanguage)['name']}"),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Enter text",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _saveValue,
                  child: Text("Translate"),
                ),
                ElevatedButton(
                  onPressed: _resetValues,
                  child: Text("Clear"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: storedValues.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text("${storedValues[index]['original']!} → ${storedValues[index]['translated']!}"),
                      trailing: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => _removeSingleResult(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
