import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petadopt/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('History'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              icon: const Icon(Icons.brightness_4_outlined),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
          ),
        ],
      ),
      body: HistoryPageWidget(),
    );
  }
}

class HistoryPageWidget extends StatefulWidget {
  @override
  _HistoryPageWidgetState createState() => _HistoryPageWidgetState();
}

class _HistoryPageWidgetState extends State<HistoryPageWidget> {
  List<Map<String, String>> adoptedPets = [];

  @override
  void initState() {
    super.initState();
    loadAdoptedPets();
  }

  Future<void> loadAdoptedPets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? adoptedPetsJson = prefs.getStringList('adoptedPets');
    if (adoptedPetsJson != null) {
      print('Adopted Pets JSON: $adoptedPetsJson');

      List<Map<String, String>> adoptedPetsList = adoptedPetsJson
          .map<Map<String, String>>(
              (petJson) => Map<String, String>.from(jsonDecode(petJson)))
          .toList();

      setState(() {
        adoptedPets = adoptedPetsList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ListView.builder(
      itemCount: adoptedPets.length,
      itemBuilder: (context, index) {
        final pet = adoptedPets[index];
        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            title: Text(
              pet['name']!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode ? Colors.grey : Colors.blueGrey,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Breed: ${pet['breed']!}'),
                Text('Age: ${pet['age']!}'),
              ],
            ),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                      '${pet['imageUrl']}'), // Assuming your pet images are stored in the 'assets/pets/' directory
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
