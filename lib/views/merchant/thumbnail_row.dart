import 'package:flutter/material.dart';
import 'package:local_biz/config.dart';
import 'package:local_biz/log.dart';
import 'package:local_biz/modal/commodity.dart';
import 'package:local_biz/utils/img_url.dart';
import 'package:local_biz/views/merchant/shopping_card_model.dart';
import 'package:provider/provider.dart';

const _defaultThumbnailHeight = 40.0;

class CommodityThumbnailRow extends StatefulWidget {
  const CommodityThumbnailRow({super.key});

  @override
  State<CommodityThumbnailRow> createState() => _CommodityThumbnailRowState();
}

class _CommodityThumbnailRowState extends State<CommodityThumbnailRow> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late ListModel<Commodity> _list;

  @override
  void initState() {
    super.initState();
    _list = ListModel<Commodity>(
        listKey: _listKey,
        initialItems: Provider.of<ShoppingCartModel>(context, listen: false)
            .getCommodities(),
        removedItemBuilder: _buildRemovedThumbnail);
  }

  Widget _buildRemovedThumbnail(
      Commodity commodity, BuildContext context, Animation<double> animation) {
    return ProductThumbnail(animation, animation, commodity);
  }

  Widget _buildThumbnail(
      BuildContext context, int idx, Animation<double> animation) {
    final thumbnailSize = Tween<double>(begin: 0.1, end: 1).animate(
      CurvedAnimation(
        curve: const Interval(0.33, 1, curve: Curves.easeIn),
        parent: animation,
      ),
    );

    final Animation<double> opacity = CurvedAnimation(
      curve: const Interval(0.33, 1, curve: Curves.linear),
      parent: animation,
    );

    return ProductThumbnail(thumbnailSize, opacity, _list[idx]);
  }

  void _updateLists(ShoppingCartModel shoppingCartModel) {
    // Update _internalList based on the model
    final commoditiesInCart = shoppingCartModel.getCommodities();

    final inCartSet = Set<Commodity>.from(commoditiesInCart);
    final listSet = Set<Commodity>.from(_list.list);

    final additionListSet = inCartSet.difference(listSet);
    for (Commodity commodity in additionListSet) {
      _list.add(commodity);
    }

    final removedListSet = listSet.difference(inCartSet);
    for (Commodity commodity in removedListSet) {
      _list.remove(commodity);
    }
  }

  @override
  Widget build(BuildContext context) {
    var shoppingCartModel = Provider.of<ShoppingCartModel>(context);
    _updateLists(shoppingCartModel);

    return AnimatedSize(
      duration: const Duration(milliseconds: 225),
      curve: Curves.easeInOut,
      alignment: AlignmentDirectional.topStart,
      child: AnimatedList(
        scrollDirection: Axis.horizontal,
        key: _listKey,
        // shrinkWrap: true,
        initialItemCount: _list.length,
        physics: const NeverScrollableScrollPhysics(), // Cart shouldn't scroll
        itemBuilder: _buildThumbnail,
      ),
    );
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
    logger.d('ProductThumbnail.build: ${commodity.toJson()}');
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
            margin: const EdgeInsetsDirectional.only(start: 16),
          )),
    );
  }
}

typedef RemovedItemBuilder<T> = Widget Function(
    T item, BuildContext context, Animation<double> animation);

/// Keeps a Dart [List] in sync with an [AnimatedList].
///
/// The [insert] and [removeAt] methods apply to both the internal list and
/// the animated list that belongs to [listKey].
///
/// This class only exposes as much of the Dart List API as is needed by the
/// sample app. More list methods are easily added, however methods that
/// mutate the list must make the same changes to the animated list in terms
/// of [AnimatedListState.insertItem] and [AnimatedList.removeItem].
class ListModel<E> {
  ListModel({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<E>? initialItems,
  }) : _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final RemovedItemBuilder<E> removedItemBuilder;
  final List<E> _items;

  AnimatedListState? get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    // animated list will be null if the widget is not built yet
    if (_animatedList != null) {
      _animatedList!.insertItem(index);
    }
  }

  void add(E item) {
    insert(_items.length, item);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList!.removeItem(
        index,
        (BuildContext context, Animation<double> animation) {
          return removedItemBuilder(removedItem, context, animation);
        },
      );
    }
    return removedItem;
  }

  void remove(E e) {
    final int index = _items.indexOf(e);
    logger.d('remove: $e, index: $index');
    if (index != -1) {
      removeAt(index);
    }
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
  List<E> get list => _items;
}
