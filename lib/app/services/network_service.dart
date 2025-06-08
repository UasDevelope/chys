import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkService extends GetxService {
  final _connectivity = Connectivity();
  final _isConnected = true.obs;

  bool get isConnected => _isConnected.value;

  Future<NetworkService> init() async {
    // Check initial connection status
    _isConnected.value = await _checkConnection();

    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((result) async {
      _isConnected.value = result != ConnectivityResult.none;
    });

    return this;
  }

  Future<bool> checkConnection() async {
    return _isConnected.value;
  }

  Future<bool> _checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
} 