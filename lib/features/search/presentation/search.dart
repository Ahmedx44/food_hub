import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  Stream<QuerySnapshot>? foodStream;
  String selectedCategory = 'All';
  RangeValues priceRange = const RangeValues(0, 50);

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      if (searchController.text.isNotEmpty) {
        String searchText = searchController.text;
        foodStream = FirebaseFirestore.instance
            .collection('foods')
            .where('name', isGreaterThanOrEqualTo: searchText)
            .where('name', isLessThanOrEqualTo: '$searchText\uf8ff')
            .snapshots();
      } else {
        foodStream = null;
      }
    });
  }

  void openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filter Options',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    value: selectedCategory,
                    items: ['All', 'Pizza', 'Burger', 'Salad', 'Pasta']
                        .map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setModalState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  RangeSlider(
                    values: priceRange,
                    min: 0,
                    max: 50,
                    divisions: 10,
                    labels: RangeLabels(
                      '\$${priceRange.start.round()}',
                      '\$${priceRange.end.round()}',
                    ),
                    onChanged: (values) {
                      setModalState(() {
                        priceRange = values;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Apply Filters'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Search'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search for food',
                      fillColor:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                      filled: true,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: openFilterBottomSheet,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Icon(
                      Icons.tune,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: foodStream == null
                  ? const Center(
                      child: Text("Type in the search bar to find food items"))
                  : StreamBuilder<QuerySnapshot>(
                      stream: foodStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text("No items found"));
                        }

                        final foodItems = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: foodItems.length,
                          itemBuilder: (context, index) {
                            var food = foodItems[index];
                            return GestureDetector(
                              onTap: () {
                                context.push('/itemdetail',
                                    extra: foodItems[index]);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.01),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                                child: ListTile(
                                  title: Text(food['name']),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('\$${food['price']}'),
                                      Text('${food['rating']} ★'),
                                      Text('Stock: ${food['item left']}'),
                                    ],
                                  ),
                                  leading: Hero(
                                    tag: food['name'],
                                    child: ExtendedImage.network(
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.fill,
                                        cache: true,
                                        '${food['image_url']}'),
                                  ),
                                ),
                              ),
                            );
                          },
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
