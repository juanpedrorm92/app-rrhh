import 'dart:io';
import 'package:device_info/device_info.dart';

String limpiarRut(String rut) {
  var rutLimpio = rut.replaceAll('-', '').replaceAll('.', '');
  var cuerpo = rutLimpio.substring(0, rutLimpio.length - 1);
  var dv = rutLimpio.substring(rutLimpio.length - 1).toUpperCase();

  return cuerpo + "-" + dv;
}

Future<String> _getIdSO() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor;
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId;
  }
}

String devicePlatform() {
  var platform;
  if (Platform.isIOS) {
    platform = 'IOS';
  } else {
    platform = 'Android';
  }

  return platform;
}
