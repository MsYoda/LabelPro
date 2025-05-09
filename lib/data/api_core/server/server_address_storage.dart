import 'package:label_pro_client/data/api_core/server/server_address.dart';
import 'package:label_pro_client/data/providers/shared_preference_service.dart';

class ServerAddressStorage {
  final SharedPreferenceService _sharedPreferenceService;

  ServerAddressStorage({
    required SharedPreferenceService sharedPreferenceService,
  }) : _sharedPreferenceService = sharedPreferenceService;

  Future<ServerAddress> _createServerAddress() async {
    final address = ServerAddress(ip: 'localhost', port: 8080);
    await _sharedPreferenceService.writeData(
      'server_address',
      address.toJson(),
    );
    return address;
  }

  Future<void> writeAddress(ServerAddress address) async {
    await _sharedPreferenceService.writeData(
      'server_address',
      address.toJson(),
    );
  }

  Future<ServerAddress> readAddress() async {
    try {
      final addressData = await _sharedPreferenceService.readData('server_address');
      return ServerAddress.fromJson(addressData);
    } on Exception {
      return _createServerAddress();
    }
  }
}
