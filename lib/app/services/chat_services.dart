import 'dart:developer';

import 'package:chys/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends GetxService {
  late IO.Socket socket;

  Future<void> initSocket() async {
    final token = StorageService.getToken();
    socket = IO.io('http://44.208.25.60:4000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {
        'token': token,
      },
    });
    socket.connect();
    socket.onConnect((_) {
      print('Socket connected: ${socket.id}');
    });
    socket.onDisconnect((_) {
      print('Socket disconnected');
    });

    socket.onConnectError((data) {
      print('Connection Error: $data');
    });
    socket.onReconnect((_) {
      print('Socket reconnected');
    });

    socket.onError((data) {
      print('Error: $data');
    });
  }

  void sendPrivateMessage(String receiverId, String message) {
    if (socket.connected) {
      socket.emit('private_message', {
        'receiverId': receiverId,
        'message': message,
      });
    } else {
      print('Socket not connected. Cannot send message.');
    }
  }

  void listenToPrivateMessages(
      Function(Map<String, dynamic>) onMessageReceived) {
    socket.on('receive_message', (data) {
      log("Private message lisner is $data");
      onMessageReceived(data);
    });
  }

  void disposeSocket() {
    socket.dispose();
  }
}
