import 'package:flutter/material.dart';
import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/helpers/auth_gate.dart';
import 'package:near_voice/core/widgets/app_text.dart';
import 'package:near_voice/core/widgets/gradient_background.dart';
import 'package:near_voice/core/widgets/my_text_field.dart';
import 'package:near_voice/core/widgets/sign_button.dart';
import 'package:near_voice/data/services/user_service.dart';

class ProfileAboutEditPage extends StatefulWidget {
  const ProfileAboutEditPage({super.key});

  @override
  State<ProfileAboutEditPage> createState() => _ProfileAboutEditPageState();
}

class _ProfileAboutEditPageState extends State<ProfileAboutEditPage> {
  final userService = UserService();

  final _aboutController = TextEditingController();
  int? _userId;
  bool _isLoading = false;

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
        _aboutController.text = userData['about'] ?? '';
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

  Future<void> _updateAbout() async {
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
      await userService.updateAbout(id: _userId!, about: _aboutController.text);

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
                              text: "Hakkımda",
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.2),

                        MyTextField(
                          label: "Kullanıcı Adı",
                          controller: _aboutController,
                        ),

                        SizedBox(height: height * 0.04),

                        SignButton(
                          onTap: _isLoading ? () {} : _updateAbout,
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
