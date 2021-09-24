// ignore_for_file: unused_local_variable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Vistas/principal.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.red
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class LoginForm extends StatefulWidget {
  final TargetPlatform platform;
  LoginForm({
    this.platform,
  });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool visibilityObs = false;
  bool _isHidden = true;
  String _usuario;
  String _password;
  int idCliente = 0;
  String url;
  final formkey = GlobalKey<FormState>();
  String tokenT;
  // ignore: unused_field
  String _debugLabelString = "";
  String _emailAddress = 'tirado1294@gmail.com';
  
  // ignore: unused_field
  bool _enableConsentButton = false;
  bool _requireConsent = true;
  String _idOneSignal = "";
  bool visibility = false;

  @override
  void initState() {
    _handleConsent();
    initPlatformState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _saveValue("");
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            color: const Color(0xff7c94b6),
            image: DecorationImage(
              image: AssetImage("images/Fondo06.png"),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.only(
            top: 40.0,
            left: 50.0,
            right: 50.0,
          ),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                SizedBox(height: 20.0),
                Container(
                  width: 130.0,
                  height: 130.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color.fromRGBO(9, 46, 116, 1.0),
                    ),
                    image: DecorationImage(
                      image: AssetImage(
                        'images/cmr.png',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                TextFormField(
                  autocorrect: false,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 20),
                  cursorColor: Colors.white,
                  cursorRadius: Radius.circular(1.0),
                  cursorWidth: 2.0,
                  decoration: const InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    fillColor: Color.fromRGBO(9, 46, 116, 1.0),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    hintText: 'USUARIO',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  onSaved: (text) {
                    _usuario = text;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      _changed(visibility);
                      return "Este campo es necesario";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 25.0),
                TextFormField(
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 20),
                  enableSuggestions: false,
                  obscureText: !this._isHidden,
                  cursorHeight: 20,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: this._isHidden ? Colors.white : Colors.blue,
                      ),
                      onPressed: () {
                        setState(() => this._isHidden = !this._isHidden);
                      },
                    ),
                    fillColor: Color.fromRGBO(9, 46, 116, 1.0),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    hintText: 'CONTRASEÑA',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  onSaved: (text) {
                    _password = text;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      _changed(visibility);
                      return "Este campo es necesario";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 25.0),
                ElevatedButton(
                  onPressed: () {
                    //metodo para cambiar de pantalla
                    //Navigator.pushNamed(context, '/inicio');
                    idCliente = 0;
                    _showSecondPage(context);
                  },
                  child: const Text(
                    'INICIAR SESIÓN',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    //Color de fondo del boton
                    primary: Colors.orange[800],
                    shape: RoundedRectangleBorder(
                      //borde del boton
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 9.0,
                  ),
                ),
                SizedBox(height: 25.0),
                Container(
                  child: Center(
                    child: new RichText(
                      textAlign: TextAlign.center,
                      text: new TextSpan(
                        text:
                            'Clic aquí para solicitar acceso a la versión de prueba',
                        style: new TextStyle(
                          color: Color.fromRGBO(9, 46, 116, 1.0),
                          decorationThickness: 2,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            launch(
                                'https://api.whatsapp.com/send/?phone=529511911121&text=Hola%21%21+quiero+obtener+acceso+a+la+versi%C3%B3n+de+prueba+de+la+aplicaci%C3%B3n.&app_absent=0');
                          },
                      ),
                    ),
                  ),
                ),
                Container(
                  height: visibility
                      ? MediaQuery.of(context).size.height - 580
                      : MediaQuery.of(context).size.height - 630,
                  child: Center(
                    child: Text(
                      'CREAMOS GESTIONES EXITOSAS',
                      style: TextStyle(
                        color: Color.fromRGBO(179, 179, 179, 1.0),
                        fontSize: 25,
                        decorationThickness: 2,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 25,
          decoration: BoxDecoration(
            color: Color.fromRGBO(9, 46, 116, 1.0),
          ),
          child: Center(
            child: new RichText(
              text: new TextSpan(
                children: [
                  new TextSpan(
                    text: 'Desarrollado por ',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  new TextSpan(
                    text: 'INGENINN 360',
                    style: new TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launch('https://www.ingeninn360.com/');
                      },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //metodo para cambiar pantalla
  void _showSecondPage(BuildContext context) {
    
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.white
      ..backgroundColor = Colors.transparent
      ..boxShadow = [BoxShadow(color: Colors.transparent)]
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.black.withOpacity(0.88)
      ..userInteractions = true
      ..dismissOnTap = false;

    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      url =
          "http://sistema.mrcorporativo.com/api/getUsuario/$_usuario,$_password,$_idOneSignal";
      EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
      EasyLoading.show(
        indicator: Container(
          height: 100,
          width: 120,
          child: SpinKitCubeGrid(
            size: 90,
            duration: Duration(milliseconds: 900),
            itemBuilder: (BuildContext context, int index) {
              int i = index + 1;
              return DecoratedBox(
                decoration: BoxDecoration(
                  /*color: index.isEven ? Colors.red : Colors.green,*/
                  image: DecorationImage(
                    image: AssetImage("images/icono$i.png"),
                  ),
                ),
              );
            },
          ),
        ),
        maskType: EasyLoadingMaskType.custom,
      );
      _getListado();
    }
  }

  List<Widget> listado(List<dynamic> info) {
    List<Widget> lista = [];
    info.forEach((elemento) {
      int elementoCliente = elemento['id_cliente'];
      lista.add(Text("$elementoCliente"));
    });
    return lista;
  }

  Future<dynamic> _getListado() async {
    try {
      final respuesta = await http.get(Uri.parse(url));

      if (respuesta.statusCode == 200) {
        if (respuesta.body != "") {
          final data = json.decode(respuesta.body);

          data.forEach((e) {
            idCliente = e['id_cliente'];
            tokenT = e['remember_token'];
          });
          _saveValue(tokenT);
          _login(idCliente);
          return jsonDecode(respuesta.body);
        } else {
          EasyLoading.instance
            ..displayDuration = const Duration(milliseconds: 2000)
            ..indicatorType = EasyLoadingIndicatorType.fadingCircle
            ..loadingStyle = EasyLoadingStyle.dark
            ..indicatorSize = 45.0
            ..radius = 10.0
            ..progressColor = Colors.white
            ..backgroundColor = Colors.transparent
            ..boxShadow = [BoxShadow(color: Colors.transparent)]
            ..indicatorColor = Colors.blue[700]
            ..indicatorSize = 70
            ..textStyle = TextStyle(
                color: Colors.grey[500],
                fontSize: 20,
                fontWeight: FontWeight.bold)
            ..maskColor = Colors.black.withOpacity(0.88)
            ..userInteractions = false
            ..dismissOnTap = true;
          EasyLoading.dismiss();
          EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
          EasyLoading.showError(
            'Error de conexión',
            maskType: EasyLoadingMaskType.custom,
          );
          return null;
        }
      } else {
        EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 2000)
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = EasyLoadingStyle.dark
          ..indicatorSize = 45.0
          ..radius = 10.0
          ..progressColor = Colors.white
          ..backgroundColor = Colors.transparent
          ..boxShadow = [BoxShadow(color: Colors.transparent)]
          ..indicatorColor = Colors.blue[700]
          ..indicatorSize = 70
          ..textStyle = TextStyle(
              color: Colors.grey[500],
              fontSize: 20,
              fontWeight: FontWeight.bold)
          ..maskColor = Colors.black.withOpacity(0.88)
          ..userInteractions = false
          ..dismissOnTap = true;
        EasyLoading.dismiss();
        EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
        EasyLoading.showError(
          'Error de conexión',
          maskType: EasyLoadingMaskType.custom,
        );
      }
    } catch (e) {
      EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 2000)
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = EasyLoadingStyle.dark
          ..indicatorSize = 45.0
          ..radius = 10.0
          ..progressColor = Colors.white
          ..backgroundColor = Colors.transparent
          ..boxShadow = [BoxShadow(color: Colors.transparent)]
          ..indicatorColor = Colors.blue[700]
          ..indicatorSize = 70
          ..textStyle = TextStyle(
              color: Colors.grey[500],
              fontSize: 20,
              fontWeight: FontWeight.bold)
          ..maskColor = Colors.black.withOpacity(0.88)
          ..userInteractions = false
          ..dismissOnTap = true;
        EasyLoading.dismiss();
        EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
        EasyLoading.showError(
          'Error de conexión',
          maskType: EasyLoadingMaskType.custom,
        );
      return null;
    }
  }

  void _changed(bool visibility) {
    setState(
      () {
        visibility = !visibility;
      },
    );
  }

  void _login(
    idCliente,
  ) {
    EasyLoading.dismiss();
    Navigator.pushReplacementNamed(context, '/inicio',
        arguments: Welcome(
          cliente: idCliente,
        ));
  }

  _saveValue(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };

    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      this.setState(() {
        _debugLabelString =
            "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      this.setState(() {
        _debugLabelString =
            "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {
      this.setState(() {
        _debugLabelString =
            "In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      //print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      //print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges changes) {
      //print("EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    });

    // NOTE: Replace with your own app ID from https://www.onesignal.com
    await OneSignal.shared
        .init("c1bfe080-0e68-4974-97e2-914afc5b7501", iOSSettings: settings);

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();

    this.setState(() {
      _enableConsentButton = requiresConsent;
    });

    // Some examples of how to use In App Messaging public methods with OneSignal SDK
    oneSignalInAppMessagingTriggerExamples();

    // Some examples of how to use Outcome Events public methods with OneSignal SDK
    oneSignalOutcomeEventsExamples();

    _handleSetEmail();
  }

  void _handleSetEmail() {
    if (_emailAddress == null) return;

    OneSignal.shared.setEmail(email: _emailAddress).whenComplete(() {
      //print("Successfully set email");
      initPlatformState1();
    }).catchError((error) {
      //print("Failed to set email with error: $error");
    });
  }

  Future<void> initPlatformState1() async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    _idOneSignal = status.subscriptionStatus.userId;
    if (status.permissionStatus.hasPrompted)
    // we know that the user was prompted for push permission

    if (status.permissionStatus.status ==
        OSNotificationPermission.notDetermined)
    // boolean telling you if the user enabled notifications

    if (status.subscriptionStatus.subscribed) {}

    // the user's APNS or FCM/GCM push token
    
    String token = status.subscriptionStatus.pushToken;

    String emailPlayerId = status.emailSubscriptionStatus.emailUserId;
    String emailAddress = status.emailSubscriptionStatus.emailAddress;
  }

  void _handleConsent() {
    //print("Setting consent to true");
    OneSignal.shared.consentGranted(true);

    //print("Setting state");
    this.setState(() {
      _enableConsentButton = false;
    });
  }

  oneSignalInAppMessagingTriggerExamples() async {
    /// Example addTrigger call for IAM
    /// This will add 1 trigger so if there are any IAM satisfying it, it
    /// will be shown to the user
    OneSignal.shared.addTrigger("trigger_1", "one");

    /// Example addTriggers call for IAM
    /// This will add 2 triggers so if there are any IAM satisfying these, they
    /// will be shown to the user
    Map<String, Object> triggers = new Map<String, Object>();
    triggers["trigger_2"] = "two";
    triggers["trigger_3"] = "three";
    OneSignal.shared.addTriggers(triggers);

    // Removes a trigger by its key so if any future IAM are pulled with
    // these triggers they will not be shown until the trigger is added back
    OneSignal.shared.removeTriggerForKey("trigger_2");

    // Get the value for a trigger by its key
    Object triggerValue =
        await OneSignal.shared.getTriggerValueForKey("trigger_3");
    //print("'trigger_3' key trigger value: " + triggerValue.toString());

    // Create a list and bulk remove triggers based on keys supplied
    List<String> keys = ["trigger_1", "trigger_3"];
    OneSignal.shared.removeTriggersForKeys(keys);

    // Toggle pausing (displaying or not) of IAMs
    OneSignal.shared.pauseInAppMessages(false);
  }

  oneSignalOutcomeEventsExamples() async {
    // Await example for sending outcomes
    outcomeAwaitExample();

    // Send a normal outcome and get a reply with the name of the outcome
    OneSignal.shared.sendOutcome("normal_1");
    OneSignal.shared.sendOutcome("normal_2").then((outcomeEvent) {
      //print(outcomeEvent.jsonRepresentation());
    });

    // Send a unique outcome and get a reply with the name of the outcome
    OneSignal.shared.sendUniqueOutcome("unique_1");
    OneSignal.shared.sendUniqueOutcome("unique_2").then((outcomeEvent) {
      //print(outcomeEvent.jsonRepresentation());
    });

    // Send an outcome with a value and get a reply with the name of the outcome
    OneSignal.shared.sendOutcomeWithValue("value_1", 3.2);
    OneSignal.shared.sendOutcomeWithValue("value_2", 3.9).then((outcomeEvent) {
      //print(outcomeEvent.jsonRepresentation());
    });
  }

  Future<void> outcomeAwaitExample() async {
    var outcomeEvent = await OneSignal.shared.sendOutcome("await_normal_1");
    //print(outcomeEvent.jsonRepresentation());
  }
}
