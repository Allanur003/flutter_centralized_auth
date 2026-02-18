import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../services/localization.dart';

class StreamFlixApp extends StatefulWidget {
  final int userAge;

  const StreamFlixApp({Key? key, required this.userAge}) : super(key: key);

  @override
  State<StreamFlixApp> createState() => _StreamFlixAppState();
}

class _StreamFlixAppState extends State<StreamFlixApp> {
  int _selectedCategory = 0;

  final List<String> _categories = [
    'trending',
    'action',
    'comedy',
    'drama',
    'horror',
    'kids',
  ];

  // Movies/Series by category
  final Map<String, List<Map<String, dynamic>>> _content = {
    'trending': [
      {'title': 'The Galaxy Wars', 'rating': '8.5', 'year': '2024', 'mature': false, 'image': '🌌'},
      {'title': 'Love in Paris', 'rating': '7.8', 'year': '2023', 'mature': false, 'image': '❤️'},
      {'title': 'Dark Secrets', 'rating': '9.2', 'year': '2024', 'mature': true, 'image': '🔮'},
      {'title': 'Comedy Hour', 'rating': '8.0', 'year': '2024', 'mature': false, 'image': '😂'},
      {'title': 'The Night Hunter', 'rating': '8.7', 'year': '2023', 'mature': true, 'image': '🌙'},
      {'title': 'Family Adventure', 'rating': '7.5', 'year': '2024', 'mature': false, 'image': '🏔️'},
    ],
    'action': [
      {'title': 'Ultimate Fighter', 'rating': '8.9', 'year': '2024', 'mature': true, 'image': '🥊'},
      {'title': 'Speed Chase', 'rating': '8.3', 'year': '2023', 'mature': false, 'image': '🏎️'},
      {'title': 'Cyber Warriors', 'rating': '8.6', 'year': '2024', 'mature': true, 'image': '🤖'},
      {'title': 'Mission Impossible', 'rating': '9.0', 'year': '2023', 'mature': false, 'image': '🎯'},
      {'title': 'Street Fighter', 'rating': '7.9', 'year': '2024', 'mature': true, 'image': '⚔️'},
      {'title': 'Hero Origins', 'rating': '8.4', 'year': '2023', 'mature': false, 'image': '🦸'},
    ],
    'comedy': [
      {'title': 'Laugh Out Loud', 'rating': '8.1', 'year': '2024', 'mature': false, 'image': '😄'},
      {'title': 'Office Pranks', 'rating': '7.8', 'year': '2023', 'mature': false, 'image': '🏢'},
      {'title': 'Funny Family', 'rating': '8.3', 'year': '2024', 'mature': false, 'image': '👨‍👩‍👧‍👦'},
      {'title': 'Stand Up Night', 'rating': '7.6', 'year': '2023', 'mature': true, 'image': '🎤'},
      {'title': 'Crazy Neighbors', 'rating': '8.0', 'year': '2024', 'mature': false, 'image': '🏠'},
      {'title': 'Joke Masters', 'rating': '7.9', 'year': '2023', 'mature': false, 'image': '🃏'},
    ],
    'drama': [
      {'title': 'Life Stories', 'rating': '9.1', 'year': '2024', 'mature': true, 'image': '📖'},
      {'title': 'Heart Breaking', 'rating': '8.8', 'year': '2023', 'mature': true, 'image': '💔'},
      {'title': 'The Crown', 'rating': '9.3', 'year': '2024', 'mature': false, 'image': '👑'},
      {'title': 'Lost Souls', 'rating': '8.5', 'year': '2023', 'mature': true, 'image': '🕊️'},
      {'title': 'Justice Served', 'rating': '8.9', 'year': '2024', 'mature': true, 'image': '⚖️'},
      {'title': 'Medical Miracles', 'rating': '8.4', 'year': '2023', 'mature': false, 'image': '⚕️'},
    ],
    'horror': [
      {'title': 'The Haunting', 'rating': '8.7', 'year': '2024', 'mature': true, 'image': '👻'},
      {'title': 'Dark Forest', 'rating': '8.3', 'year': '2023', 'mature': true, 'image': '🌲'},
      {'title': 'Nightmare House', 'rating': '9.0', 'year': '2024', 'mature': true, 'image': '🏚️'},
      {'title': 'Ghost Stories', 'rating': '8.5', 'year': '2023', 'mature': true, 'image': '💀'},
      {'title': 'The Curse', 'rating': '8.8', 'year': '2024', 'mature': true, 'image': '🔮'},
      {'title': 'Silent Screams', 'rating': '8.6', 'year': '2023', 'mature': true, 'image': '😱'},
    ],
    'kids': [
      {'title': 'Funny Animals', 'rating': '8.2', 'year': '2024', 'mature': false, 'image': '🦁'},
      {'title': 'Magic Kingdom', 'rating': '8.5', 'year': '2023', 'mature': false, 'image': '🏰'},
      {'title': 'Space Rangers', 'rating': '8.0', 'year': '2024', 'mature': false, 'image': '🚀'},
      {'title': 'Underwater Friends', 'rating': '7.9', 'year': '2023', 'mature': false, 'image': '🐠'},
      {'title': 'Dino Park', 'rating': '8.3', 'year': '2024', 'mature': false, 'image': '🦕'},
      {'title': 'Fairy Tales', 'rating': '8.1', 'year': '2023', 'mature': false, 'image': '🧚'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isDark = provider.isDarkMode;
    final locale = provider.locale;

    final categoryKey = _categories[_selectedCategory];
    List<Map<String, dynamic>> content = _content[categoryKey] ?? [];

    // Filter mature content based on age
    if (widget.userAge < 18) {
      content = content.where((item) => !item['mature']).toList();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            const Text(
              'STREAMFLIX',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Categories
          Container(
            height: 50,
            color: Colors.black,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: isSelected
                          ? Border(
                              bottom: BorderSide(
                                color: Colors.red,
                                width: 3,
                              ),
                            )
                          : null,
                    ),
                    child: Text(
                      AppLocalizations.translate(category, locale),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[400],
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Content Grid
          Expanded(
            child: content.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizations.translate('age_restricted', locale),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: content.length,
                    itemBuilder: (ctx, index) {
                      final item = content[index];
                      return _ContentCard(
                        title: item['title'],
                        rating: item['rating'],
                        year: item['year'],
                        image: item['image'],
                        isMature: item['mature'],
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

class _ContentCard extends StatelessWidget {
  final String title;
  final String rating;
  final String year;
  final String image;
  final bool isMature;
  final String locale;

  const _ContentCard({
    Key? key,
    required this.title,
    required this.rating,
    required this.year,
    required this.image,
    required this.isMature,
    required this.locale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$year • ⭐ $rating',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    image,
                    style: const TextStyle(fontSize: 80),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    AppLocalizations.translate('play', locale),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Close', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        image,
                        style: const TextStyle(fontSize: 60),
                      ),
                    ),
                    if (isMature)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '18+',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        year,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, color: Colors.yellow, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        rating,
                        style: const TextStyle(
                          color: Colors.yellow,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
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
  }
}