import 'package:FleetTracker/Views/CommonUI/button.dart';
import 'package:FleetTracker/Views/CommonUI/headerGIF.dart';
import 'package:FleetTracker/Views/CommonUI/headerText.dart';
import 'package:FleetTracker/Views/CommonUI/subHeader.dart';
import 'package:FleetTracker/constants.dart';
import 'package:flutter/material.dart';


class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController _oldPasswordController = new TextEditingController();
  TextEditingController _newPasswordController = new TextEditingController();
  TextEditingController _confirmPasswordController =
      new TextEditingController();

  FocusNode _oldPasswordNode = new FocusNode();
  FocusNode _newPasswordNode = new FocusNode();
  FocusNode _confirmPasswordNode = new FocusNode();

  final _formKey = GlobalKey<FormState>();

  bool oldShowPassword = false;
  bool newShowPassword = false;
  bool confirmShowPassword = false;


  bool _apiCall = false;

  Widget _buildOldPassword() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29),
      ),
      child: TextFormField(
        controller: _oldPasswordController,
        focusNode: _oldPasswordNode,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_newPasswordNode);
        },
        validator: (value) {
          if (value.isEmpty == false) {
            if (!passwordRegex.hasMatch(value)) {
              return 'Invalid password. Enter alphabets or numbers';
            } else if (value.length < 6) {
              return 'Password must be atleast 6 characters';
            } else {
              return null;
            }
          } else {
            return 'Enter old password';
          }
        },
        cursorColor: cursorColor,
        cursorWidth: 3,
        obscureText: oldShowPassword ? false : true,
        decoration: InputDecoration(
            hintText: 'Old Password',
            prefixIcon: Icon(
              Icons.lock,
              color: iconColor,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                oldShowPassword ? Icons.visibility : Icons.visibility_off,
                color: iconColor,
              ),
              onPressed: () {
                setState(() {
                  oldShowPassword = !oldShowPassword;
                });
              },
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none)),
      ),
    );
  }

  Widget _buildNewPassword() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        controller: _newPasswordController,
        focusNode: _newPasswordNode,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_confirmPasswordNode);
        },
        validator: (value) {
          if (value.isEmpty == false) {
            if (!passwordRegex.hasMatch(value)) {
              return 'Invalid password. Enter alphabets or numbers';
            } else if (value.length < 6) {
              return 'Password must be atleast 6 characters';
            } else {
              return null;
            }
          } else {
            return 'Enter new password';
          }
        },
        cursorColor: cursorColor,
        cursorWidth: 3,
        obscureText: newShowPassword ? false : true,
        decoration: InputDecoration(
            hintText: 'New Password',
            prefixIcon: Icon(
              Icons.lock,
              color: iconColor,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                newShowPassword ? Icons.visibility : Icons.visibility_off,
                color: iconColor,
              ),
              onPressed: () {
                setState(() {
                  newShowPassword = !newShowPassword;
                });
              },
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none)),
      ),
    );
  }

// a widget method to build text field to confirm password
  Widget _buildConfirmPassword() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        controller: _confirmPasswordController,
        focusNode: _confirmPasswordNode,
        textInputAction: TextInputAction.done,
        validator: (value) {
          if (value.isEmpty == false) {
            if (!passwordRegex.hasMatch(value)) {
              return 'Invalid password. Enter alphabets or numbers';
            } else if (value.length < 6) {
              return 'Password must be atleast 6 characters';
            } else if (_newPasswordController.text.trim() !=
                _confirmPasswordController.text.trim()) {
              return "Passwords do not match";
            } else {
              return null;
            }
          } else {
            return 'Enter confirm password';
          }
        },
        cursorColor: cursorColor,
        cursorWidth: 3,
        obscureText: confirmShowPassword ? false : true,
        decoration: InputDecoration(
            hintText: 'Confirm Password',
            prefixIcon: Icon(
              Icons.lock,
              color: iconColor,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                confirmShowPassword ? Icons.visibility : Icons.visibility_off,
                color: iconColor,
              ),
              onPressed: () {
                setState(() {
                  confirmShowPassword = !confirmShowPassword;
                });
              },
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none)),
      ),
    );
  }

  Widget _buildChangePasswordBtn() {
    return FlatButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          setState(() {
            _apiCall = true;
          });
          
        }
      },
      child: _apiCall == false
          ? buildButton(context, 'Change Password', 0.45)
          : CircularProgressIndicator(
              backgroundColor: iconColor,
              valueColor: new AlwaysStoppedAnimation<Color>(bodyBgColor),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _apiCall,
      child: Scaffold(
        backgroundColor: bodyBgColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    buildHeaderGif(context),
                    buildHeaderText(context),
                    buildSubHeaderText(context, 'Change your password'),
                    Container(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 40),
                            _buildOldPassword(),
                            SizedBox(height: 20),
                            _buildNewPassword(),
                            SizedBox(height: 20),
                            _buildConfirmPassword(),
                            SizedBox(height: 30),
                            _buildChangePasswordBtn(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
