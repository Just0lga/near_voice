import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/helpers/auth_service.dart';
import 'package:near_voice/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:near_voice/core/widgets/gradient_background.dart';
import 'package:near_voice/data/services/user_service.dart';
import 'package:near_voice/data/services/user_location_updater.dart'; // 🔹 EKLENDİ
import 'package:near_voice/presentation/pages/profile_page.dart';
import 'package:near_voice/presentation/pages/settings_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final authService = AuthService();
  int selectedIndex = 0;
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>?> usersData = [];

  bool isLoading = true;
  UserLocationUpdater? locationUpdater;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
    loadUsersData();
  }

  /// 🟢 Giriş yapan kullanıcının verilerini al ve konum güncellemesini başlat
  Future<void> loadUserData() async {
    final authUser = Supabase.instance.client.auth.currentUser;
    if (authUser == null) return;

    final details = await UserService().getCurrentUserDetails();
    if (details == null) return;

    setState(() {
      userData = {
        'email': authUser.email,
        ...?details,
        ...?authUser.userMetadata,
      };
      isLoading = false;
    });

    // 🔹 Kullanıcının kendi konum güncellemesini başlat
    final userId = details['id'] as int;
    locationUpdater?.stopAutoUpdate();
    locationUpdater = UserLocationUpdater(userId: userId);
    locationUpdater!.startAutoUpdate();
  }

  /// 🔵 Tüm kullanıcıların verilerini çek
  Future<void> loadUsersData() async {
    final authUser = Supabase.instance.client.auth.currentUser;
    if (authUser == null) return;

    final details = await UserService().getAllUsers();

    setState(() {
      usersData = details;
      print("usersData: $usersData");
      isLoading = false;
    });
  }

  @override
  void dispose() {
    locationUpdater?.stopAutoUpdate(); // 🔹 Otomatik güncellemeyi durdur
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // 🔹 TÜM KULLANICILARIN MARKER'LARINI OLUŞTUR
    List<Marker> markers = usersData
        .where(
          (user) =>
              user != null &&
              user["latitude"] != null &&
              user["longitude"] != null,
        )
        .map((user) {
          return Marker(
            point: LatLng(
              double.parse(user!["latitude"].toString()),
              double.parse(user["longitude"].toString()),
            ),
            child: Container(
              width: width * 0.02,
              height: width * 0.02,
              decoration: BoxDecoration(
                color: AppColor.purple900,
                borderRadius: BorderRadius.circular(0),
              ),
              alignment: Alignment.center,
              child: AppText(text: user["user_name"]),
            ),
          );
        })
        .toList();

    final currentEmail = authService.getCurrentUserEmail();
    final currentToken = authService.getAuth();
    print("Bearer $currentToken");

    return Scaffold(
      body: GradientBackground(
        linearGradient: AppColor.backgroundGradient,
        child: Center(
          child: isLoading
              ? LinearProgressIndicator(color: Colors.purple)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🔹 Header
                    Container(
                      width: width,
                      decoration: BoxDecoration(
                        color: AppColor.white5,
                        border: Border(
                          bottom: BorderSide(color: AppColor.white10),
                        ),
                      ),
                      alignment: Alignment.bottomCenter,
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: width * 0.03),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: width * 0.01),
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: AppColor.purple800,
                                        size: width * 0.07,
                                      ),
                                      AppText(
                                        text: "Near Voice",
                                        textFontSize: width * 0.05,
                                        textFontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: width * 0.01),
                                  Row(
                                    children: [
                                      SizedBox(width: width * 0.03),
                                      AppText(
                                        text:
                                            "${markers.length} kişi yakınlarda",
                                        textFontSize: width * 0.03,
                                        textFontWeight: FontWeight.w500,
                                        textColor: AppColor.white60,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                width: width * 0.1,
                                height: width * 0.1,
                                decoration: BoxDecoration(
                                  color: AppColor.white10,
                                  borderRadius: BorderRadius.circular(width),
                                  border: Border.all(color: AppColor.white10),
                                ),
                                child: Icon(
                                  Icons.near_me_outlined,
                                  color: AppColor.white60,
                                ),
                              ),
                              SizedBox(width: width * 0.03),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 🟣 Body
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: height * 0.02,
                          horizontal: width * 0.03,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ActiveInfoContainer(
                                    title: "Şu an aktif",
                                    subtitle: "${usersData.length}",
                                  ),
                                  ActiveInfoContainer(
                                    title: "Yakınlarda",
                                    subtitle: "${markers.length}",
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.02),
                              SizedBox(
                                height: height * 0.6,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      width * 0.03,
                                    ),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: FlutterMap(
                                    options: MapOptions(
                                      initialCenter: markers.isNotEmpty
                                          ? markers.first.point
                                          : const LatLng(37.0000, 35.3213),
                                      initialZoom: 10,
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 🔹 Bottom Nav
                    Container(
                      width: width,
                      height: height * 0.12,
                      decoration: BoxDecoration(
                        color: AppColor.white5,
                        border: Border(
                          top: BorderSide(color: AppColor.white10),
                        ),
                      ),
                      alignment: Alignment.bottomCenter,
                      child: SafeArea(
                        top: false,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              NavigationBarItem(
                                onTap: () => onItemTapped(0),
                                iconData: Icons.map,
                                text: "Harita",
                                isSelected: selectedIndex == 0,
                              ),
                              NavigationBarItem(
                                onTap: () => onItemTapped(1),
                                iconData: Icons.chat_bubble_outline,
                                text: "Sohbet",
                                isSelected: selectedIndex == 1,
                              ),
                              NavigationBarItem(
                                onTap: () {
                                  onItemTapped(2);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfilePage(),
                                    ),
                                  );
                                },
                                iconData: Icons.person_outline,
                                text: "Profil",
                                isSelected: selectedIndex == 2,
                              ),
                              NavigationBarItem(
                                onTap: () {
                                  onItemTapped(3);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SettingsPage(),
                                    ),
                                  );
                                },
                                iconData: Icons.settings_outlined,
                                text: "Ayarlar",
                                isSelected: selectedIndex == 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class NavigationBarItem extends StatelessWidget {
  const NavigationBarItem({
    super.key,
    required this.onTap,
    required this.iconData,
    required this.text,
    required this.isSelected,
  });

  final GestureTapCallback onTap;
  final IconData iconData;
  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width * 0.16,
        height: width * 0.16,
        decoration: BoxDecoration(
          gradient: isSelected ? AppColor.logoGradient : null,
          borderRadius: BorderRadius.circular(width * 0.05),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: isSelected ? Colors.white : AppColor.white60,
              size: width * 0.06,
            ),
            SizedBox(height: width * 0.01),
            AppText(
              text: text,
              textColor: isSelected ? Colors.white : AppColor.white60,
              textFontSize: width * 0.03,
              textFontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}

class ActiveInfoContainer extends StatelessWidget {
  const ActiveInfoContainer({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.45,
      height: height * 0.09,
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      decoration: BoxDecoration(
        color: AppColor.white5,
        border: Border.all(color: AppColor.white10),
        borderRadius: BorderRadius.circular(width * 0.03),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: title,
            textFontSize: width * 0.03,
            textFontWeight: FontWeight.w500,
            textColor: AppColor.white60,
          ),
          SizedBox(height: width * 0.02),
          AppText(
            text: subtitle,
            textFontSize: width * 0.05,
            textFontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
