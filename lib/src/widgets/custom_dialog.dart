import 'package:animate_do/animate_do.dart';
import 'package:app_rrhh/src/utils/const.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {

  final String titulo, descripcion, buttonText, pathImagen;
  
  CustomDialog({
    required this.titulo, 
    required this.descripcion,
    required this.buttonText,
    required this.pathImagen
  });

  @override
  Widget build(BuildContext context) {
    return ElasticIn(
      child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Consts.padding)
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: dialogContent(context),
      ),
    );
  }

  Widget dialogContent(BuildContext context){

    final contenedor = Container(
      padding: EdgeInsets.only(
        top: Consts.avatarRadius + Consts.padding,
        bottom: Consts.padding,
        left: Consts.padding,
        right: Consts.padding
      ),
      margin: EdgeInsets.only(top: Consts.avatarRadius),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(Consts.padding),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius:10.0,
            offset: const Offset(0.0, 10.0)
          )
        ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            descripcion, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 24.0,),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text(buttonText),
            ),
          )
        ],
      ),
    );


    final circulo_avatar = Positioned(
      left: Consts.padding,
      right: Consts.padding,
      child: CircleAvatar(
        radius: Consts.avatarRadius,
        backgroundColor: Colors.transparent,
        child: Image(
          image: AssetImage('assets/${pathImagen}'),
        ),
      ),
    );

    return Stack(
      children: <Widget>[
        contenedor,
        circulo_avatar
      ],
    );
  }
}
