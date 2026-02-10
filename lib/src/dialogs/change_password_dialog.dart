import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/src/helpers/helper.dart';

class ChangePasswordDialog {
  static show(BuildContext context, {Function(String, String)? callback}) {
    GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);

    TextEditingController _oldPasswordController = TextEditingController();
    TextEditingController _newPasswordController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();
    FocusNode _oldPasswordFocusNode = FocusNode();
    FocusNode _newPasswordFocusNode = FocusNode();
    FocusNode _confirmPasswordFocusNode = FocusNode();

    InputDecoration getInputDecoration({String? hintText, String? labelText}) {
      return new InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle: Theme.of(context).textTheme.bodyMedium!.merge(
              TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
        errorMaxLines: 2,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.3))),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.8))),
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.error.withOpacity(0.3))),
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.error.withOpacity(0.8))),
        labelStyle: Theme.of(context).textTheme.bodyMedium!.merge(
              TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
        contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 0),
      );
    }

    void _submit() {
      if (_profileSettingsFormKey.currentState!.validate()) {
        _profileSettingsFormKey.currentState!.save();
        Navigator.pop(context);

        if (callback != null) {
          callback(_oldPasswordController.text.trim(), _newPasswordController.text.trim());
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 20),
          titlePadding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 20),
          title: Row(
            children: <Widget>[
              Icon(Icons.person, size: heightDp * 20),
              SizedBox(width: heightDp * 10),
              Text(
                'Change Password',
                style: Theme.of(context).textTheme.bodyLarge,
              )
            ],
          ),
          children: <Widget>[
            Form(
              key: _profileSettingsFormKey,
              child: Column(
                children: <Widget>[
                  new TextFormField(
                    controller: _oldPasswordController,
                    focusNode: _oldPasswordFocusNode,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    keyboardType: TextInputType.text,
                    decoration: getInputDecoration(labelText: 'Old Password'),
                    obscureText: true,
                    validator: (input) =>
                        input!.length < 8 ? 'Password must have 1 letter, 1 digit and must be atleast 8 characters in length' : null,
                    onFieldSubmitted: (input) {
                      FocusScope.of(context).requestFocus(_newPasswordFocusNode);
                    },
                  ),
                  SizedBox(height: heightDp * 10),
                  new TextFormField(
                    controller: _newPasswordController,
                    focusNode: _newPasswordFocusNode,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: getInputDecoration(hintText: '', labelText: 'New Password'),
                    validator: (input) => !passwordValidation(input!) || input.length < 8
                        ? 'Password must have 1 letter, 1 digit and must be atleast 8 characters in length'
                        : (_newPasswordController.text != _confirmPasswordController.text)
                            ? 'Should match the passwords'
                            : null,
                    onFieldSubmitted: (input) {
                      FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
                    },
                  ),
                  SizedBox(height: heightDp * 10),
                  new TextFormField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocusNode,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: getInputDecoration(hintText: '', labelText: 'Confirm Password'),
                    validator: (input) => !passwordValidation(input!) || input.length < 8
                        ? 'Password must have 1 letter, 1 digit and must be atleast 8 characters in length'
                        : (_newPasswordController.text != _confirmPasswordController.text)
                            ? 'Should match the passwords'
                            : null,
                    onFieldSubmitted: (input) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                MaterialButton(
                  onPressed: _submit,
                  child: Text(
                    'Save',
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
