import 'package:app_rrhh/src/bloc/provider.dart';
import 'package:app_rrhh/src/pages/home_page.dart';
import 'package:app_rrhh/src/pages/login_page.dart';
import 'package:app_rrhh/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:flutter/material.dart';
 
void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();  
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Provider(
      child: MaterialApp(
      title: 'Subdireccion de Gestion y Desarrollo de las personas',
      debugShowCheckedModeBanner: false,
      initialRoute: LoginPage.routeName,
      routes:{
        LoginPage.routeName: (BuildContext context) => LoginPage(),
        HomePage.routeName : (BuildContext context) => HomePage()
      },)
    );
  }
}