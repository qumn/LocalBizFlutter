import 'dart:math';

import 'package:flutter/material.dart';
import 'package:local_biz/config.dart';
import 'package:local_biz/log.dart';
import 'package:local_biz/modal/commodity.dart';
import 'package:local_biz/utils/img_url.dart';
import 'package:local_biz/views/merchant/shopping_card_model.dart';
import 'package:provider/provider.dart';

const _maxThumbnailCount = 3;
const _defaultThumbnailHeight = 40.0;
const _thumbnailGap = 16.0;
const _cartIconHeight = 56.0;
const _mobileCornerRadius = 24.0;
const _cartIconWidth = 64.0;
// These curves define the emphasized easing curve.
const Cubic _accelerateCurve = Cubic(0.548, 0, 0.757, 0.464);
const Cubic _decelerateCurve = Cubic(0.23, 0.94, 0.41, 1);
// The time at which the accelerate and decelerate curves switch off
const _peakVelocityTime = 0.248210;
// Percent (as a decimal) of animation that should be completed at _peakVelocityTime
const _peakVelocityProgress = 0.379146;
// Radius of the shape on the top start and bottom start of the sheet for mobile layouts.

typedef ShoppingCartMap = Map<int, (Commodity, int)>;

double _paddedThumbnailHeight(BuildContext context) {
  return _defaultThumbnailHeight + _thumbnailGap;
}

class ExpandingBottomSheet extends StatefulWidget {
  const ExpandingBottomSheet({
    super.key,
    required this.hideController,
    required this.expandingController,
  });

  final AnimationController hideController;
  final AnimationController expandingController;

  @override
  State<ExpandingBottomSheet> createState() => _ExpandingBottomSheetState();
}

class _ExpandingBottomSheetState extends State<ExpandingBottomSheet> {
  // The width of the Material, calculated by _widthFor() & based on the number
  // of products in the cart. 64.0 is the width when there are 0 products
  // (_kWidthForZeroProducts)
  double _height = _cartIconHeight;
  double _width = _cartIconWidth;

  // Controller for the opening and closing of the ExpandingBottomSheet
  AnimationController get _controller => widget.expandingController;

  // Animations for the opening and closing of the ExpandingBottomSheet
  late Animation<double> _widthAnimation;
  late Animation<double> _heightAnimation;
  late Animation<double> _topStartShapeAnimation;
  late Animation<double> _bottomStartShapeAnimation;

  Animation<double> _getWidthAnimation(double screenWidth) {
    if (_controller.status == AnimationStatus.forward) {
      // Opening animation
      return Tween<double>(begin: _width, end: screenWidth).animate(
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
    if (_controller.status == AnimationStatus.forward) {
      // Opening animation
      return _getEmphasizedEasingAnimation(
        begin: _height,
        peak: _getPeakPoint(begin: _height, end: screenHeight),
        end: screenHeight,
        isForward: true,
        parent: _controller.view,
      );
    } else {
      // Closing animation
      return Tween<double>(
        begin: _height,
        end: screenHeight,
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
    const cornerRadius = _mobileCornerRadius;

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
    return _paddedThumbnailHeight(context);
  }

  double _mobileWidthFor(int numCommoditis, BuildContext context) {
    final cartThumbnailGap = numCommoditis > 0 ? 16 : 0;
    final thumbnailsWidth = min(numCommoditis, _maxThumbnailCount) *
        _paddedThumbnailHeight(context);
    final overflowNumberWidth = numCommoditis > _maxThumbnailCount ? 45 : 0;
    return _cartIconWidth +
        cartThumbnailGap +
        thumbnailsWidth +
        overflowNumberWidth;
  }

  double get _bottomSafeArea {
    return max(MediaQuery.of(context).viewPadding.bottom - 16, 0);
  }

  @override
  Widget build(BuildContext context) {
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

    final Widget child = SizedBox(
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
        elevation: 4,
        color: Colors.pink[100],
        child: const ExtensibleShoppingCart(),
      ),
    );

    return child;
  }
}

class ExtensibleShoppingCart extends StatefulWidget {
  const ExtensibleShoppingCart({super.key});

  @override
  State<ExtensibleShoppingCart> createState() => _ExtensibleShoppingCartState();
}

class _ExtensibleShoppingCartState extends State<ExtensibleShoppingCart> {
  final _height = _cartIconHeight;

  EdgeInsetsDirectional _horizontalCartPaddingFor(int numCommoditis) {
    return (numCommoditis == 0)
        ? const EdgeInsetsDirectional.only(start: 20, end: 8)
        : const EdgeInsetsDirectional.only(start: 32, end: 8);
  }

  double get _bottomSafeArea {
    return max(MediaQuery.of(context).viewPadding.bottom - 16, 0);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var shoppingCartModel =
        Provider.of<ShoppingCartModel>(context, listen: true);
    var numCommoditis = shoppingCartModel.length();
    logger.d(
        "rebuild ExtensibleShoppingCart with shoppingCartModel.length() = $numCommoditis");

    return Material(
      animationDuration: const Duration(milliseconds: 0),
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(20),
        ),
      ),
      elevation: 4,
      color: theme.colorScheme.primaryContainer,
      child: Column(
        children: [
          Row(
            children: [
              AnimatedPadding(
                padding: _horizontalCartPaddingFor(numCommoditis),
                duration: const Duration(milliseconds: 225),
                child: const Icon(Icons.shopping_cart),
              ),
              Container(
                // Accounts for the overflow number
                width: min(numCommoditis, _maxThumbnailCount) *
                        _paddedThumbnailHeight(context) +
                    (numCommoditis > 0 ? _thumbnailGap : 0),
                height: _height,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const CommodityThumbnailRow(),
              ),
              const ExtraProductsNumber(),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class CommodityThumbnailRow extends StatefulWidget {
  const CommodityThumbnailRow({super.key});

  @override
  State<CommodityThumbnailRow> createState() => _CommodityThumbnailRowState();
}

class _CommodityThumbnailRowState extends State<CommodityThumbnailRow> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  // _list represents what's currently on screen. If _internalList updates,
  // it will need to be updated to match it.
  late _ListModel _list;

  // _internalList represents the list as it is updated by the AppStateModel.
  late List<int> _internalList;

  @override
  void initState() {
    super.initState();
    _list = _ListModel(
      listKey: _listKey,
      initialItems: [],
      removedItemBuilder: _buildRemovedThumbnail,
    );
    _internalList = List<int>.from(_list.list);
  }

  Commodity? _commodityWithId(BuildContext context, int id) {
    var shoppingCartModel =
        Provider.of<ShoppingCartModel>(context, listen: false);
    return shoppingCartModel.getCommodity(id);
  }

  Widget _buildRemovedThumbnail(
      int cid, BuildContext context, Animation<double> animation) {
    logger.d("--------- buildRemovedThumbnail cid = $cid");
    return ProductThumbnail(
        animation, animation, _commodityWithId(context, cid)!);
  }


  Widget _buildThumbnail(
      BuildContext context, int index, Animation<double> animation) {
    final thumbnailSize = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        curve: const Interval(0.33, 1, curve: Curves.easeIn),
        parent: animation,
      ),
    );

    final Animation<double> opacity = CurvedAnimation(
      curve: const Interval(0.33, 1, curve: Curves.linear),
      parent: animation,
    );

    logger.d(
        "--------- buildThumbnail index = $index, commodity: ${_list[index]}");
    var commodity = _commodityWithId(context, _list[index]);
    return commodity != null
        ? ProductThumbnail(thumbnailSize, opacity, commodity)
        : Container();
  }

  Widget _buildAnimatedList(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      shrinkWrap: true,
      itemBuilder: _buildThumbnail,
      initialItemCount: _list.length,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(), // Cart shouldn't scroll
    );
  }

  // If the lists are the same length, assume nothing has changed.
  // If the internalList is shorter than the ListModel, an item has been removed.
  // If the internalList is longer, then an item has been added.
  void _updateLists(ShoppingCartModel shoppingCartModel) {
    // Update _internalList based on the model
    _internalList = shoppingCartModel.getCommodityIds();
    final internalSet = Set<int>.from(_internalList);
    final listSet = Set<int>.from(_list.list);

    final difference = internalSet.difference(listSet);
    if (difference.isEmpty) {
      return;
    }

    for (final product in difference) {
      if (_internalList.length < _list.length) {
        _list.remove(product);
      } else if (_internalList.length > _list.length) {
        _list.add(product);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var shoppingCartModel = Provider.of<ShoppingCartModel>(context);
    _updateLists(shoppingCartModel);
    return _buildAnimatedList(context);
  }
}

class ProductThumbnail extends StatelessWidget {
  const ProductThumbnail(this.animation, this.opacityAnimation, this.commodity,
      {super.key});

  final Animation<double> animation;
  final Animation<double> opacityAnimation;
  final Commodity commodity;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnimation,
      child: ScaleTransition(
        scale: animation,
        child: Container(
            width: _defaultThumbnailHeight,
            height: _defaultThumbnailHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: commodity.img != null
                    ? NetworkImage(getImgUrl(commodity.img!))
                    : const AssetImage(defaultCommodityImage) as ImageProvider,
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            margin: const EdgeInsetsDirectional.only(start: 16)),
      ),
    );
  }
}

class ExtraProductsNumber extends StatelessWidget {
  const ExtraProductsNumber({super.key});

  Widget _buildOverflow(ShoppingCartModel model, BuildContext context) {
    var theme = Theme.of(context);
    var textStyle = theme.textTheme.labelLarge!
        .copyWith(color: theme.colorScheme.onPrimaryContainer);

    if (model.length() <= _maxThumbnailCount) {
      return Container();
    }

    final numOverflowProducts = model.length() - _maxThumbnailCount;
    // Maximum of 99 so padding doesn't get messy.
    final displayedOverflowProducts =
        numOverflowProducts <= 99 ? numOverflowProducts : 99;
    return Text(
      '+$displayedOverflowProducts',
      style: textStyle,
      textScaleFactor: 1.4,
    );
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<ShoppingCartModel>(context);
    return _buildOverflow(model, context);
  }
}

// _ListModel manipulates an internal list and an AnimatedList
class _ListModel {
  _ListModel({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<int>? initialItems,
  }) : _items = initialItems?.toList() ?? [];

  final GlobalKey<AnimatedListState> listKey;
  final Widget Function(int, BuildContext, Animation<double>)
      removedItemBuilder;
  final List<int> _items;

  AnimatedListState? get _animatedList => listKey.currentState;

  void add(int product) {
    _insert(_items.length, product);
  }

  void _insert(int index, int item) {
    _items.insert(index, item);
    _animatedList!
        .insertItem(index, duration: const Duration(milliseconds: 225));
  }

  void remove(int product) {
    final index = _items.indexOf(product);
    if (index >= 0) {
      _removeAt(index);
    }
  }

  void _removeAt(int index) {
    final removedItem = _items.removeAt(index);
    _animatedList!.removeItem(index, (context, animation) {
      return removedItemBuilder(removedItem, context, animation);
    });
  }

  int get length => _items.length;

  int operator [](int index) => _items[index];

  int indexOf(int item) => _items.indexOf(item);

  List<int> get list => _items;
}

// Maximum number of thumbnails shown in the cart.

// Emphasized Easing is a motion curve that has an organic, exciting feeling.
// It's very fast to begin with and then very slow to finish. Unlike standard
// curves, like [Curves.fastOutSlowIn], it can't be expressed in a cubic bezier
// curve formula. It's quintic, not cubic. But it _can_ be expressed as one
// curve followed by another, which we do here.
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
