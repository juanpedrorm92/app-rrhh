

import 'dart:convert';
import 'dart:io';

import 'package:app_rrhh/src/model/userLocation_model.dart';
import 'package:app_rrhh/src/providers/location_provider.dart';
import 'package:http/http.dart' as http; 
import 'package:app_rrhh/src/model/eventos_model.dart';
import 'package:app_rrhh/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:app_rrhh/src/utils/helpers.dart';


class EventosProvider{
//Variables globales
  final Uri _urlEventos = Uri.parse('https://rrhh-dev.ssasur.cl/api/auth/events');
  final Uri _urlEventosRegistro = Uri.parse('https://rrhh-dev.ssasur.cl/api/auth/events/create');

  UserLocation? userLocation;
  
//Instancias
  final  prefUsuario = new PreferenciasUsuario();
  final  location    = new LocationProvider();
  

  Future <List<EventoModel>> listarEventos() async{
    
    final _rutLimpio     = limpiarRut(prefUsuario.usuRut);
    final _rutFormateado = _rutLimpio.substring(0, _rutLimpio.length - 1);
    final _body          = {"rut":_rutFormateado};
    final _headers       = {"x-Requested-With":"XMLHttpRequest", "Authorization": "Bearer "+prefUsuario.token};
  
  //creo una lista de tipo EventoModel
    final List<EventoModel> eventos = [];

    final respApi     = await http.post(_urlEventos, headers: _headers, body: _body);
    final decodedData = json.decode(respApi.body);

    if(decodedData == null) return [];
    
    decodedData['events'].forEach((event){
      final prodTemp = EventoModel.fromJson(event);
      eventos.add(prodTemp);
    });

    return eventos;
  }

   crearEvento(String tipoMarca, String identificador) async{

    userLocation         = location.getLocation();
    final _rutLimpio     = limpiarRut(prefUsuario.usuRut);
    final _rutFormateado = _rutLimpio.substring(0, _rutLimpio.length - 1);
    final _headers       = {"x-Requested-With":"XMLHttpRequest", "Authorization": "Bearer "+prefUsuario.token};
    final _body          = {"type":tipoMarca, "lat":userLocation?.latitude.toString(),"lng":userLocation?.longitude.toString(), "rut":_rutFormateado.toString(), "identifier_id":identificador.toString()};


    //compruebo si hay internet

    try{

      final internet = await InternetAddress.lookup('google.com');
      
      if(internet.isNotEmpty && internet[0].rawAddress.isNotEmpty){
        //conectado
        final respApi = await http.post(_urlEventosRegistro, headers: _headers, body: _body);

        Map<String, dynamic> decodedResp = json.decode(respApi.body);

        if(decodedResp['error']){
          return {'error':true, 'mensaje':decodedResp['message']};
        }else{
          return {'error':false, 'mensaje': decodedResp['message']};
        }
      }
    }on SocketException catch(_){
      return {'error':true, 'mensaje': 'Favor, compueba la conexión de tus datos móviles'};
    }

   

  }




  
}