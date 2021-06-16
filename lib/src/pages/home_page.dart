import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:app_rrhh/src/model/eventos_model.dart';
import 'package:app_rrhh/src/providers/eventos_provider.dart';
import 'package:app_rrhh/src/utils/alertas.dart';
import 'package:app_rrhh/src/utils/const.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  static String routeName = "home";

  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//Instancias
  final eventosProvider = new EventosProvider();
  final scaffoldKey     = new GlobalKey<ScaffoldState>();

//Variables Globales
  String _mesAppBar = 'Null';
  bool _guardando = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       key: scaffoldKey,
       body: Container(
         child: Center(child:Text("Hola Mundo")),
       )
    );
  }


  Widget _crearAppbar(String mes) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          title: Text(
            mes,
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          background: FadeInImage(
            image: NetworkImage(
                'https://www.araucaniasur.cl/wp-content/uploads/2019/07/banner-principal-OK.jpg'),
            placeholder: AssetImage('assets/loading.gif'),
            fadeInDuration: Duration(microseconds: 5000),
            fit: BoxFit.cover,
          )),
    );
}

  _crearListado() {
      return RefreshIndicator(
        onRefresh: refrescarLista,
        child: FutureBuilder(
            future: eventosProvider.listarEventos(),
            builder: (BuildContext context,
                AsyncSnapshot<List<EventoModel>> snapshot) {
              if (snapshot.hasData) {
                int index = 0;
                final eventos = snapshot.data;
                _mesAppBar = eventos![index].mes.toString();
                return CustomScrollView(
                  slivers: <Widget>[
                    _crearAppbar(_mesAppBar),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int i) =>
                              FadeInLeft(child: _crearItem(context, eventos[i])),
                          childCount: eventos.length),
                    )
                  ],
                );
              } else {
                return CustomScrollView(
                  slivers: <Widget>[
                    _crearAppbar(_mesAppBar),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      SizedBox(
                        height: 20.0,
                      ),
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    ]))
                  ],
                );
              }
            }),
      );
    }

  Widget _crearItem(BuildContext context, EventoModel eventos) {
    return Column(children: <Widget>[
      Card(
        child: ListTile(
          leading: _iconMarca(eventos.tipoMarcaje),
          title: Text('${eventos.establecimiento} ${eventos.ubicacion} '),
          subtitle: Text('${eventos.fecha}'),
        ),
      )
    ]);
  }

  Widget _iconMarca(String marca) {
    if (marca == 'Entrada') {
      return Icon(Icons.arrow_upward, color: Colors.green);
    } else {
      return Icon(Icons.arrow_downward, color: Colors.red);
    }
  }

  Future<Null> refrescarLista() {
    final duration = new Duration(seconds: 2);
    new Timer(duration, () {
      setState(() {
        _crearListado();
        _crearAppbar(_mesAppBar);
      });
    });
    return Future.delayed(duration);
  }


Future scann(BuildContext context,String tipoMarca) async {

    try {
      var scanCod = await BarcodeScanner.scan();
      _submit(context, tipoMarca, scanCod.toString());
    }on PlatformException catch (e){
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        mostrarAlerta(context, "Favor, verificar permisos de Camara!",
            'Atención!', Consts.incorrecto);
      } else {
        mostrarAlerta(
            context, "Unknown error: $e", "Atención!", Consts.incorrecto);
      }
    } on FormatException {
      // presiona boton volver
    } catch (e) {
      mostrarAlerta(
          context, "Unknown error: $e", "Atención!", Consts.incorrecto);
    }
  }


  _submit(BuildContext context,String tipoMarca, String identificador) async {

      mostrarSnackBar(context,"Guardando registro..", _guardando);

      Map info = await eventosProvider.crearEvento(tipoMarca, identificador);

      if (info['error']) {
        mostrarAlerta(
            context,
            info['mensaje'],
            'Ups, hubo un inconveniente. Intentalo nuevamente',
            Consts.incorrecto);
        mostrarSnackBar(context,"", _guardando = false);
      } else {
        mostrarAlerta(
            context, info['mensaje'], 'Marcaje Guardado', Consts.correcto);
        mostrarSnackBar(context,"", _guardando = false);
      }

      setState(() {
        _crearListado();
      });
  }





}