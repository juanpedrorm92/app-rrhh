import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_rrhh/src/utils/helpers.dart';

class UsuarioProvider{


  final _urlApiLogin = Uri.parse('https://rrhh-dev.ssasur.cl/api/auth/login');
  
  Future<Map<String, dynamic>> login(String rut, String password) async{
    
    final _rutFormateado = limpiarRut(rut);

    //cuerpo de la peticion
    final _body = {"usuario":_rutFormateado, "password":password};

    final response = await http.post(_urlApiLogin, body: _body);

    Map<String, dynamic> decodedResp = json.decode(response.body);

    //si la respuesta viene con error valor true
    if(decodedResp['error']){
      return {'error': true, 'mensaje': decodedResp['message']};
    }else{
      return {'error': false, 'token': decodedResp['access_token'],'usuRut':decodedResp['rut']};
    }

  }

  


}