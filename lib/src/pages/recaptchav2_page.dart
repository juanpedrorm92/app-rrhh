import 'package:app_rrhh/src/pages/login_page.dart';
import 'package:app_rrhh/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recaptcha_v2/flutter_recaptcha_v2.dart';

class ReCaptchaPage extends StatefulWidget {
  
  static String routeName = 'captcha';

  @override
  _ReCaptchaState createState() => _ReCaptchaState();
}

  String verifyResult = "";
class _ReCaptchaState extends State<ReCaptchaPage> {

//instancias
  RecaptchaV2Controller recaptchaV2Controller = RecaptchaV2Controller();
  final preferenciasUsuario = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    recaptchaV2Controller.show();
    return Scaffold(
      appBar: AppBar(
        title: Text("reCaptcha"),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(verifyResult),
              ],
            ),
          ),
          RecaptchaV2(
            apiKey: "6LcsgM4bAAAAAJ2iGFLJUDqiBjtdmNtUmh3U1-iZ",
            apiSecret: "6LcsgM4bAAAAABp24DiYOOA5TbDeKI5cA4xm6yhn",
            controller: recaptchaV2Controller,
            onVerifiedError: (err){
              
            },
            onVerifiedSuccessfully: (success) {
              setState(() {
                if (success) {
                  //verifyResult = "You've been verified successfully.";
                  preferenciasUsuario.intentosSesion = 0;
                  recaptchaV2Controller.hide();
                  Navigator.popAndPushNamed(context, LoginPage.routeName);
                } else {
                  verifyResult = "Failed to verify.";
                }
              });
            },
          ),
        ],
      ),
    );
  }
}