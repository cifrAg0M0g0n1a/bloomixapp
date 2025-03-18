import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../models/flower.dart';
import '../flower_detail/flower_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Flower> favoriteFlowers = [];
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    userId = await DatabaseHelper().getUserId();
    if (userId != null) {
      final favorites = await DatabaseHelper().getFavorites(userId!);
      setState(() {
        favoriteFlowers = favorites;
      });
    }
  }

  Future<void> _removeFromFavorites(String flowerId) async {
    if (userId != null) {
      await DatabaseHelper().deleteFavorite(userId!, flowerId);
      _loadFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Избранное"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 25,
          color: Colors.black,
        ),
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: favoriteFlowers.isEmpty
          ? const Center(
        child: Text('Нет избранных букетов'),
      )
          : ListView.builder(
        itemCount: favoriteFlowers.length,
        itemBuilder: (context, index) {
          final flower = favoriteFlowers[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8), // Радиус скругления
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
            trailing: IconButton(
              icon: Icon(Icons.favorite, color: Theme.of(context).colorScheme.tertiary),
              onPressed: () => _removeFromFavorites(flower.id),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlowerDetailScreen(flower: flower),
                ),
              );
            },
          );
        },
      ),
    );
  }
}