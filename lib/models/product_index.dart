import 'dart:convert';

class ProductIndex {
    String name;
    int isMain;

  ProductIndex({
      this.name,
      this.isMain,
  });

  //String get fullLogoUrl => 'https://oilgasconference.az/css/oilgasconference/logo-site.png?v=2020.11.07$';

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "isMain": isMain == null ? null : isMain,
    };
  }

  factory ProductIndex.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ProductIndex(
      name: map["name"],
      isMain: map["isMain"] == null ? null : map["isMain"],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductIndex.fromJson(String source) => ProductIndex.fromMap(json.decode(source));
}
