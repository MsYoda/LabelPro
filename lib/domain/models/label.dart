class Label {
  final int id;
  final String name;

  const Label({
    required this.id,
    required this.name,
  });

  factory Label.fromJson(Map<String, dynamic> json) {
    return Label(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
