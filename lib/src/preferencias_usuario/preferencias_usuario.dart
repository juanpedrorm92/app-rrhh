import 'package:shared_preferences/shared_preferences.dart';

/*
  Recordar instalar el paquete de:
    shared_preferences:
  Inicializar en el main
    final prefs = new PreferenciasUsuario();
    await prefs.initPrefs();
    
    Recuerden que el main() debe de ser async {...
*/
class PreferenciasUsuario {


  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences? _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del token
  String get token {
    return _prefs!.getString('token') ?? '';
  }

  set token( String value ) {
    _prefs!.setString('token', value);
  }

  String get usuRut{
    return _prefs!.getString('usuRut') ?? '';
  }

  set usuRut( String value){
    _prefs!.setString('usuRut', value);
  }

  int get intentosSesion{
    return _prefs!.getInt('intentosSesion') ?? 0;
  }

  set intentosSesion( int value){
    _prefs!.setInt('intentosSesion', value);
  }

  // GET y SET de la última página
  String get ultimaPagina {
    return _prefs!.getString('ultimaPagina') ?? 'login';
  }

  set ultimaPagina( String value ) {
    print("Muestro el value de pref "+value);
    _prefs!.setString('ultimaPagina', value);
  }

}