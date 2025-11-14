part of 'rating_bar.dart';

/// A widget to display rating as assigned using [rating] property.
///
/// This is a read only version of [RatingBar].
///
/// Use [RatingBar], if interactive version is required.
/// i.e. if user input is required.
class RatingBarIndicator extends StatefulWidget {
  /// Creates a read only rating bar indicator.
  const RatingBarIndicator({
    required this.itemBuilder,
    this.textDirection,
    this.unratedColor,
    this.direction = Axis.horizontal,
    this.itemCount = 5,
    this.itemPadding = EdgeInsets.zero,
    this.itemSize = 40.0,
    this.physics = const NeverScrollableScrollPhysics(),
    this.rating = 0.0,
    this.includeOuterPadding = true,
    super.key,
  });

  /// {@macro flutterRatingBar.itemBuilder}
  final IndexedWidgetBuilder itemBuilder;

  /// {@macro flutterRatingBar.textDirection}
  final TextDirection? textDirection;

  /// {@macro flutterRatingBar.unratedColor}
  final Color? unratedColor;

  /// {@macro flutterRatingBar.direction}
  final Axis direction;

  /// {@macro flutterRatingBar.itemCount}
  final int itemCount;

  /// {@macro flutterRatingBar.itemPadding}
  final EdgeInsets itemPadding;

  /// {@macro flutterRatingBar.itemSize}
  final double itemSize;

  /// Controls the scrolling behaviour of rating bar.
  ///
  /// Default is [NeverScrollableScrollPhysics].
  final ScrollPhysics physics;

  /// Defines the rating value for indicator.
  ///
  /// Default is 0.0
  final double rating;

  /// Determines whether to apply [itemPadding] to the first and last
  /// rating item along the main axis.
  ///
  /// Default is true.
  final bool includeOuterPadding;

  @override
  State<RatingBarIndicator> createState() => _RatingBarIndicatorState();
}

class _RatingBarIndicatorState extends State<RatingBarIndicator> {
  double _ratingFraction = 0;
  int _ratingNumber = 0;
  bool _isRTL = false;

  late EdgeInsets _resolvedItemPadding;

  @override
  void initState() {
    super.initState();
    _ratingNumber = widget.rating.truncate() + 1;
    _ratingFraction = widget.rating - _ratingNumber + 1;
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = widget.textDirection ?? Directionality.of(context);
    _isRTL = textDirection == TextDirection.rtl;
    _ratingNumber = widget.rating.truncate() + 1;
    _ratingFraction = widget.rating - _ratingNumber + 1;
    _resolvedItemPadding = widget.itemPadding;

    return SingleChildScrollView(
      scrollDirection: widget.direction,
      physics: widget.physics,
      child: widget.direction == Axis.horizontal
          ? Row(
              mainAxisSize: MainAxisSize.min,
              textDirection: textDirection,
              children: _children,
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              textDirection: textDirection,
              children: _children,
            ),
    );
  }

  List<Widget> get _children {
    return List.generate(
      widget.itemCount,
      (index) {
        if (widget.textDirection != null) {
          if (widget.textDirection == TextDirection.rtl &&
              Directionality.of(context) != TextDirection.rtl) {
            return Transform(
              transform: Matrix4.identity()..scale(-1.0, 1, 1),
              alignment: Alignment.center,
              transformHitTests: false,
              child: _buildItems(index),
            );
          }
        }
        return _buildItems(index);
      },
    );
  }

  Widget _buildItems(int index) {
    return Padding(
      padding: _getItemPadding(index),
      child: SizedBox(
        width: widget.itemSize,
        height: widget.itemSize,
        child: Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
              child: index + 1 < _ratingNumber
                  ? widget.itemBuilder(context, index)
                  : ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        widget.unratedColor ?? Theme.of(context).disabledColor,
                        BlendMode.srcIn,
                      ),
                      child: widget.itemBuilder(context, index),
                    ),
            ),
            if (index + 1 == _ratingNumber)
              if (_isRTL)
                FittedBox(
                  child: ClipRect(
                    clipper: _IndicatorClipper(
                      ratingFraction: _ratingFraction,
                      rtlMode: _isRTL,
                    ),
                    child: widget.itemBuilder(context, index),
                  ),
                )
              else
                FittedBox(
                  child: ClipRect(
                    clipper: _IndicatorClipper(
                      ratingFraction: _ratingFraction,
                    ),
                    child: widget.itemBuilder(context, index),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  EdgeInsets _getItemPadding(int index) {
    if (widget.includeOuterPadding) {
      return _resolvedItemPadding;
    }

    if (widget.itemCount <= 1) {
      return _resolvedItemPadding;
    }

    if (widget.direction == Axis.horizontal) {
      if (!_isRTL) {
        if (index == 0) {
          return _resolvedItemPadding.copyWith(left: 0);
        }
        if (index == widget.itemCount - 1) {
          return _resolvedItemPadding.copyWith(right: 0);
        }
      } else {
        if (index == 0) {
          return _resolvedItemPadding.copyWith(right: 0);
        }
        if (index == widget.itemCount - 1) {
          return _resolvedItemPadding.copyWith(left: 0);
        }
      }
    } else {
      if (index == 0) {
        return _resolvedItemPadding.copyWith(top: 0);
      }
      if (index == widget.itemCount - 1) {
        return _resolvedItemPadding.copyWith(bottom: 0);
      }
    }

    return _resolvedItemPadding;
  }
}

class _IndicatorClipper extends CustomClipper<Rect> {
  _IndicatorClipper({
    required this.ratingFraction,
    this.rtlMode = false,
  });

  final double ratingFraction;
  final bool rtlMode;

  @override
  Rect getClip(Size size) {
    return rtlMode
        ? Rect.fromLTRB(
            size.width - size.width * ratingFraction,
            0,
            size.width,
            size.height,
          )
        : Rect.fromLTRB(
            0,
            0,
            size.width * ratingFraction,
            size.height,
          );
  }

  @override
  bool shouldReclip(_IndicatorClipper oldClipper) {
    return ratingFraction != oldClipper.ratingFraction ||
        rtlMode != oldClipper.rtlMode;
  }
}
