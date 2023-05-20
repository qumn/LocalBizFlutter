import 'package:flutter/material.dart';

const defaultMerchantImage = 'assets/merchant.jpeg';

class MerchantDetailScreen extends StatefulWidget {
  const MerchantDetailScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MerchantDetailScreenState();
}

class _MerchantImage extends StatelessWidget {
  const _MerchantImage(this.img);

  final String? img;

  @override
  Widget build(BuildContext context) {
    ImageProvider image = img != null
        ? NetworkImage(img!)
        : const AssetImage(defaultMerchantImage) as ImageProvider;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details page'),
      ),
      body: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(image: image, fit: BoxFit.cover))),
    );
  }
}

class _MerchantDetailScreenState extends State<MerchantDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(child: _MerchantImage(null)),
        Expanded(child: Placeholder())
      ],
    );
  }
}
