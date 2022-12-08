import 'dart:convert';

// aqui tenemos nuestro modelo dell objeto SimpleString
class SimpleString {
  SimpleString({
    required this.simpleString,
    String? idFirebase,
  });

  String simpleString;
  String? idFirebase;
  // tenemos  nustros metodos para convertirlode JSON a Map y viseversa
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
