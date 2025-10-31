import 'package:flutter/material.dart';
import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/helpers/auth_gate.dart';
import 'package:near_voice/core/widgets/app_text.dart';
import 'package:near_voice/core/widgets/gradient_background.dart';
import 'package:near_voice/core/widgets/sign_button.dart';
import 'package:near_voice/data/services/user_service.dart';

class ProfileInterestsEditPage extends StatefulWidget {
  const ProfileInterestsEditPage({super.key});

  @override
  State<ProfileInterestsEditPage> createState() =>
      _ProfileInterestsEditPageState();
}

class _ProfileInterestsEditPageState extends State<ProfileInterestsEditPage> {
  final userService = UserService();

  int? _userId;
  bool _isLoading = false;

  // 🔹 5 kategori ve her bir kategori altındaki seçenekler
  final Map<String, List<String>> interestCategories = {
    "Spor": ["Futbol", "Basketbol", "Voleybol", "Yoga", "Koşu"],
    "Yemek & Mutfak": ["Yemek Yapma", "Tatlı", "Kahve", "Burger", "Gastronomi"],
    "Hobi & Sanat": ["Kitap", "Müzik", "Fotoğraf", "Resim", "Tiyatro"],
    "Aktivite & Eğlence": ["Sinema", "Gezi", "PC Oyunları", "Konser", "Dans"],
    "Teknoloji & Bilim": [
      "Yeni Teknoloji",
      "Bilim",
      "Astronomi",
      "Kodlama",
      "Gadget",
    ],
  };

  // 🔹 Seçilen alanlar
  final Map<String, List<String>> selectedByCategory = {
    "Spor": [],
    "Yemek & Mutfak": [],
    "Hobi & Sanat": [],
    "Aktivite & Eğlence": [],
    "Teknoloji & Bilim": [],
  };

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
        if (userData['interests'] != null && userData['interests'].isNotEmpty) {
          final allSelected = (userData['interests'] as String).split(',');
          // Burada stringi kategorilere dağıtıyoruz
          for (var category in interestCategories.keys) {
            selectedByCategory[category] = allSelected
                .where((i) => interestCategories[category]!.contains(i))
                .toList();
          }
        }
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

  void _toggleInterest(String category, String interest) {
    setState(() {
      final selected = selectedByCategory[category]!;

      if (selected.contains(interest)) {
        selected.remove(interest);
      } else {
        if (selected.length >= 2) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                "$category kategorisinde maksimum 2 seçim yapabilirsiniz.",
              ),
            ),
          );
          return;
        }
        selected.add(interest);
      }
    });
  }

  Future<void> _updateInterests() async {
    if (_isLoading) return;
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Kullanıcı bilgisi bulunamadı."),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Seçilenleri tek stringe çeviriyoruz
      final allSelected = selectedByCategory.values.expand((x) => x).toList();

      await userService.updateInterests(
        id: _userId!,
        interests: allSelected.join(','),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Profil başarıyla güncellendi."),
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      body: GradientBackground(
        linearGradient: AppColor.backgroundGradient,
        child: Center(
          child: Column(
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
                              text: "İlgili Alanlarım",
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
                        SizedBox(height: height * 0.02),
                        ...interestCategories.entries.map((entry) {
                          final category = entry.key;
                          final options = entry.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: category,
                                textFontSize: width * 0.04,
                                textFontWeight: FontWeight.bold,
                                textColor: AppColor.white80,
                              ),
                              SizedBox(height: 8),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: options.map((interest) {
                                  final isSelected =
                                      selectedByCategory[category]!.contains(
                                        interest,
                                      );
                                  return GestureDetector(
                                    onTap: () =>
                                        _toggleInterest(category, interest),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        gradient: isSelected
                                            ? AppColor.hoverGradient
                                            : null,
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColor.white10
                                              : AppColor.white20,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: AppText(
                                        text: interest,
                                        textColor: isSelected
                                            ? Colors.white
                                            : AppColor.white60,
                                        textFontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: height * 0.03),
                            ],
                          );
                        }).toList(),
                        SignButton(
                          onTap: _isLoading ? () {} : _updateInterests,
                          text: _isLoading ? "Kaydediliyor..." : "Kaydet",
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
