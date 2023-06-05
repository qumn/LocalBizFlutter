import 'package:flutter/material.dart';

class Price extends StatelessWidget {
  const Price(this.price, {super.key, this.fontSize = 18});
  final double price;
  final double fontSize;

  String integerPart(double price) {
    return price.toStringAsFixed(0);
  }

  // get decimal part
  String decimalPart(double price) {
    return price.toStringAsFixed(2).split('.')[1];
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var moneyStyle = theme.textTheme.bodyLarge!.copyWith(
        fontWeight: FontWeight.w700,
        color: colorScheme.primary,
        fontSize: fontSize);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text("¥", style: moneyStyle),
        Text(
          integerPart(price),
          style: moneyStyle.copyWith(fontSize: fontSize * 1.5),
        ),
        Text(
          ".${decimalPart(price)}",
          style: moneyStyle,
        )
      ],
    );
  }
}
