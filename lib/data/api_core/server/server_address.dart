class ServerAddress {
  final String ip;
  final int port;

  const ServerAddress({
    required this.ip,
    required this.port,
  });

  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
      'port': port,
    };
  }

  factory ServerAddress.fromJson(Map<String, dynamic> json) {
    return ServerAddress(
      ip: json['ip'] as String,
      port: json['port'] as int,
    );
  }
}
