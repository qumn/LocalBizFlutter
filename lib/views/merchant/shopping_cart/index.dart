import 'dart:math';

import 'package:flutter/material.dart';
import 'package:local_biz/views/merchant/shopping_card_model.dart';
import 'package:provider/provider.dart';

import 'collapse.dart';
import 'expand.dart';

const _maxThumbnailCount = 3;
const _defaultThumbnailHeight = 40.0;
const _thumbnailGap = 16.0;
const _cartIconHeight = 56.0;
const _cornerRadius = 24.0;
const _cartIconWidth = 64.0;
// These curves define the emphasized easing curve.
const Cubic _accelerateCurve = Cubic(0.548, 0, 0.757, 0.464);
const Cubic _decelerateCurve = Cubic(0.23, 0.94, 0.41, 1);
// The time at which the accelerate and decelerate curves switch off
const _peakVelocityTime = 0.248210;
// Percent (as a decimal) of animation that should be completed at _peakVelocityTime
const _peakVelocityProgress = 0.379146;
// Radius of the shape on the top start and bottom start of the sheet for mobile layouts.

class ExpandingBottomSheet extends StatefulWidget {
  const ExpandingBottomSheet({
    super.key,
    required this.expandingController,
  });

  final AnimationController expandingController;

  @override
  State<ExpandingBottomSheet> createState() => ExpandingBottomSheetState();
}

class ExpandingBottomSheetState extends State<ExpandingBottomSheet> {
  final _shoppingCartKey = GlobalKey();
  // The width of the Material, calculated by _widthFor() & based on the number
  // of products in the cart. 64.0 is the width when there are 0 products
  // (_kWidthForZeroProducts)
  double _height = _cartIconHeight;
  double _width = _cartIconWidth;

  // Controller for the opening and closing of the ExpandingBottomSheet
  AnimationController get _controller => widget.expandingController;
  bool get _cartIsVisible =>
      _topStartShapeAnimation.value <= _cornerRadius * _peakVelocityTime;

  // Animations for the opening and closing of the ExpandingBottomSheet
  late Animation<double> _widthAnimation;
  late Animation<double> _heightAnimation;
  late Animation<double> _topStartShapeAnimation;
  late Animation<double> _bottomStartShapeAnimation;

  Animation<double> _getWidthAnimation(double screenWidth) {
    if (_controller.status == AnimationStatus.forward) {
      // Opening animation
      return Tween<double>(
        begin: _width,
        end: screenWidth,
      ).animate(
        CurvedAnimation(
          parent: _controller.view,
          curve: const Interval(0, 0.3, curve: Curves.fastOutSlowIn),
        ),
      );
    } else {
      // Closing animation
      return _getEmphasizedEasingAnimation(
        begin: _width,
        peak: _getPeakPoint(begin: _width, end: screenWidth),
        end: screenWidth,
        isForward: false,
        parent: CurvedAnimation(
            parent: _controller.view, curve: const Interval(0, 0.87)),
      );
    }
  }

  Animation<double> _getHeightAnimation(double screenHeight) {
    var maxHeight = screenHeight * 0.4;
    if (_controller.status == AnimationStatus.forward) {
      // Opening animation
      return _getEmphasizedEasingAnimation(
        begin: _height,
        peak: _getPeakPoint(begin: _height, end: maxHeight),
        end: maxHeight,
        isForward: true,
        parent: _controller.view,
      );
    } else {
      // Closing animation
      return Tween<double>(
        begin: _height,
        end: maxHeight,
      ).animate(
        CurvedAnimation(
          parent: _controller.view,
          curve: const Interval(0.434, 1, curve: Curves.linear), // not used
          // only the reverseCurve will be used
          reverseCurve: Interval(0.434, 1, curve: Curves.fastOutSlowIn.flipped),
        ),
      );
    }
  }

  // Animation of the top-start cut corner. It's cut when closed and not cut when open.
  Animation<double> _getShapeTopStartAnimation(BuildContext context) {
    const cornerRadius = _cornerRadius;

    if (_controller.status == AnimationStatus.forward) {
      return Tween<double>(begin: cornerRadius, end: 0).animate(
        CurvedAnimation(
          parent: _controller.view,
          curve: const Interval(0, 0.3, curve: Curves.fastOutSlowIn),
        ),
      );
    } else {
      return _getEmphasizedEasingAnimation(
        begin: cornerRadius,
        peak: _getPeakPoint(begin: cornerRadius, end: 0),
        end: 0,
        isForward: false,
        parent: _controller.view,
      );
    }
  }

  // Animation of the bottom-start cut corner. It's cut when closed and not cut when open.
  Animation<double> _getShapeBottomStartAnimation(BuildContext context) {
    const cornerRadius = 0.0;

    if (_controller.status == AnimationStatus.forward) {
      return Tween<double>(begin: cornerRadius, end: 0).animate(
        CurvedAnimation(
          parent: _controller.view,
          curve: const Interval(0, 0.3, curve: Curves.fastOutSlowIn),
        ),
      );
    } else {
      return _getEmphasizedEasingAnimation(
        begin: cornerRadius,
        peak: _getPeakPoint(begin: cornerRadius, end: 0),
        end: 0,
        isForward: false,
        parent: _controller.view,
      );
    }
  }

  double _mobileHeightFor(BuildContext context) {
    return paddedThumbnailHeight(context);
  }

  double _mobileWidthFor(int numCommoditis, BuildContext context) {
    final cartThumbnailGap = numCommoditis > 0 ? 16 : 0;
    final thumbnailsWidth =
        min(numCommoditis, _maxThumbnailCount) * paddedThumbnailHeight(context);
    final overflowNumberWidth = numCommoditis > _maxThumbnailCount ? 45 : 0;
    return _cartIconWidth +
        cartThumbnailGap +
        thumbnailsWidth +
        overflowNumberWidth;
  }

  double get _bottomSafeArea {
    return max(MediaQuery.of(context).viewPadding.bottom - 16, 0);
  }

  // Returns true if the cart is open or opening and false otherwise.
  bool get _isOpen {
    final status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  // Opens the ExpandingBottomSheet if it's closed, otherwise does nothing.
  void open() {
    if (!_isOpen) {
      _controller.forward();
    }
  }

  // Closes the ExpandingBottomSheet if it's open or opening, otherwise does nothing.
  void close() {
    if (_isOpen) {
      _controller.reverse();
    }
  }

  Widget _buildCart() {
    return TapRegion(
      onTapOutside: (d) => close(),
      onTapInside: (d) => open(),
      //onTapDown: toggle,
      child: SizedBox(
        key: _shoppingCartKey,
        width: _widthAnimation.value,
        height: _heightAnimation.value,
        child: Material(
          animationDuration: const Duration(milliseconds: 0),
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(_topStartShapeAnimation.value),
              bottomStart: Radius.circular(_bottomStartShapeAnimation.value),
            ),
          ),
          child: _cartIsVisible
              ? const ExpandShoppingCart()
              : const CollapseShoppingCart(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var shoppingCartModel = Provider.of<ShoppingCartModel>(context);
    var numCommoditis = shoppingCartModel.length();

    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    _width = _mobileWidthFor(numCommoditis, context);
    _height = _mobileHeightFor(context) + _bottomSafeArea;
    _widthAnimation = _getWidthAnimation(screenWidth);
    _heightAnimation = _getHeightAnimation(screenHeight);
    _topStartShapeAnimation = _getShapeTopStartAnimation(context);
    _bottomStartShapeAnimation = _getShapeBottomStartAnimation(context);

    return Material(
      animationDuration: const Duration(milliseconds: 0),
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(20),
        ),
      ),
      elevation: 4,
      color: theme.colorScheme.primaryContainer,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 225),
        curve: Curves.easeInOut,
        child: AnimatedBuilder(
          animation: widget.expandingController,
          builder: (ctx, child) {
            return _buildCart();
          },
        ),
      ),
    );
  }
}

Animation<T> _getEmphasizedEasingAnimation<T>({
  required T begin,
  required T peak,
  required T end,
  required bool isForward,
  required Animation<double> parent,
}) {
  Curve firstCurve;
  Curve secondCurve;
  double firstWeight;
  double secondWeight;

  if (isForward) {
    firstCurve = _accelerateCurve;
    secondCurve = _decelerateCurve;
    firstWeight = _peakVelocityTime;
    secondWeight = 1 - _peakVelocityTime;
  } else {
    firstCurve = _decelerateCurve.flipped;
    secondCurve = _accelerateCurve.flipped;
    firstWeight = 1 - _peakVelocityTime;
    secondWeight = _peakVelocityTime;
  }

  return TweenSequence<T>(
    [
      TweenSequenceItem<T>(
        weight: firstWeight,
        tween: Tween<T>(
          begin: begin,
          end: peak,
        ).chain(CurveTween(curve: firstCurve)),
      ),
      TweenSequenceItem<T>(
        weight: secondWeight,
        tween: Tween<T>(
          begin: peak,
          end: end,
        ).chain(CurveTween(curve: secondCurve)),
      ),
    ],
  ).animate(parent);
}

double _getPeakPoint({required double begin, required double end}) {
  return begin + (end - begin) * _peakVelocityProgress;
}

double paddedThumbnailHeight(BuildContext context) {
  return _defaultThumbnailHeight + _thumbnailGap;
}
