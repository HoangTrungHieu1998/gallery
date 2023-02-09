
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery/constant.dart';
import 'package:gallery/services/auth_service.dart';

import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: const EdgeInsets.all(10),child: Image.asset(Constant.imageLogin),),
              const SizedBox(height: 100,),
              FloatingActionButton.extended(
                onPressed: (){
                  signInGoogle();
                },
                label: const Text(
                  "Sign in with Google",
                  style: TextStyle(color: Colors.black),
                ),
                icon: Image.asset(
                  Constant.imageGoogle,
                  height: 32, width: 32,
                ),
                backgroundColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  void signInGoogle(){
    authService.signInWithGoogle().then((UserCredential? user){
      if(user !=null){
        authentication(user);
      }
    });
  }

  void authentication(UserCredential user) {
    authService.authenticateUser(user).then((isNewUser){
      if(isNewUser){
        authService.addDataToDB(user: user).then((value)
        => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const HomeScreen())));
      }else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const HomeScreen()));
      }
    });
  }
}
