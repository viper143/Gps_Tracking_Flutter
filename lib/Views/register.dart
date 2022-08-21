import 'package:FleetTracker/Controllers/authentication.dart';
import 'package:FleetTracker/Views/CommonUI/button.dart';
import 'package:FleetTracker/Views/CommonUI/headerGIF.dart';
import 'package:FleetTracker/Views/CommonUI/headerText.dart';
import 'package:FleetTracker/Views/CommonUI/subHeader.dart';
import 'package:FleetTracker/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Register extends StatelessWidget {
  final AuthenticationController _authenticationController = Get.find();
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _phoneNumber = new TextEditingController();

  final FocusNode _nameNode = new FocusNode();
  final FocusNode _emailNode = new FocusNode();
  final FocusNode _passwordNode = new FocusNode();
  final FocusNode _phoneNumberNode = new FocusNode();

  final _formKey = GlobalKey<FormState>();

  Widget _buildUsernameTxtField(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        controller: _nameController,
        focusNode: _nameNode,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) =>
            FocusScope.of(context).requestFocus(_emailNode),
        validator: (value) {
          if (value.isEmpty == true || value.trim().length == 0) {
            return 'Invalid username';
          } else {
            return null;
          }
        },
        cursorColor: cursorColor,
        cursorWidth: 3,
        decoration: InputDecoration(
            hintText: 'Your Name / Company Name',
            prefixIcon: Icon(
              Icons.person,
              color: iconColor,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none)),
      ),
    );
  }

  Widget _buildEmailTxtField(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        controller: _emailController,
        focusNode: _emailNode,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) =>
            FocusScope.of(context).requestFocus(_phoneNumberNode),
        validator: (value) {
          if (value.isEmpty == false) {
            if (!emailRegex.hasMatch(value)) {
              return 'Invalid Email';
            } else {
              return null;
            }
          } else {
            return 'Enter an email';
          }
        },
        cursorColor: cursorColor,
        cursorWidth: 3,
        decoration: InputDecoration(
            hintText: 'Email',
            prefixIcon: Icon(
              Icons.email,
              color: iconColor,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none)),
      ),
    );
  }

  Widget _buildphoneNumber(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        controller: _phoneNumber,
        focusNode: _phoneNumberNode,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordNode);
        },
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp('[0-9]'))
        ],
        validator: (value) {
          if (value.trim().length == 10) {
            return null;
          } else {
            return 'Enter IMEI number(10 digits)';
          }
        },
        cursorColor: cursorColor,
        cursorWidth: 3,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.phone, color: iconColor),
            fillColor: Colors.white,
            filled: true,
            hintText: 'Phone Number',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none)),
      ),
    );
  }

  Widget _buildPasswordTextField(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Obx(() {
        return TextFormField(
          focusNode: _passwordNode,
          controller: _passwordController,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
          validator: (value) {
            if (value.isEmpty == false) {
              if (!passwordRegex.hasMatch(value)) {
                return 'Invalid password. Enter alphabets or numbers';
              } else if (value.length < 6) {
                return 'Password must be atleast 6 characters.';
              } else {
                return null;
              }
            } else {
              return 'Enter password';
            }
          },
          cursorColor: cursorColor,
          cursorWidth: 3,
          obscureText: !_authenticationController.showRegisterPassword.value,
          decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: Icon(
                Icons.lock,
                color: iconColor,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _authenticationController.showRegisterPassword.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: iconColor,
                ),
                onPressed: () {
                  _authenticationController.showRegisterPassword.value =
                      !_authenticationController.showRegisterPassword.value;
                },
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none)),
        );
      }),
    );
  }

  Widget _buildRadioBtn(context) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Radio(
              value: 'Personal',
              groupValue: _authenticationController.selectedRole.value,
              onChanged: (value) {
                _authenticationController.selectedRole.value = value;
              }),
          Text(
            'Personal',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Radio(
            value: 'Business',
            groupValue: _authenticationController.selectedRole.value,
            onChanged: (value) {
              _authenticationController.selectedRole.value = value;
            },
          ),
          Text(
            'Business',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildRegisterBtn(context) {
    return FlatButton(onPressed: () {
      if (_formKey.currentState.validate()) {
        FocusScope.of(context).unfocus();
        _authenticationController.registerUser(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _phoneNumber.text.trim());
      }
    }, child: Obx(() {
      return _authenticationController.isHavingAPICall.value == false
          ? buildButton(context, 'Register', 0.45)
          : CircularProgressIndicator(
              backgroundColor: iconColor,
              valueColor: new AlwaysStoppedAnimation<Color>(bodyBgColor),
            );
    }));
  }

  Widget _buildFooterText() {
    return Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: RichText(
            text: TextSpan(
                text: 'Already have an account?',
                style: TextStyle(color: Colors.black, fontSize: 16.0),
                children: <TextSpan>[
                  TextSpan(
                      text: ' Login',
                      style:
                          TextStyle(color: Colors.blueAccent, fontSize: 16.0),
                      recognizer: TapGestureRecognizer()..onTap = () {})
                ]),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  buildHeaderGif(context),
                  buildHeaderText(context),
                  buildSubHeaderText(
                      context, 'Track your vehicle in real time'),
                  SizedBox(height: 30),
                  Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _buildUsernameTxtField(context),
                          SizedBox(height: 20),
                          _buildEmailTxtField(context),
                          SizedBox(height: 20),
                          _buildphoneNumber(context),
                          SizedBox(height: 20),
                          _buildPasswordTextField(context)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  _buildRadioBtn(context),
                  SizedBox(height: 5),
                  _buildRegisterBtn(context),
                  SizedBox(height: 5),
                  _buildFooterText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
