import 'package:Videotheque/app/appMain.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Videotheque/globals.dart';
// Create a Form widget.
class ConnexionForm extends StatefulWidget {
  @override
  ConnexionFormState createState() {
    return ConnexionFormState();
  }
}
class ConnexionFormState extends State<ConnexionForm> {

  final _formKey = GlobalKey<FormState>();
  bool _switchState = true;
  bool _showPassword = true;
  bool _showLoader = false;
  bool _disableButton = false;
  Icon _showPassIcon = Icon(Icons.visibility_off);
  String _user;
  String _pass;
  String _emailAsk;
  String _errorUser = null;
  String _errorPass = null;
  BuildContext _connexionContext = null;

  Color _iconButtonColor = GlobalsColor.darkGreen;
  TextEditingController _userCtrl;  
  TextEditingController _passCtrl;

  Future<List<String>> _read() async {
    final prefs = await SharedPreferences.getInstance();
    String _user = prefs.getString("user") ?? "";
    String _pass = prefs.getString("pass") ?? "";
    return [_user, _pass];
  }

  Future<bool> _save(key, val) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, val);
  }

  OutlineInputBorder inputBorder = new OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(3)),
    borderSide: BorderSide(
      color: GlobalsColor.darkGreen,
      width: 2,
      style: BorderStyle.solid
    )
  );

  @override
  void initState() {
    super.initState();
    _read().then((creds) {
      setState(() {
        _user = creds[0];
        _pass = creds[1];
        _userCtrl = TextEditingController(text: _user);
        _passCtrl = TextEditingController(text: _pass);
      });
    }); 
  }

  void checkCreds() {
    GlobalsFunc.fetchData("https://app-videotheque.scriptis.fr/php/checkCreds.php?user="+_user+"&pass="+_pass)
      .then((message) {
        if (message.body.isNotEmpty) {
          setState(() {
            _showLoader = false;
            _iconButtonColor = GlobalsColor.darkGreen;
            _disableButton = false;
          });
        } else { checkMail(); return; }
        if (message.body == GlobalsMessage.errorConnect) {
          GlobalsFunc.snackBar(context, GlobalsMessage.errorConnect);
          print("param error");
        } else if (message.body == GlobalsMessage.errorUserConnect) {
          setState(() {                                
            _errorUser = GlobalsMessage.errorUserConnect;
          });
        } else if (message.body == GlobalsMessage.errorPassConnect) {
          setState(() {
            _errorPass = GlobalsMessage.errorPassConnect;
          });
        }
      }).catchError((onError) {
        print(onError);
        GlobalsFunc.snackBar(context, GlobalsMessage.errorConnect);
        setState(() {
          _showLoader = false;
          _iconButtonColor = GlobalsColor.darkGreen;
          _disableButton = false;
        });
      });
  }

  void checkMail() {
    GlobalsFunc.fetchData("https://app-videotheque.scriptis.fr/php/checkEmail.php?user="+_user)
      .then((response) {
        if (response.body == "true") {
          GlobalsFunc.snackBar(context, "Connecté");
          print("Request launched");
          Navigator.pushNamed(context, "/app", arguments: MainAppRoute(_user, _pass));
        } else {
          dispAskMail();
        }
      }).catchError((error) {
        print(error);
        GlobalsFunc.snackBar(context, GlobalsMessage.errorConnect);
      }).whenComplete(() {
        setState(() {
          _showLoader = false;
          _iconButtonColor = GlobalsColor.darkGreen;
          _disableButton = false;
        });
      });
  }

  Future <void> dispAskMail() async {
    await showDialog<ConnexionForm> (
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.all(10),
          title: Text("Email requis"),
          children: <Widget>[
            Text(
              GlobalsMessage.askMail,
              textAlign: TextAlign.justify,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: GlobalsColor.darkGreen)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: GlobalsColor.darkGreen, width: 2)),
                labelText: "Email",
                focusColor: GlobalsColor.darkGreen,
                labelStyle: TextStyle(color: GlobalsColor.darkGreen, decorationColor: GlobalsColor.darkGreen)
              ),
              onChanged: (val) {
                _emailAsk = val;
              },
            ),
            FlatButton(
              child: Text("Envoyer"),
              onPressed: () {
                print("envoyer");
                Navigator.pop(context);
                setState(() { //On change le statut du bouton
                  _showLoader = true;
                  _iconButtonColor = GlobalsColor.darkGreenDisabled;
                  _disableButton = true;
                });
                GlobalsFunc.fetchData("https://app-videotheque.scriptis.fr/php/upload_email.php?mail="+_emailAsk+"&user="+_user+"&pass="+_pass)
                .then((data) {
                  if (data.body.isNotEmpty) {
                    GlobalsFunc.snackBar(_connexionContext, GlobalsMessage.errorMail, 6);
                  } else {
                    setState(() {
                      _showLoader = false;
                      _iconButtonColor = GlobalsColor.darkGreen;
                      _disableButton = false;
                    });
                    print("Request launched");
                    Navigator.pushNamed(_connexionContext, "/app", arguments: MainAppRoute(_user, _pass));
                  }
                }).catchError((onError) {
                  print(onError);
                  GlobalsFunc.snackBar(_connexionContext, GlobalsMessage.errorMail, 6);
                  setState(() {
                    _showLoader = false;
                    _iconButtonColor = GlobalsColor.darkGreen;
                    _disableButton = false;
                  });
                });
              },
            )
          ],
        );
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    _connexionContext = context;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.only(bottom: 10),
                title: TextFormField(
                  controller: _userCtrl,
                  decoration: InputDecoration(
                    border: inputBorder,
                    focusedBorder: inputBorder,
                    errorText: _errorUser,
                    labelStyle: TextStyle(
                      color: GlobalsColor.darkGreen,
                    ),
                    labelText: "Nom d'utilisateur",
                    contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
                  ),
                  validator: (value) {
                    //Error case
                    if (value.isEmpty) 
                      return "Veuillez entrer un nom d'utilisateur valide";
                    //Success case
                    _user = value;
                    return null;
                  },
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.only(bottom: 10),
                title: TextFormField(
                  obscureText: _showPassword,
                  controller: _passCtrl,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    border: inputBorder,
                    focusedBorder: inputBorder,
                    labelStyle: TextStyle(color: GlobalsColor.darkGreen),
                    focusColor: GlobalsColor.darkGreen,
                    labelText: "Mot de passe",
                    errorText: _errorPass,
                    contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
                    suffixIcon: IconButton(
                      icon: _showPassIcon,
                      color: GlobalsColor.lightGreen,
                      onPressed: () {
                        if (_showPassword) {
                          setState(() {
                            _showPassword = false;   
                            _showPassIcon = Icon(Icons.visibility);
                          });
                        } else {
                          setState(() {
                            _showPassword = true;
                            _showPassIcon = Icon(Icons.visibility_off);                       
                          });
                        }
                      },
                    ),
                  ),
                  validator: (value) {
                    //Error case
                    if (value.isEmpty) 
                      return "Veuillez entrer un mot de passe valide";

                    //Success case
                    _pass = value;
                    return null;
                  },
                ),
              ),
              SwitchListTile(
                title: new Text("Sauvegarder mon mot de passe"),
                value: _switchState,
                onChanged: (val) {
                  setState(() {
                    _switchState = val;              
                  });
                },
                activeColor: GlobalsColor.lightGreen,            
              ),
              Stack(
                fit: StackFit.passthrough,
                overflow: Overflow.clip,
                children: <Widget>[
                  Visibility(
                    visible: _showLoader,
                    child: Padding(padding: EdgeInsets.only(left: 3, top: 3, right: 0, bottom: 0), child: SizedBox(
                      width: 85,
                      height: 85,
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                        valueColor: AlwaysStoppedAnimation<Color>(GlobalsColor.darkGreen)
                      ),
                    )),
                  ),
                  RawMaterialButton(
                    padding: EdgeInsets.all(25),
                    shape: CircleBorder(side: BorderSide(color: _iconButtonColor, width: 2)),
                    enableFeedback: !_disableButton,
                    child: Icon(Icons.arrow_forward, color: _iconButtonColor, size: 40),
                    onPressed: () {
                      setState(() {
                        _errorPass = null;
                        _errorUser = null;
                      });
                      if (!_disableButton) {  //Si le bouton est activé
                        if (_formKey.currentState.validate()) { //Si le formulaire est validé
                          if (_switchState) { //Si on sauvegarde le mot de passe
                            _save("user", _user).then((success) {
                              print("user saved : " + _user);
                            });
                            _save("pass", _pass).then((success) {
                              print("pass saved : " + _pass);
                            });
                          }
                          setState(() { //On change le statut du bouton
                            _showLoader = true;
                            _iconButtonColor = GlobalsColor.darkGreenDisabled;
                            _disableButton = true;
                          });
                          checkCreds();
                        } else return null;
                      }
                    },
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 35),
                child: Text(
                  "Cette application requiert une connexion internet stable et fluide, dans le cas contraire il se pourrait qu\'il y ait certains problèmes de connexion.",
                  textAlign: TextAlign.justify
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}