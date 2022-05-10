import 'dart:ui';

import 'package:flutter/material.dart';

const Color blackColor = Color(0xFF111111);
const Color primaryColor = Color(0xFF9d73ef);
const Color primaryLightColor = Color(0xFF9d73ef);
const Color greyColor = Color(0xFF727C8E);
const Color accentColor = Color(0xFFF7B733);
const Color greenColor = Color(0xFF66BB6A);
RegExp emailRegex = RegExp(
    "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$");

final List<String> productTypes = ["Flash", "New"];
final List<String> categoryTypes = ["Food", "Grooming", "Toys", "Veterinary"];
