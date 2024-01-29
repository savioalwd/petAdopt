import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petadopt/screens/history_page.dart';
import 'package:petadopt/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsPage extends StatelessWidget {
  final Map<String, String> pet;

  DetailsPage({required this.pet});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Pet Details'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              icon: const Icon(Icons.brightness_4_outlined),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: themeProvider.isDarkMode ? null : Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(20.0), // Adjust the border radius
                  child: Image.asset(
                    pet['imageUrl']!,
                    width: MediaQuery.of(context)
                        .size
                        .width, // Set width to full screen width
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            '${pet['name']}',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.blueGrey,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${pet['age']} old',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: themeProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Breed: ${pet['breed']}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Height: ${pet['height']}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            '${pet['gender']}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Weight: ${pet['weight']}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${pet['description']}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String petName = pet['name']!;

                              // Check if the pet has already been adopted
                              if (prefs.getStringList('adoptedPets')?.any(
                                      (adoptedPet) =>
                                          adoptedPet.contains(petName)) ==
                                  true) {
                                // Pet is already adopted, show a message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'You have already adopted $petName.'),
                                  ),
                                );
                              } else {
                                // Pet is not adopted, update SharedPreferences
                                List<String> adoptedPetsJson = prefs
                                        .getStringList('adoptedPets')
                                        ?.toList() ??
                                    [];

                                // Serialize the pet object to JSON
                                String petJson = jsonEncode(pet);
                                adoptedPetsJson.add(petJson);

                                prefs.setStringList(
                                    'adoptedPets', adoptedPetsJson);

                                // Show a message that the pet has been adopted
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('You\'ve now adopted $petName.'),
                                  ),
                                );
                              }
                            },
                            child: const Text('Adopt me'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            themeProvider.isDarkMode ? Colors.grey : Colors.blueGrey,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return HistoryPage();
            }),
          );
        },
        tooltip: 'Show History',
        child: Icon(
          Icons.history,
          color: themeProvider.isDarkMode ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
