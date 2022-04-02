import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petcare_commerce/core/theme/constants.dart';
import 'package:petcare_commerce/providers/auth_provider.dart';
import 'package:petcare_commerce/screens/bottom_overview_screen.dart';
import 'package:provider/provider.dart';
import '../home/home_screen.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _hidePassword = true;
  bool _isLoading = false;

  //vars
  late String email, password;
  RegExp emailRegex = RegExp(
      "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$");

  void _saveForm() async {
    bool? isValid = _formKey.currentState?.validate();
    if (isValid!) {
      _formKey.currentState?.save();
      try {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<AuthProvider>(context, listen: false)
            .signIn(email.trim(), password);
        Navigator.pushReplacementNamed(context, BottomOverviewScreen.routeName);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            '$error',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: themeConst.errorColor,
        ));
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
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                image: AssetImage(
                  "assets/images/bg_picture.png",
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
                            Text(
                              "Forgot Password?",
                              style: themeConst.textTheme.subtitle1!.copyWith(
                                  color: blackColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: RaisedButton(
                            color: themeConst.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            onPressed: _isLoading ? null : _saveForm,
                            child: _isLoading
                                ? Center(
                                    child: Container(
                                        height: 20,
                                        width: 20,
                                        child:
                                            const CircularProgressIndicator()))
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
                              "Dont have an account?",
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
