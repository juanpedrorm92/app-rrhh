import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:app_rrhh/src/bloc/login_bloc.dart';
import 'package:app_rrhh/src/bloc/provider.dart';
import 'package:app_rrhh/src/pages/home_page.dart';
import 'package:app_rrhh/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:app_rrhh/src/providers/usuario_provider.dart';
import 'package:app_rrhh/src/utils/alertas.dart';
import 'package:app_rrhh/src/utils/const.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  static String routeName = "login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //instancias 
  final usuarioProvider = new UsuarioProvider();
  final preferenciasUsuario = new PreferenciasUsuario();
  //variables globales 
  ProgressDialog? _progressDialog;

  Color primary   = Color.fromRGBO(0, 8, 170, 1);
  Color secondary = Color.fromRGBO(255, 45, 0, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Stack(
         children: [
           _crearFondo(context),
           _loginForm(context)
         ],
       ),
    );
  }


    Widget _crearFondo(BuildContext context) {

    //para obtener el 40% de la pantalla 
    final size = MediaQuery.of(context).size;

    final fondo = Container(
      height: size.height * 0.4,
      width: double.infinity, // todo el ancho
      decoration: BoxDecoration( // para decorar el espacio
        gradient: LinearGradient(
          colors: <Color>[
            this.primary,
            this.secondary
          ]
        )

      ),
    );
    
    return Stack(
      children: <Widget>[
        fondo,
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0,),
              //el double infinity me ocpara todo el ancho y por defecto lo centrara
              SizedBox(height: 10.0, width: double.infinity),
              Text("Servicio de Salud Araucania Sur", style: TextStyle(color: Colors.white, fontSize:20.0 ),)
            ],
          ),
        )
      ],
    );
  }

  Widget _loginForm(BuildContext context){
    
  final bloc = Provider.of(context);
  
  final size = MediaQuery.of(context).size;

// va a permitir hacer scroll dependiendo el largo del hijo (child)
  return SingleChildScrollView(
    child: Column(
      children: <Widget>[
        SafeArea(
          child: Container(
            height: 180.0,
          ),
        ),
        Container(
          width: size.width * 0.85,
          // cpn respecto al ancho, este va a ser dinamico ya que va a depender de los alementos internos 
          //separacion de la caja con el texto de arriba (Usuario)
          margin: EdgeInsets.symmetric(vertical: 30.0),
          padding: EdgeInsets.symmetric(vertical: 50.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: <BoxShadow>[ // para dar sombreado 
              BoxShadow(
                color: Colors.black26,
                blurRadius: 3.0,
                //mas notorio el sombreado
                offset: Offset(0.0, 5.0),
                //con mas blur la sombra
                spreadRadius: 3.0
              )
            ]
          ),
          child: Column(
            children: <Widget>[
              Text("Ingreso", style: TextStyle(fontSize: 20.0),),
              SizedBox(height: 60.0,),
              _crearInputRut(bloc),
              SizedBox(height: 30.0 ,),
               _crearInputPassword(bloc),
              SizedBox(height: 30.0,),
              _crearBotonIngresar(bloc), 
            ],
          ),
        )
      ],
    ),
  );
}


Widget _crearInputRut(LoginBloc bloc){

     return StreamBuilder(
     stream: bloc.rutStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            icon: Icon(Icons.supervised_user_circle, color: Colors.blue),
            hintText: '12345678-0',
            labelText: 'Rut',
            counterText: snapshot.data,
              errorText: snapshot.hasError ? snapshot.error.toString():""
          ),
          onChanged: bloc.changedRut,
        ),
      );
    }
  );

  
} 

Widget _crearInputPassword(LoginBloc bloc){

  return StreamBuilder(
    stream: bloc.passwordStream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(Icons.vpn_key, color: Colors.blue,),
            labelText: 'Contraseña',
            counterText: snapshot.data,
            errorText: snapshot.hasError ? snapshot.error.toString():""
          ),
          onChanged: bloc.changedPassword,
        ),
      );
    }
  );
}

Widget _crearBotonIngresar(LoginBloc bloc){
  return StreamBuilder(
    stream: bloc.formValidStram,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return ElevatedButton(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
          child: Text("Ingresar"),
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)
            )
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)    
        ),
        onPressed: snapshot.hasData ? ()=> _login(bloc,context): null
      );
    }
  );
 }
 
  
_login(LoginBloc bloc, BuildContext context) async{
  
  _progressDialog = ProgressDialog(context, title: Text("Cargando") ,message: Text("Favor espere..."),dismissable: false);
  _progressDialog!.show();
  //mientras se muestra el cuadro de dialogo consulto por el metodo de login 
  Map respLogin = await  usuarioProvider.login(bloc.rut, bloc.password);

   if(respLogin['error']){
     _progressDialog!.dismiss();
    mostrarAlerta(context, respLogin['mensaje'],'Informacion Incorrecta',Consts.incorrecto);
  }else{

     _progressDialog!.dismiss();
    //almaceno en el storage el token y rut del usuario
    preferenciasUsuario.token = respLogin['token'].toString();
    preferenciasUsuario.usuRut = respLogin['usuRut'].toString();
    //una vez que este todo ok, paso a la pantalla del home
    Navigator.pushReplacementNamed(context, HomePage.routeName);
  } 
}


}