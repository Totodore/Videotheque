import 'package:flutter/material.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/Connexion/mainConnexion.dart';
// Create a Form widget.
class SubscriptionForm extends StatefulWidget {
  @override
  SubscriptionFormState createState() {
    return SubscriptionFormState();
  }
}
class SubscriptionFormState extends State<SubscriptionForm> {
  final _formKey = GlobalKey<FormState>();
  
  bool _showPassword = true;
  bool _showPasswordVerification = true;
  bool _showLoader = false;
  bool _disableButton = false;


  String _pass = "";
  String _user = "";
  String _mail = "";

  Icon _showPassIcon = Icon(Icons.visibility_off);
  Icon _showPassIconVerification = Icon(Icons.visibility_off);
  Color _iconButtonColor = GlobalsColor.darkGreen;

  OutlineInputBorder inputBorder = new OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(3)),
    borderSide: BorderSide(
      color: GlobalsColor.darkGreen,
      width: 2,
      style: BorderStyle.solid
    )
  );

  void register() {
    GlobalsFunc.fetchData("https://app-videotheque.scriptis.fr/php/subscribe.new.php?user="+_user+"&pass="+_pass+"&mail="+_mail)
    .then((data) {
      setState(() {
        _showLoader = false;
        _iconButtonColor = GlobalsColor.darkGreen;
        _disableButton = false;
      });
      if (data.body.isNotEmpty) {
        if (data.body == "creds error exists") {
          GlobalsFunc.snackBar(context, "Ouuups ! L'une des informations entrées existe déjà (mail, mot de passe, identifiant)", 6);
        } else if (data.body == "creds error size") {
          GlobalsFunc.snackBar(context, "Ouuups ! Le mot de passe et le nom d'utilisateur doivent faire au moins 4 caractères", 6);
        } else if (data.body == "creds error not found") {
          GlobalsFunc.snackBar(context, GlobalsMessage.errorConnect);
        }
      } else {
        GlobalsFunc.snackBar(context, "Votre compte à bien été créé !", 6);
        ConnexionState.tabCtrl.animateTo(0);
      }
    }).catchError((onError) {
        GlobalsFunc.snackBar(context, GlobalsMessage.errorConnect);
    });
  }
  @override
  Widget build(BuildContext context) {
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
                  decoration: InputDecoration(
                    border: inputBorder,
                    focusedBorder: inputBorder,
                    labelStyle: TextStyle(color: GlobalsColor.darkGreen),
                    labelText: "Nom d'utilisateur",
                    contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Veuillez entrer un nom d'utilisateur valide";
                    }
                    _user = value;
                    return null;
                  },
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.only(bottom: 10),
                title: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: inputBorder,
                    focusedBorder: inputBorder,
                    labelStyle: TextStyle(color: GlobalsColor.darkGreen),
                    labelText: "Email",
                    contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Veuillez entrer un email valide";
                    }
                    _mail = value;
                    return null;
                  },
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.only(bottom: 10),
                title: TextFormField(
                  obscureText: _showPassword,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    border: inputBorder,
                    focusedBorder: inputBorder,
                    labelStyle: TextStyle(color: GlobalsColor.darkGreen),
                    focusColor: GlobalsColor.darkGreen,
                    labelText: "Mot de passe",
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
                    if (value.isEmpty) {
                      return "Veuillez entrer un mot de passe valide";
                    }
                    _pass = value;
                    return null;
                  },
                  onChanged: (pass) {
                    _pass = pass;
                  },
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.only(bottom: 10),
                title: TextFormField(
                  obscureText: _showPasswordVerification,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    border: inputBorder,
                    focusedBorder: inputBorder,
                    labelStyle: TextStyle(color: GlobalsColor.darkGreen),
                    focusColor: GlobalsColor.darkGreen,
                    labelText: "Vérification du mot de passe",
                    contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
                    suffixIcon: IconButton(
                      icon: _showPassIconVerification,
                      color: GlobalsColor.lightGreen,
                      onPressed: () {
                        if (_showPasswordVerification) {
                          setState(() {
                            _showPasswordVerification = false;   
                            _showPassIconVerification = Icon(Icons.visibility);
                          });
                        } else {
                          setState(() {
                            _showPasswordVerification = true;
                            _showPassIconVerification = Icon(Icons.visibility_off);                       
                          });
                        }
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Veuillez entrer un mot de passe valide";
                    } else if (value != _pass) 
                      return "Les mots de passes ne correspondent pas";
                    return null;
                  },
                ),
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
                    child: Icon(Icons.done, color: _iconButtonColor, size: 40),
                    onPressed: () {
                      if (!_disableButton) {  //Si le bouton est activé
                        if (_formKey.currentState.validate()) { //Si le formulaire est validé
                          setState(() { //On change le statut du bouton
                            _showLoader = true;
                            _iconButtonColor = GlobalsColor.darkGreenDisabled;
                            _disableButton = true;
                          });
                          register();
                        } else return null;
                      }
                    }
                  )
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}