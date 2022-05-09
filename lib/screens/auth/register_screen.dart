import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petcare_commerce/core/constants/assets_source.dart';
import 'package:petcare_commerce/core/constants/constants.dart';
import 'package:petcare_commerce/core/service/service_locator.dart';
import 'package:petcare_commerce/providers/auth_provider.dart';
import 'package:petcare_commerce/screens/home/home_screen.dart';
import 'package:petcare_commerce/widgets/custom_snack_bar.dart';
import 'package:provider/provider.dart';

import '../bottom_overview_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "/register_screen";

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  ThemeData? themeConst;
  double? mHeight, mWidth;
  final _formKey = GlobalKey<FormState>();
  bool _hidePassword = true;
  bool _isLoading = false;

  //vars
  late String email, password, username;

  void _saveForm() async {
    bool? isValid = _formKey.currentState?.validate();
    if (isValid!) {
      _formKey.currentState?.save();
      try {
        setState(() {
          _isLoading = true;
        });
        await locator<AuthProvider>()
            .signUp(username.trim(), email.trim(), password);
        Navigator.pushNamedAndRemoveUntil(context,
            BottomOverviewScreen.routeName, (Route<dynamic> route) => false);
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
      ),
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
                height: mHeight! * 0.18,
              ),
              Text(
                "Join us",
                style: themeConst!.textTheme.headline4?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                "Sign up to continue",
                style: themeConst!.textTheme.subtitle1
                    ?.copyWith(color: Colors.white),
              ),
              Card(
                margin: const EdgeInsets.only(top: 50),
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
                              labelText: "Name", focusColor: greyColor),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Name is required";
                            }
                            if (value.length < 6) {
                              return "Please enter a valid name";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            username = value!;
                          },
                        ),
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
                            email = value!.trim();
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            TextFormField(
                                decoration: const InputDecoration(
                                    labelText: "Password"),
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
                                }),
                            IconButton(
                                icon: _hidePassword
                                    ? const Icon(
                                        FontAwesomeIcons.eye,
                                        size: 15,
                                      )
                                    : const Icon(
                                        FontAwesomeIcons.eyeSlash,
                                        size: 15,
                                      ),
                                onPressed: () {
                                  setState(() {
                                    _hidePassword = !_hidePassword;
                                  });
                                }),
                          ],
                        ),
                        SizedBox(height: 60),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: RaisedButton(
                            color: themeConst!.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            onPressed: _isLoading ? null : _saveForm,
                            child: _isLoading
                                ? Center(
                                    child: Container(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator()))
                                : Text(
                                    "Sign Up",
                                    style: themeConst!.textTheme.headline6
                                        ?.copyWith(
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
                              "Already have an account?",
                              style: themeConst!.textTheme.subtitle1?.copyWith(
                                  color: greyColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Sign in",
                                  style: themeConst!.textTheme.subtitle1
                                      ?.copyWith(
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
