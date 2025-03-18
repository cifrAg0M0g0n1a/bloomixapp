import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../database/database_helper.dart';
import '../../models/flower.dart';

class AuthorizationScreen extends StatefulWidget {
  const AuthorizationScreen({super.key});

  @override
  _AuthorizationScreenState createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirmPassword = '';
  String name = '';
  String? profileImg =
      'https://i.pinimg.com/1200x/ab/51/b1/ab51b137b0a8a3e902c4951be09dac4d.jpg';

  @override
  void initState() {
    super.initState();
  }

  void _toggleForm() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (!isLogin && password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Пароли не совпадают!'),
            backgroundColor: Theme.of(
              context,
            ).colorScheme.errorContainer.withOpacity(0.5),
          ),
        );
        return;
      }

      if (!isLogin) {
        // РЕГИСТРАЦИЯ
        if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
          final newUser = User(
            id: const Uuid().v4(),
            name: name,
            email: email,
            password: password,
            profileImg: profileImg,
          );

          await DatabaseHelper().insertUser(newUser);

          // Сохранение ID в SharedPreferences
          await DatabaseHelper().saveUserId(newUser.id);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Регистрация успешна!'),
              backgroundColor: Theme.of(
                context,
              ).colorScheme.tertiary.withOpacity(0.7),
            ),
          );
          Navigator.pushReplacementNamed(context, '/main');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Не все поля заполнены!'),
              backgroundColor: Theme.of(
                context,
              ).colorScheme.errorContainer.withOpacity(0.5),
            ),
          );
        }
      } else {
        // ВХОД
        final user = await DatabaseHelper().login(email, password);
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Неверный email или пароль!'),
              backgroundColor: Theme.of(
                context,
              ).colorScheme.errorContainer.withOpacity(0.5),
            ),
          );
          return;
        }

        // Сохранение ID в SharedPreferences
        await DatabaseHelper().saveUserId(user.id);

        Navigator.pushReplacementNamed(context, '/main');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.8),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            isLogin ? 'Вход' : 'Регистрация',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        if (!isLogin)
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Имя',
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              filled: true,
                              fillColor: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.1),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ), // Цвет границы в обычном состоянии
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ), // Цвет границы в обычном состоянии
                              ),
                            ),
                            cursorColor: Theme.of(context).colorScheme.primary,
                            onSaved: (value) => name = value!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ), // Цвет границы в обычном состоянии
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ), // Цвет границы в обычном состоянии
                            ),
                          ),
                          cursorColor: Theme.of(context).colorScheme.primary,
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) => email = value!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Пароль',
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ), // Цвет границы в обычном состоянии
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ), // Цвет границы в обычном состоянии
                            ),
                          ),
                          cursorColor: Theme.of(context).colorScheme.primary,
                          obscureText: true,
                          onSaved: (value) => password = value!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: 10),
                        if (!isLogin)
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Подтверждение пароля',
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              filled: true,
                              fillColor: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.1),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ), // Цвет границы в обычном состоянии
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ), // Цвет границы в обычном состоянии
                              ),
                            ),
                            cursorColor: Theme.of(context).colorScheme.primary,
                            obscureText: true,
                            onSaved: (value) => confirmPassword = value!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        SizedBox(height: 10),
                        Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primary,
                              ),
                              foregroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.tertiary,
                              ),
                              overlayColor: MaterialStateProperty.all(
                                Colors.grey.withOpacity(
                                  0.2,
                                ), // Цвет всплеска (splash)
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    7,
                                  ), // Скругление углов
                                ),
                              ),
                            ),
                            onPressed: _submitForm,
                            child: Text(
                              isLogin ? 'Войти' : 'Зарегистрироваться',
                            ),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: _toggleForm,
                            child: Text(
                              isLogin
                                  ? 'Нет аккаунта? Зарегистрируйтесь'
                                  : 'Уже есть аккаунт? Войти',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
