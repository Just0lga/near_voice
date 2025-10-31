import 'package:flutter/material.dart';
import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/helpers/auth_gate.dart';
import 'package:near_voice/core/widgets/app_text.dart';
import 'package:near_voice/core/widgets/gradient_background.dart';
import 'package:near_voice/core/widgets/my_text_field.dart';
import 'package:near_voice/core/widgets/sign_button.dart';
import 'package:near_voice/data/services/user_service.dart';

class ProfileMainEditPage extends StatefulWidget {
  const ProfileMainEditPage({super.key});

  @override
  State<ProfileMainEditPage> createState() => _ProfileMainEditPageState();
}

class _ProfileMainEditPageState extends State<ProfileMainEditPage> {
  final userService = UserService();

  final _usernameController = TextEditingController();
  String? _selectedGender;
  int? _userId;
  bool _isLoading = false;

  final List<String> _genders = ['Kadın', 'Erkek', 'Diğer'];

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
        _usernameController.text = userData['user_name'] ?? '';
        _selectedGender = userData['gender'];
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

  Future<void> _updateProfile() async {
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
      await userService.updateUser(
        id: _userId!,
        username: _usernameController.text,
        gender: _selectedGender,
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
                              text: "Kişisel Bilgilerim",
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
                          controller: _usernameController,
                        ),

                        SizedBox(height: height * 0.01),

                        GenderDropdownField(
                          selectedGender: _selectedGender,
                          genders: _genders,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedGender = newValue;
                            });
                          },
                        ),

                        SizedBox(height: height * 0.04),

                        SignButton(
                          onTap: _isLoading ? () {} : _updateProfile,
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

class GenderDropdownField extends StatelessWidget {
  final String? selectedGender;
  final List<String> genders;
  final ValueChanged<String?> onChanged;

  const GenderDropdownField({
    super.key,
    required this.selectedGender,
    required this.genders,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColor.white20, width: 1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedGender,
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down,
            color: AppColor.white60,
            size: width * 0.056,
          ),
          dropdownColor: AppColor.purple500,
          hint: Text(
            "Cinsiyet",
            style: TextStyle(
              fontFamily: "AnekLatin",
              color: AppColor.white60,
              fontSize: width * 0.037,
            ),
          ),
          style: TextStyle(
            fontFamily: "AnekLatin",
            color: AppColor.white60,
            fontSize: width * 0.037,
          ),
          onChanged: onChanged,
          items: genders.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontFamily: "AnekLatin",
                  color: AppColor.white60,
                  fontSize: width * 0.037,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
