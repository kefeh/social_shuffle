import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_shuffle/features/dashboard/widgets/game_mode_card.dart';
import 'package:social_shuffle/features/deck_library/deck_library_sheet.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isCarouselView = true;
  late PageController _pageController;
  double _currentPage = 0.0;

  final Color _baseColor = const Color(0xFF1A1A2E);

  final List<Map<String, dynamic>> _gameModes = [
    {
      'title': 'Trivia',
      'color': const Color(0xFFE94560),
      'game_engine_id': 'trivia',
      'game_engine_type': 'quiz',
      'icon': Icons.lightbulb,
      'image': 'assets/images/trivia.png',
      'subtitle': 'Test your knowledge',
    },
    {
      'title': 'Charades',
      'color': const Color(0xFF4ECCA3),
      'game_engine_id': 'charades',
      'game_engine_type': 'charades',
      'icon': Icons.accessibility_new,
      'image': 'assets/images/charades.png',
      'subtitle': 'Act it out',
    },
    {
      'title': 'Truth or Dare',
      'color': const Color(0xFFFF2E63),
      'game_engine_id': 'truth_or_dare',
      'game_engine_type': 'flip',
      'icon': Icons.whatshot,
      'image': 'assets/images/truth-or-dare.png',
      'subtitle': 'No secrets allowed',
    },
    {
      'title': 'Deep Dive',
      'color': const Color(0xFF4361EE),
      'game_engine_id': 'deep_dive',
      'game_engine_type': 'simple_flip',
      'icon': Icons.question_answer_rounded,
      'image': 'assets/images/deep-dive.png',
      'subtitle': 'Skip the small talk',
    },
    {
      'title': 'Never Have I',
      'color': const Color(0xFFFF9A3C),
      'game_engine_id': 'nhie',
      'game_engine_type': 'flip',
      'icon': Icons.local_bar,
      'image': 'assets/images/never-have.png',
      'subtitle': 'Spill the tea',
    },
    {
      'title': 'Most Likely',
      'color': const Color(0xFF9D4EDD),
      'game_engine_id': 'most_likely',
      'game_engine_type': 'voting',
      'icon': Icons.people,
      'image': 'assets/images/trivia.png',
      'subtitle': 'Point fingers',
    },
    {
      'title': 'Hot Takes', // or 'Debate Club'
      'color': const Color(0xFFF9C80E), // Electric Amber/Yellow
      'game_engine_id': 'hot_takes', // This ID links to the decks
      'game_engine_type': 'simple_flip', // The new engine we just built
      'icon': Icons.campaign_rounded, // Megaphone icon implies "Speak Up"
      'image':
          'assets/images/trivia.png', // Replace with a mic or speech bubble image
      'subtitle': 'Debate & Discuss',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.75, initialPage: 0);
    _pageController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {
      _currentPage = _pageController.page!;
    });
  }

  Color get _activeColor {
    if (_gameModes.isEmpty) return Colors.blue;
    final int index = _currentPage.round().clamp(0, _gameModes.length - 1);
    return _gameModes[index]['color'];
  }

  void _showDeckLibrary(
    BuildContext context,
    String gameModeTitle,
    String gameEngineId,
    Color color,
  ) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        child: Wrap(
          children: [
            DeckLibrarySheet(
              gameModeTitle: gameModeTitle,
              gameEngineId: gameEngineId,
              backgroundColor: color,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
        ),
        title: Row(
          children: [
            Icon(Icons.style, color: _activeColor),
            const SizedBox(width: 10),
            const Text(
              'Social Shuffle',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  _isCarouselView
                      ? Icons.grid_view_rounded
                      : Icons.view_carousel_rounded,
                  key: ValueKey(_isCarouselView),
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                HapticFeedback.selectionClick();
                setState(() {
                  _isCarouselView = !_isCarouselView;

                  if (_isCarouselView) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_pageController.hasClients) {
                        _pageController.jumpToPage(_currentPage.round());
                      }
                    });
                  }
                });
              },
            ),
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_activeColor.withOpacity(0.6), _baseColor, _baseColor],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: 1.0,
                child: Text(
                  _isCarouselView ? "Choose Your Vibe" : "All Games",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _isCarouselView
                      ? _buildCarouselView()
                      : _buildGridView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselView() {
    return PageView.builder(
      key: const ValueKey('Carousel'),
      controller: _pageController,
      physics: const BouncingScrollPhysics(),
      itemCount: _gameModes.length,
      itemBuilder: (context, index) {
        final mode = _gameModes[index];

        double pagePos = _pageController.position.haveDimensions
            ? _pageController.page!
            : _pageController.initialPage.toDouble();

        double distance = (index - pagePos).abs();

        double scale = max(0.83, 1.0 - (distance * 0.3));

        double opacity = max(0.4, 1.0 - (distance * 0.6));

        return Center(
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: GameModeCard(
                heroTag: "card_${mode['game_engine_id']}",
                title: mode['title'],
                subtitle: mode['subtitle'],
                icon: mode['icon'],
                color: mode['color'],
                isActive: distance < 0.5,
                onTap: () => _showDeckLibrary(
                  context,
                  mode['title'],
                  mode['game_engine_id'],
                  mode['color'],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      key: const ValueKey('Grid'),
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: _gameModes.length,
      itemBuilder: (context, index) {
        final mode = _gameModes[index];
        return GameModeCard(
          heroTag: "card_${mode['game_engine_id']}",
          title: mode['title'],
          subtitle: mode['subtitle'],
          color: mode['color'],
          icon: mode['icon'],
          isActive: true,
          onTap: () => _showDeckLibrary(
            context,
            mode['title'],
            mode['game_engine_id'],
            mode['color'],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
