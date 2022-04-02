import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petcare_commerce/core/constants/assets_source.dart';
import 'package:petcare_commerce/core/theme/constants.dart';
import 'package:petcare_commerce/providers/auth_provider.dart';
import 'package:petcare_commerce/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ThemeData? themeConst;
  double? mHeight, mWidth;
  bool _uploadNewPhoto = false;
  late Map<String, dynamic> jsonUserData;
  bool _isUploading = false;
  bool _isInit = true;
  late Future<Map<String, dynamic>> _getUserData;

  //image picker
  File? _imageFile;
  final imagePicker = ImagePicker();

  // get user data from shared preferences
  Future<Map<String, dynamic>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = json.decode(prefs.getString("userData")!);
    String? imgURL = prefs.getString("profileURL");
    data.putIfAbsent("profileURL", () => imgURL);
    return data;
  }

  // capture image from camera
  Future<void> _takePhoto() async {
    final capturePhoto =
        await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(capturePhoto!.path);
      _uploadNewPhoto = true;
    });
  }

  // get the image widget
  ImageProvider _getImageWidget(String profileURL) {
    if (profileURL == "" && _imageFile == null) {
      return const AssetImage(AssetsSource.userAvatar);
    } else if (_imageFile != null) {
      return FileImage(_imageFile!);
    } else {
      return NetworkImage(profileURL);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _getUserData = getData();
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaConst = MediaQuery.of(context);
    mHeight = mediaConst.size.height;
    mWidth = mediaConst.size.width;
    themeConst = Theme.of(context);
    return FutureBuilder(
        future: _getUserData,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    Stack(children: [
                      Container(
                        height: mHeight! * 0.3,
                        color: themeConst?.primaryColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: _takePhoto,
                                child: CircleAvatar(
                                  radius: 75,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                      radius: 70,
                                      backgroundImage: _getImageWidget(
                                          snapshot.data["profileURL"])),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                snapshot.data["username"],
                                style: themeConst?.textTheme.headline6
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                snapshot.data["email"],
                                style: themeConst?.textTheme.caption?.copyWith(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ),
                    ]),
                    ListTile(
                      onTap: () {},
                      leading: Icon(
                        FontAwesomeIcons.boxes,
                        color: themeConst?.colorScheme.secondary,
                      ),
                      title: Text(
                        "My Orders",
                        style: themeConst?.textTheme.subtitle1
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    ListTile(
                      onTap: () {},
                      leading: Icon(
                        FontAwesomeIcons.solidHeart,
                        color: Colors.blue.shade600,
                      ),
                      title: Text(
                        "Favourites",
                        style: themeConst?.textTheme.subtitle1
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.signOutAlt,
                        color: Colors.red.shade400,
                      ),
                      title: Text(
                        "Logout",
                        style: themeConst?.textTheme.subtitle1
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      onTap: () async {
                        try {
                          bool shouldLogout = await showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text(
                                    'Do you want to logout?',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  buttonPadding: EdgeInsets.zero,
                                  actionsPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 20),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: greyColor, fontSize: 18),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: const Text(
                                        'Yes',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                );
                              });
                          if (shouldLogout) {
                            await Provider.of<AuthProvider>(context,
                                    listen: false)
                                .logout();
                            Navigator.pushReplacementNamed(
                                context, LoginScreen.routeName);
                          }
                        } catch (error) {
                          print(error);
                        }
                      },
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    _uploadNewPhoto
                        ? Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                            child: RaisedButton(
                              onPressed: _isUploading
                                  ? null
                                  : () async {
                                      try {
                                        setState(() {
                                          _isUploading = true;
                                        });
                                        await Provider.of<AuthProvider>(context,
                                                listen: false)
                                            .uploadProductPhoto(_imageFile!);
                                        setState(() {
                                          _uploadNewPhoto = false;
                                        });
                                      } catch (error) {
                                        showDialog(
                                            context: context,
                                            builder: (dCtx) => AlertDialog(
                                                  content: Text(
                                                      "Cant upload the photo"),
                                                  actions: [
                                                    FlatButton(
                                                      onPressed: () {
                                                        Navigator.pop(dCtx);
                                                      },
                                                      child: const Text("OK"),
                                                    )
                                                  ],
                                                ));
                                      }
                                      setState(() {
                                        _isUploading = false;
                                      });
                                    },
                              color: themeConst!.colorScheme.secondary,
                              textColor: Colors.white,
                              child: _isUploading
                                  ? const Center(
                                      child: SizedBox(
                                      height: 15,
                                      width: 15,
                                      child: CircularProgressIndicator(),
                                    ))
                                  : const Text("Upload Profile Photo"),
                            ),
                          )
                        : Container()
                  ],
                );
        });
  }
}
