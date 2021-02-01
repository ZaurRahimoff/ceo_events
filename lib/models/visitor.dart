import 'dart:convert';

class Visitor {
    String id;
    String personalId;
    String name;
    String company;
    String position;
    String email;
    String mobile;

  Visitor({
      this.id,
      this.personalId,
      this.name,
      this.company,
      this.position,
      this.email,
      this.mobile,
  });

  //String get fullLogoUrl => 'https://oilgasconference.az/css/oilgasconference/logo-site.png?v=2020.11.07$';

  Map<String, dynamic> toMap() {
    return {
        "ID": id,
        "Personal_ID": personalId,
        "Name": name,
        "Company": company == null ? null : company,
        "Position": position == null ? null : position,
        "Email": email == null ? null : email,
        "Mobile": mobile == null ? null : mobile,
    };
  }

  factory Visitor.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Visitor(
        id: map["ID"],
        personalId: map["Personal_ID"],
        name: map["Name"],
        company: map["Company"] == null ? null : map["Company"],
        position: map["Position"] == null ? null : map["Position"],
        email: map["Email"] == null ? null : map["Email"],
        mobile: map["Mobile"] == null ? null : map["Mobile"],
    );
  }

  String toJson() => json.encode(toMap());

  factory Visitor.fromJson(String source) => Visitor.fromMap(json.decode(source));
}
