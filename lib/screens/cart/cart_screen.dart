import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../models/flower.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Cart> cartItems = [];
  int totalPrice = 0;
  int deliveryPrice = 350;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
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

    final items = await DatabaseHelper().getCartItems(userId);

    setState(() {
      cartItems = items;
      totalPrice = 0;  // Обнуляем сумму
      // Пересчитываем цену при загрузке корзины
      for (var cartItem in cartItems) {
        getFlowerById(cartItem.flower_id).then((flower) {
          totalPrice += flower.cost * cartItem.quantity;
        });
      }
      isLoading = false;
    });
  }

  Future<void> increaseQuantity(Cart cart) async {
    await DatabaseHelper().insertOrUpdateCart(cart);
    loadCart();
  }

  Future<void> decreaseQuantity(Cart cart) async {
    if (cart.quantity > 1) {
      await DatabaseHelper().decreaseCartQuantity(cart.user_id, cart.flower_id);
    }
    loadCart();
  }

  Future<void> removeItem(Cart cart) async {
    await DatabaseHelper().removeFromCart(cart.user_id, cart.flower_id);
    loadCart();
  }

  Future<Flower> getFlowerById(String flowerId) async {
    Flower flower = await DatabaseHelper().getFlowerById(flowerId);
    return flower;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Корзина"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 25,
          color: Colors.black,
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Основная часть с товарами
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : cartItems.isEmpty
                  ? Center(child: Text("Корзина пуста"))
                  : ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartItems[index];
                  return FutureBuilder<Flower>(
                    future: getFlowerById(cartItem.flower_id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Ошибка при загрузке данных о цветке"),
                        );
                      }

                      final flower = snapshot.data!;
                      totalPrice += flower.cost * cartItem.quantity;

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  flower.image,
                                  width: 100,
                                  height: 100,
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
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      flower.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '${flower.cost} ₽',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => decreaseQuantity(cartItem),
                                          icon: Icon(Icons.remove_circle_outline),
                                        ),
                                        Text(
                                          '${cartItem.quantity}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        IconButton(
                                          onPressed: () => increaseQuantity(cartItem),
                                          icon: Icon(Icons.add_circle_outline),
                                        ),
                                        Spacer(),
                                        IconButton(
                                          onPressed: () => removeItem(cartItem),
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // Перетаскиваемая панель с суммой заказа
            DraggableScrollableSheet(
              initialChildSize: 0.2,
              minChildSize: 0.2,
              maxChildSize: 0.5,
              builder: (BuildContext context, ScrollController scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildPriceRow("Сумма заказа", totalPrice),
                        _buildPriceRow("Доставка", deliveryPrice),
                        _buildPriceRow("Скидка", 0),
                        const Divider(height: 32, thickness: 1),
                        _buildPriceRow("Итого", totalPrice + deliveryPrice, isTotal: true),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Заказ успешно создан!'),
                                backgroundColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.tertiary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Перейти к оформлению  ${totalPrice.toInt() + deliveryPrice.toInt()} ₽',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, int amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w400,
            ),
          ),
          Text(
            '${amount.toInt()} ₽',
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}