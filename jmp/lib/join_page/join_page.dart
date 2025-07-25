import '../common/jmp_animations.dart';
import '../common/jmp_theme.dart';
import '../signup_with_email/signup_with_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class JoinPageWidget extends StatefulWidget {
  const JoinPageWidget({super.key});

  @override
  JoinPageWidgetState createState() => JoinPageWidgetState();
}

class JoinPageWidgetState extends State<JoinPageWidget>
    with TickerProviderStateMixin {
  final animationsMap = {
    'columnOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      duration: 100,
      fadeIn: true,
      curve: Curves.easeInOut,
    ),
    'imageOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      duration: 600,
      delay: 1100,
      fadeIn: true,
      scale: 0.4,
      curve: Curves.easeInOut,
    ),
    'textOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      duration: 600,
      delay: 1100,
      fadeIn: true,
      slideOffset: const Offset(0, -70),
      curve: Curves.easeInOut,
    ),
    'textOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      duration: 600,
      delay: 1100,
      fadeIn: true,
      slideOffset: const Offset(0, -100),
      curve: Curves.easeInOut,
    ),
  };
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    for (var anim in animationsMap.values) {
      createAnimation(anim, this);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startPageLoadAnimations(
        animationsMap.values
            .where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
        this,
      );
    });
  }

  @override
  void dispose() {
    for (var anim in animationsMap.values) {
      anim.animationController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                child: Image.asset(
                  'assets/images/app_launcher_icon.png',
                  width: 140,
                  height: 140,
                  fit: BoxFit.fitHeight,
                ).animated([animationsMap['imageOnPageLoadAnimation']]),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                child: Text(
                  'JMP',
                  style: JMPTheme.title1.override(
                    fontFamily: 'NotoSansKhmer',
                    color: const Color(0xFF313131),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    useGoogleFonts: false,
                  ),
                ).animated([animationsMap['textOnPageLoadAnimation1']]),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 120),
                child: Text(
                  'Job and Freelancing Marketplace !',
                  style: JMPTheme.bodyText1.override(
                    fontFamily: 'NotoSansKhmer',
                    color: const Color(0xBF696969),
                    useGoogleFonts: false,
                  ),
                ).animated([animationsMap['textOnPageLoadAnimation2']]),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Join to JMP',
                style: JMPTheme.bodyText1.override(
                  fontFamily: 'NotoSansKhmer',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  useGoogleFonts: false,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(32, 4, 32, 4),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupWithEmailPageWidget(),
                        ),
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 45,
                      decoration: BoxDecoration(
                        color: JMPTheme.primaryColor,
                        borderRadius: BorderRadius.circular(36),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.mail,
                            color: Colors.white,
                            size: 24,
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                            child: Text(
                              'Continue with E-mail',
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
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(32, 4, 32, 4),
                  child: Container(
                    width: 100,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(
                        color: const Color(0x40313131),
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
                          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
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
                  padding: const EdgeInsetsDirectional.fromSTEB(32, 4, 32, 4),
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
                          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
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
          const Spacer(),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'By Signing up, you agree to our',
                  style: JMPTheme.bodyText1,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                  child: Text(
                    'Term of Service',
                    style: JMPTheme.bodyText1.override(
                      fontFamily: 'NotoSansKhmer',
                      color: JMPTheme.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      useGoogleFonts: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'and',
                  style: JMPTheme.bodyText1,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                  child: Text(
                    'Privacy Policy',
                    style: JMPTheme.bodyText1.override(
                      fontFamily: 'NotoSansKhmer',
                      color: JMPTheme.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      useGoogleFonts: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ).animated([animationsMap['columnOnPageLoadAnimation']!]),
    );
  }
}
