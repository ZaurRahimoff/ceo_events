import 'dart:convert';

class ResponseStatus {
    String message;
    int messageId;

  ResponseStatus({
      this.message,
      this.messageId,
  });

  //String get fullLogoUrl => 'https://oilgasconference.az/css/oilgasconference/logo-site.png?v=2020.11.07$';

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "messageId": messageId,
    };
  }

  factory ResponseStatus.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ResponseStatus(
        message: map["message"],
        messageId: map["messageId"],
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseStatus.fromJson(String source) => ResponseStatus.fromMap(json.decode(source));
}
