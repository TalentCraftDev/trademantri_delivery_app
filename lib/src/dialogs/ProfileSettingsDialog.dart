import 'package:flutter/material.dart';
import 'package:delivery_app/src/models/index.dart';

class ProfileSettingsDialog extends StatefulWidget {
  DeliveryUserModel? userModel;
  Function? onChanged;

  ProfileSettingsDialog({Key? key, this.userModel, this.onChanged}) : super(key: key);

  @override
  _ProfileSettingsDialogState createState() => _ProfileSettingsDialogState();
}

class _ProfileSettingsDialogState extends State<ProfileSettingsDialog> {
  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();
  String? oldMobile;
  @override
  Widget build(BuildContext context) {
    oldMobile = widget.userModel!.mobile;

    return TextButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                title: Row(
                  children: <Widget>[
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text(
                      'Profile Settings',
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
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(hintText: 'John Doe', labelText: 'First Name'),
                          initialValue: widget.userModel!.firstName,
                          validator: (input) => input!.trim().length < 3 ? 'Not a valid first name' : null,
                          onSaved: (input) => widget.userModel!.firstName = input!.trim(),
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(hintText: 'John Doe', labelText: 'Last Name'),
                          initialValue: widget.userModel!.lastName,
                          validator: (input) => input!.trim().length < 3 ? 'Not a valid last name' : null,
                          onSaved: (input) => widget.userModel!.lastName = input!.trim(),
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          keyboardType: TextInputType.number,
                          decoration: getInputDecoration(hintText: '123445', labelText: 'PhoneNumber'),
                          initialValue: widget.userModel!.mobile,
                          validator: (input) => input!.trim().length != 10 ? 'Please enter 10 numbers' : null,
                          onSaved: (input) => widget.userModel!.mobile = input!.trim(),
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
                      SizedBox(width: 20),
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
            });
      },
      child: Text(
        "Edit",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  InputDecoration getInputDecoration({String? hintText, String? labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyMedium!.merge(
            TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      labelStyle: Theme.of(context).textTheme.bodyMedium!.merge(
            TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
    );
  }

  void _submit() {
    if (_profileSettingsFormKey.currentState!.validate()) {
      _profileSettingsFormKey.currentState!.save();
      Navigator.pop(context);
      widget.userModel!.isNewPhoneNumber = widget.userModel!.mobile != oldMobile;
      if (widget.userModel!.isNewPhoneNumber!) widget.userModel!.phoneVerified = false;
      widget.onChanged!(widget.userModel);
    }
  }
}
