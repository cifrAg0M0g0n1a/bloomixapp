import 'package:flutter/material.dart';

import '../models/flower.dart';
import '../screens/flower_detail/flower_detail_screen.dart';
import '../screens/selection/selection_screen.dart';

// ВИДЖЕТ ПОИСКА
Widget buildSearchField(context) {
  return TextField(
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.grey, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Theme
              .of(context)
              .colorScheme
              .tertiary,
          width: 2,
        ),
      ),
      prefixIcon: const Icon(Icons.search, color: Colors.grey),
      hintText: 'Цветы',
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

// ВИДЖЕТЫ ПОДБОРОК
Widget buildSelectionsGrid(List<Selection> selections, context) {
  return GridView.count(
    crossAxisCount: 3,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    children:
    selections
        .map((selection) => _buildSelectionTile(selection, context))
        .toList(),
  );
}

Widget _buildSelectionTile(Selection selection, context) {
  IconData? icon;

  switch (selection.icon) {
    case 'favorite':
      icon = Icons.favorite;
      break;
    case 'woman':
      icon = Icons.woman;
      break;
    case 'trending_up':
      icon = Icons.trending_up;
      break;
    case 'card_giftcard':
      icon = Icons.card_giftcard;
      break;
    case 'local_dining':
      icon = Icons.local_dining;
      break;
    default:
      icon = Icons.image; // Если тип не найден
  }

  return GestureDetector(
    onTap: () {
      // Переход на SelectionScreen при нажатии на подборку
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectionScreen(selection: selection),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              selection.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            child: Icon(icon, color: Colors.black, size: 28),
          ),
        ],
      ),
    ),
  );
}
// КОНЕЦ ВИДЖЕТОВ ПОДБОРОК

// ВИДЖЕТЫ БУКЕТОВ
Widget buildCategorySection(Category category, Map<String, List<Flower>> flowersBySelection) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 20),
      Text(
        category.name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      _buildFlowerList(flowersBySelection[category.id] ?? []),
    ],
  );
}

Widget _buildFlowerList(List<Flower> flowers) {
  return SizedBox(
    height: 160, // Можно настроить по размеру
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: flowers.length,
      itemBuilder: (context, index) {
        return _buildFlowerCard(flowers[index], context);
      },
    ),
  );
}

Widget _buildFlowerCard(Flower flower, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FlowerDetailScreen(flower: flower),
        ),
      );
    },
    child: Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(flower.image),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '${flower.cost} ₽',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
// КОНЕЦ ВИДЖЕТОВ БУКЕТОВ