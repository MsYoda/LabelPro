class AppSettings {
  final String serverAddress;
  final int servicePort;
  final String username;
  final String password;
  final int datasetId;

  const AppSettings({
    required this.serverAddress,
    required this.servicePort,
    required this.username,
    required this.password,
    required this.datasetId,
  });

  const AppSettings.empty({
    this.serverAddress = 'localhost',
    this.servicePort = 80,
    this.username = '',
    this.password = '',
    this.datasetId = 0,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      serverAddress: json['serverAddress'] as String,
      servicePort: json['servicePort'] as int,
      username: json['username'] as String,
      password: json['password'] as String,
      datasetId: json['datasetId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serverAddress': serverAddress,
      'servicePort': servicePort,
      'username': username,
      'password': password,
      'datasetId': datasetId,
    };
  }

  AppSettings copyWith({
    String? serverAddress,
    int? servicePort,
    String? username,
    String? password,
    int? datasetId,
  }) {
    return AppSettings(
      serverAddress: serverAddress ?? this.serverAddress,
      servicePort: servicePort ?? this.servicePort,
      username: username ?? this.username,
      password: password ?? this.password,
      datasetId: datasetId ?? this.datasetId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppSettings &&
        other.serverAddress == serverAddress &&
        other.servicePort == servicePort &&
        other.username == username &&
        other.password == password &&
        other.datasetId == datasetId;
  }

  @override
  int get hashCode {
    return serverAddress.hashCode ^
        servicePort.hashCode ^
        username.hashCode ^
        password.hashCode ^
        datasetId.hashCode;
  }

  @override
  String toString() {
    return 'AppSettings(serverAddress: $serverAddress, servicePort: $servicePort, username: $username, password: $password, datasetId: $datasetId)';
  }
}
