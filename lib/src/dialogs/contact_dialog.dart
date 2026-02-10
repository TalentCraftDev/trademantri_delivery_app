import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/src/helpers/validators.dart';
import 'package:delivery_app/src/models/contact_model.dart';
import 'package:delivery_app/src/models/delivery_user_model.dart';

class ContactDialog {
  static show(BuildContext context, DeliveryUserModel deliveryUserModel, {Function(ContactModel)? callback}) {
    GlobalKey<FormState> _formkey = new GlobalKey<FormState>();
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);

    TextEditingController _nameController = TextEditingController(text: deliveryUserModel.firstName! + " " + deliveryUserModel.lastName!);
    TextEditingController _phoneController = TextEditingController(text: deliveryUserModel.mobile);
    TextEditingController _emailController = TextEditingController(text: deliveryUserModel.email);
    TextEditingController _reasonController = TextEditingController();
    FocusNode _nameFocusNode = FocusNode();
    FocusNode _phoneFocusNode = FocusNode();
    FocusNode _emailFocusNode = FocusNode();
    FocusNode _reasonFocusNode = FocusNode();

    ContactModel _contactModel = ContactModel();

    _contactModel.userId = deliveryUserModel.id;
    _contactModel.name = _nameController.text.trim();
    _contactModel.phone = _phoneController.text.trim();
    _contactModel.email = _emailController.text.trim();

    InputDecoration getInputDecoration({String? hintText, String? labelText}) {
      return new InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle: Theme.of(context).textTheme.bodyMedium!.merge(
              TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.3))),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.8))),
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.error.withOpacity(0.3))),
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.error.withOpacity(0.8))),
        labelStyle: Theme.of(context).textTheme.bodyMedium!.merge(
              TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
      );
    }

    void _submit() {
      if (_formkey.currentState!.validate()) {
        _formkey.currentState!.save();
        Navigator.pop(context);

        if (callback != null) {
          callback(_contactModel);
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
              Icon(Icons.info, size: heightDp * 20),
              SizedBox(width: heightDp * 10),
              Text(
                'Contact Us',
                style: Theme.of(context).textTheme.bodyLarge,
              )
            ],
          ),
          children: <Widget>[
            Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  new TextFormField(
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    keyboardType: TextInputType.text,
                    decoration: getInputDecoration(labelText: 'Name'),
                    validator: (input) => input!.isEmpty ? "Please input name" : null,
                    onFieldSubmitted: (input) {
                      FocusScope.of(context).requestFocus(_phoneFocusNode);
                    },
                    onSaved: (input) {
                      _contactModel.name = input!.trim();
                    },
                  ),
                  SizedBox(height: heightDp * 10),
                  new TextFormField(
                    controller: _phoneController,
                    focusNode: _phoneFocusNode,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    keyboardType: TextInputType.phone,
                    decoration: getInputDecoration(hintText: '', labelText: 'Phone Number'),
                    validator: (input) => input!.length != 10 ? "Should be 10 numbers" : null,
                    onFieldSubmitted: (input) {
                      FocusScope.of(context).requestFocus(_emailFocusNode);
                    },
                    onSaved: (input) {
                      _contactModel.phone = input!.trim();
                    },
                  ),
                  SizedBox(height: heightDp * 10),
                  new TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    keyboardType: TextInputType.emailAddress,
                    decoration: getInputDecoration(hintText: '', labelText: 'email'),
                    validator: (input) => !KeicyValidators.isValidEmail(input!) ? "Should be a valid email" : null,
                    onFieldSubmitted: (input) {
                      FocusScope.of(context).requestFocus(_reasonFocusNode);
                    },
                    onSaved: (input) {
                      _contactModel.email = input!.trim();
                    },
                  ),
                  SizedBox(height: heightDp * 10),
                  new TextFormField(
                    controller: _reasonController,
                    focusNode: _reasonFocusNode,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    decoration: getInputDecoration(hintText: '', labelText: 'Reason'),
                    validator: (input) => input!.length < 8 ? "Should be more than 8 charactors" : null,
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.left,
                    onFieldSubmitted: (input) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    onSaved: (input) {
                      _contactModel.reason = input!.trim();
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
