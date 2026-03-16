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

  final List<String> _categories = ['trending', 'action', 'comedy', 'drama', 'horror', 'kids'];

  final Map<String, List<Map<String, dynamic>>> _content = {
    'trending': [
      {'title': 'The Galaxy Wars', 'rating': '8.5', 'year': '2024', 'mature': false, 'image': 'assets/images/movies/galaxy_wars.jpg', 'fallback': '🌌', 'genre': 'Sci-Fi'},
      {'title': 'Love in Paris', 'rating': '7.8', 'year': '2023', 'mature': false, 'image': 'assets/images/movies/love_paris.jpg', 'fallback': '❤️', 'genre': 'Romance'},
      {'title': 'Dark Secrets', 'rating': '9.2', 'year': '2024', 'mature': true, 'image': 'assets/images/movies/dark_secrets.jpg', 'fallback': '🔮', 'genre': 'Thriller'},
      {'title': 'Comedy Hour', 'rating': '8.0', 'year': '2024', 'mature': false, 'image': 'assets/images/movies/comedy_hour.jpg', 'fallback': '😂', 'genre': 'Comedy'},
      {'title': 'The Night Hunter', 'rating': '8.7', 'year': '2023', 'mature': true, 'image': 'assets/images/movies/night_hunter.jpg', 'fallback': '🌙', 'genre': 'Action'},
      {'title': 'Family Adventure', 'rating': '7.5', 'year': '2024', 'mature': false, 'image': 'assets/images/movies/family_adventure.jpg', 'fallback': '🏔️', 'genre': 'Adventure'},
    ],
    'action': [
      {'title': 'Ultimate Fighter', 'rating': '8.9', 'year': '2024', 'mature': true, 'image': 'assets/images/movies/ultimate_fighter.jpg', 'fallback': '🥊', 'genre': 'Action'},
      {'title': 'Speed Chase', 'rating': '8.3', 'year': '2023', 'mature': false, 'image': 'assets/images/movies/speed_chase.jpg', 'fallback': '🏎️', 'genre': 'Action'},
      {'title': 'Cyber Warriors', 'rating': '8.6', 'year': '2024', 'mature': true, 'image': 'assets/images/movies/cyber_warriors.jpg', 'fallback': '🤖', 'genre': 'Sci-Fi'},
      {'title': 'Mission Impossible', 'rating': '9.0', 'year': '2023', 'mature': false, 'image': 'assets/images/movies/mission_impossible.jpg', 'fallback': '🎯', 'genre': 'Action'},
      {'title': 'Street Fighter', 'rating': '7.9', 'year': '2024', 'mature': true, 'image': 'assets/images/movies/street_fighter.jpg', 'fallback': '⚔️', 'genre': 'Action'},
      {'title': 'Hero Origins', 'rating': '8.4', 'year': '2023', 'mature': false, 'image': 'assets/images/movies/hero_origins.jpg', 'fallback': '🦸', 'genre': 'Action'},
    ],
    'comedy': [
      {'title': 'Laugh Out Loud', 'rating': '8.1', 'year': '2024', 'mature': false, 'image': 'assets/images/movies/laugh_out_loud.jpg', 'fallback': '😄', 'genre': 'Comedy'},
      {'title': 'Office Pranks', 'rating': '7.8', 'year': '2023', 'mature': false, 'image': 'assets/images/movies/office_pranks.jpg', 'fallback': '🏢', 'genre': 'Comedy'},
      {'title': 'Funny Family', 'rating': '8.3', 'year': '2024', 'mature': false, 'image': 'assets/images/movies/funny_family.jpg', 'fallback': '👨‍👩‍👧‍👦', 'genre': 'Comedy'},
      {'title': 'Stand Up Night', 'rating': '7.6', 'year': '2023', 'mature': true, 'image': 'assets/images/movies/stand_up_night.jpg', 'fallback': '🎤', 'genre': 'Comedy'},
      {'title': 'Crazy Neighbors', 'rating': '8.0', 'year': '2024', 'mature': false, 'image': 'assets/images/movies/crazy_neighbors.jpg', 'fallback': '🏠', 'genre': 'Comedy'},
      {'title': 'Joke Masters', 'rating': '7.9', 'year': '2023', 'mature': false, 'image': 'assets/images/movies/joke_masters.jpg', 'fallback': '🃏', 'genre': 'Comedy'},
    ],
    'drama': [
      {'title': 'Life Stories', 'rating': '9.1', 'year': '2024', 'mature': true, 'image': 'assets/images/movies/life_stories.jpg', 'fallback': '📖', 'genre': 'Drama'},
      {'title': 'Heart Breaking', 'rating': '8.8', 'year': '2023', 'mature': true, 'image': 'assets/images/movies/heart_breaking.jpg', 'fallback': '💔', 'genre': 'Drama'},
      {'title': 'The Crown', 'rating': '9.3', 'year': '2024', 'mature': false, 'image': 'assets/images/movies/the_crown.jpg', 'fallback': '👑', 'genre': 'Drama'},
      {'title': 'Lost Souls', 'rating': '8.5', 'year': '2023', 'mature': true, 'image': 'assets/images/movies/lost_souls.jpg', 'fallback': '🕊️', 'genre': 'Drama'},
      {'title': 'Justice Served', 'rating': '8.9', 'year': '2024', 'mature': true, 'image': 'assets/images/movies/justice_served.jpg', 'fallback': '⚖️', 'genre': 'Legal'},
      {'title': 'Medical Miracles', 'rating': '8.4', 'year': '2023', 'mature': false, 'image': 'assets/images/movies/medical_miracles.jpg', 'fallback': '⚕️', 'genre': 'Medical'},
    ],
    'horror': [
      {'title': 'The Haunting', 'rating': '8.7', 'year': '2024', 'mature': true, 'image': 'assets/images/movies/the_haunting.jpg', 'fallback': '👻', 'genre': 'Horror'},
      {'title': 'Dark Forest', 'rating': '8.3', 'year': '2023', 'mature': true, 'image': 'assets/images/movies/dark_forest.jpg', 'fallback': '🌲', 'genre': 'Horror'},
      {'title': 'Nightmare House', 'rating': '9.0', 'year': '2024', 'mature': true, 'image': 'assets/images/movies/nightmare_house.jpg', 'fallback': '🏚️', 'genre': 'Horror'},
      {'title': 'Ghost Stories', 'rating': '8.5', 'year': '2023', 'mature': true, 'image': 'assets/images/movies/ghost_stories.jpg', 'fallback': '💀', 'genre': 'Horror'},
      {'title': 'The Curse', 'rating': '8.8', 'year': '2024', 'mature': true, 'image': 'assets/images/movies/the_curse.jpg', 'fallback': '🔮', 'genre': 'Horror'},
      {'title': 'Silent Screams', 'rating': '8.6', 'year': '2023', 'mature': true, 'image': 'assets/images/movies/silent_screams.jpg', 'fallback': '😱', 'genre': 'Horror'},
    ],
    'kids': [
      {'title': 'Funny Animals', 'rating': '8.2', 'year': '2024', 'mature': false, 'image': 'assets/images/movies/funny_animals.jpg', 'fallback': '🦁', 'genre': 'Animation'},
      {'title': 'Magic Kingdom', 'rating': '8.5', 'year': '2023', 'mature': false, 'image': 'assets/images/movies/magic_kingdom.jpg', 'fallback': '🏰', 'genre': 'Fantasy'},
      {'title': 'Space Rangers', 'rating': '8.0', 'year': '2024', 'mature': false, 'image': 'assets/images/movies/space_rangers.jpg', 'fallback': '🚀', 'genre': 'Adventure'},
      {'title': 'Underwater Friends', 'rating': '7.9', 'year': '2023', 'mature': false, 'image': 'assets/images/movies/underwater_friends.jpg', 'fallback': '🐠', 'genre': 'Animation'},
      {'title': 'Dino Park', 'rating': '8.3', 'year': '2024', 'mature': false, 'image': 'assets/images/movies/dino_park.jpg', 'fallback': '🦕', 'genre': 'Adventure'},
      {'title': 'Fairy Tales', 'rating': '8.1', 'year': '2023', 'mature': false, 'image': 'assets/images/movies/fairy_tales.jpg', 'fallback': '🧚', 'genre': 'Fantasy'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final locale = provider.locale;
    final categoryKey = _categories[_selectedCategory];
    List<Map<String, dynamic>> content = _content[categoryKey] ?? [];
    if (widget.userAge < 18) {
      content = content.where((item) => !item['mature']).toList();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'STREAMFLIX',
          style: TextStyle(
            color: Color(0xFFE50914),
            fontWeight: FontWeight.w900,
            fontSize: 22,
            letterSpacing: 1,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person_outline, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 48,
            color: Colors.black,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (ctx, index) {
                final isSelected = index == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? const Color(0xFFE50914) : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.translate(_categories[index], locale),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[500],
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: content.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizations.translate('age_restricted', locale),
                      style: TextStyle(color: Colors.grey[600], fontSize: 15),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: content.length,
                    itemBuilder: (ctx, index) {
                      final item = content[index];
                      return _ContentCard(item: item, locale: locale);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final String locale;

  const _ContentCard({Key? key, required this.item, required this.locale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetail(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              item['image'] as String,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF1A1A1A),
                child: Center(child: Text(item['fallback'] as String, style: const TextStyle(fontSize: 52))),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
            if (item['mature'] as bool)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE50914),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('18+', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] as String,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(item['year'] as String, style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                        const SizedBox(width: 8),
                        const Icon(Icons.star_rounded, color: Color(0xFFFFA000), size: 13),
                        const SizedBox(width: 2),
                        Text(
                          item['rating'] as String,
                          style: const TextStyle(color: Color(0xFFFFA000), fontSize: 11, fontWeight: FontWeight.w600),
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

  void _showDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 1.6,
                child: Image.asset(
                  item['image'] as String,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF2A2A2A),
                    child: Center(child: Text(item['fallback'] as String, style: const TextStyle(fontSize: 64))),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(item['year'] as String, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey[600]!), borderRadius: BorderRadius.circular(4)),
                        child: Text(item['genre'] as String, style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.star_rounded, color: Color(0xFFFFA000), size: 14),
                      const SizedBox(width: 3),
                      Text(item['rating'] as String, style: const TextStyle(color: Color(0xFFFFA000), fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: TextStyle(color: Colors.grey[500])),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE50914), foregroundColor: Colors.white),
            icon: const Icon(Icons.play_arrow_rounded, size: 18),
            label: Text(AppLocalizations.translate('play', locale)),
          ),
        ],
      ),
    );
  }
}
