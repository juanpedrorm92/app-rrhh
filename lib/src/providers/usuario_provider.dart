import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_rrhh/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:app_rrhh/src/utils/helpers.dart';

class UsuarioProvider{


  final _urlApiLogin = Uri.parse('https://rrhh.ssasur.cl/api/auth/login');
  PreferenciasUsuario prefUsuario = new PreferenciasUsuario();
  
  Future<Map<String, dynamic>> login(String rut, String password) async{
    
    final _rutFormateado = limpiarRut(rut);

    //cuerpo de la peticion
    final _body = {"usuario":_rutFormateado, "password":password};

    try{  

        final response = await http.post(_urlApiLogin, body: _body);
        Map<String, dynamic> decodedResp = json.decode(response.body);

          //si la respuesta viene con error valor true
        if(decodedResp['error']){
          //si falla en el inicio de sesion, incremento 
          prefUsuario.intentosSesion++;
          return {'error': true, 'mensaje': decodedResp['message']};
        }else{
          //si accede seteo el valor
          prefUsuario.intentosSesion = 0;
          return {'error': false, 'token': decodedResp['access_token'],'usuRut':decodedResp['rut']};
        } 

    } on TimeoutException catch(_){
      return {'error': true, 'mensaje': 'Tiempo de espera alcanzado'};
    } on SocketException{
      return {'error': true, 'mensaje': 'Sin internet'};
    } on FormatException {
      return {'error': true, 'mensaje': 'Formato Erroneo'};
    }
   
  }

}