

import 'dart:convert';
import 'dart:io';
import 'package:app_rrhh/src/providers/location_provider.dart';
import 'package:http/http.dart' as http; 
import 'package:app_rrhh/src/model/eventos_model.dart';
import 'package:app_rrhh/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:location/location.dart';


class EventosProvider{
//Variables globales
  final Uri _urlEventos = Uri.parse('https://rrhh.ssasur.cl/api/auth/events');
  final Uri _urlEventosRegistro = Uri.parse('https://rrhh.ssasur.cl/api/auth/events/create');
  LocationData? locationData;

//Instancias
  final  prefUsuario         = new PreferenciasUsuario();
  final  locationProvider    = new LocationProvider();
  Location location          = new Location();
  

  Future <List<EventoModel>> listarEventos() async{
    
    final _rutLimpio     = prefUsuario.usuRut.replaceAll('-', '').replaceAll('.', '');
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

  Future <Map<String, dynamic>> crearEvento(String tipoMarca, String identificador) async{

    //verfico los permisos de ubicacion
      locationProvider.permisosUbicacion();
    //luego obtengo las coordenadas
    try{
      locationData   = await location.getLocation();
    }on Exception catch(e){
      return {'error':true, 'mensaje': 'Favor, compueba los permisos de ubicación'};
    }
    final _rutLimpio     = prefUsuario.usuRut.replaceAll('-', '').replaceAll('.', '');
    final _rutFormateado = _rutLimpio.substring(0, _rutLimpio.length - 1);
    final _headers       = {"x-Requested-With":"XMLHttpRequest", "Authorization": "Bearer "+prefUsuario.token};
    final _body          = {"type":tipoMarca, "lat":locationData?.latitude.toString(),"lng":locationData?.longitude.toString(), "rut":_rutFormateado.toString(), "identifier_id":identificador.toString()};
   
    Map<String, dynamic> decodedResp = {'error':true, 'mensaje':'Error al obtener los eventos'};
    
    //compruebo si hay internet

    try{

      final internet = await InternetAddress.lookup('google.com');
      
      if(internet.isNotEmpty && internet[0].rawAddress.isNotEmpty){
        //conectado
        final respApi = await http.post(_urlEventosRegistro, headers: _headers, body: _body);

         decodedResp = json.decode(respApi.body);

        if(decodedResp['error']){
           decodedResp = {'error':true, 'mensaje':decodedResp['message']};
        }else{
          decodedResp = {'error':false, 'mensaje': decodedResp['message']};
        }
      }
    }on SocketException catch(_){
      return {'error':true, 'mensaje': 'Favor, compueba la conexión de tus datos móviles'};
    }

    return decodedResp;
  }




  
}