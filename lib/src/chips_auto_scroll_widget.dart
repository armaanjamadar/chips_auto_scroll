import 'package:flutter/material.dart';

/// A widget that displays a scrollable list of chips and automatically
/// scrolls to keep the selected chip visible and centered.
///
/// Supports both horizontal and vertical scroll directions, any chip widget,
/// and customizable scroll animations.
///
/// ## Basic Usage
///
/// ```dart
/// ChipsAutoScroll(
///   selectedIndex: _selectedIndex,
///   children: List.generate(
///     categories.length,
///     (index) => ChoiceChip(
///       label: Text(categories[index]),
///       selected: index == _selectedIndex,
///       onSelected: (_) => setState(() => _selectedIndex = index),
///     ),
///   ),
/// )
/// ```
class ChipsAutoScroll extends StatefulWidget {
  /// The list of chip widgets to display.
  /// Can be any widget — [ChoiceChip], [FilterChip], [ActionChip],
  /// or any custom widget.
  final List<Widget> children;

  /// The index of the currently selected chip.
  /// The list will automatically scroll to keep this chip visible.
  final int selectedIndex;

  /// The scroll direction of the chip list.
  /// Defaults to [Axis.horizontal].
  final Axis scrollDirection;

  /// The duration of the scroll animation when [selectedIndex] changes.
  /// Defaults to 350 milliseconds.
  final Duration animationDuration;

  /// The curve of the scroll animation when [selectedIndex] changes.
  /// Defaults to [Curves.easeOut].
  final Curve animationCurve;

  /// Padding around the chip list.
  /// Defaults to `EdgeInsets.symmetric(horizontal: 8, vertical: 12)`
  /// for horizontal, and `EdgeInsets.symmetric(horizontal: 12, vertical: 8)`
  /// for vertical.
  final EdgeInsetsGeometry? padding;

  /// The height of the chip list container when scroll direction is horizontal.
  /// Defaults to 60.
  final double? height;

  /// The width of the chip list container when scroll direction is vertical.
  /// Defaults to null (takes available width).
  final double? width;

  /// The scroll physics of the list.
  /// Defaults to [ClampingScrollPhysics].
  final ScrollPhysics? physics;

  const ChipsAutoScroll({
    super.key,
    required this.children,
    required this.selectedIndex,
    this.scrollDirection = Axis.horizontal,
    this.animationDuration = const Duration(milliseconds: 350),
    this.animationCurve = Curves.easeOut,
    this.padding,
    this.height,
    this.width,
    this.physics,
  }) : assert(
          selectedIndex >= 0,
          'selectedIndex must be >= 0',
        );

  @override
  State<ChipsAutoScroll> createState() => _ChipsAutoScrollState();
}

class _ChipsAutoScrollState extends State<ChipsAutoScroll> {
  final ScrollController _controller = ScrollController();
  final GlobalKey _listKey = GlobalKey();
  late List<GlobalKey> _keys;

  @override
  void initState() {
    super.initState();
    _initKeys();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelected(animate: false);
    });
  }

  @override
  void didUpdateWidget(covariant ChipsAutoScroll oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.children.length != widget.children.length) {
      _initKeys();
    }

    if (oldWidget.selectedIndex != widget.selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelected(animate: true);
      });
    }
  }

  void _initKeys() {
    _keys = List.generate(widget.children.length, (_) => GlobalKey());
  }

  void _scrollToSelected({required bool animate}) {
    if (!_controller.hasClients) return;
    if (widget.children.isEmpty) return;

    final clampedIndex = widget.selectedIndex.clamp(0, widget.children.length - 1);
    final maxScroll = _controller.position.maxScrollExtent;

    void scroll(double target) {
      final clamped = target.clamp(0.0, maxScroll);
      if (animate) {
        _controller.animateTo(
          clamped,
          duration: widget.animationDuration,
          curve: widget.animationCurve,
        );
      } else {
        _controller.jumpTo(clamped);
      }
    }

    // Near end — scroll as far as possible in the end direction
    if (clampedIndex >= widget.children.length - 2) {
      scroll(maxScroll);
      return;
    }

    // Near start — scroll as far as possible in the start direction
    if (clampedIndex <= 1) {
      scroll(0);
      return;
    }

    // Middle chips — center them
    final itemContext = _keys[clampedIndex].currentContext;
    final listContext = _listKey.currentContext;
    if (itemContext == null || listContext == null) return;

    final RenderBox item = itemContext.findRenderObject() as RenderBox;
    final RenderBox list = listContext.findRenderObject() as RenderBox;

    if (widget.scrollDirection == Axis.horizontal) {
      final itemOffset = item.localToGlobal(Offset.zero, ancestor: list).dx;
      final itemCenter = itemOffset + (item.size.width / 2);
      final viewportCenter = list.size.width / 2;
      final targetOffset = _controller.offset + (itemCenter - viewportCenter);
      scroll(targetOffset);
    } else {
      final itemOffset = item.localToGlobal(Offset.zero, ancestor: list).dy;
      final itemCenter = itemOffset + (item.size.height / 2);
      final viewportCenter = list.size.height / 2;
      final targetOffset = _controller.offset + (itemCenter - viewportCenter);
      scroll(targetOffset);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  EdgeInsetsGeometry get _defaultPadding {
    return widget.scrollDirection == Axis.horizontal
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 12)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  }

  @override
  Widget build(BuildContext context) {
    final list = ListView.builder(
      key: _listKey,
      controller: _controller,
      scrollDirection: widget.scrollDirection,
      physics: widget.physics ?? const ClampingScrollPhysics(),
      padding: widget.padding ?? _defaultPadding,
      itemCount: widget.children.length,
      itemBuilder: (context, index) {
        return KeyedSubtree(
          key: _keys[index],
          child: widget.children[index],
        );
      },
    );

    if (widget.scrollDirection == Axis.horizontal) {
      return SizedBox(
        height: widget.height ?? 60,
        width: widget.width,
        child: list,
      );
    } else {
      return SizedBox(
        height: widget.height,
        width: widget.width,
        child: list,
      );
    }
  }
}
