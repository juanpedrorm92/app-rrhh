import 'dart:convert';

EventoModel eventoModelFromJson(String str) => EventoModel.fromJson(json.decode(str));

String eventoModelToJson(EventoModel data) => json.encode(data.toJson());

class EventoModel {
    String establecimiento;
    String ubicacion;
    String tipoMarcaje;
    String fecha;
    String mes;

    EventoModel({
       required this.establecimiento,
       required this.ubicacion,
       required this.tipoMarcaje,
       required this.fecha,
       required this.mes
    });

    factory EventoModel.fromJson(Map<String, dynamic> json) => EventoModel(
        
        establecimiento : json["establishment"],
        ubicacion       : json["location"],
        tipoMarcaje     : json["type"],
        fecha           : json["date"],
        mes             : json["month"]
    );

    Map<String, dynamic> toJson() => {
        
        "tipo_marcaje"  : tipoMarcaje,
        "fecha"         : fecha,
        "mes"           : mes
    };
}
