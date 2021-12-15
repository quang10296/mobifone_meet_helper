import 'dart:convert';
import 'package:flutter/material.dart';
import 'model/user_model.dart';
import 'screen/contacts.dart';
import 'package:http/http.dart' as http;

void main() {
  // getAppToken();
  runApp(MaterialApp(
    theme: new ThemeData(scaffoldBackgroundColor: Colors.white),
    home: MyApp(),
  ));
}

// Future<UserModel> authenticateUser(String username, String password) async {
//   final prefs = await SharedPreferences.getInstance();
//   final appToken = prefs.getString('appToken') ?? "";
//   print("app token : ${appToken}");
//   var headers = {'app-token': appToken, 'Content-Type': 'application/json'};

//   final response = await http.post(
//       Uri.parse('https://ott.mobifone.ai/api/account/login'),
//       body: json.encode(
//           {'username': username, 'password': password, "device": "Flutter"}),
//       headers: headers);

//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     print(UserModel.fromJson(jsonDecode(response.body)));
//     return new UserModel.fromJson(jsonDecode(response.body));
//   } else {
//     print("response.statusCode != 200");
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load album');
//   }
// }

Future<LicenseModel> getAppToken() async {
  final response = await http.post(
      Uri.parse('https://ott.mobifone.ai/api/token/apptoken'),
      body: json.encode(
          {"company_name": "MobiFone-ITC", "license": "MZ7D-SGHI-XR1Z-HER8"}),
      headers: {'Content-Type': 'application/json'});

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    // If the server did return a 200 OK response,
    final model = LicenseModel.fromJson(jsonDecode(response.body));
    // then parse the JSON.
    // final prefs = await SharedPreferences.getInstance();
    // final appToken = prefs.setString('appToken', model.data.appToken);
    return LicenseModel.fromJson(jsonDecode(response.body));
  } else {
    print("response.statusCode != 200");
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

abstract class SocketDelegate {
  void onCallComing(String name);
  void onCancelCall();
  void onRejectCall();
  void onAcceptCall();
  void onMissCall();
  void onEndCall();
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MyApp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(''),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Mobifone OTT',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    //forgot password screen
                  },
                  textColor: Colors.blue,
                  child: Text(''),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      style: raisedButtonStyle,
                      child: Text('Login'),
                      onPressed: () async {
                        print(nameController.text);
                        print(passwordController.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ContactScreen()),
                        );
                      },
                    )),
              ],
            )));
  }
}

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.white,
  primary: Colors.blue,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Thông Báo"),
    content: Text("Sai tên đăng nhập hoặc mật khẩu."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
