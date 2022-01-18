import 'package:cloud_firestore/cloud_firestore.dart';

final TOKEN = 'Token';
final CREATE_AT = 'NgayTao';
final PLATFORM = 'NenTang';

class Token {
  final Timestamp createAt;
  final String platform;
  final String token;

  Token({
    required this.createAt,
    required this.platform,
    required this.token
  });

  Map<String, dynamic> toMap() => {
    TOKEN: token,
    CREATE_AT: createAt,
    PLATFORM: platform,
  };

  Token.fromMap(Map<String, dynamic> map):
        assert(map[TOKEN] != null),
        token = map[TOKEN],
        createAt = map[CREATE_AT],
        platform = map[PLATFORM];
}