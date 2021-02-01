import 'dart:convert';

import 'package:ceo_events/models/product_index.dart';

class Company {
    int projectId;
    int id;
    String name;
    String standN;
    String address;
    String phone;
    String email;
    String site;
    String contactEmail;
    String logoLink;
    String descriptionLink;
    String fax;
    List<ProductIndex> productIndexes;
    String mobile;
    
  Company({
      this.projectId,
      this.id,
      this.name,
      this.standN,
      this.address,
      this.phone,
      this.email,
      this.site,
      this.contactEmail,
      this.logoLink,
      this.descriptionLink,
      this.fax,
      this.productIndexes,
      this.mobile,
  });

  //String get fullLogoUrl => 'https://oilgasconference.az/css/oilgasconference/logo-site.png?v=2020.11.07$';

  Map<String, dynamic> toMap() {
    return {
        "ProjectID": projectId,
        "ID": id,
        "Name": name,
        "StandN": standN == null ? null : standN,
        "Address": address,
        "Phone": phone == null ? null : phone,
        "Email": email == null ? null : email,
        "Site": site == null ? null : site,
        "ContactEmail": contactEmail == null ? null : contactEmail,
        "LogoLink": logoLink == null ? null : logoLink,
        "DescriptionLink": descriptionLink,
        "Fax": fax == null ? null : fax,
        "ProductIndexes": productIndexes == null ? null : List<dynamic>.from(productIndexes.map((x) => x.toMap())),
        "Mobile": mobile == null ? null : mobile,
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Company(
        projectId: map["ProjectID"],
        id: map["ID"],
        name: map["Name"],
        standN: map["StandN"] == null ? null : map["StandN"],
        address: map["Address"],
        phone: map["Phone"] == null ? null : map["Phone"],
        email: map["Email"] == null ? null : map["Email"],
        site: map["Site"] == null ? null : map["Site"],
        contactEmail: map["ContactEmail"] == null ? null : map["ContactEmail"],
        logoLink: map["LogoLink"] == null ? null : map["LogoLink"],
        descriptionLink: map["DescriptionLink"],
        fax: map["Fax"] == null ? null : map["Fax"],
        productIndexes: map["ProductIndexes"] == null ? null : List<ProductIndex>.from(map["ProductIndexes"].map((x) => ProductIndex.fromMap(x))),
        mobile: map["Mobile"] == null ? null : map["Mobile"],
    );
  }

  String toJson() => json.encode(toMap());

  factory Company.fromJson(String source) => Company.fromMap(json.decode(source));
}
