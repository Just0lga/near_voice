import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:near_voice/data/services/user_service.dart';

class UserLocationUpdater {
  final int userId;
  Timer? _timer;
  final _userService = UserService();

  UserLocationUpdater({required this.userId});

  /// 📍 Her dakika konumu otomatik güncelle
  void startAutoUpdate() async {
    await _updateOnce(); // Uygulama açıldığında ilk konumu güncelle

    _timer = Timer.periodic(const Duration(minutes: 1000), (_) async {
      await _updateOnce();
    });
  }

  /// 🛑 Durdur
  void stopAutoUpdate() {
    _timer?.cancel();
  }

  /// 📡 Tek seferlik konum al ve Supabase'e gönder
  Future<void> _updateOnce() async {
    try {
      // İzinleri kontrol et
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      // Konumu al
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await _userService.updateLocation(
        id: userId,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      print("✅ Location updated for user $userId");
    } catch (e) {
      print("⚠️ Location update failed: $e");
    }
  }
}
