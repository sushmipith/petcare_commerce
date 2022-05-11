import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/assets_source.dart';
import '../../core/constants/constants.dart';
import '../../core/service/service_locator.dart';
import '../../widgets/custom_snack_bar.dart';
import '../../providers/auth_provider.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgot_password_screen';
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formVerificationKey = GlobalKey<FormState>();
  String? _email, _verificationCode, _password;
  bool _isLoading = false;
  bool _isVerify = false;
  bool _hidePassword = true;

  void _saveForm() async {
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      await locator<AuthProvider>().forgotPassword(_email!);
      setState(() {
        _isLoading = false;
        _isVerify = true;
      });
      showCustomSnackBar(
        context: context,
        message: 'Verification code has been send to your email. Please check',
        isError: false,
      );
    } catch (error) {
      setState(() => _isLoading = false);
      showCustomSnackBar(
        context: context,
        message: 'Sorry, couldn\'t send verification code. $error',
        isError: true,
      );
    }
  }

  void _verifyForm() async {
    try {
      if (!_formVerificationKey.currentState!.validate()) {
        return;
      }
      _formVerificationKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      await locator<AuthProvider>()
          .resetPassword(_password!, _verificationCode!);
      setState(() {
        _isLoading = false;
      });
      showCustomSnackBar(
        context: context,
        message: 'Your password has been reset successfully. Please login',
        isError: false,
      );
    } catch (error) {
      setState(() => _isLoading = false);
      showCustomSnackBar(
        context: context,
        message: 'Sorry, couldn\'t reset password.',
        isError: true,
      );
    }
  }

  /// FUNC [_buildForgotWidget] : Build Forgot for email
  Widget _buildForgotWidget(ThemeData themeConst) {
    return Form(
      key: _formKey,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 40),
        child: Column(
          children: [
            Text(
              "To reset please enter your email, a verification code will be sent to your email.",
              style: themeConst.textTheme.subtitle1!.copyWith(
                color: blackColor,
              ),
            ),
            const SizedBox(
              height: 10,
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
                _email = value!;
              },
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
                        "Send Code",
                        style: themeConst.textTheme.headline6!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w600),
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
                  style: themeConst.textTheme.subtitle1!
                      .copyWith(color: greyColor, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Login",
                      style: themeConst.textTheme.subtitle1!.copyWith(
                          color: accentColor, fontWeight: FontWeight.w600),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// FUNC [_buildVerificationWidget] : Build Verification and reset password
  Widget _buildVerificationWidget(ThemeData themeConst) {
    return Form(
      key: _formVerificationKey,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 40),
        child: Column(
          children: [
            Text(
              "Enter the verification code and new password to reset",
              style: themeConst.textTheme.subtitle1!
                  .copyWith(color: blackColor, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: "Verification Code", focusColor: greyColor),
              keyboardType: const TextInputType.numberWithOptions(
                  signed: false, decimal: false),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Verification Code is required";
                }
                if (!emailRegex.hasMatch(value.trim())) {
                  return "Verification Code is not valid";
                }
                return null;
              },
              onSaved: (value) {
                _verificationCode = value!;
              },
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextFormField(
                    decoration: const InputDecoration(labelText: "Password"),
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
                      _password = value!;
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
              height: 40,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: themeConst.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isLoading ? null : _verifyForm,
                child: _isLoading
                    ? const Center(
                        child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator()))
                    : Text(
                        "Reset Password",
                        style: themeConst.textTheme.headline6!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaConst = MediaQuery.of(context);
    double mHeight = mediaConst.size.height;
    ThemeData themeConst = Theme.of(context);
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
                height: mHeight * 0.25,
              ),
              Text(
                "Forgot Password?",
                style: themeConst.textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                "Don't worry we got you covered",
                style: themeConst.textTheme.subtitle1!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: !_isVerify
                      ? _buildForgotWidget(themeConst)
                      : _buildVerificationWidget(themeConst))
            ],
          ),
        ],
      ),
    );
  }
}
