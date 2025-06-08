import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkService extends GetxService {
  final _connectivity = Connectivity();
  final isConnected = true.obs;

  Future<NetworkService> init() async {
    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    
    // Get initial connection status
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
    
    return this;
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    isConnected.value = result != ConnectivityResult.none;
  }

  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
} 