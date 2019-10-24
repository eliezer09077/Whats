import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whats_app/pages/Cadastro.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _msgError = "";
  bool _focusEmail = true;
  bool _focusSenha = false;

  void _falhaLogin(PlatformException erro, BuildContext context) {
    setState(() {
      _msgError = "Falha ao realizar login, tente novamente em isntantes!";
    });
    if (erro.code == "ERROR_WEAK_PASSWORD") {
      setState(() {
        _msgError = "Senha invalida!";
      });
    } else if (erro.code == "ERROR_USER_NOT_FOUND") {
      setState(() {
        _msgError = "E-mail não localizado, revise o mesmo!";
      });
    }
    final snackbar = SnackBar(
        //backgroundColor: Colors.green,
        duration: Duration(seconds: 10),
        content: Text(_msgError));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
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
                        "imagens/logo.png",
                        width: 200,
                        height: 150,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Informe um E-mail!';
                          } else if (!value.contains("@")) {
                            return 'Informe um E-mail valido!';
                          }
                          return null;
                        },
                        controller: _controllerEmail,
                        autofocus: _focusEmail,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: "E-mail",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: Colors.white),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Informe uma Senha!';
                        }
                        return null;
                      },
                      controller: _controllerSenha,
                      obscureText: true,
                      autofocus: _focusSenha,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Senha",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 10),
                      child: RaisedButton(
                        child: Text(
                          "Entar",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        color: Colors.green,
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            auth
                                .signInWithEmailAndPassword(
                                    email: _controllerEmail.text,
                                    password: _controllerSenha.text)
                                .then((user) {
                              //Caso der certo
                              print("OK");
                              print(user.toString());
                            }).catchError((erro) {
                              _falhaLogin(erro, context);
                            });
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 14),
                      child: Center(
                        child: GestureDetector(
                          child: Text(
                            "Nao tem Conta?, Cadastre-se",
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Cadastro()));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )));
  }
}
