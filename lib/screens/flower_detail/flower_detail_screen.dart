import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../models/flower.dart';

class FlowerDetailScreen extends StatefulWidget {
  final Flower flower;

  const FlowerDetailScreen({super.key, required this.flower});

  @override
  _FlowerDetailScreenState createState() => _FlowerDetailScreenState();
}

class _FlowerDetailScreenState extends State<FlowerDetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    String? userId = await DatabaseHelper().getUserId();
    if (userId == null) return;

    List<Flower> favorites = await DatabaseHelper().getFavorites(userId);
    setState(() {
      isFavorite = favorites.any((flower) => flower.id == widget.flower.id);
    });
  }

  Future<void> _toggleFavorite() async {
    String? userId = await DatabaseHelper().getUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: пользователь не авторизован!'),
          backgroundColor: Theme.of(
            context,
          ).colorScheme.errorContainer.withOpacity(0.5),
        ),
      );
      return;
    }

    if (isFavorite) {
      await DatabaseHelper().deleteFavorite(userId, widget.flower.id);
    } else {
      await DatabaseHelper().insertFavorites(Favorites(user_id: userId, flower_id: widget.flower.id));
    }

    setState(() {
      isFavorite = !isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isFavorite ? '${widget.flower.name} добавлен в избранное!' : '${widget.flower.name} удален из избранного!'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  widget.flower.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/placeholder.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Theme.of(context).colorScheme.tertiary,
                            size: 30,
                          ),
                          onPressed: _toggleFavorite,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.flower.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${widget.flower.cost} ₽",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Состав:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.flower.composition,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Легенда:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(widget.flower.legend, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  const Text(
                    "Описание:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.flower.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () async {
              String? userId = await DatabaseHelper().getUserId();

              if (userId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ошибка: пользователь не авторизован')),
                );
                return;
              }

              final cartItem = Cart(
                user_id: userId,
                flower_id: widget.flower.id,
                quantity: 1,
              );

              await DatabaseHelper().insertCart(cartItem);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${widget.flower.name} добавлен в корзину!'),
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                ),
              );
            },
            child: Text(
              'Добавить в корзину ${widget.flower.cost} ₽',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}