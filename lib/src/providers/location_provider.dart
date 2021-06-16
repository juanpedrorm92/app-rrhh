
import 'package:app_rrhh/src/model/userLocation_model.dart';
import 'package:location/location.dart';

class LocationProvider{

//Instancias
Location location = new Location();

//Variables globales
UserLocation? _currentLocation;

  getLocation() async{

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData locationData;

    _serviceEnabled = await location.serviceEnabled();
    if(!_serviceEnabled){
      _serviceEnabled = await location.requestService();
      if(!_serviceEnabled){
        return;
      }
    }
    
    _permissionGranted = await location.hasPermission();
    if(_permissionGranted == PermissionStatus.denied){
      _permissionGranted = await location.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return;
      }
    }

    try{

      locationData = await location.getLocation();
      _currentLocation = UserLocation(
        latitude:  locationData.latitude,
        longitude: locationData.longitude
      );

    } on Exception catch(e){
      _currentLocation = UserLocation(
        latitude: 0,
        longitude: 0
      );
    }

    return _currentLocation;
  }

  }

