import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class RecuperarSenha extends StatefulWidget {
  @override
  _RecuperarSenhaState createState() => _RecuperarSenhaState();
}

class _RecuperarSenhaState extends State<RecuperarSenha> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _email = TextEditingController();

  String _msgError = "";
  final _formKey = GlobalKey<FormState>();

  void _falhaRecuperar(PlatformException erro, BuildContext context) {
    switch (erro.code) {
      case "ERROR_INVALID_EMAIL":
        setState(() {
          _msgError = "E-mail invalido!";
        });
        break;
      case "ERROR_USER_NOT_FOUND":
        setState(() {
          _msgError = "E-mail não encontrado!";
        });
        break;
      default:
        setState(() {
          _msgError = "Falha ao realizar login, tente novamente em isntantes!";
        });
    }
    final snackbar = SnackBar(
        //backgroundColor: Colors.green,
        duration: Duration(seconds: 7),
        content: Text(_msgError));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Recuperar Senha"),
              actions: <Widget>[],
            ),
            body: Builder(
              builder: (context) => Container(
                decoration: BoxDecoration(color: Color(0xff075E54)),
                padding: EdgeInsets.all(16),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 32),
                          child: Image.asset(
                            "imagens/usuario.png",
                            width: 200,
                            height: 150,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Informe seu E-Mail!';
                                } else if (!value.contains("@")) {
                                  return 'Informe um E-mail valido!';
                                }
                                return null;
                              },
                              controller: _email,
                              autofocus: true,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(32, 16, 32, 16),
                                  hintText: "E-mail",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  filled: true,
                                  fillColor: Colors.white),
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 16, bottom: 10),
                          child: RaisedButton(
                            child: Text(
                              "Recuperar",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: Colors.green,
                            padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32)),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                auth
                                    .sendPasswordResetEmail(email: _email.text)
                                    .then((user) {
                                  //Caso der certo
                                  print("OK");
                                }).catchError((erro) {
                                  _falhaRecuperar(erro, context);
                                });
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
