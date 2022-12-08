import 'dart:convert';

class SimpleString {
  SimpleString({
    required this.simpleString,
    String? idFirebase,
  });

  String simpleString;
  String? idFirebase;

  factory SimpleString.fromJson(String str) =>
      SimpleString.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SimpleString.fromMap(Map<String, dynamic> json) => SimpleString(
        simpleString: json["simpleString"],
      );

  Map<String, dynamic> toMap() => {
        "simpleString": simpleString,
      };
}
