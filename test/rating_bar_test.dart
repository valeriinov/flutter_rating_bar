import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_test/flutter_test.dart';

const _itemSize = 40.0;
const _itemPadding = EdgeInsets.symmetric(horizontal: 10);
const _spacedBarWidth = 300.0;

void main() {
  _setup();

  group('RatingBar Widget Tests', () {
    _ratingBarShouldUpdateRatingWhenTappingItemPadding();
    _ratingBarShouldUpdateRatingWhenDraggingFromItemPadding();
    _ratingBarShouldUpdateRatingWhenDraggingBetweenItems();
  });
}

void _setup() {}

void _ratingBarShouldUpdateRatingWhenTappingItemPadding() {
  testWidgets('RatingBar should update rating when tapping item padding',
      (tester) async {
    double? updatedRating;
    await tester.pumpWidget(
      _buildRatingBar(
        onRatingUpdate: (rating) {
          updatedRating = rating;
        },
      ),
    );

    await tester.tapAt(_secondItemLeftPadding(tester));
    await tester.pumpAndSettle();

    expect(updatedRating, 2);
  });
}

void _ratingBarShouldUpdateRatingWhenDraggingFromItemPadding() {
  testWidgets('RatingBar should update rating when dragging from item padding',
      (tester) async {
    double? updatedRating;
    await tester.pumpWidget(
      _buildRatingBar(
        onRatingUpdate: (rating) {
          updatedRating = rating;
        },
      ),
    );

    final gesture = await tester.startGesture(_secondItemLeftPadding(tester));
    await gesture.moveBy(const Offset(_itemSize, 0));
    await gesture.moveBy(const Offset(1, 0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(updatedRating, 2);
  });
}

void _ratingBarShouldUpdateRatingWhenDraggingBetweenItems() {
  testWidgets('RatingBar should update rating when dragging between items',
      (tester) async {
    double? updatedRating;
    await tester.pumpWidget(
      _buildRatingBar(
        itemPadding: EdgeInsets.zero,
        onRatingUpdate: (rating) {
          updatedRating = rating;
        },
        width: _spacedBarWidth,
        wrapAlignment: WrapAlignment.spaceBetween,
      ),
    );

    final gesture = await tester.startGesture(_spaceBetweenFirstItems(tester));
    await gesture.moveBy(const Offset(_itemSize, 0));
    await gesture.moveBy(const Offset(1, 0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(updatedRating, 2);
  });
}

Widget _buildRatingBar({
  required ValueChanged<double> onRatingUpdate,
  EdgeInsetsGeometry itemPadding = _itemPadding,
  double? width,
  WrapAlignment wrapAlignment = WrapAlignment.start,
}) {
  final ratingBar = RatingBar.builder(
    glow: false,
    itemPadding: itemPadding,
    onRatingUpdate: onRatingUpdate,
    wrapAlignment: wrapAlignment,
    itemBuilder: (context, index) {
      return const Icon(Icons.star);
    },
  );

  return MaterialApp(
    home: Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: width == null
            ? ratingBar
            : SizedBox(width: width, child: ratingBar),
      ),
    ),
  );
}

Offset _secondItemLeftPadding(WidgetTester tester) {
  final box = tester.renderObject<RenderBox>(find.byType(RatingBar));
  final secondItemLeftPaddingDx =
      _itemSize + _itemPadding.horizontal + _itemPadding.left / 2;
  final localOffset = Offset(secondItemLeftPaddingDx, box.size.height / 2);

  return box.localToGlobal(localOffset);
}

Offset _spaceBetweenFirstItems(WidgetTester tester) {
  final box = tester.renderObject<RenderBox>(find.byType(RatingBar));
  const itemCount = 5;
  const firstGapStart = _itemSize;
  const firstGapWidth =
      (_spacedBarWidth - _itemSize * itemCount) / (itemCount - 1);
  const localOffset = Offset(
    firstGapStart + firstGapWidth / 2,
    _itemSize / 2,
  );

  return box.localToGlobal(localOffset);
}
