import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _nome = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _senha = TextEditingController();

  String _msgError = "";
  bool _focusEmail = true;
  bool _focusSenha = false;
  final _formKey = GlobalKey<FormState>();

  void _falhaCadastro(PlatformException erro, BuildContext context) {
    setState(() {
      _msgError = "Falha ao realizar login, tente novamente em isntantes!";
    });
    if (erro.code == "ERROR_WEAK_PASSWORD") {
      setState(() {
        _msgError = "Senha invalida!";
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
          appBar: AppBar(
            title: Text("Cadastro"),
            actions: <Widget>[],
          ),
          body: Container(
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
                            return 'Informe seu nome!';
                          }
                          return null;
                        },
                        controller: _nome,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: "Nome",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: Colors.white),
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
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Informe uma Senha!';
                        }
                        return null;
                      },
                      controller: _senha,
                      obscureText: true,
                      autofocus: true,
                      keyboardType: TextInputType.text,
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
                          "Cadastrar",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        color: Colors.green,
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            auth
                                .createUserWithEmailAndPassword(
                                    email: _email.text, password: _senha.text)
                                .then((user) {
                              //Caso der certo
                              print("OK");
                              print(user.toString());
                            }).catchError((erro) {
                              _falhaCadastro(erro, context);
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
        ));
  }
}
