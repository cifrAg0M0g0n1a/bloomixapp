import 'package:flutter/material.dart';

import '../../database/database_helper.dart';
import '../../models/flower.dart';
import '../../widgets/widgets.dart';

class SelectionScreen extends StatefulWidget {
  final Selection selection;

  const SelectionScreen({super.key, required this.selection});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Category> categories = [];
  Map<String, List<Flower>> flowersByCategory = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Загружаем категории
    List<Category> loadedCategories = await _dbHelper.getAllCategories();
    Map<String, List<Flower>> loadedFlowers = {};

    // Загружаем букеты, отфильтрованные по выбранной подборке
    for (var category in loadedCategories) {
      List<Flower> flowers = await _dbHelper.getFlowersByCategory(category.id);
      // Фильтруем только те букеты, которые соответствуют id подборки
      List<Flower> filteredFlowers = flowers
          .where((flower) => flower.selectionId == widget.selection.id)
          .toList();
      loadedFlowers[category.id] = filteredFlowers;
    }

    setState(() {
      categories = loadedCategories;
      flowersByCategory = loadedFlowers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.selection.name),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Выводим категории и букеты
                ...categories.map((category) => buildCategorySection(category, flowersByCategory)).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}