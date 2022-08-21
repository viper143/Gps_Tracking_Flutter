import 'package:flutter/material.dart';

String baseURL = "http://143.110.188.196:8080";

const iconColor = Color.fromRGBO(222, 158, 54, 20);
const cursorColor = Color.fromRGBO(222, 158, 54, 50);
const buttonBeginColor = Color.fromRGBO(222, 158, 54, 50);
const buttonEndColor = Color.fromRGBO(251, 210, 79, 1);
const bodyBgColor = Color.fromRGBO(206, 227, 226, 1);

// defining regex pattern for license/model field
Pattern characterPattern =
    r'^([A-Za-z0-9]*[ ]*[A-Za-z0-9]*[ ]*[A-Za-z0-9]*[ ]*[A-Za-z0-9]*[ ]*[A-Za-z0-9]*)$';
RegExp characterRegex = new RegExp(characterPattern);

// defining regex pattern for email text field
Pattern emailPattern =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
RegExp emailRegex = new RegExp(emailPattern);

// defining regex pattern for driver name text field
Pattern stringPattern = r'^[A-Za-z]*[ ]*[A-Za-z]*[ ]*[A-Za-z]*[ ]*[A-Za-z]*$';
RegExp stringRegex = new RegExp(stringPattern);

// regex pattern for otp code
Pattern codePattern = r'^([0-9]{6})$';
RegExp codeRegex = new RegExp(codePattern);

// regex pattern for username/project name
Pattern usernamePattern = r'^[a-zA-Z]*[_|-| |]*[a-zA-Z0-9]*$';
RegExp usernameRegex = new RegExp(usernamePattern);

// regex pattern for passwords
Pattern passwordPattern = r'^[a-zA-Z0-9]*$';
RegExp passwordRegex = new RegExp(passwordPattern);

// regex pattern for IMEI number
Pattern imeiPatttern = r'^[0-9]*$';
RegExp imeiRegex = new RegExp(imeiPatttern);
