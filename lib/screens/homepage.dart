import 'package:flutter/material.dart';
import 'package:petadopt/constants.dart';
import 'package:petadopt/screens/details_page.dart';
import 'package:petadopt/screens/history_page.dart';
import 'package:petadopt/theme_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> filteredPetsList = [];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Adoption'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search Pets...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
              onChanged: (query) {
                setState(() {
                  filteredPetsList = ConstantsList.petsList
                      .where((pet) => pet.values.any((value) =>
                          value.toLowerCase().contains(query.toLowerCase())))
                      .toList();
                });
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color:
                    themeProvider.isDarkMode ? Colors.white24 : Colors.blueGrey,
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Adopt your favourite pets',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Chip(
                          label: const Text('10% Discount'),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset(
                        'assets/pets/pet1.png',
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('Recents'),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredPetsList.isEmpty
                    ? ConstantsList.petsList.length
                    : filteredPetsList.length,
                itemBuilder: (context, index) {
                  final pet = filteredPetsList.isEmpty
                      ? ConstantsList.petsList[index]
                      : filteredPetsList[index];
                  return Card(
                    elevation: 3,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: MediaQuery.of(context).size.height * 0.5,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12.0),
                            image: DecorationImage(
                              image: AssetImage(pet['imageUrl']!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          pet['name']!,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pet['breed']!,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: themeProvider.isDarkMode
                                    ? Colors.black87
                                    : Colors.blueGrey,
                              ),
                            ),
                            Text(
                              pet['description']!,
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsPage(pet: pet),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 5,
            ),
          ],
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
