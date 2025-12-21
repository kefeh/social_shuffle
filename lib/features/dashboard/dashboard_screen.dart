import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
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
  Color _backgroundColor = Colors.redAccent;

  final List<Map<String, dynamic>> _gameModes = [
    {
      'title': 'Trivia',
      'color': Colors.redAccent,
      'game_engine_id': 'trivia',
      'game_engine_type': 'quiz',
      'image': 'assets/images/trivia.png',
    },
    {
      'title': 'Charades',
      'color': Colors.lightBlue,
      'game_engine_id': 'charades',
      'game_engine_type': 'task',
      'image': 'assets/images/charades.png',
    },
    {
      'title': 'Truth or Dare',
      'color': Colors.pink,
      'game_engine_id': 'truth_or_dare',
      'game_engine_type': 'flip',
      'image': 'assets/images/truth-or-dare.png',
    },
    {
      'title': 'Debate',
      'color': Colors.green,
      'game_engine_id': 'debate',
      'game_engine_type': 'voting',
      'image': 'assets/images/trivia.png',
    },
    {
      'title': 'Never Have I Ever',
      'color': Colors.orange,
      'game_engine_id': 'nhie',
      'game_engine_type': 'flip',
      'image': 'assets/images/never-have.png',
    },
    {
      'title': 'Most Likely To',
      'color': Colors.purple,
      'game_engine_id': 'most_likely',
      'game_engine_type': 'voting',
      'image': 'assets/images/trivia.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.6, initialPage: 0)
      ..addListener(() {
        setState(() {
          _currentPage = _pageController.page!;
          _updateBackgroundColor();
        });
      });
  }

  void _updateBackgroundColor() {
    int page = _pageController.page!.round();
    if (page < _gameModes.length) {
      setState(() {
        _backgroundColor = _gameModes[page]['color'];
      });
    }
  }

  void _showDeckLibrary(
    BuildContext context,
    String gameModeTitle,
    String gameEngineId,
    Color color,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Wrap(
        children: [
          DeckLibrarySheet(
            gameModeTitle: gameModeTitle,
            gameEngineId: gameEngineId,
            backgroundColor: color,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Social Shuffle'),
        actions: [
          IconButton(
            icon: Icon(_isCarouselView ? Icons.grid_on : Icons.view_carousel),
            onPressed: () {
              if (_isCarouselView) {
                _pageController.jumpTo(0.0);
              }
              setState(() {
                _currentPage = 0;
                _isCarouselView = !_isCarouselView;
              });
            },
          ),
        ],
      ),
      body: _isCarouselView
          ? PageView.builder(
              key: ValueKey('PageView'),
              controller: _pageController,
              itemCount: _gameModes.length,
              itemBuilder: (context, index) {
                double scale = max(0.6, (1.4 - (_currentPage - index).abs()));
                final mode = _gameModes[index];
                double pagePos = _pageController.position.haveDimensions
                    ? _pageController.page!
                    : 0.0;
                double distanceFromCenter = (index - pagePos).abs();

                double opacity = 0.0;

                if (distanceFromCenter < 0.5) {
                  opacity = (0.5 - distanceFromCenter) * 2;

                  opacity = opacity.clamp(0.0, 1.0);
                }
                return Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Opacity(
                          opacity: opacity.ceil().toDouble(),
                          child: Transform.translate(
                            offset: Offset(0, 50 * (1 - opacity)),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                mode['title'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Transform.scale(
                        scale: scale,
                        child: GameModeCard(
                          title: mode['title'],
                          image: mode['image'],
                          color: (mode['color'] as Color).withOpacity(
                            opacity == 0
                                ? 0.5
                                : clampDouble(opacity + 0.5, 0.5, 1.0),
                          ),
                          onTap: () => _showDeckLibrary(
                            context,
                            mode['title'],
                            mode['game_engine_id'],
                            mode['color'],
                          ),
                          isGridView: false,
                        ),
                      ),
                    ),
                    Expanded(flex: 1, child: Container()),
                  ],
                );
              },
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                key: ValueKey('GridView'),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.5,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: _gameModes.length,
                itemBuilder: (context, index) {
                  final mode = _gameModes[index];
                  return GameModeCard(
                    title: mode['title'],
                    color: mode['color'],
                    image: mode['image'],
                    onTap: () => _showDeckLibrary(
                      context,
                      mode['title'],
                      mode['game_engine_id'],
                      mode['color'],
                    ),
                    isGridView: true,
                  );
                },
              ),
            ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
