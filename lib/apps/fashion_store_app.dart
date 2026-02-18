import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../services/localization.dart';

class FashionStoreApp extends StatefulWidget {
  const FashionStoreApp({Key? key}) : super(key: key);

  @override
  State<FashionStoreApp> createState() => _FashionStoreAppState();
}

class _FashionStoreAppState extends State<FashionStoreApp> {
  int _selectedCategory = 0;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'mens_wear', 'icon': '👔'},
    {'name': 'womens_wear', 'icon': '👗'},
    {'name': 'kids_wear', 'icon': '👶'},
    {'name': 'accessories', 'icon': '👜'},
  ];

  final Map<String, List<Map<String, dynamic>>> _products = {
    'mens_wear': [
      {'name': 'Classic Suit', 'price': '\$299', 'image': '👔', 'color': Colors.blue},
      {'name': 'Casual Shirt', 'price': '\$49', 'image': '👕', 'color': Colors.cyan},
      {'name': 'Jeans', 'price': '\$79', 'image': '👖', 'color': Colors.indigo},
      {'name': 'Jacket', 'price': '\$149', 'image': '🧥', 'color': Colors.brown},
      {'name': 'Sneakers', 'price': '\$99', 'image': '👟', 'color': Colors.grey},
      {'name': 'T-Shirt', 'price': '\$29', 'image': '👚', 'color': Colors.green},
    ],
    'womens_wear': [
      {'name': 'Evening Dress', 'price': '\$199', 'image': '👗', 'color': Colors.pink},
      {'name': 'Blouse', 'price': '\$59', 'image': '👚', 'color': Colors.purple},
      {'name': 'Skirt', 'price': '\$69', 'image': '👗', 'color': Colors.red},
      {'name': 'Coat', 'price': '\$179', 'image': '🧥', 'color': Colors.deepPurple},
      {'name': 'Heels', 'price': '\$89', 'image': '👠', 'color': Colors.pink},
      {'name': 'Handbag', 'price': '\$129', 'image': '👜', 'color': Colors.brown},
    ],
    'kids_wear': [
      {'name': 'Kids T-Shirt', 'price': '\$19', 'image': '👕', 'color': Colors.orange},
      {'name': 'Kids Dress', 'price': '\$39', 'image': '👗', 'color': Colors.pink},
      {'name': 'Shorts', 'price': '\$24', 'image': '🩳', 'color': Colors.blue},
      {'name': 'Kids Shoes', 'price': '\$49', 'image': '👟', 'color': Colors.red},
      {'name': 'Jacket', 'price': '\$59', 'image': '🧥', 'color': Colors.green},
      {'name': 'Cap', 'price': '\$15', 'image': '🧢', 'color': Colors.yellow},
    ],
    'accessories': [
      {'name': 'Watch', 'price': '\$199', 'image': '⌚', 'color': Colors.grey},
      {'name': 'Sunglasses', 'price': '\$79', 'image': '🕶️', 'color': Colors.black},
      {'name': 'Belt', 'price': '\$39', 'image': '👞', 'color': Colors.brown},
      {'name': 'Wallet', 'price': '\$49', 'image': '👛', 'color': Colors.grey},
      {'name': 'Scarf', 'price': '\$29', 'image': '🧣', 'color': Colors.red},
      {'name': 'Hat', 'price': '\$35', 'image': '🎩', 'color': Colors.black},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isDark = provider.isDarkMode;
    final locale = provider.locale;

    final categoryKey = _categories[_selectedCategory]['name'];
    final products = _products[categoryKey] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.translate('fashion_store', locale)),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.translate('cart', locale)),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Categories
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (ctx, index) {
                final category = _categories[index];
                final isSelected = index == _selectedCategory;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = index;
                    });
                  },
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark ? Colors.blue[700] : Colors.blue[600])
                          : (isDark ? Colors.grey[800] : Colors.grey[200]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          category['icon'],
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.translate(
                            category['name'],
                            locale,
                          ),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Products Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (ctx, index) {
                final product = products[index];
                return _ProductCard(
                  name: product['name'],
                  price: product['price'],
                  image: product['image'],
                  color: product['color'],
                  isDark: isDark,
                  locale: locale,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String image;
  final Color color;
  final bool isDark;
  final String locale;

  const _ProductCard({
    Key? key,
    required this.name,
    required this.price,
    required this.image,
    required this.color,
    required this.isDark,
    required this.locale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Text(
                  image,
                  style: const TextStyle(fontSize: 80),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$name ${AppLocalizations.translate('add_to_cart', locale)}'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Icon(Icons.add_shopping_cart, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}