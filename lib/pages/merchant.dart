import 'package:flutter/material.dart';
import 'package:local_biz/modal/merchant.dart';

const defaultMerchantImage = 'assets/merchant.jpeg';

class MerchantPage extends StatefulWidget {
  const MerchantPage({super.key});

  @override
  State<StatefulWidget> createState() => _MerchantPageState();
}

class _MerchantPageState extends State<MerchantPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: get merchant info from server
    var merchantItems =
        List.generate(10, (i) => Merchant(name: "茶百道 ${i}th", desc: ""))
            .map((m) => MerchantItem(merchant: m));

    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[...merchantItems],
    );
  }
}

class MerchantItem extends StatelessWidget {
  const MerchantItem({super.key, required this.merchant});

  final Merchant merchant;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        // color: theme.primaryColorDark,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 5, child: _MerchantImage(merchant.img)),
            const SizedBox(height: 10),
            Expanded(flex: 2, child: _Description(merchant))
          ],
        ),
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
            borderRadius: const BorderRadius.all(Radius.circular(3)),
            image: DecorationImage(image: image, fit: BoxFit.cover)));
  }
}

class _Description extends StatelessWidget {
  const _Description(this.merchant);

  final Merchant merchant;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var titleStyle = theme.textTheme.titleMedium!
        .copyWith(color: theme.colorScheme.onSurface);
    var litleStyle =
        theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.onSurface);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(merchant.name, style: titleStyle),
        const SizedBox(height: 2),
        DefaultTextStyle.merge(
          style: litleStyle,
          child: Row(children: [
            Text("${merchant.score ?? 4.0} 分"),
            const Text(" | "),
            Text("月销售 ${merchant.sales ?? 0}"),
          ]),
        )
      ],
    );
  }
}
