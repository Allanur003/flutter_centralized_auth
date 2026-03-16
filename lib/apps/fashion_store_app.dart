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
  final Map<String, Map<String, dynamic>> _cart = {};

  final List<Map<String, dynamic>> _categories = [
    {'name': 'mens_wear', 'label': 'Men'},
    {'name': 'womens_wear', 'label': 'Women'},
    {'name': 'kids_wear', 'label': 'Kids'},
    {'name': 'accessories', 'label': 'Accessories'},
  ];

  final Map<String, List<Map<String, dynamic>>> _products = {
    'mens_wear': [
      {'id': 'm1', 'name': 'Classic Suit', 'price': 800, 'image': 'assets/images/fashion/suit.jpg', 'fallback': '👔', 'sizes': ['S','M','L','XL'], 'rating': 4.8, 'reviews': 124},
      {'id': 'm2', 'name': 'Casual Shirt', 'price': 200, 'image': 'assets/images/fashion/shirt.jpg', 'fallback': '👕', 'sizes': ['S','M','L'], 'rating': 4.5, 'reviews': 89},
      {'id': 'm3', 'name': 'Slim Jeans', 'price': 250, 'image': 'assets/images/fashion/jeans.jpg', 'fallback': '👖', 'sizes': ['30','32','34','36'], 'rating': 4.6, 'reviews': 203},
      {'id': 'm4', 'name': 'Leather Jacket', 'price': 500, 'image': 'assets/images/fashion/jacket.jpg', 'fallback': '🧥', 'sizes': ['M','L','XL'], 'rating': 4.9, 'reviews': 67},
      {'id': 'm5', 'name': 'Sneakers', 'price': 300, 'image': 'assets/images/fashion/sneakers.jpg', 'fallback': '👟', 'sizes': ['40','41','42','43','44'], 'rating': 4.7, 'reviews': 311},
      {'id': 'm6', 'name': 'Premium T-Shirt', 'price': 150, 'image': 'assets/images/fashion/tshirt.jpg', 'fallback': '👚', 'sizes': ['S','M','L','XL'], 'rating': 4.4, 'reviews': 156},
    ],
    'womens_wear': [
      {'id': 'w1', 'name': 'Evening Dress', 'price': 450, 'image': 'assets/images/fashion/dress.jpg', 'fallback': '👗', 'sizes': ['XS','S','M','L'], 'rating': 4.9, 'reviews': 178},
      {'id': 'w2', 'name': 'Silk Blouse', 'price': 180, 'image': 'assets/images/fashion/blouse.jpg', 'fallback': '👚', 'sizes': ['XS','S','M','L'], 'rating': 4.6, 'reviews': 92},
      {'id': 'w3', 'name': 'Midi Skirt', 'price': 170, 'image': 'assets/images/fashion/skirt.jpg', 'fallback': '👗', 'sizes': ['XS','S','M'], 'rating': 4.5, 'reviews': 134},
      {'id': 'w4', 'name': 'Wool Coat', 'price': 650, 'image': 'assets/images/fashion/coat.jpg', 'fallback': '🧥', 'sizes': ['S','M','L'], 'rating': 4.8, 'reviews': 88},
      {'id': 'w5', 'name': 'Stiletto Heels', 'price': 380, 'image': 'assets/images/fashion/heels.jpg', 'fallback': '👠', 'sizes': ['36','37','38','39'], 'rating': 4.7, 'reviews': 210},
      {'id': 'w6', 'name': 'Leather Handbag', 'price': 520, 'image': 'assets/images/fashion/handbag.jpg', 'fallback': '👜', 'sizes': ['One Size'], 'rating': 4.9, 'reviews': 145},
    ],
    'kids_wear': [
      {'id': 'k1', 'name': 'Kids T-Shirt', 'price': 80, 'image': 'assets/images/fashion/kids_tshirt.jpg', 'fallback': '👕', 'sizes': ['2-3Y','4-5Y','6-7Y'], 'rating': 4.5, 'reviews': 67},
      {'id': 'k2', 'name': 'Kids Dress', 'price': 120, 'image': 'assets/images/fashion/kids_dress.jpg', 'fallback': '👗', 'sizes': ['2-3Y','4-5Y'], 'rating': 4.7, 'reviews': 43},
      {'id': 'k3', 'name': 'Shorts', 'price': 60, 'image': 'assets/images/fashion/kids_shorts.jpg', 'fallback': '🩳', 'sizes': ['2-3Y','4-5Y','6-7Y'], 'rating': 4.4, 'reviews': 55},
      {'id': 'k4', 'name': 'Kids Sneakers', 'price': 120, 'image': 'assets/images/fashion/kids_shoes.jpg', 'fallback': '👟', 'sizes': ['24','25','26','27'], 'rating': 4.6, 'reviews': 89},
      {'id': 'k5', 'name': 'Kids Jacket', 'price': 200, 'image': 'assets/images/fashion/kids_jacket.jpg', 'fallback': '🧥', 'sizes': ['4-5Y','6-7Y','8-9Y'], 'rating': 4.8, 'reviews': 34},
      {'id': 'k6', 'name': 'Cap', 'price': 40, 'image': 'assets/images/fashion/kids_cap.jpg', 'fallback': '🧢', 'sizes': ['One Size'], 'rating': 4.3, 'reviews': 78},
    ],
    'accessories': [
      {'id': 'a1', 'name': 'Luxury Watch', 'price': 1200, 'image': 'assets/images/fashion/watch.jpg', 'fallback': '⌚', 'sizes': ['One Size'], 'rating': 4.9, 'reviews': 234},
      {'id': 'a2', 'name': 'Sunglasses', 'price': 180, 'image': 'assets/images/fashion/sunglasses.jpg', 'fallback': '🕶️', 'sizes': ['One Size'], 'rating': 4.6, 'reviews': 167},
      {'id': 'a3', 'name': 'Leather Belt', 'price': 120, 'image': 'assets/images/fashion/belt.jpg', 'fallback': '🪣', 'sizes': ['S','M','L'], 'rating': 4.5, 'reviews': 98},
      {'id': 'a4', 'name': 'Slim Wallet', 'price': 90, 'image': 'assets/images/fashion/wallet.jpg', 'fallback': '👛', 'sizes': ['One Size'], 'rating': 4.7, 'reviews': 312},
      {'id': 'a5', 'name': 'Cashmere Scarf', 'price': 160, 'image': 'assets/images/fashion/scarf.jpg', 'fallback': '🧣', 'sizes': ['One Size'], 'rating': 4.8, 'reviews': 76},
      {'id': 'a6', 'name': 'Fedora Hat', 'price': 110, 'image': 'assets/images/fashion/hat.jpg', 'fallback': '🎩', 'sizes': ['S/M','L/XL'], 'rating': 4.6, 'reviews': 54},
    ],
  };

  int get _cartItemCount => _cart.values.fold(0, (sum, item) => sum + (item['qty'] as int));
  double get _cartTotal => _cart.values.fold(0.0, (sum, item) => sum + (item['price'] as int) * (item['qty'] as int));

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      final id = product['id'] as String;
      if (_cart.containsKey(id)) {
        _cart[id]!['qty'] = (_cart[id]!['qty'] as int) + 1;
      } else {
        _cart[id] = {
          'id': id,
          'name': product['name'],
          'price': product['price'],
          'fallback': product['fallback'],
          'qty': 1,
        };
      }
    });
  }

  void _removeFromCart(String id) {
    setState(() {
      _cart.remove(id);
    });
  }

  void _updateQty(String id, int qty) {
    setState(() {
      if (qty <= 0) {
        _cart.remove(id);
      } else {
        _cart[id]!['qty'] = qty;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isDark = provider.isDarkMode;
    final locale = provider.locale;
    final categoryKey = _categories[_selectedCategory]['name'] as String;
    final products = _products[categoryKey] ?? [];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18, color: isDark ? Colors.white : const Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.translate('fashion_store', locale),
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => _showCart(context, locale, isDark),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, color: isDark ? Colors.white : const Color(0xFF1A1A1A), size: 26),
                  if (_cartItemCount > 0)
                    Positioned(
                      top: 4,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$_cartItemCount',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryBar(isDark, locale),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemCount: products.length,
              itemBuilder: (ctx, index) {
                final product = products[index];
                final inCart = _cart.containsKey(product['id']);
                return _ProductCard(
                  product: product,
                  isDark: isDark,
                  inCart: inCart,
                  locale: locale,
                  onTap: () => _showProductDetail(context, product, isDark, locale),
                  onAddToCart: () => _addToCart(product),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _cartItemCount > 0
          ? _buildCartBar(isDark, locale)
          : null,
    );
  }

  Widget _buildCategoryBar(bool isDark, String locale) {
    return Container(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: _categories.asMap().entries.map((entry) {
            final index = entry.key;
            final category = entry.value;
            final isSelected = index == _selectedCategory;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = index),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? Colors.white : const Color(0xFF1A1A1A))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark ? const Color(0xFF3A3A3A) : const Color(0xFFDDDDDD)),
                  ),
                ),
                child: Text(
                  AppLocalizations.translate(category['name'] as String, locale),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? (isDark ? const Color(0xFF1A1A1A) : Colors.white)
                        : (isDark ? const Color(0xFF888888) : const Color(0xFF666666)),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCartBar(bool isDark, String locale) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: Border(top: BorderSide(color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$_cartItemCount ${AppLocalizations.translate('items', locale)}',
                    style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF888888) : const Color(0xFF888888)),
                  ),
                  Text(
                    '${_cartTotal.toStringAsFixed(0)} TMT',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _showCart(context, locale, isDark),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
              child: Text(AppLocalizations.translate('cart', locale)),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetail(BuildContext context, Map<String, dynamic> product, bool isDark, String locale) {
    String selectedSize = (product['sizes'] as List).first as String;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.translate('product_details', locale),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: isDark ? Colors.white : const Color(0xFF1A1A1A)),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE)),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 1.2,
                          child: Image.asset(
                            product['image'] as String,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0),
                              child: Center(
                                child: Text(product['fallback'] as String, style: const TextStyle(fontSize: 80)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              product['name'] as String,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                          Text(
                            '${product['price']} TMT',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFA000)),
                          const SizedBox(width: 4),
                          Text(
                            '${product['rating']}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(${product['reviews']} reviews)',
                            style: TextStyle(fontSize: 13, color: isDark ? const Color(0xFF888888) : const Color(0xFF888888)),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D32).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              AppLocalizations.translate('in_stock', locale),
                              style: const TextStyle(fontSize: 12, color: Color(0xFF2E7D32), fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.translate('size', locale),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (product['sizes'] as List).map((size) {
                          final isSelected = selectedSize == size;
                          return GestureDetector(
                            onTap: () => setModalState(() => selectedSize = size as String),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (isDark ? Colors.white : const Color(0xFF1A1A1A))
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.transparent
                                      : (isDark ? const Color(0xFF3A3A3A) : const Color(0xFFDDDDDD)),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                size as String,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? (isDark ? const Color(0xFF1A1A1A) : Colors.white)
                                      : (isDark ? Colors.white : const Color(0xFF1A1A1A)),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.local_shipping_outlined, size: 16, color: Color(0xFF2E7D32)),
                          const SizedBox(width: 6),
                          Text(
                            AppLocalizations.translate('free_shipping', locale),
                            style: const TextStyle(fontSize: 13, color: Color(0xFF2E7D32), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        _addToCart(product);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product['name']} — ${AppLocalizations.translate('add_to_cart', locale)}'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Text(AppLocalizations.translate('add_to_cart', locale)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCart(BuildContext context, String locale, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final cartItems = _cart.values.toList();
          final total = cartItems.fold(0.0, (sum, item) => sum + (item['price'] as int) * (item['qty'] as int));

          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.translate('cart', locale),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                        ),
                      ),
                      if (cartItems.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_cartItemCount}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, color: isDark ? Colors.white : const Color(0xFF1A1A1A)),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                Divider(height: 16, color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE)),
                Expanded(
                  child: cartItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_bag_outlined, size: 64, color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFDDDDDD)),
                              const SizedBox(height: 16),
                              Text(
                                AppLocalizations.translate('empty_cart', locale),
                                style: TextStyle(fontSize: 16, color: isDark ? const Color(0xFF888888) : const Color(0xFF888888)),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: cartItems.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE),
                          ),
                          itemBuilder: (ctx, index) {
                            final item = cartItems[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(item['fallback'] as String, style: const TextStyle(fontSize: 30)),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'] as String,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${item['price']} TMT',
                                          style: TextStyle(fontSize: 13, color: isDark ? const Color(0xFF888888) : const Color(0xFF666666)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() => _updateQty(item['id'] as String, (item['qty'] as int) - 1));
                                          setModalState(() {});
                                        },
                                        child: Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFDDDDDD)),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Icon(Icons.remove, size: 14, color: isDark ? Colors.white : const Color(0xFF1A1A1A)),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 36,
                                        child: Text(
                                          '${item['qty']}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() => _updateQty(item['id'] as String, (item['qty'] as int) + 1));
                                          setModalState(() {});
                                        },
                                        child: Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Icon(Icons.add, size: 14, color: isDark ? const Color(0xFF1A1A1A) : Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                if (cartItems.isNotEmpty) ...[
                  Divider(height: 1, color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.translate('total', locale),
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? const Color(0xFF888888) : const Color(0xFF666666),
                          ),
                        ),
                        Text(
                          '${total.toStringAsFixed(0)} TMT',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    child: SafeArea(
                      top: false,
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            setState(() => _cart.clear());
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalizations.translate('order_placed', locale)),
                                backgroundColor: const Color(0xFF2E7D32),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            );
                          },
                          child: Text(AppLocalizations.translate('checkout', locale)),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool isDark;
  final bool inCart;
  final String locale;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const _ProductCard({
    Key? key,
    required this.product,
    required this.isDark,
    required this.inCart,
    required this.locale,
    required this.onTap,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: inCart
                ? (isDark ? Colors.white.withOpacity(0.3) : const Color(0xFF1A1A1A).withOpacity(0.3))
                : (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      product['image'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0),
                        child: Center(
                          child: Text(product['fallback'] as String, style: const TextStyle(fontSize: 52)),
                        ),
                      ),
                    ),
                    if (inCart)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            size: 12,
                            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFFA000)),
                        const SizedBox(width: 3),
                        Text(
                          '${product['rating']}',
                          style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF888888) : const Color(0xFF888888)),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${product['price']} T',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                          ),
                        ),
                        GestureDetector(
                          onTap: onAddToCart,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 16,
                              color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
