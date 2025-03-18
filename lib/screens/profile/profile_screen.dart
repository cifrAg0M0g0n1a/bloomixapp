import 'package:bloomixapp/database/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/flower.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'Иван Иванов';
  String userEmail = 'ivan.ivanov@example.com';
  String userImage =
      'https://i.siteapi.org/kQyKR19urRS_CVDHmnFr7lXOi7o=/0x0:564x752/s.siteapi.org/1aa8a624fd24470/img/70sbtgeem5oo0ossk4kg8sokw0ocwk';

  // Функция загрузки данных профиля
  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    User user = await DatabaseHelper().getUserById(prefs.getString('user_id'));

    setState(() {
      userName = user.name;
      userEmail = user.email;
    });
  }

  Future<void> logout() async {
    DatabaseHelper().logout();

    Navigator.pushReplacementNamed(context, '/authorization');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Вы успешно вышли из аккаунта'),
        backgroundColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Изображение профиля
                ClipRRect(
                  borderRadius: BorderRadius.circular(75.0), // Округленные углы
                  child: Image.network(
                    userImage,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/placeholder.png',
                        // Путь к локальному изображению-заглушке
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Имя пользователя
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.black,
                  ),
                ),
                const SizedBox(height: 10),

                // Email пользователя
                Text(
                  userEmail,
                  style: const TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.inactiveGray,
                  ),
                ),

                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    logout();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  child: Text(
                    'Выйти',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
