import 'dart:math';
import 'package:flutter/material.dart';
import 'package:social_shuffle/features/dashboard/widgets/game_mode_card.dart';

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
    {'title': 'Trivia', 'color': Colors.redAccent},
    {'title': 'Charades', 'color': Colors.blueAccent},
    {'title': 'Truth or Dare', 'color': Colors.greenAccent},
    {'title': 'Debate', 'color': Colors.purpleAccent},
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isCarouselView
          ? _backgroundColor.withOpacity(0.5)
          : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Social Shuffle'),
        actions: [
          IconButton(
            icon: Icon(_isCarouselView ? Icons.grid_on : Icons.view_carousel),
            onPressed: () {
              setState(() {
                _isCarouselView = !_isCarouselView;
              });
            },
          ),
        ],
      ),
      body: _isCarouselView
          ? PageView.builder(
              controller: _pageController,
              itemCount: _gameModes.length,
              itemBuilder: (context, index) {
                final mode = _gameModes[index];
                double scale = max(
                  0.8,
                  (1.0 - (_currentPage - index).abs()) + 0.2,
                );
                return Transform.scale(
                  scale: scale,
                  child: GameModeCard(
                    title: mode['title'],
                    color: mode['color'],
                    onTap: () {
                      // Handle tap
                    },
                  ),
                );
              },
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
              ),
              itemCount: _gameModes.length,
              itemBuilder: (context, index) {
                final mode = _gameModes[index];
                return GameModeCard(
                  title: mode['title'],
                  color: mode['color'],
                  onTap: () {
                    // Handle tap
                  },
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
