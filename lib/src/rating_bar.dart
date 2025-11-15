import 'dart:math' as math;

import 'package:flutter/material.dart';

part 'rating_bar_indicator.dart';

/// Defines widgets which are to used as rating bar items.
class RatingWidget {
  /// Creates [RatingWidget] with the given [full], [half] and [empty] widgets.
  const RatingWidget({
    required this.full,
    required this.half,
    required this.empty,
  });

  /// Defines widget to be used as rating bar item
  /// when the item is completely rated.
  final Widget full;

  /// Defines widget to be used as rating bar item
  /// when only the half portion of item is rated.
  final Widget half;

  /// Defines widget to be used as rating bar item
  /// when the item is unrated.
  final Widget empty;
}

/// A widget to receive rating input from users.
///
/// [RatingBar] can also be used to display rating
///
/// Prefer using [RatingBarIndicator] instead, if read only version is required.
/// As RatingBarIndicator supports any fractional rating value.
class RatingBar extends StatefulWidget {
  /// Creates [RatingBar] using the [ratingWidget].
  const RatingBar({
    /// Customizes the Rating Bar item with [RatingWidget].
    required RatingWidget ratingWidget,
    required this.onRatingUpdate,
    this.glowColor,
    this.maxRating,
    this.textDirection,
    this.unratedColor,
    this.allowHalfRating = false,
    this.direction = Axis.horizontal,
    this.glow = true,
    this.glowRadius = 2,
    this.ignoreGestures = false,
    this.initialRating = 0.0,
    this.itemCount = 5,
    this.itemPadding = EdgeInsets.zero,
    this.itemSize = 40.0,
    this.minRating = 0,
    this.tapOnlyMode = false,
    this.updateOnDrag = false,
    this.wrapAlignment = WrapAlignment.start,
    this.includeOuterPadding = true,
    this.useAvailableSpace = false,
    super.key,
  })  : _itemBuilder = null,
        _ratingWidget = ratingWidget;

  /// Creates [RatingBar] using the [itemBuilder].
  const RatingBar.builder({
    /// {@template flutterRatingBar.itemBuilder}
    /// Widget for each rating bar item.
    /// {@endtemplate}
    required IndexedWidgetBuilder itemBuilder,
    required this.onRatingUpdate,
    this.glowColor,
    this.maxRating,
    this.textDirection,
    this.unratedColor,
    this.allowHalfRating = false,
    this.direction = Axis.horizontal,
    this.glow = true,
    this.glowRadius = 2,
    this.ignoreGestures = false,
    this.initialRating = 0.0,
    this.itemCount = 5,
    this.itemPadding = EdgeInsets.zero,
    this.itemSize = 40.0,
    this.minRating = 0,
    this.tapOnlyMode = false,
    this.updateOnDrag = false,
    this.wrapAlignment = WrapAlignment.start,
    this.includeOuterPadding = true,
    this.useAvailableSpace = false,
    super.key,
  })  : _itemBuilder = itemBuilder,
        _ratingWidget = null;

  /// Return current rating whenever rating is updated.
  ///
  /// [updateOnDrag] can be used to change the behaviour
  /// how the callback reports the update.
  final ValueChanged<double> onRatingUpdate;

  /// Defines color for glow.
  ///
  /// Default is [ColorScheme.secondary].
  final Color? glowColor;

  /// Sets maximum rating
  ///
  /// Default is [itemCount].
  final double? maxRating;

  /// {@template flutterRatingBar.textDirection}
  /// The text flows from right to left if [textDirection] = TextDirection.rtl
  /// {@endtemplate}
  final TextDirection? textDirection;

  /// {@template flutterRatingBar.unratedColor}
  /// Defines color for the unrated portion.
  ///
  /// Default is [ThemeData.disabledColor].
  /// {@endtemplate}
  final Color? unratedColor;

  /// Default [allowHalfRating] = false.
  /// Setting true enables half rating support.
  final bool allowHalfRating;

  /// {@template flutterRatingBar.direction}
  /// Direction of rating bar.
  ///
  /// Default = Axis.horizontal
  /// {@endtemplate}
  final Axis direction;

  /// if set to true, Rating Bar item will glow when being touched.
  ///
  /// Default is true.
  final bool glow;

  /// Defines the radius of glow.
  ///
  /// Default is 2.
  final double glowRadius;

  /// if set to true, will disable any gestures over the rating bar.
  ///
  /// Default is false.
  final bool ignoreGestures;

  /// Defines the initial rating to be set to the rating bar.
  final double initialRating;

  /// {@template flutterRatingBar.itemCount}
  /// Defines total number of rating bar items.
  ///
  /// Default is 5.
  /// {@endtemplate}
  final int itemCount;

  /// {@template flutterRatingBar.itemPadding}
  /// The amount of space by which to inset each rating item.
  /// {@endtemplate}
  final EdgeInsetsGeometry itemPadding;

  /// {@template flutterRatingBar.itemSize}
  /// Defines width and height of each rating item in the bar.
  ///
  /// Default is 40.0
  /// {@endtemplate}
  final double itemSize;

  /// Sets minimum rating
  ///
  /// Default is 0.
  final double minRating;

  /// if set to true will disable drag to rate feature.
  /// Note: Enabling this mode will disable half rating capability.
  ///
  /// Default is false.
  final bool tapOnlyMode;

  /// Defines whether or not the `onRatingUpdate` updates while dragging.
  ///
  /// Default is false.
  final bool updateOnDrag;

  /// How the item within the [RatingBar] should be placed in the main axis.
  ///
  /// For example, if [wrapAlignment] is [WrapAlignment.center], the item in
  /// the RatingBar are grouped together in the center of their run
  /// in the main axis.
  ///
  /// Defaults to [WrapAlignment.start].
  final WrapAlignment wrapAlignment;

  /// {@template flutterRatingBar.includeOuterPadding}
  /// Determines whether to apply [itemPadding] to the first and last
  /// rating item along the main axis.
  ///
  /// Default is true.
  /// {@endtemplate}
  final bool includeOuterPadding;

  /// {@template flutterRatingBar.useAvailableSpace}
  /// If set to true, rating items will be spaced to fill the available
  /// space along the main axis, based on the incoming layout constraints.
  ///
  /// When enabled, [itemPadding] is ignored and spacing is calculated
  /// automatically. [includeOuterPadding] is still applied.
  ///
  /// Default is false.
  /// {@endtemplate}
  final bool useAvailableSpace;

  final IndexedWidgetBuilder? _itemBuilder;
  final RatingWidget? _ratingWidget;

  @override
  State<RatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  double _rating = 0;
  bool _isRTL = false;
  double iconRating = 0;

  late double _minRating;
  late double _maxRating;
  late final ValueNotifier<bool> _glow;

  late final _PaddingResolver _paddingResolver;

  @override
  void initState() {
    super.initState();
    _glow = ValueNotifier(false);
    _minRating = widget.minRating;
    _maxRating = widget.maxRating ?? widget.itemCount.toDouble();
    _rating = widget.initialRating;
    _paddingResolver = _createPaddingResolver();
  }

  @override
  void didUpdateWidget(RatingBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialRating != widget.initialRating) {
      _rating = widget.initialRating;
    }
    _minRating = widget.minRating;
    _maxRating = widget.maxRating ?? widget.itemCount.toDouble();

    _updatePaddingResolverConfig();
  }

  @override
  void dispose() {
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = widget.textDirection ?? Directionality.of(context);
    _isRTL = textDirection == TextDirection.rtl;
    iconRating = 0.0;

    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          _paddingResolver.recalculateResolvedPadding(
            constraints: constraints,
            textDirection: textDirection,
          );

          return Wrap(
            alignment: widget.wrapAlignment,
            textDirection: textDirection,
            direction: widget.direction,
            children: List.generate(
              widget.itemCount,
              (index) => _buildRating(context, index),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRating(BuildContext context, int index) {
    final ratingWidget = widget._ratingWidget;
    final item = widget._itemBuilder?.call(context, index);
    final ratingOffset = widget.allowHalfRating ? 0.5 : 1.0;

    Widget resolvedRatingWidget;

    if (index >= _rating) {
      resolvedRatingWidget = _NoRatingWidget(
        size: widget.itemSize,
        enableMask: ratingWidget == null,
        unratedColor: widget.unratedColor ?? Theme.of(context).disabledColor,
        child: ratingWidget?.empty ?? item!,
      );
    } else if (index >= _rating - ratingOffset && widget.allowHalfRating) {
      if (ratingWidget?.half == null) {
        resolvedRatingWidget = _HalfRatingWidget(
          size: widget.itemSize,
          enableMask: ratingWidget == null,
          rtlMode: _isRTL,
          unratedColor: widget.unratedColor ?? Theme.of(context).disabledColor,
          child: item!,
        );
      } else {
        resolvedRatingWidget = SizedBox(
          width: widget.itemSize,
          height: widget.itemSize,
          child: FittedBox(
            child: _isRTL
                ? Transform(
                    transform: Matrix4.identity()..scale(-1.0, 1, 1),
                    alignment: Alignment.center,
                    transformHitTests: false,
                    child: ratingWidget!.half,
                  )
                : ratingWidget!.half,
          ),
        );
      }
      iconRating += 0.5;
    } else {
      resolvedRatingWidget = SizedBox(
        width: widget.itemSize,
        height: widget.itemSize,
        child: FittedBox(
          child: ratingWidget?.full ?? item,
        ),
      );
      iconRating += 1.0;
    }

    return IgnorePointer(
      ignoring: widget.ignoreGestures,
      child: GestureDetector(
        onTapDown: (details) {
          double value;
          if (index == 0 && (_rating == 1 || _rating == 0.5)) {
            value = 0;
          } else {
            final tappedPosition = details.localPosition.dx;
            final tappedOnFirstHalf = tappedPosition <= widget.itemSize / 2;
            value = index +
                (tappedOnFirstHalf && widget.allowHalfRating ? 0.5 : 1.0);
          }

          value = math.max(value, widget.minRating);
          widget.onRatingUpdate(value);
          _rating = value;
          setState(() {});
        },
        onHorizontalDragStart: _isHorizontal ? _onDragStart : null,
        onHorizontalDragEnd: _isHorizontal ? _onDragEnd : null,
        onHorizontalDragUpdate: _isHorizontal ? _onDragUpdate : null,
        onVerticalDragStart: _isHorizontal ? null : _onDragStart,
        onVerticalDragEnd: _isHorizontal ? null : _onDragEnd,
        onVerticalDragUpdate: _isHorizontal ? null : _onDragUpdate,
        child: Padding(
          padding: _getItemPadding(index),
          child: ValueListenableBuilder<bool>(
            valueListenable: _glow,
            builder: (context, glow, child) {
              if (glow && widget.glow) {
                final glowColor =
                    widget.glowColor ?? Theme.of(context).colorScheme.secondary;
                return DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: glowColor.withAlpha(30),
                        blurRadius: 10,
                        spreadRadius: widget.glowRadius,
                      ),
                      BoxShadow(
                        color: glowColor.withAlpha(20),
                        blurRadius: 10,
                        spreadRadius: widget.glowRadius,
                      ),
                    ],
                  ),
                  child: child,
                );
              }
              return child!;
            },
            child: resolvedRatingWidget,
          ),
        ),
      ),
    );
  }

  bool get _isHorizontal => widget.direction == Axis.horizontal;

  EdgeInsets _getItemPadding(int index) {
    return _paddingResolver.getItemPaddingForIndex(
      index: index,
      isRTL: _isRTL,
    );
  }

  void _onDragUpdate(DragUpdateDetails dragDetails) {
    if (!widget.tapOnlyMode) {
      final box = context.findRenderObject() as RenderBox?;
      if (box == null) return;

      final pos = box.globalToLocal(dragDetails.globalPosition);
      final resolvedItemPadding = _paddingResolver.resolvedItemPadding;

      double i;
      if (widget.direction == Axis.horizontal) {
        i = pos.dx / (widget.itemSize + resolvedItemPadding.horizontal);
      } else {
        i = pos.dy / (widget.itemSize + resolvedItemPadding.vertical);
      }
      var currentRating = widget.allowHalfRating ? i : i.round().toDouble();
      if (currentRating > widget.itemCount) {
        currentRating = widget.itemCount.toDouble();
      }
      if (currentRating < 0) {
        currentRating = 0.0;
      }
      if (_isRTL && widget.direction == Axis.horizontal) {
        currentRating = widget.itemCount - currentRating;
      }

      _rating = currentRating.clamp(_minRating, _maxRating);
      if (widget.updateOnDrag) widget.onRatingUpdate(iconRating);
      setState(() {});
    }
  }

  void _onDragStart(DragStartDetails details) {
    _glow.value = true;
  }

  void _onDragEnd(DragEndDetails details) {
    _glow.value = false;
    widget.onRatingUpdate(iconRating);
    iconRating = 0.0;
  }

  _PaddingResolver _createPaddingResolver() {
    return _PaddingResolver(
      direction: widget.direction,
      itemCount: widget.itemCount,
      includeOuterPadding: widget.includeOuterPadding,
      itemSize: widget.itemSize,
      useAvailableSpace: widget.useAvailableSpace,
      itemPadding: widget.itemPadding,
    );
  }

  void _updatePaddingResolverConfig() {
    _paddingResolver.updateConfig(
      direction: widget.direction,
      itemCount: widget.itemCount,
      includeOuterPadding: widget.includeOuterPadding,
      itemSize: widget.itemSize,
      useAvailableSpace: widget.useAvailableSpace,
      itemPadding: widget.itemPadding,
    );
  }
}

class _HalfRatingWidget extends StatelessWidget {
  const _HalfRatingWidget({
    required this.size,
    required this.child,
    required this.enableMask,
    required this.rtlMode,
    required this.unratedColor,
  });

  final Widget child;
  final double size;
  final bool enableMask;
  final bool rtlMode;
  final Color unratedColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: enableMask
          ? Stack(
              fit: StackFit.expand,
              children: [
                FittedBox(
                  child: _NoRatingWidget(
                    size: size,
                    unratedColor: unratedColor,
                    enableMask: enableMask,
                    child: child,
                  ),
                ),
                FittedBox(
                  child: ClipRect(
                    clipper: _HalfClipper(
                      rtlMode: rtlMode,
                    ),
                    child: child,
                  ),
                ),
              ],
            )
          : FittedBox(
              child: child,
            ),
    );
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  _HalfClipper({required this.rtlMode});

  final bool rtlMode;

  @override
  Rect getClip(Size size) => rtlMode
      ? Rect.fromLTRB(
          size.width / 2,
          0,
          size.width,
          size.height,
        )
      : Rect.fromLTRB(
          0,
          0,
          size.width / 2,
          size.height,
        );

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}

class _NoRatingWidget extends StatelessWidget {
  const _NoRatingWidget({
    required this.size,
    required this.child,
    required this.enableMask,
    required this.unratedColor,
  });

  final double size;
  final Widget child;
  final bool enableMask;
  final Color unratedColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: FittedBox(
        child: enableMask
            ? ColorFiltered(
                colorFilter: ColorFilter.mode(
                  unratedColor,
                  BlendMode.srcIn,
                ),
                child: child,
              )
            : child,
      ),
    );
  }
}

class _PaddingResolver {
  _PaddingResolver({
    required Axis direction,
    required int itemCount,
    required bool includeOuterPadding,
    required double itemSize,
    required bool useAvailableSpace,
    required EdgeInsetsGeometry itemPadding,
  })  : _direction = direction,
        _itemCount = itemCount,
        _includeOuterPadding = includeOuterPadding,
        _itemSize = itemSize,
        _useAvailableSpace = useAvailableSpace,
        _itemPadding = itemPadding;

  Axis _direction;
  int _itemCount;
  bool _includeOuterPadding;
  double _itemSize;
  bool _useAvailableSpace;
  EdgeInsetsGeometry _itemPadding;

  EdgeInsets resolvedItemPadding = EdgeInsets.zero;

  void updateConfig({
    required Axis direction,
    required int itemCount,
    required bool includeOuterPadding,
    required double itemSize,
    required bool useAvailableSpace,
    required EdgeInsetsGeometry itemPadding,
  }) {
    _direction = direction;
    _itemCount = itemCount;
    _includeOuterPadding = includeOuterPadding;
    _itemSize = itemSize;
    _useAvailableSpace = useAvailableSpace;
    _itemPadding = itemPadding;
  }

  void recalculateResolvedPadding({
    required BoxConstraints constraints,
    required TextDirection textDirection,
  }) {
    if (!_useAvailableSpace) {
      _setDefaultPadding(textDirection);

      return;
    }

    final mainExtent = _getMainExtent(constraints);

    if (_isUnboundedExtent(mainExtent)) {
      _setDefaultPadding(textDirection);

      return;
    }

    if (_itemCount <= 0) {
      _setDefaultPadding(textDirection);

      return;
    }

    final freeExtent = _calculateFreeExtent(mainExtent);

    if (_isNonPositive(freeExtent)) {
      _setDefaultPadding(textDirection);

      return;
    }

    final totalPaddingSlots = _calculateTotalPaddingSlots();

    if (totalPaddingSlots <= 0) {
      _setDefaultPadding(textDirection);

      return;
    }

    final perPadding = freeExtent / totalPaddingSlots;

    if (_isNonPositive(perPadding)) {
      _setDefaultPadding(textDirection);

      return;
    }

    final basePadding = _createBasePadding(perPadding);
    resolvedItemPadding = basePadding.resolve(textDirection);
  }

  EdgeInsets getItemPaddingForIndex({
    required int index,
    required bool isRTL,
  }) {
    if (_includeOuterPadding) {
      return resolvedItemPadding;
    }

    if (_itemCount <= 1) {
      return resolvedItemPadding;
    }

    if (_direction == Axis.horizontal) {
      return isRTL
          ? _horizontalRtlPadding(index)
          : _horizontalLtrPadding(index);
    }

    return _verticalPadding(index);
  }

  void _setDefaultPadding(TextDirection textDirection) {
    resolvedItemPadding = _itemPadding.resolve(textDirection);
  }

  double _getMainExtent(BoxConstraints constraints) {
    return _direction == Axis.horizontal
        ? constraints.maxWidth
        : constraints.maxHeight;
  }

  bool _isUnboundedExtent(double mainExtent) {
    return mainExtent.isInfinite;
  }

  double _calculateFreeExtent(double mainExtent) {
    final itemsExtent = _itemSize * _itemCount;

    return mainExtent - itemsExtent;
  }

  bool _isNonPositive(double value) {
    return value <= 0;
  }

  int _calculateTotalPaddingSlots() {
    const bothSidesSlots = 2;

    if (_itemCount == 1) {
      return bothSidesSlots;
    }

    if (_includeOuterPadding) {
      return bothSidesSlots * _itemCount;
    }

    return bothSidesSlots * (_itemCount - 1);
  }

  EdgeInsets _createBasePadding(double perPadding) {
    return _direction == Axis.horizontal
        ? EdgeInsets.symmetric(horizontal: perPadding)
        : EdgeInsets.symmetric(vertical: perPadding);
  }

  EdgeInsets _horizontalLtrPadding(int index) {
    if (index == 0) {
      return resolvedItemPadding.copyWith(left: 0);
    }

    if (index == _itemCount - 1) {
      return resolvedItemPadding.copyWith(right: 0);
    }

    return resolvedItemPadding;
  }

  EdgeInsets _horizontalRtlPadding(int index) {
    if (index == 0) {
      return resolvedItemPadding.copyWith(right: 0);
    }

    if (index == _itemCount - 1) {
      return resolvedItemPadding.copyWith(left: 0);
    }

    return resolvedItemPadding;
  }

  EdgeInsets _verticalPadding(int index) {
    if (index == 0) {
      return resolvedItemPadding.copyWith(top: 0);
    }

    if (index == _itemCount - 1) {
      return resolvedItemPadding.copyWith(bottom: 0);
    }

    return resolvedItemPadding;
  }
}
