import 'package:flutter/material.dart';
import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/helpers/auth_gate.dart';
import 'package:near_voice/core/widgets/app_text.dart';
import 'package:near_voice/core/helpers/auth_service.dart';
import 'package:near_voice/core/widgets/back_button_and_right_button.dart';
import 'package:near_voice/core/widgets/gradient_background.dart';
import 'package:near_voice/core/widgets/my_text_field.dart';
import 'package:near_voice/core/widgets/sign_button.dart';
import 'package:intl/intl.dart';
import 'package:near_voice/data/model/services/user_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Servislerin örneklerini oluştur
  final authService = AuthService();
  final userService = UserService(); // 🚩 YENİ

  // Controller'lar
  final _usernameController =
      TextEditingController(); // 🚩 YENİ: Kullanıcı adı için
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State değişkenleri
  DateTime? _birthDate;
  String? _selectedGender;
  final List<String> _genders = ['Male', 'Female', 'Other'];
  bool _isLoading = false; // 🚩 YENİ: Yüklenme durumunu takip etmek için

  // Doğum tarihi metnini formatlar
  String get _birthDateText {
    if (_birthDate == null) {
      return '';
    }
    return DateFormat('dd/MM/yyyy').format(_birthDate!);
  }

  // Takvimi açma fonksiyonu
  Future<void> _selectDate() async {
    // ... (Bu fonksiyon aynı kalabilir) ...
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  // 🔄 GÜNCELLENDİ: Kayıt olma fonksiyonu
  void signUp() async {
    if (_isLoading)
      return; // Zaten işlem yapılıyorsa tekrar tetiklenmesini engelle

    setState(() {
      _isLoading = true; // Yüklenme animasyonunu başlat
    });

    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Alanların dolu olup olmadığını kontrol et
    if (username.isEmpty || _birthDate == null || _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurun.")),
      );
      setState(() => _isLoading = false);
      return;
    }

    // Şifrelerin eşleşip eşleşmediğini kontrol et
    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Şifreler eşleşmiyor")));
      setState(() => _isLoading = false);
      return;
    }

    try {
      // Veritabanı için tarihi formatla (YYYY-MM-DD)
      final formattedBirthDate = DateFormat('yyyy-MM-dd').format(_birthDate!);

      // 1. ADIM: AuthService ile Supabase Auth'a kullanıcıyı kaydet
      final authResponse = await authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        username: username,
        gender: _selectedGender!,
        birthDate: formattedBirthDate,
      );

      // Auth kaydı başarılıysa ve kullanıcı nesnesi geldiyse devam et
      if (authResponse.user != null) {
        // 2. ADIM: UserService ile 'user' tablosuna profil bilgilerini ekle
        await userService.insertUser(
          username: username,
          birthDate: formattedBirthDate,
          gender: _selectedGender!,
          latitude: 0.0, // Varsayılan veya daha sonra alınacak konum
          longitude: 0.0,
          authUserId: authResponse.user!.id,
        );

        if (mounted) {
          Navigator.pop(context); // Kayıt başarılı, önceki sayfaya dön
        }
      } else {
        // Auth kaydı başarısız olduysa
        throw Exception(
          authResponse.session?.toString() ?? 'Kayıt başarısız oldu.',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Hata: ${e.toString()}")));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // İşlem bitince yüklenme durumunu kapat
        });
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            const BackButtonAndRightButton(),
            SizedBox(height: height * 0.04),
            Image.asset(
              "assets/near_voice_logo_purple2.png",
              height: height * 0.1,
            ),
            SizedBox(height: height * 0.06),

            // 🚩 YENİ: Kullanıcı adı alanı
            MyTextField(label: "Username", controller: _usernameController),
            SizedBox(height: height * 0.010),

            MyTextField(label: "Email", controller: _emailController),
            SizedBox(height: height * 0.010),

            GestureDetector(
              onTap: _selectDate,
              child: AbsorbPointer(
                child: MyTextField(
                  label: "Doğum Tarihi (GG/AA/YYYY)",
                  controller: TextEditingController(text: _birthDateText),
                  key: ValueKey(_birthDateText),
                ),
              ),
            ),
            SizedBox(height: height * 0.010),

            GenderDropdownField(
              selectedGender: _selectedGender,
              genders: _genders,
              onChanged: (newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
            ),
            SizedBox(height: height * 0.010),

            MyTextField(
              label: "Şifre",
              controller: _passwordController,
              obscureText: true,
            ),
            SizedBox(height: height * 0.010),

            MyTextField(
              label: "Şifreyi Onayla",
              controller: _confirmPasswordController,
              obscureText: true,
            ),
            SizedBox(height: height * 0.020),

            // 🔄 GÜNCELLENDİ: Buton artık yüklenme durumunu gösteriyor
            SignButton(
              onTap: _isLoading
                  ? () {}
                  : signUp, // Yükleniyorsa butonu pasif yap
              buttonColor: const Color(0xFF362875),
              buttonWidget: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : AppText(text: "Sign Up", textFontSize: width * 0.056),
            ),
            const SizedBox(height: 20), // Boşluk
            const SignInNavigateButton(),
            const SizedBox(height: 20), // Boşluk
          ],
        ),
      ),
    );
  }
}

// Cinsiyet seçimi için bağımsız StatelessWidget
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
      width: width,
      height: width * 0.126, // MyTextField ile aynı yüksekliği korumak için
      padding: EdgeInsets.symmetric(horizontal: width * 0.037),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(width * 0.04),
        border: Border.all(color: AppColor().mainColor),
      ),
      alignment: Alignment.centerLeft,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: AppText(
            text: "Gender",
            textColor: AppColor().mainColor,
            textFontSize: width * 0.037,
          ),
          value: selectedGender,
          dropdownColor: Colors.white,
          icon: Icon(Icons.arrow_drop_down, color: AppColor().mainColor),
          isExpanded: true,
          style: TextStyle(color: Colors.white, fontSize: width * 0.037),
          onChanged: onChanged,
          items: genders.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: AppText(
                text: value,
                textColor: AppColor().mainColor,
                textFontSize: width * 0.037,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class SignInNavigateButton extends StatelessWidget {
  const SignInNavigateButton({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AuthGate()),
            );
          },
          child: Row(
            children: [
              AppText(
                text: "Zaten bir hesabınız var mı?",
                textFontWeight: FontWeight.w500,
                textFontSize: width * 0.034,
                textColor: Colors.white,
              ),
              AppText(
                text: " Giriş Yapın",
                textFontWeight: FontWeight.w600,
                textFontSize: width * 0.034,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
