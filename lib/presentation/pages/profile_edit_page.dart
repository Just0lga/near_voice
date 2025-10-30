import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/helpers/auth_gate.dart';
import 'package:near_voice/core/widgets/app_text.dart';
import 'package:near_voice/core/widgets/gradient_background.dart';
import 'package:near_voice/core/widgets/my_text_field.dart';
import 'package:near_voice/core/widgets/sign_button.dart';
import 'package:near_voice/data/model/services/user_service.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final userService = UserService();

  final _usernameController = TextEditingController();
  final _birthDateController = TextEditingController();

  DateTime? _birthDate;
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
        if (userData['birth_date'] != null) {
          _birthDate = DateTime.tryParse(userData['birth_date']);
          if (_birthDate != null) {
            _birthDateController.text = DateFormat(
              'dd/MM/yyyy',
            ).format(_birthDate!);
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kullanıcı bilgileri alınamadı: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF362875),
              onPrimary: Colors.white,
              surface: Color(0xFF5A48AA),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF362875),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
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

      Navigator.push(
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
        child: Column(
          children: [
            // 🟣 HEADER (padding'den etkilenmez)
            Container(
              width: width,
              decoration: BoxDecoration(
                color: AppColor.white5,
                border: Border(bottom: BorderSide(color: AppColor.white10)),
              ),
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                bottom: false, // altta fazladan boşluk olmasın
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

            // 🟣 BODY (padding uygulanır)
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: height * 0.02,
                  horizontal: width * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.03),

                    Container(
                      width: width * 0.25,
                      height: width * 0.25,
                      decoration: BoxDecoration(
                        gradient: AppColor.logoGradient,
                        borderRadius: BorderRadius.circular(width * 0.05),
                      ),
                      child: Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: width * 0.15,
                      ),
                    ),

                    SizedBox(height: height * 0.03),

                    AppText(
                      text: "Near Voice",
                      textFontWeight: FontWeight.w600,
                      textFontSize: width * 0.1,
                    ),

                    SizedBox(height: height * 0.015),

                    AppText(
                      text: "Yaknındaki kayıp sesi bul",
                      textFontWeight: FontWeight.w300,
                      textFontSize: width * 0.036,
                      textColor: AppColor.white60,
                    ),

                    SizedBox(height: height * 0.03),

                    MyTextField(
                      label: "Kullanıcı Adı",
                      controller: _usernameController,
                    ),

                    GestureDetector(
                      onTap: _selectDate,
                      child: AbsorbPointer(
                        child: MyTextField(
                          label: "Doğum Tarihi (GG/AA/YYYY)",
                          controller: _birthDateController,
                        ),
                      ),
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

                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/helpers/auth_gate.dart';
import 'package:near_voice/core/widgets/app_text.dart';
import 'package:near_voice/core/widgets/gradient_background.dart';
import 'package:near_voice/core/widgets/my_text_field.dart';
import 'package:near_voice/core/widgets/sign_button.dart';
import 'package:near_voice/data/model/services/user_service.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final userService = UserService();

  final _usernameController = TextEditingController();
  final _birthDateController = TextEditingController();

  DateTime? _birthDate;
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
        if (userData['birth_date'] != null) {
          _birthDate = DateTime.tryParse(userData['birth_date']);
          if (_birthDate != null) {
            _birthDateController.text = DateFormat(
              'dd/MM/yyyy',
            ).format(_birthDate!);
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kullanıcı bilgileri alınamadı: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF362875),
              onPrimary: Colors.white,
              surface: Color(0xFF5A48AA),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF362875),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
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

      Navigator.push(
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
                    children: [
                      SizedBox(height: height * 0.02),

                      // 🔙 Geri butonu
                      Container(
                        height: height * 0.04,
                        child: Row(
                          children: [
                            SizedBox(width: width * 0.02),
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

                      GestureDetector(
                        onTap: _selectDate,
                        child: AbsorbPointer(
                          child: MyTextField(
                            label: "Doğum Tarihi (GG/AA/YYYY)",
                            controller: _birthDateController,
                          ),
                        ),
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

                      Expanded(child: SizedBox()),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
*/

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
