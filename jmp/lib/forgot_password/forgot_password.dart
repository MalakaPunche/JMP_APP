import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../common/JMP_theme.dart';
import '../common/JMP_widgets.dart';
import '../common/JMP_util.dart';

class ForgotPasswordPageWidget extends StatefulWidget {
  const ForgotPasswordPageWidget({super.key});

  @override
  State<ForgotPasswordPageWidget> createState() => ForgotPasswordPageWidgetState();
}

class ForgotPasswordPageWidgetState extends State<ForgotPasswordPageWidget> {
  TextEditingController? emailController;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  Future<void> _resetPassword() async {
    if (formKey.currentState!.validate()) {
      try {
        showSnackbar(context, 'Sending reset email...', loading: true);
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController!.text,
        );
        if (mounted) {
          showSnackbar(context, 'Password reset email sent!');
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showSnackbar(context, 'No user found with this email.');
        } else {
          showSnackbar(context, 'Error: ${e.message}');
        }
      } catch (e) {
        showSnackbar(context, 'An error occurred. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
              size: 24,
            ),
          ),
          title: Text(
            'Reset Password',
            style: JMPTheme.title1.override(
              fontFamily: 'NotoSansKhmer',
              color: Colors.white,
              useGoogleFonts: false,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(32, 32, 32, 32),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your email address to reset your password',
                    style: JMPTheme.bodyText1.override(
                      fontFamily: 'NotoSansKhmer',
                      color: Colors.white,
                      useGoogleFonts: false,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: JMPTheme.bodyText1.override(
                        fontFamily: 'NotoSansKhmer',
                        color: Colors.white,
                        useGoogleFonts: false,
                      ),
                      hintText: 'Enter your email',
                      hintStyle: JMPTheme.bodyText1.override(
                        fontFamily: 'NotoSansKhmer',
                        color: Colors.white.withOpacity(0.5),
                        useGoogleFonts: false,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                    ),
                    style: JMPTheme.bodyText1.override(
                      fontFamily: 'NotoSansKhmer',
                      color: Colors.white,
                      useGoogleFonts: false,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  FFButtonWidget(
                    onPressed: _resetPassword,
                    text: 'Reset Password',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 45,
                      color: JMPTheme.primaryColor,
                      textStyle: JMPTheme.subtitle2.override(
                        fontFamily: 'NotoSansKhmer',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        useGoogleFonts: false,
                      ),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: 36,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
