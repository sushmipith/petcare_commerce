import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/assets_source.dart';
import '../../core/service/service_locator.dart';
import '../../core/constants/constants.dart';
import '../../providers/auth_provider.dart';
import 'forgot_password_screen.dart';
import '../bottom_overview_screen.dart';
import '../../widgets/custom_snack_bar.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/login_screen";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late ThemeData themeConst;
  late double mHeight, mWidth;
  final _formKey = GlobalKey<FormState>();
  bool _hidePassword = true;
  bool _isLoading = false;

  //vars
  late String email, password;

  void _saveForm() async {
    bool? isValid = _formKey.currentState?.validate();
    if (isValid!) {
      _formKey.currentState?.save();
      try {
        setState(() {
          _isLoading = true;
        });
        await locator<AuthProvider>().signIn(email.trim(), password);
        Navigator.pushReplacementNamed(context, BottomOverviewScreen.routeName);
      } catch (error) {
        showCustomSnackBar(
          isError: true,
          message: '$error',
          context: context,
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaConst = MediaQuery.of(context);
    mHeight = mediaConst.size.height;
    mWidth = mediaConst.size.width;
    themeConst = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                image: AssetImage(
                  AssetsSource.bgPic,
                ),
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            children: [
              Container(
                height: mHeight * 0.25,
              ),
              Text(
                "Welcome",
                style: themeConst.textTheme.headline4?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                "Sign in to continue",
                style: themeConst.textTheme.subtitle1!
                    .copyWith(color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 25, bottom: 40),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: "Email", focusColor: greyColor),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email is required";
                            }
                            if (!emailRegex.hasMatch(value.trim())) {
                              return "Email is not valid";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            email = value!;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: "Password"),
                              obscureText: _hidePassword,
                              obscuringCharacter: "*",
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Password is required";
                                }
                                if (value.length < 6) {
                                  return "Password must be at least 6 characters long";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                password = value!;
                              },
                              onFieldSubmitted: (value) {
                                _saveForm();
                              },
                            ),
                            IconButton(
                                icon: _hidePassword
                                    ? const Icon(
                                        FontAwesomeIcons.eyeSlash,
                                        size: 15,
                                      )
                                    : const Icon(
                                        FontAwesomeIcons.eye,
                                        size: 15,
                                      ),
                                onPressed: () {
                                  setState(() {
                                    _hidePassword = !_hidePassword;
                                  });
                                }),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, ForgotPasswordScreen.routeName);
                              },
                              child: Text(
                                "Forgot Password?",
                                style: themeConst.textTheme.subtitle1!.copyWith(
                                    color: blackColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: themeConst.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _isLoading ? null : _saveForm,
                            child: _isLoading
                                ? const Center(
                                    child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator()))
                                : Text(
                                    "Sign In",
                                    style: themeConst.textTheme.headline6!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: themeConst.textTheme.subtitle1!.copyWith(
                                  color: greyColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RegisterScreen.routeName);
                                },
                                child: Text(
                                  "Sign up",
                                  style: themeConst.textTheme.subtitle1!
                                      .copyWith(
                                          color: accentColor,
                                          fontWeight: FontWeight.w600),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
