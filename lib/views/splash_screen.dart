import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gallery/services/auth_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../constant.dart';
import 'home/home_screen.dart';
import 'login/login_screen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Timer _timer;
  double _start = 2;
  late AuthService authService;

  void startTimer() {
    const oneSec = Duration(milliseconds: 500);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            authService = AuthService();
            if(authService.getCurrentUser() == null){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const LoginScreen()));
            }else{
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const HomeScreen()));
            }

          });
        } else {
          setState(() {
            _start-= 0.5;
          });
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: const EdgeInsets.all(50),child: Image.asset(Constant.imageGallery),),
              const SizedBox(height: 100,),
              LoadingAnimationWidget.flickr(
                rightDotColor: Colors.black,
                leftDotColor: const Color(0xff0bb3c2),
                size: 25,
              )
            ],
          ),
        ),
      ),
    );
  }
}