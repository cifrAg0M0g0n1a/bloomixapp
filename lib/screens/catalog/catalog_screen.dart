import 'package:flutter/material.dart';

import '../../database/database_helper.dart';
import '../../models/flower.dart';
import '../../widgets/widgets.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Selection> selections = [];
  List<Category> categories = [];
  Map<String, List<Flower>> flowersBySelection = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    List<Selection> loadedSelections = await _dbHelper.getAllSelections();

    List<Category> loadedCategories = await _dbHelper.getAllCategories();
    Map<String, List<Flower>> loadedFlowers = {};
    for (var category in loadedCategories) {
      List<Flower> flowers = await _dbHelper.getFlowersByCategory(category.id);
      loadedFlowers[category.id] = flowers;
    }

    setState(() {
      selections = loadedSelections;
      categories = loadedCategories;
      flowersBySelection = loadedFlowers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...categories.map((category) => buildCategorySection(category, flowersBySelection)).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}