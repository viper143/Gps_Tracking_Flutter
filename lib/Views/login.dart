import 'package:FleetTracker/Controllers/authentication.dart';
import 'package:FleetTracker/Views/CommonUI/button.dart';
import 'package:FleetTracker/Views/CommonUI/headerGIF.dart';
import 'package:FleetTracker/Views/CommonUI/headerText.dart';
import 'package:FleetTracker/Views/CommonUI/subHeader.dart';
import 'package:FleetTracker/Views/ResetPassword/confirmEmail.dart';
import 'package:FleetTracker/Views/register.dart';
import 'package:FleetTracker/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  final FocusNode _emailNode = new FocusNode();
  final FocusNode _passwordNode = new FocusNode();

  final _formKey = GlobalKey<FormState>();

  final bool showPassword = false;

  final bool _apiCall = false;

  Widget _buildEmailTxtField(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        focusNode: _emailNode,
        controller: _emailController,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value.isEmpty == true || !emailRegex.hasMatch(value)) {
            return "Please Enter a Valid Email";
          }
          return null;
        },
        onFieldSubmitted: (value) =>
            FocusScope.of(context).requestFocus(_passwordNode),
        cursorColor: cursorColor,
        cursorWidth: 3,
        decoration: InputDecoration(
            hintText: 'Email',
            prefixIcon: Icon(
              Icons.email,
              color: iconColor,
            ),
            fillColor: Colors.white,
            filled: true,
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
            if (value.isEmpty ||
                !passwordRegex.hasMatch(value) ||
                value.length < 6) {
              return "Please Enter a Valid Password";
            }
            return null;
          },
          cursorColor: cursorColor,
          cursorWidth: 3,
          obscureText: !_authenticationController.showLoginPassword.value,
          decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: Icon(
                Icons.lock,
                color: iconColor,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _authenticationController.showLoginPassword.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: iconColor,
                ),
                onPressed: () {
                  _authenticationController.showLoginPassword.value =
                      !_authenticationController.showLoginPassword.value;
                },
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12.0))),
        );
      }),
    );
  }

  Widget _buildForgotPassword(context) {
    return FlatButton(
      onPressed: () {
        Get.to(ConfirmEmail());
      },
      child: Text(
        'Forgot Password ?',
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.height / 40,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildLoginBtn(context) {
    return FlatButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          FocusScope.of(context).unfocus();
          _authenticationController.loginUser(
              _emailController.text.trim(), _passwordController.text.trim());
        }
      },
      child: Obx(() {
        return _authenticationController.isHavingAPICall.value == false
            ? buildButton(context, 'Login', 0.45)
            : CircularProgressIndicator(
                backgroundColor: iconColor,
                valueColor: new AlwaysStoppedAnimation<Color>(bodyBgColor),
              );
      }),
    );
  }

  Widget _buildFooterText() {
    return Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: RichText(
            text: TextSpan(
                text: 'Don\'t have an account?',
                style: TextStyle(color: Colors.black, fontSize: 16.0),
                children: <TextSpan>[
                  TextSpan(
                      text: ' Register',
                      style:
                          TextStyle(color: Colors.blueAccent, fontSize: 16.0),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(Register());
                        })
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
                  SizedBox(height: 40),
                  Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _buildEmailTxtField(context),
                          SizedBox(height: 22),
                          _buildPasswordTextField(context)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  _buildForgotPassword(context),
                  SizedBox(height: 5),
                  _buildLoginBtn(context),
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
