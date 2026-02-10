// import 'package:flutter/material.dart';
// import 'package:delivery_app/config/app_config.dart' as config;
// import 'package:delivery_app/src/bloc/Authentication/authentication_event.dart';
// import 'package:delivery_app/src/bloc/forgot/forgot_bloc.dart';
// import 'package:delivery_app/src/bloc/forgot/forgot_event.dart';
// import 'package:delivery_app/src/bloc/forgot/forgot_state.dart';
// import 'package:delivery_app/src/elements/BlockButtonWidget.dart';
// import 'package:delivery_app/generated/l10n.dart';
// import 'package:delivery_app/src/helpers/index.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/Authentication/authentication_bloc.dart';
// import '../bloc/Authentication/authentication_state.dart';
// import 'package:delivery_app/generated/l10n.dart';
// import 'package:delivery_app/src/models/user.dart';

// class ResetPasswordWidget extends StatelessWidget {
//   final GlobalKey<FormState> resetFormKey = GlobalKey<FormState>();
//   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//   final tokenController = TextEditingController();
//   final newPasswordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     _onResetButtonPressed() {
//       if (resetFormKey.currentState.validate()) {
//         BlocProvider.of<ForgotBloc>(context).add(sendResetPasswordPressed(token: tokenController.text, password: newPasswordController.text));
//       } else {}
//     }

//     return WillPopScope(
//       onWillPop: Helper.of(context).onWillPop,
//       child: Scaffold(
//           key: navigatorKey,
//           body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
//             builder: (context, state) {
//               final authBloc = BlocProvider.of<AuthenticationBloc>(context);
//               if (state is AuthenticationAuthenticated) {
//                 // return loginForm(context);
//                 return Stack(
//                   alignment: AlignmentDirectional.topCenter,
//                   children: <Widget>[
//                     Positioned(
//                       top: 0,
//                       child: Container(
//                         width: config.App(context).appWidth(100),
//                         height: config.App(context).appHeight(37),
//                         decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
//                       ),
//                     ),
//                     Positioned(
//                       top: config.App(context).appHeight(37) - 120,
//                       child: Container(
//                         width: config.App(context).appWidth(84),
//                         height: config.App(context).appHeight(37),
//                         child: Text(
//                           S.of(context).reset,
//                           style: Theme.of(context).textTheme.headlineMedium.merge(TextStyle(color: Theme.of(context).colorScheme.primary)),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       top: config.App(context).appHeight(37) - 50,
//                       child: Container(
//                           decoration:
//                               BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.all(Radius.circular(10)), boxShadow: [
//                             BoxShadow(
//                               blurRadius: 50,
//                               color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.2),
//                             )
//                           ]),
//                           margin: EdgeInsets.symmetric(
//                             horizontal: 20,
//                           ),
//                           padding: EdgeInsets.symmetric(vertical: 50, horizontal: 27),
//                           width: config.App(context).appWidth(88),
// //              height: config.App(context).appHeight(55),
//                           child: Form(
//                             key: resetFormKey,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 TextFormField(
//                                   keyboardType: TextInputType.text,
//                                   controller: tokenController,
//                                   validator: (input) => input.length < 6 ? S.of(context).input_reset_password_token : null,
//                                   decoration: InputDecoration(
//                                     labelText: "Reset Password Token",
//                                     labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
//                                     contentPadding: EdgeInsets.all(12),
//                                     hintText: '',
//                                     hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
//                                     prefixIcon: Icon(Icons.alternate_email, color: Theme.of(context).colorScheme.secondary),
//                                     border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
//                                     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5))),
//                                     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
//                                   ),
//                                 ),
//                                 SizedBox(height: 30),
//                                 TextFormField(
//                                   keyboardType: TextInputType.text,
//                                   obscureText: true,
//                                   controller: newPasswordController,
//                                   validator: (input) => input.length < 6 ? S.of(context).should_password_input : null,
//                                   decoration: InputDecoration(
//                                     labelText: "New Password",
//                                     labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
//                                     contentPadding: EdgeInsets.all(12),
//                                     hintText: '',
//                                     hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
//                                     prefixIcon: Icon(Icons.lock, color: Theme.of(context).colorScheme.secondary),
//                                     border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
//                                     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5))),
//                                     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
//                                   ),
//                                 ),
//                                 SizedBox(height: 30),
//                                 BlockButtonWidget(
//                                   text: Text(
//                                     S.of(context).reset,
//                                     style: TextStyle(color: Theme.of(context).colorScheme.primary),
//                                   ),
//                                   color: Theme.of(context).colorScheme.secondary,
//                                   onPressed: () {
//                                     state is ResetLoading ? () {} : _onResetButtonPressed();
//                                   },
//                                 ),
//                               ],
//                             ),
//                           )),
//                     ),
//                   ],
//                 );
//               }
//               if (state is AuthenticationFailure) {
//                 return Center(
//                     child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     Text(state.message),
//                     FlatButton(
//                       textColor: Theme.of(context).colorScheme.primary,
//                       child: Text('Retry'),
//                       onPressed: () {
//                         authBloc.add(AppLoaded());
//                       },
//                     )
//                   ],
//                 ));
//               }
//               return Center(
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                 ),
//               );
//             },
//           )),
//     );
//   }
// }
