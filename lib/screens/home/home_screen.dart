import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../models/flower.dart';
import '../../widgets/widgets.dart';
import '../flower_detail/flower_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Selection> selections = [];
  List<Category> categories = [];
  Map<String, List<Flower>> flowersBySelection = {};
  List<Flower> allFlowers = [];
  List<Flower> searchResults = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    List<Selection> loadedSelections = await _dbHelper.getAllSelections();
    List<Category> loadedCategories = await _dbHelper.getAllCategories();
    List<Flower> loadedFlowers = await _dbHelper.getAllFlowers();

    Map<String, List<Flower>> categorizedFlowers = {};
    for (var category in loadedCategories) {
      List<Flower> flowers = await _dbHelper.getFlowersByCategory(category.id);
      categorizedFlowers[category.id] = flowers;
    }

    setState(() {
      selections = loadedSelections;
      categories = loadedCategories;
      flowersBySelection = categorizedFlowers;
      allFlowers = loadedFlowers;
    });
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() => searchResults = []);
    } else {
      setState(() {
        searchResults = allFlowers.where((flower) =>
        flower.name.toLowerCase().contains(query) ||
            flower.description.toLowerCase().contains(query)).toList();
      });
    }
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
                buildSearchField(),
                const SizedBox(height: 20),
                if (searchResults.isEmpty) ...[
                  const Text(
                    'Подборки',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  buildSelectionsGrid(selections, context),
                  const SizedBox(height: 20),
                  ...categories.map((category) => buildCategorySection(category, flowersBySelection)).toList(),
                ] else ...[
                  buildSearchResults()
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
            width: 2,
          ),
        ),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        hintText: 'Поиск букетов',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget buildSearchResults() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final flower = searchResults[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              flower.image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/placeholder.png', width: 50, height: 50);
              },
            ),
          ),
          title: Text(flower.name),
          subtitle: Text('${flower.cost} ₽'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FlowerDetailScreen(flower: flower),
            ),
          ),
        );
      },
    );
  }
}
