# chips_auto_scroll

A Flutter widget that automatically scrolls to and centers the selected chip in a horizontal or vertical chip list.

> Flutter doesn't provide built-in support for automatically scrolling and centering selected items in a scrollable chip list. This package solves that problem with a simple, plug-and-play widget.

![chips_auto_scroll demo](https://raw.githubusercontent.com/armaanjamadar/chips_auto_scroll/main/demo.gif)

## Features

- ✅ Auto-scrolls to the selected chip on init and on index change
- ✅ Supports **horizontal** and **vertical** scroll directions
- ✅ Works with **any widget** — `ChoiceChip`, `FilterChip`, `ActionChip`, or fully custom components
- ✅ Customizable animation **duration** and **curve**
- ✅ Customizable **padding**, **height**, **width**, and **scroll physics**
- ✅ `ClampingScrollPhysics` by default for consistent cross-platform behavior
- ✅ Edge chips scroll to boundary when centering isn't possible
- ✅ Zero dependencies beyond Flutter

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  chips_auto_scroll: ^0.0.2
```

Then run:

```bash
flutter pub get
```

## Usage

### Horizontal Example

```dart
import 'package:chips_auto_scroll/chips_auto_scroll.dart';

int _selectedIndex = 0;

ChipsAutoScroll(
  selectedIndex: _selectedIndex,
  children: List.generate(
    categories.length,
    (index) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(categories[index]),
        selected: index == _selectedIndex,
        onSelected: (_) => setState(() => _selectedIndex = index),
      ),
    ),
  ),
)
```

### Vertical Example

```dart
ChipsAutoScroll(
  selectedIndex: _selectedIndex,
  scrollDirection: Axis.vertical,
  height: 300,
  width: 160,
  children: List.generate(
    categories.length,
    (index) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ChoiceChip(
        label: Text(categories[index]),
        selected: index == _selectedIndex,
        onSelected: (_) => setState(() => _selectedIndex = index),
      ),
    ),
  ),
)
```

### Custom Animation

```dart
ChipsAutoScroll(
  selectedIndex: _selectedIndex,
  animationDuration: const Duration(milliseconds: 500),
  animationCurve: Curves.easeInOut,
  children: [...],
)
```

### Custom Padding

```dart
ChipsAutoScroll(
  selectedIndex: _selectedIndex,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  children: [...],
)
```

### Custom Physics

```dart
ChipsAutoScroll(
  selectedIndex: _selectedIndex,
  physics: const BouncingScrollPhysics(),
  children: [...],
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `children` | `List<Widget>` | required | The chip widgets to display |
| `selectedIndex` | `int` | required | Index of the selected chip |
| `scrollDirection` | `Axis` | `Axis.horizontal` | Scroll direction |
| `animationDuration` | `Duration` | `350ms` | Duration of scroll animation |
| `animationCurve` | `Curve` | `Curves.easeOut` | Curve of scroll animation |
| `padding` | `EdgeInsetsGeometry?` | auto | Padding around the list |
| `height` | `double?` | `60` (horizontal) | Height of the container |
| `width` | `double?` | `null` | Width of the container |
| `physics` | `ScrollPhysics?` | `ClampingScrollPhysics` | Scroll physics |

## When to use this package

This package is designed for:
- Horizontal category/filter chip lists
- Vertical tag or option lists
- Tab-style selectors with more items than fit on screen

It works best for **small to medium lists** (up to ~50 items). For very large or infinite lists, a position-based solution would be more appropriate.

## How It Works

`ChipsAutoScroll` uses a `ScrollController` and a `GlobalKey` per item to measure each chip's exact position in the scroll viewport. On init it uses `jumpTo` (instant, no flash) and on subsequent index changes it uses `animateTo` (smooth animation). Chips near the edges that cannot be centered are scrolled to the nearest boundary instead.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request on GitHub.

## License

MIT
