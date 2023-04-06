import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chat_api_app/components/app_theme.dart';
import 'package:chat_api_app/components/curve.dart';
import 'package:chat_api_app/components/custom_text_field.dart';
import 'package:chat_api_app/navigation_home_screen.dart';
import 'package:chat_api_app/screen/signup_screen.dart';
import 'package:chat_api_app/src/user.dart';
import 'package:chat_api_app/src/user_server.dart';

class Login extends StatefulWidget {
  static const namedRoute = "login-screen";
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email = "";
  String _password = "";
  String _error = "";

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  static const storage = FlutterSecureStorage();
  dynamic userInfo = ''; // storage에 있는 유저 정보를 저장

  void _signIn() async {
    try {
      User? signInuser = await ApiService().signIn(_email, _password);
      if (signInuser != null) {
        var val = User.serialize(signInuser);
        await storage.write(
          key: 'userInfo',
          value: val,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${signInuser.username}님 반갑습니다.'),
            duration: Duration(seconds: 2),
          ),
        );

        // Navigator.pushNamedAndRemoveUntil(
        //     context, NavigationHomeScreen.routeName, (route) => false);

        // 모든페이지 제거 후 특정페이지로 이동
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationHomeScreen(),
            ),
            (route) => false);
      }
    } on Exception catch (e) {
      setState(() {
        _error = e.toString().substring(11);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        // alignment: Alignment.bottomRight,
        // fit: StackFit.expand,
        children: [
          Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ClipPath(
                      clipper: ImageClipper(),
                      child: Image.asset(
                        'assets/images/plant_tools.png',
                        alignment: Alignment.topCenter,
                        fit: BoxFit.fitHeight,
                        // fit: BoxFit.fitWidth,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          "환영합니다",
                          style: AppTheme.headline,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '가입하신 이메일로 로그인 해주세요.',
                          style: AppTheme.caption,
                        ),
                        const SizedBox(
                          height: 40,
                        )
                      ],
                    ),
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
                      onChanged: (value) {},
                      onSaved: (String? val) {
                        _password = val!;
                      },
                      validator: passwordValidator,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(''),
                          TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(
                                  AppTheme.kDarkGreenColor),
                            ),
                            child: Text(
                              '비밀번호 찾기',
                              style: AppTheme.signForm,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: AppTheme.kDarkGreenColor,
                          borderRadius: BorderRadius.circular(30)),
                      child: TextButton(
                        onPressed: onSavePressed,
                        // onPressed: () {

                        //   final formKeyState = _formkey.currentState!;
                        //   if (formKeyState.validate()) {
                        //     formKeyState.save();
                        //     _signIn();
                        //   }
                        // },
                        child: Text(
                          '로그인',
                          style: AppTheme.inButton,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('아직 계정이 없으신가요?', style: AppTheme.caption),
                        TextButton(
                          onPressed: () {
                            // Navigator.pop(context);
                            Navigator.push(
                                context,
                                // PageRouteBuilder(
                                //   pageBuilder: (_, __, ___) =>
                                //       const SignupScreen(),
                                //   transitionDuration:
                                //       const Duration(seconds: 0),
                                MaterialPageRoute(
                                  builder: (_) => const SignupScreen(),
                                  // fullscreenDialog: true,
                                ));
                          },
                          child: Text(
                            '회원가입',
                            style: AppTheme.signForm,
                          ),
                        ),
                      ],
                    ),
                  ],
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
        ],
      ),
    );
  }

  void onSavePressed() {
    final formKeyState = _formkey.currentState!;
    if (formKeyState.validate()) {
      formKeyState.save();
      _signIn();
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

  String? passwordValidator(String? val) {
    if (val!.isEmpty) {
      return '비밀번호를 입력하세요.';
    }
    return null;
  }
}
