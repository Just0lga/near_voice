import 'package:flutter/material.dart';
import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/widgets/app_text.dart';
import 'package:near_voice/core/widgets/gradient_background.dart';
import 'package:near_voice/core/widgets/sign_button.dart';
import 'package:near_voice/core/helpers/auth_gate.dart';
import 'package:near_voice/data/services/user_service.dart';

class EditMaxDistancePage extends StatefulWidget {
  const EditMaxDistancePage({super.key});

  @override
  State<EditMaxDistancePage> createState() => _EditMaxDistancePageState();
}

class _EditMaxDistancePageState extends State<EditMaxDistancePage> {
  final userService = UserService();

  int? _userId;
  bool _isLoading = false;
  int _selectedDistance = 10; // varsayılan değer

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final userData = await userService.getCurrentUserDetails();
      if (userData != null) {
        _userId = userData['id'];
        _selectedDistance = userData['max_distance'] ?? 10;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Kullanıcı bilgileri alınamadı: $e"),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateMaxDistance() async {
    if (_isLoading || _userId == null) return;

    setState(() => _isLoading = true);

    try {
      await userService.updateMaxDistance(
        id: _userId!,
        maxDistance: _selectedDistance,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Maksimum mesafe başarıyla güncellendi."),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthGate()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Güncelleme hatası: $e"),
        ),
      );
      print(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showDistancePicker() {
    showDialog(
      context: context,
      builder: (context) {
        int tempDistance = _selectedDistance;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const AppText(
                text: "Maksimum Mesafe Seçin (km)",
                textFontSize: 18,
                textColor: AppColor.purple950,
              ),
              content: SizedBox(
                height: 100,
                child: Column(
                  children: [
                    Slider(
                      value: tempDistance.toDouble(),
                      min: 1,
                      max: 100,
                      divisions: 99,
                      label: "$tempDistance km",
                      onChanged: (value) {
                        setStateDialog(() {
                          tempDistance = value.toInt();
                        });
                      },
                    ),
                    AppText(
                      text: "$tempDistance km",
                      textFontSize: 16,
                      textFontWeight: FontWeight.w500,
                      textColor: AppColor.purple950,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const AppText(
                    text: "İptal",
                    textColor: AppColor.purple950,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => _selectedDistance = tempDistance);
                    Navigator.pop(context);
                  },
                  child: const AppText(
                    text: "Seç",
                    textColor: AppColor.purple950,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: GradientBackground(
        linearGradient: AppColor.backgroundGradient,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 Header
              Container(
                width: width,
                decoration: BoxDecoration(
                  color: AppColor.white5,
                  border: Border(bottom: BorderSide(color: AppColor.white10)),
                ),
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: width * 0.03),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: width * 0.02),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                color: Colors.transparent,
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: AppColor.white60,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              text: "Maksimum Mesafe",
                              textFontSize: width * 0.055,
                              textHeight: 1,
                            ),
                          ],
                        ),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.2),
                      GestureDetector(
                        onTap: _showDistancePicker,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 30,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.white5,
                            border: Border.all(color: AppColor.white10),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(text: "Seçilen Mesafe", textFontSize: 18),
                              AppText(
                                text: "$_selectedDistance km",
                                textFontSize: 18,
                                textFontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      SignButton(
                        onTap: _isLoading ? () {} : _updateMaxDistance,
                        text: _isLoading
                            ? "Kaydediliyor..."
                            : "Güncelle ve Kaydet",
                      ),

                      Expanded(child: SizedBox()),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            text: "Near Voice",
                            textColor: AppColor.white60,
                            textFontSize: width * 0.03,
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.03),
                    ],
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
