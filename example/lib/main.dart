import 'package:flutter/material.dart';
import 'package:chips_auto_scroll/chips_auto_scroll.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChipsAutoScroll Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen>
    with SingleTickerProviderStateMixin {
  int _horizontalIndex = 0;
  int _verticalIndex = 0;

  late final TabController _tabController;

  final List<String> categories = [
    'General',
    'Technology',
    'Science',
    'Sports',
    'Music',
    'Food',
    'Travel',
    'Fashion',
    'Health',
    'Finance',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChipsAutoScroll Example'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Horizontal'),
            Tab(text: 'Vertical'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHorizontalExample(),
          _buildVerticalExample(),
        ],
      ),
    );
  }

  Widget _buildHorizontalExample() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Horizontal Chips',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),

        // Horizontal ChipsAutoScroll
        ChipsAutoScroll(
          selectedIndex: _horizontalIndex,
          scrollDirection: Axis.horizontal,
          children: List.generate(
            categories.length,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(categories[index]),
                selected: index == _horizontalIndex,
                onSelected: (_) =>
                    setState(() => _horizontalIndex = index),
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Tap a button to jump to that category:',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 12),

        // Buttons to test jumping
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              categories.length,
              (index) => ElevatedButton(
                onPressed: () => setState(() => _horizontalIndex = index),
                child: Text('${index + 1}'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalExample() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Vertical Chips',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Vertical ChipsAutoScroll
            SizedBox(
              height: 300,
              child: ChipsAutoScroll(
                selectedIndex: _verticalIndex,
                scrollDirection: Axis.vertical,
                width: 160,
                children: List.generate(
                  categories.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ChoiceChip(
                      label: Text(categories[index]),
                      selected: index == _verticalIndex,
                      onSelected: (_) =>
                          setState(() => _verticalIndex = index),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 24),

        // Buttons to test jumping
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 52),
            ...List.generate(
              categories.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  onPressed: () => setState(() => _verticalIndex = index),
                  child: Text('Jump to ${index + 1}'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
