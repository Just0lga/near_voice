import 'package:flutter/gestures.dart'; // 🚩 YENİ: Tıklanabilir metin için
import 'package:flutter/material.dart';
import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/helpers/auth_gate.dart';
import 'package:near_voice/core/widgets/app_text.dart';
import 'package:near_voice/core/helpers/auth_service.dart';
import 'package:near_voice/core/widgets/gradient_background.dart';
import 'package:near_voice/core/widgets/my_text_field.dart';
import 'package:near_voice/core/widgets/sign_button.dart';
import 'package:intl/intl.dart';
import 'package:near_voice/data/model/services/user_service.dart';
import 'package:near_voice/presentation/pages/privacy_policy_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Servislerin örneklerini oluştur
  final authService = AuthService();
  final userService = UserService();

  // Controller'lar
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State değişkenleri
  DateTime? _birthDate;
  String? _selectedGender;
  final List<String> _genders = ['Kadın', 'Erkek', 'Diğer'];
  bool _isLoading = false;
  bool _privacyPolicyAccepted = false;

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

  void _navigateToPrivacyPolicy() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => PrivacyPolicyPage()));
  }

  // 🔄 GÜNCELLENDİ: Kayıt olma fonksiyonu
  void signUp() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Alanların dolu olup olmadığını kontrol et
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        _birthDate == null ||
        _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurun.")),
      );
      setState(() => _isLoading = false);
      return;
    }

    // 🚩 YENİ: Gizlilik politikası onayını kontrol et
    if (!_privacyPolicyAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Devam etmek için gizlilik politikasını onaylamalısınız.",
          ),
        ),
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
          _isLoading = false;
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
        linearGradient: AppColor.backgroundGradient,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  height: height * 0.04,
                  child: Row(
                    children: [
                      SizedBox(width: width * 0.02),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
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
                ),
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

                MyTextField(
                  label: "Kullanıcı Adı",
                  controller: _usernameController,
                ),
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
                SizedBox(height: height * 0.018),

                GenderDropdownField(
                  selectedGender: _selectedGender,
                  genders: _genders,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                ),

                SizedBox(height: height * 0.01),

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

                SizedBox(height: height * 0.02),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(unselectedWidgetColor: AppColor.white60),
                      child: Checkbox(
                        value: _privacyPolicyAccepted,
                        onChanged: (bool? value) {
                          setState(() {
                            _privacyPolicyAccepted = value ?? false;
                          });
                        },
                        activeColor: AppColor.purple500,
                        checkColor: Colors.white,
                        side: BorderSide(color: AppColor.white60, width: 1.5),
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: "AnekLatin",
                            color: AppColor.white60,
                            fontSize: width * 0.035,
                          ),
                          children: [
                            TextSpan(
                              text: "Gizlilik Politikasını ",
                              style: TextStyle(
                                color: AppColor.purple500,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColor.purple500,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _navigateToPrivacyPolicy,
                            ),
                            const TextSpan(text: "okudum, onaylıyorum."),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height * 0.02), // 🔄 Boşluğu azalttım

                SignButton(
                  onTap: _isLoading
                      ? () {}
                      : signUp, // Yükleniyorsa butonu pasif yap
                  text: _isLoading ? "Yükleniyor" : "Kayıt Ol",
                ),

                Expanded(child: SizedBox()),

                const SignInNavigateButton(),
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
            /*/ 🔄 Yorumu kaldırdım, AuthGate'e gitmesi mantıklı
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AuthGate()),
            );
          */
          },

          child: Row(
            children: [
              AppText(
                text: "Zaten bir hesabınız var mı?",
                textFontWeight: FontWeight.w500,
                textFontSize: width * 0.034,
                textColor: AppColor.white40,
              ),
              AppText(
                text: " Giriş Yapın",
                textFontWeight: FontWeight.w600,
                textFontSize: width * 0.034,
                textColor: AppColor.purple500,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
