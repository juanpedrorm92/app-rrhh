import 'package:app_rrhh/src/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';

mostrarAlerta(BuildContext context, String mensaje, String titulo, String pathImagen){
  showDialog(
    context: context,
    builder: (BuildContext context)=> CustomDialog(
      titulo: titulo,
      descripcion: mensaje == 'null' ? 'null':mensaje,
      buttonText: "OK",
      pathImagen: pathImagen,
    )
  );
}