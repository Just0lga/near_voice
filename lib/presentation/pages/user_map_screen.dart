import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class UserMapScreen extends StatelessWidget {
  const UserMapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Kullanıcılar - Database'den geliyormuş gibi
    List<Map<String, dynamic>> users = [
      {
        'id': '1',
        'name': 'Ahmet Yılmaz',
        'latitude': 41.0082,
        'longitude': 28.9784, // İstanbul
      },
      {
        'id': '2',
        'name': 'Ayşe Demir',
        'latitude': 39.9334,
        'longitude': 32.8597, // Ankara
      },
      {
        'id': '3',
        'name': 'Mehmet Kaya',
        'latitude': 38.4192,
        'longitude': 27.1287, // İzmir
      },
      {
        'id': '4',
        'name': 'Fatma Öz',
        'latitude': 37.0662,
        'longitude': 37.3833, // Gaziantep
      },
      {
        'id': '5',
        'name': 'Ali Çelik',
        'latitude': 36.8969,
        'longitude': 30.7133, // Antalya
      },
    ];

    List<Marker> markers = users.map((user) {
      return Marker(
        point: LatLng(
          double.parse(user['latitude'].toString()),
          double.parse(user['longitude'].toString()),
        ),
        width: 80,
        height: 80,
        child: Column(
          children: [
            const Icon(Icons.location_on, color: Colors.red, size: 40),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                user['name'] ?? 'Kullanıcı',
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Kullanıcı Konumları')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(39.9334, 32.8597),
          initialZoom: 6,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c', 'd'],
          ),
          MarkerLayer(markers: markers),
        ],
      ),
    );
  }
}
