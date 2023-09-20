import 'dart:html';

import 'package:flutter/material.dart';
import 'package:project_june1/stateful%20login%20with%20validation.dart';
import 'package:project_june1/storages%20in%20flutter/shared%20preferences/simple%20login%20using%20shared%20pref/shared-home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  runApp(MaterialApp(home: LoginShared(),));
}
class LoginShared extends StatefulWidget {
  @override
  State<LoginShared> createState() => _LoginSharedState();
}
class _LoginSharedState extends State<LoginShared> {
  final name =TextEditingController();
  final email = TextEditingController();
  final pwd = TextEditingController();
  late SharedPreferences preferences;
  late bool newuser;

  @override
  void initState() {
    check_if_user_already_login();
    super.initState();
  }

  void check_if_user_already_login() async{
    preferences = await SharedPreferences.getInstance();
    //?? - if the condition is null fetch the second value
    //check whether the user is already logged in, if getBool('userlogin') is null
    // which means user is new
    newuser = preferences.getBool('newuser') ?? true;
    if(newuser == false){
      Navigator.push(context, MaterialPageRoute(
          builder: (context)=>SharedHome()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration page"),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Username'),
                controller: name,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Password'),
                controller: pwd,
              ),
            ),
            Padding(padding:const EdgeInsets.all(10.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder() , hintText: 'email'),
              controller: email,
            ),),

            ElevatedButton(
                onPressed: () async {
                  //shared preference instance creation
                  preferences = await SharedPreferences.getInstance();
                  String username = email.text;
                  String password = pwd.text;

                  if (username != "" && password != "") {
                    preferences.setString('uname', username);
                    preferences.setString('pword', password);
                    //set the user logged in
                    preferences.setBool('newuser', false);

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(
                            builder: (context) => SharedHome()));
                  }
                  //to clear text fields
                  name.text="";
                  email.text = "";
                  pwd.text = "";

                },
                child: const Text("Login"))
          ],
        ),
      ),
    );
  }
  void storedata()async{
    String personname=name.text;
    String password=pwd.text;

    preferences = await SharedPreferences.getInstance();
    preferences.setString('name', personname);
    preferences.setString('pass', password);

    Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Login2()));


  }

}