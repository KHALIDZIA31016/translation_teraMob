import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  // Singleton instance for accessing globally
  static final ConnectivityService _instance = ConnectivityService._internal();

  factory ConnectivityService() => _instance;

  ConnectivityService._internal();

  // Check internet connectivity
  Future<bool> isInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
