import 'package:flutter/material.dart';
import 'package:graduation_project/services/notification_service.dart';
import 'package:graduation_project/utils/constants/constants.dart';
import 'package:lottie/lottie.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../widgets/my_text_field.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("تسجيل دخول", style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Column(
            children: [
              Container(
                height: size.height / 4,
                width: size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Lottie.asset('assets/anim/form.json'),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height * 0.05),
                        MyTextField(
                          hint: "اسم المستخدم",
                          controller: _nameController,
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          hint: "رقم الموبايل",
                          controller: _phoneController,
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          hint: "كلمة المرور",
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 35),
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith(
                              (states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            fixedSize: MaterialStateProperty.resolveWith(
                              (states) => Size(size.width, 48),
                            ),
                          ),
                          onPressed: () async {
                            var token = await NotificationService.getTokenID();
                            var phone = _phoneController.text;
                            if (phone.startsWith('0')) {
                              phone = '+97$phone';
                            }
                            if (_formKey.currentState?.validate() ?? false) {
                              Constants.showLoaderDialog(context);
                              await AuthService.loginUser(
                                MyUser(
                                    phone: phone,
                                    name: _nameController.text,
                                    password: _passwordController.text,
                                    image: Constants.personPlaceHolder,
                                    token: token,
                                ),
                                context,
                                true,
                              );
                            }
                          },
                          child: const Text("إنشاء حساب"),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("لدبك حساب بالفعل؟", style: Theme.of(context).textTheme.labelSmall),
                            TextButton(
                              onPressed: () async {
                                Navigator.pushReplacementNamed(context, "login");
                              },
                              child: const Text(
                                "تسجيل الدخول",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF00C944),
                                ),
                              ),
                            )
                          ],
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
