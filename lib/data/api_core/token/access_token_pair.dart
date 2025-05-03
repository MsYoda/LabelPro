import 'package:json_annotation/json_annotation.dart';

// part 'access_token_pair.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccessTokenPair {
  final String access;
  final String refresh;

  const AccessTokenPair({
    required this.access,
    required this.refresh,
  });

  factory AccessTokenPair.fromJson(Map<String, dynamic> json) {
    return AccessTokenPair(
      access: json['access'] as String,
      refresh: json['refresh'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'access': access,
        'refresh': refresh,
      };
}
