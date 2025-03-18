import 'package:uuid/uuid.dart';

// МОДЕЛЬ ПОЛЬЗОВАТЕЛЯ
class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String? profileImg;

  User({required this.id, required this.name, required this.email, required this.password, this.profileImg});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'profile_img': profileImg,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      profileImg: map['profile_img'],
    );
  }
}

// МОДЕЛЬ БУКЕТА
class Flower {
  final String id;
  final String name;
  final int cost;
  final String image;
  final String description;
  final String composition;
  final String legend;
  final String categoryId;
  final String selectionId;

  Flower({
    String? id,  // id может быть пустым, если мы генерируем его автоматически
    required this.name,
    required this.cost,
    required this.image,
    required this.description,
    required this.composition,
    required this.legend,
    required this.categoryId,
    required this.selectionId,
  }) : id = id ?? Uuid().v4();  // Генерируем id, если оно не передано

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
      'image': image,
      'description': description,
      'composition': composition,
      'legend': legend,
      'category_id': categoryId,
      'selection_id': selectionId,
    };
  }

  factory Flower.fromMap(Map<String, dynamic> map) {
    return Flower(
      id: map['id'],
      name: map['name'],
      cost: map['cost'],
      image: map['image'],
      description: map['description'],
      composition: map['composition'],
      legend: map['legend'],
      categoryId: map['category_id'],
      selectionId: map['selection_id'],
    );
  }
}

// МОДЕЛЬ ПОДБОРКИ
class Selection {
  final String id;
  final String name;
  final String? icon;

  Selection({required this.id, required this.name, this.icon});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }

  factory Selection.fromMap(Map<String, dynamic> map) {
    return Selection(
      id: map['id'],
      name: map['name'],
      icon: map['icon'],
    );
  }
}

// МОДЕЛЬ КАТЕГОРИИ
class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
    );
  }
}

// МОДЕЛЬ КОРЗИНЫ
class Cart {
  final String user_id;
  final String flower_id;
  int quantity;

  Cart({required this.user_id, required this.flower_id, required this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'flower_id': flower_id,
      'quantity': quantity,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      user_id: map['user_id'],
      flower_id: map['flower_id'],
      quantity: map['quantity'] ?? 1,
    );
  }
}

// МОДЕЛЬ ИЗБРАННОГО
class Favorites {
  final String user_id;
  final String flower_id;

  Favorites({required this.user_id, required this.flower_id});

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'flower_id': flower_id,
    };
  }

  factory Favorites.fromMap(Map<String, dynamic> map) {
    return Favorites(
      user_id: map['user_id'],
      flower_id: map['flower_id'],
    );
  }
}