import 'package:flutter/material.dart';
import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/helpers/auth_gate.dart';
import 'package:near_voice/core/widgets/app_text.dart';
import 'package:near_voice/core/widgets/gradient_background.dart';
import 'package:near_voice/core/widgets/my_text_field.dart';
import 'package:near_voice/core/widgets/sign_button.dart';
import 'package:near_voice/data/services/user_service.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
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
        SnackBar(content: Text("Kullanıcı bilgileri alınamadı: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfile() async {
    if (_isLoading) return;
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kullanıcı bilgisi bulunamadı.")),
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
        const SnackBar(content: Text("Profil başarıyla güncellendi.")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthGate()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Güncelleme hatası: $e")));
      print(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: GradientBackground(
        linearGradient: AppColor.backgroundGradient,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.03),
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: height * 0.02),

                      // 🔙 Geri butonu
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              color: Colors.transparent,
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: AppColor.white60,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.05),

                      // 📍 Logo
                      Container(
                        width: width * 0.25,
                        height: width * 0.25,
                        decoration: BoxDecoration(
                          gradient: AppColor.logoGradient,
                          borderRadius: BorderRadius.circular(width * 0.05),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: width * 0.15,
                        ),
                      ),

                      SizedBox(height: height * 0.03),

                      AppText(
                        text: "Profil Bilgileri",
                        textFontWeight: FontWeight.w600,
                        textFontSize: width * 0.09,
                      ),

                      SizedBox(height: height * 0.03),

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
