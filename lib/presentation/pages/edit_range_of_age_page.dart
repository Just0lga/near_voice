import 'package:flutter/material.dart';
import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/widgets/app_text.dart';
import 'package:near_voice/core/widgets/gradient_background.dart';
import 'package:near_voice/core/widgets/sign_button.dart';
import 'package:near_voice/core/helpers/auth_gate.dart';
import 'package:near_voice/data/services/user_service.dart';

class EditRangeOfAgePage extends StatefulWidget {
  const EditRangeOfAgePage({super.key});

  @override
  State<EditRangeOfAgePage> createState() => _EditRangeOfAgePageState();
}

class _EditRangeOfAgePageState extends State<EditRangeOfAgePage> {
  final userService = UserService();
  int? _userId;
  bool _isLoading = false;

  int _minAge = 18;
  int _maxAge = 30;

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
        _minAge = userData['min_age'] ?? 18;
        _maxAge = userData['max_age'] ?? 30;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kullanıcı bilgileri alınamadı: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateAgeRange() async {
    if (_isLoading) return;
    if (_userId == null) return;

    setState(() => _isLoading = true);

    try {
      await userService.updateMinAge(id: _userId!, minAge: _minAge);
      await userService.updateMaxAge(id: _userId!, maxAge: _maxAge);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Yaş aralığı başarıyla güncellendi.")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthGate()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Güncelleme hatası: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _pickMinAge() {
    int tempMin = _minAge;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Minimum Yaşı Seçin"),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("$tempMin"),
                  Slider(
                    value: tempMin.toDouble(),
                    min: 18,
                    max: _maxAge.toDouble(),
                    divisions: _maxAge - 18,
                    onChanged: (value) {
                      setStateDialog(() {
                        tempMin = value.toInt();
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("İptal"),
            ),
            TextButton(
              onPressed: () {
                setState(() => _minAge = tempMin);
                Navigator.pop(context);
              },
              child: const Text("Seç"),
            ),
          ],
        );
      },
    );
  }

  void _pickMaxAge() {
    int tempMax = _maxAge;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Maksimum Yaşı Seçin"),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("$tempMax"),
                  Slider(
                    value: tempMax.toDouble(),
                    min: _minAge.toDouble(),
                    max: 100,
                    divisions: 100 - _minAge,
                    onChanged: (value) {
                      setStateDialog(() {
                        tempMax = value.toInt();
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("İptal"),
            ),
            TextButton(
              onPressed: () {
                setState(() => _maxAge = tempMax);
                Navigator.pop(context);
              },
              child: const Text("Seç"),
            ),
          ],
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
                              text: "Yaş Aralığını Düzenle",
                              textFontSize: width * 0.05,
                              textHeight: 1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.05,
                    horizontal: width * 0.08,
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickMinAge,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: AppColor.white10),
                            color: AppColor.white5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(text: "Minimum Yaş: $_minAge"),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white70,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _pickMaxAge,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: AppColor.white10),
                            color: AppColor.white5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(text: "Maksimum Yaş: $_maxAge"),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white70,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      SignButton(
                        onTap: _isLoading ? () {} : _updateAgeRange,
                        text: _isLoading ? "Kaydediliyor..." : "Kaydet",
                      ),
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
