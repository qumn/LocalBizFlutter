import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:local_biz/modal/merchant.dart';
import 'package:go_router/go_router.dart' as go;
import 'package:local_biz/views/merchat_detail.dart';

const defaultMerchantImage = 'assets/merchant.jpeg';

class MerchantScreen extends StatefulWidget {
  const MerchantScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MerchantScreenState();
}

class _MerchantScreenState extends State<MerchantScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: get merchant info from server
    var merchantItems =
        List.generate(10, (i) => Merchant(mid: i, name: "茶百道 ${i}th", desc: ""))
            .map((m) => MerchantItem(merchant: m));

    return Scaffold(
      appBar: AppBar(
        title: const Text("LocalBiz"),
        leading: const Icon(Icons.menu),
        actions: const [
          Icon(Icons.search),
        ],
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[...merchantItems],
      ),
    );
  }
}

class MerchantItem extends StatelessWidget {
  const MerchantItem({super.key, required this.merchant});
  final Merchant merchant;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0,
      closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)),
      closedBuilder: (context, action) => MerchantCar(merchant: merchant),
      openBuilder: (context, action) => const MerchantDetailScreen(),
    );
  }
}

class MerchantCar extends StatelessWidget {
  const MerchantCar({super.key, required this.merchant});

  final Merchant merchant;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: _MerchantImage(merchant.img)),
          Expanded(
            flex: 2,
            child: Container(
                padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                child: _Description(merchant)),
          ),
        ],
      ),
    );
  }
}

class _MerchantImage extends StatelessWidget {
  const _MerchantImage(this.img);

  final String? img;

  @override
  Widget build(BuildContext context) {
    ImageProvider image = img != null
        ? NetworkImage(img!)
        : const AssetImage(defaultMerchantImage) as ImageProvider;
    return Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(image: image, fit: BoxFit.cover)));
  }
}

class _Description extends StatelessWidget {
  const _Description(this.merchant);

  final Merchant merchant;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var titleStyle = theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onSurface, fontWeight: FontWeight.w500);
    var litleStyle =
        theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.onSurface);
    var scoreStyle =
        theme.textTheme.labelMedium!.copyWith(color: theme.colorScheme.primary);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(merchant.name, style: titleStyle),
          Text("月销售 ${merchant.sales ?? 0}", style: litleStyle),
        ]),
        Container(
          // height: 90% of parent
          height: scoreStyle.fontSize! * 2.5,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: theme.colorScheme.primaryContainer),
          child: Center(
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Icon(Icons.star,
                  color: theme.colorScheme.primary,
                  size: scoreStyle.fontSize! * 2),
              Text((merchant.score ?? 0.0).toStringAsFixed(1),
                  style: scoreStyle),
            ]),
          ),
        )
      ],
    );
  }
}
