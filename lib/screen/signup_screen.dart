import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chat_api_app/components/app_theme.dart';
import 'package:chat_api_app/components/custom_text_field.dart';
import 'package:chat_api_app/navigation_home_screen.dart';
import 'package:chat_api_app/src/user.dart';
import 'package:chat_api_app/src/user_server.dart';

class SignupScreen extends StatefulWidget {
  static const namedRoute = "signup-screen";
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String _username = "";
  String _email = "";
  String _password = "";
  String _error = "";

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  static const storage = FlutterSecureStorage();

  void _signup() async {
    try {
      User? createduser =
          await ApiService().signUp(_email, _username, _password);
      if (createduser != null) {
        var val = User.serialize(createduser);
        await storage.write(
          key: 'userInfo',
          value: val,
        );
        Navigator.pushNamedAndRemoveUntil(
            context, NavigationHomeScreen.routeName, (route) => false);
      }
    } on Exception catch (e) {
      setState(() {
        _error = e.toString().substring(11);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Material(
      child: Stack(
        children: [
          Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Container(
                  // color: Colors.amber,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: <Widget>[
                          Text(
                            '회원가입',
                            style: GoogleFonts.notoSansNKo(
                              color: AppTheme.kDarkGreenColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 28.0,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            '새로운 계정을 생성합니다.',
                            style: GoogleFonts.notoSansNKo(
                              color: AppTheme.kGreyColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 40.0),
                          // 에러 메시지
                          if (_error.isNotEmpty)
                            Column(
                              children: [
                                Text(
                                  _error,
                                  style: const TextStyle(color: Colors.red),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          CustomTextField(
                            hintText: '이름',
                            // icon: Icons.space_bar,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {},
                            onSaved: (String? val) {
                              _username = val!;
                            },
                            validator: usernameValidator,
                          ),
                          CustomTextField(
                            hintText: '이메일',
                            // icon: Icons.space_bar,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {},
                            onSaved: (String? val) {
                              _email = val!;
                            },
                            validator: emailValidator,
                          ),
                          CustomTextField(
                            hintText: '비밀번호',
                            obscureText: true,
                            icon: Icons.lock_outline_rounded,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              _password = value;
                            },
                            onSaved: (String? val) {
                              _password = val!;
                            },
                            validator: passwordValidator,
                          ),
                          CustomTextField(
                            hintText: '비밀번호 재확인',
                            obscureText: true,
                            icon: Icons.lock_person_outlined,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {},
                            onSaved: (String? val) {},
                            validator: passwordConfirmValidator,
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          Container(
                            height: 50,
                            width: 250,
                            decoration: BoxDecoration(
                                color: AppTheme.kDarkGreenColor,
                                borderRadius: BorderRadius.circular(30)),
                            child: TextButton(
                              onPressed: onSavePressed,
                              child: const Text(
                                '회원가입',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '이미 계정이 있으신가요?',
                                style: GoogleFonts.notoSansNKo(
                                    color: AppTheme.kGreyColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0),

                                // style: AppTheme.signForm,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  // Navigator.push(
                                  //     context,
                                  //     PageRouteBuilder(
                                  //       pageBuilder: (_, __, ___) =>
                                  //           const Login(),
                                  //       transitionDuration:
                                  //           const Duration(seconds: 0),
                                  //       // MaterialPageRoute(
                                  //       //   builder: (_) => const Login(),
                                  //       //   fullscreenDialog: true,
                                  //     ));
                                },
                                child: Text(
                                  '로그인',
                                  style: AppTheme.signForm,
                                ),
                              )
                            ],
                          ),

                          // TextButton(
                          //   onPressed: () {
                          //     Navigator.pop(context);
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (_) => Login(),
                          //           fullscreenDialog: true,
                          //         ));
                          //   },
                          //   child: const Text(
                          //     '이미 계정을 가지고 계신가요? 로그인',
                          //     style: TextStyle(fontSize: 16),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8, left: 8),
            child: CircleAvatar(
              // backgroundColor: Colors.grey.shade300,
              backgroundColor: AppTheme.white.withOpacity(0.9),
              radius: 24.0,
              child: IconButton(
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: const Icon(
                  // Icons.arrow_back_ios_new,
                  Icons.close,
                  color: AppTheme.kDarkGreenColor,
                  size: 28.0,
                ),
              ),
            ),
          ),

          // Positioned(
          //   top: 40.0,
          //   left: 20.0,
          //   child: CircleAvatar(
          //     backgroundColor: Colors.grey.shade300,
          //     radius: 20.0,
          //     child: IconButton(
          //       onPressed: () {
          //         Navigator.pop(context);
          //       },
          //       icon: const Icon(
          //         // Icons.arrow_back_ios_new,
          //         Icons.close,
          //         color: AppTheme.kDarkGreenColor,
          //         size: 24.0,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  void onSavePressed() {
    final formKeyState = _formkey.currentState!;
    if (formKeyState.validate()) {
      formKeyState.save();
      _signup();
    }
  }

  String? emailValidator(String? val) {
    if (val!.isEmpty) {
      return '이메일을 입력하세요.';
    }
    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(val)) {
      return '이메일을 정확히 입력하세요.';
    }
    return null;
  }

  String? usernameValidator(String? val) {
    if (val!.isEmpty) {
      return '이름을 입력하세요.';
    }
    return null;
  }

  String? passwordValidator(String? val) {
    if (val!.isEmpty) {
      return '비밀번호를 입력하세요.';
    }
    return null;
  }

  String? passwordConfirmValidator(String? val) {
    if (val!.isEmpty) {
      return '비밀번호를 한번 더 입력하세요.';
    }
    if (val != _password) {
      return "비밀번호가 일치하지 않습니다.";
    }
    return null;
  }
}
