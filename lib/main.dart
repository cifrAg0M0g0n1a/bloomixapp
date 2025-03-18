import 'package:bloomixapp/screens/authorization/authorization_screen.dart';
import 'package:bloomixapp/screens/cart/cart_screen.dart';
import 'package:bloomixapp/screens/catalog/catalog_screen.dart';
import 'package:bloomixapp/screens/favorites/favorites_screen.dart';
import 'package:bloomixapp/screens/home/home_screen.dart';
import 'package:bloomixapp/screens/profile/profile_screen.dart';
import 'package:bloomixapp/screens/screensaver/screensaver_screen.dart';
import 'package:bloomixapp/screens/selection/selection_screen.dart';
import 'package:bloomixapp/styles/light_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bloomix',
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: const CupertinoScrollBehavior(),
          child: child!,
        );
      },
      theme: lightTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const ScreensaverScreen(),
        '/main': (context) => const MainScreen(),
        '/catalog': (context) => const CatalogScreen(),
        '/favorites': (context) => const FavoritesScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/home': (context) => const HomeScreen(),
        '/cart': (context) => const CartScreen(),
        '/authorization': (context) => const AuthorizationScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  List<Widget> body = const [
    HomeScreen(),
    CatalogScreen(),
    FavoritesScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).colorScheme.primary,
          body: body[_currentIndex],

          ///-------------------------Навигация-------------------------------///
          bottomNavigationBar: Theme(
            data: ThemeData(
              brightness: Brightness.light,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Container(
                color: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: (int newIndex) {
                    setState(() {
                      _currentIndex = newIndex;
                    });
                  },
                  backgroundColor: Colors.transparent,
                  type: BottomNavigationBarType.fixed,
                  showUnselectedLabels: true,
                  // Показывать подписи для неактивных элементов
                  showSelectedLabels: true,
                  // Показывать подписи для активных элементов
                  selectedFontSize: 12.0,
                  // Размер текста при выборе
                  unselectedFontSize: 12.0,
                  selectedItemColor: Theme.of(context).colorScheme.tertiary,
                  // Цвет активных иконок и текста
                  unselectedItemColor: Colors.grey,
                  // Цвет неактивных иконок и текста
                  elevation: 0.0,
                  items: [
                    // Активная/неактивная иконки главной
                    BottomNavigationBarItem(
                      icon: Container(
                        child:
                            _currentIndex == 0
                                ? SvgPicture.asset(
                                  'assets/icons/home.svg',
                                  width: 30,
                                  height: 30,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.tertiary,
                                    BlendMode.srcIn,
                                  ),
                                )
                                : SvgPicture.asset(
                                  'assets/icons/home.svg',
                                  width: 30,
                                  height: 30,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.onPrimary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                      ),
                      label: 'Главная',
                    ),
                    // Активная/неактивная иконки каталога
                    BottomNavigationBarItem(
                      icon: Container(
                        child:
                            _currentIndex == 1
                                ? SvgPicture.asset(
                                  'assets/icons/catalog.svg',
                                  width: 30,
                                  height: 30,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.tertiary,
                                    BlendMode.srcIn,
                                  ),
                                )
                                : SvgPicture.asset(
                                  'assets/icons/catalog.svg',
                                  width: 30,
                                  height: 30,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.onPrimary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                      ),
                      label: 'Каталог',
                    ),
                    // Активная/неактивная иконки избранного
                    BottomNavigationBarItem(
                      icon: Container(
                        child:
                            _currentIndex == 2
                                ? SvgPicture.asset(
                                  'assets/icons/favorites.svg',
                                  width: 30,
                                  height: 30,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.tertiary,
                                    BlendMode.srcIn,
                                  ),
                                )
                                : SvgPicture.asset(
                                  'assets/icons/favorites.svg',
                                  width: 30,
                                  height: 30,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.onPrimary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                      ),
                      label: 'Избранное',
                    ),
                    // Активная/неактивная иконки корзины
                    BottomNavigationBarItem(
                      icon: Container(
                        child:
                            _currentIndex == 3
                                ? SvgPicture.asset(
                                  'assets/icons/cart.svg',
                                  width: 30,
                                  height: 30,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.tertiary,
                                    BlendMode.srcIn,
                                  ),
                                )
                                : SvgPicture.asset(
                                  'assets/icons/cart.svg',
                                  width: 30,
                                  height: 30,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.onPrimary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                      ),
                      label: 'Корзина',
                    ),
                    // Активная/неактивная иконки профиля
                    BottomNavigationBarItem(
                      icon: Container(
                        child:
                            _currentIndex == 4
                                ? SvgPicture.asset(
                                  'assets/icons/profile.svg',
                                  width: 30,
                                  height: 30,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.tertiary,
                                    BlendMode.srcIn,
                                  ),
                                )
                                : SvgPicture.asset(
                                  'assets/icons/profile.svg',
                                  width: 30,
                                  height: 30,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.onPrimary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                      ),
                      label: 'Профиль',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
