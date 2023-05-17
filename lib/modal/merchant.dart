class Merchant {
  Merchant({
    required this.name,
    required this.desc,
    this.img,
  });

  String? img;
  String name;
  String desc;
  double? score;
  int? sales;
}
