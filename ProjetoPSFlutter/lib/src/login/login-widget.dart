import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:ProjetoPSFlutter/src/login/login-bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
       bloc: LoginBloc(context),
       child: Material(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            //Image
            Container(
              color: Colors.grey[800].withOpacity(0.4),
            ),
            SingleChildScrollView(child: _LoginContent()),
          ],
        ),    
       )
    );
  }
}

class _LoginContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

  LoginBloc bloc = BlocProvider.of<LoginBloc>(context);


    _botao(){
      return Column(
        
        children: <Widget>[
          RaisedButton.icon(
            color: Colors.green,
            textColor: Colors.white,
            icon: Icon(Icons.phone),
            label: Text("Login Telefone  "),
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
            onPressed: bloc.onClickTelefone,
          ),
            
          RaisedButton.icon(
            color: Colors.blue ,
            textColor: Colors.white,
            icon: Icon(FontAwesomeIcons.facebookF),
            label: Text("Login Facebook"),
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
            onPressed: bloc.onClickFacebook,
          ),
            
          RaisedButton.icon(
            color: Colors.red,
            textColor: Colors.white,
            icon: Icon(FontAwesomeIcons.google),
            label: Text("Login Google     "),
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
            onPressed: bloc.onClickGoogle,
          ),
        ],
      );
    }

    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlutterLogo(size: 72,),
          Container(height: 150,),
          StreamBuilder(
             stream: bloc.outLoading,
             initialData: false,
             builder: (BuildContext context, AsyncSnapshot snapshot) {
               return AnimatedCrossFade(                
                firstChild: _botao(),
                secondChild: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ), 
              crossFadeState: snapshot.data ? CrossFadeState.showSecond : CrossFadeState.showFirst, 
              duration: Duration(milliseconds: 500)
              );
             },
          ),  
          TextField(
            onChanged: (String valor) => bloc.phoneEvent.add,
            onSubmitted: (String value) => bloc.onClickTelefone(),
            
          )
        ],
      ),
    );
  }
}
