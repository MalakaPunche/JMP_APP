import '../common/jmp_theme.dart';
import '../common/jmp_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../common/jmp_util.dart';
import '../home_page/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import '../freelancer_page/frelancer_page_widget.dart'; // Add this import
import '../login_with_email/login_with_email.dart'; // Add this import

class SignupWithEmailPageWidget extends StatefulWidget {
  const SignupWithEmailPageWidget({super.key});

  @override
  SignupWithEmailPageWidgetState createState() =>
      SignupWithEmailPageWidgetState();
}

class SignupWithEmailPageWidgetState extends State<SignupWithEmailPageWidget> {
  TextEditingController? textController1;
  TextEditingController? textController2;
  late bool passwordVisibility1;
  TextEditingController? textController3;
  late bool passwordVisibility2;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    passwordVisibility1 = false;
    textController3 = TextEditingController();
    passwordVisibility2 = false;
  }

  Future<void> _createAccount() async {
    if (formKey.currentState!.validate()) {
      if (textController2?.text != textController3?.text) {
        showSnackbar(context, 'Passwords do not match');
        return;
      }

      try {
        showSnackbar(context, 'Creating account...', loading: true);

        if (!textController1!.text.contains('@') || !textController1!.text.contains('.')) {
          showSnackbar(context, 'Please enter a valid email address');
          return;
        }

        if (textController2!.text.length < 6) {
          showSnackbar(context, 'Password must be at least 6 characters long');
          return;
        }

        print('Attempting to create account with email: ${textController1!.text}');

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: textController1!.text,
          password: textController2!.text,
        );

        print('Account created successfully: ${userCredential.user?.uid}');

        if (userCredential.user != null) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        }
      } on FirebaseAuthException catch (e) {
        print('Firebase Auth Error: ${e.code} - ${e.message}');
        String errorMessage;
        switch (e.code) {
          case 'weak-password':
            errorMessage = 'The provided password is too weak.';
            break;
          case 'email-already-in-use':
            errorMessage = 'An account already exists for that email.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Email/password accounts are not enabled.';
            break;
          default:
            errorMessage = 'Error: ${e.message}';
        }
        showSnackbar(context, errorMessage);
      } catch (e) {
        print('General Error: $e');
        showSnackbar(context, 'An error occurred: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Scaffold(
        key: scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () async {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
              size: 24,
            ),
          ),
          actions: const [],
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  32, 32, 32, 0),
                              child: Text(
                                'Join our community today',
                                textAlign: TextAlign.center,
                                style: JMPTheme.bodyText1.override(
                                  fontFamily: 'NotoSansKhmer',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  useGoogleFonts: false,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 4, 16, 0),
                            child: Text(
                              'Create an account to continue.',
                              style: JMPTheme.bodyText1.override(
                                fontFamily: 'NotoSansKhmer',
                                color: const Color(0xCD303030),
                                useGoogleFonts: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(32, 45, 32, 0),
                        child: TextFormField(
                          controller: textController1,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'Email Address',
                            hintStyle: JMPTheme.bodyText1.override(
                              fontFamily: 'NotoSansKhmer',
                              color: Colors.grey[400],
                              useGoogleFonts: false,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                          ),
                          style: JMPTheme.bodyText1.override(
                            fontFamily: 'NotoSansKhmer',
                            color: Colors.black87,
                            useGoogleFonts: false,
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(32, 16, 32, 0),
                        child: TextFormField(
                          controller: textController2,
                          obscureText: !passwordVisibility1,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: JMPTheme.bodyText1.override(
                              fontFamily: 'NotoSansKhmer',
                              color: Colors.grey[400],
                              useGoogleFonts: false,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            suffixIcon: InkWell(
                              onTap: () => setState(() =>
                                  passwordVisibility1 = !passwordVisibility1),
                              child: Icon(
                                passwordVisibility1
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey[400],
                                size: 22,
                              ),
                            ),
                          ),
                          style: JMPTheme.bodyText1.override(
                            fontFamily: 'NotoSansKhmer',
                            color: Colors.black87,
                            useGoogleFonts: false,
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(32, 16, 32, 0),
                        child: TextFormField(
                          controller: textController3,
                          obscureText: !passwordVisibility2,
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            hintStyle: JMPTheme.bodyText1.override(
                              fontFamily: 'NotoSansKhmer',
                              color: Colors.grey[400],
                              useGoogleFonts: false,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            suffixIcon: InkWell(
                              onTap: () => setState(() =>
                                  passwordVisibility2 = !passwordVisibility2),
                              child: Icon(
                                passwordVisibility2
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey[400],
                                size: 22,
                              ),
                            ),
                          ),
                          style: JMPTheme.bodyText1.override(
                            fontFamily: 'NotoSansKhmer',
                            color: Colors.black87,
                            useGoogleFonts: false,
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  32, 32, 32, 0),
                              child: FFButtonWidget(
                                onPressed: _createAccount,
                                text: 'Create Account',
                                options: FFButtonOptions(
                                  width: 130,
                                  height: 45,
                                  color: JMPTheme.primaryColor,
                                  textStyle: JMPTheme.subtitle2.override(
                                    fontFamily: 'NotoSansKhmer',
                                    color: Colors.white,
                                    useGoogleFonts: false,
                                  ),
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: 36,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                'By creating an account, you agree to our Terms of Service and Privacy Policy.',
                                textAlign: TextAlign.center,
                                style: JMPTheme.bodyText1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    32, 0, 0, 0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height: 2,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFEEEEEE),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 0, 8, 0),
                              child: Text(
                                'or',
                                style: JMPTheme.bodyText1,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 32, 0),
                                child: Container(
                                  width: 100,
                                  height: 2,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFEEEEEE),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  32, 4, 32, 4),
                              child: Container(
                                width: 100,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(36),
                                  border: Border.all(
                                    color: const Color(0x3F313131),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 25,
                                      height: 25,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/images/google_icon.svg',
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16, 0, 0, 0),
                                      child: Text(
                                        'Continue with Google',
                                        style: JMPTheme.subtitle2.override(
                                          fontFamily: 'NotoSansKhmer',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          useGoogleFonts: false,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  32, 4, 32, 4),
                              child: Container(
                                width: 100,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(36),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.apple,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16, 0, 0, 0),
                                      child: Text(
                                        'Continue with Apple',
                                        style: JMPTheme.subtitle2.override(
                                          fontFamily: 'NotoSansKhmer',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          useGoogleFonts: false,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16, 25, 16, 32),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: JMPTheme.bodyText1,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  4, 0, 0, 0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginWithEmailPageWidget(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Log In',
                                  style: JMPTheme.bodyText1.override(
                                    fontFamily: 'NotoSansKhmer',
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts: false,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Add this at the end of your column
                      Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
