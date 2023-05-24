import 'package:flutter/material.dart';
import 'package:local_biz/utils/img_url.dart';

class LbImage extends StatelessWidget {
  const LbImage({super.key, this.imgUrl, required this.defaultImage});
  final String? imgUrl;
  final ImageProvider defaultImage;

  @override
  Widget build(BuildContext context) {
    ImageProvider image =
        imgUrl != null ? NetworkImage(getImgUrl(imgUrl!)) : defaultImage;
    return Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(image: image, fit: BoxFit.cover)));
  }
}
