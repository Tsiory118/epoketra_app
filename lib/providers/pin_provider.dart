import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final pinProvider = StateNotifierProvider<PinNotifier, String?>((ref) => PinNotifier());

class PinNotifier extends StateNotifier<String?> {
  final storage = FlutterSecureStorage();
  PinNotifier() : super(null) {
    loadPin();
  }

  Future<void> loadPin() async {
    String? pin = await storage.read(key: 'pin');
    state = pin;
  }

  Future<bool> validatePin(String input) async {
    return input == state;
  }
}
