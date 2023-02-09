
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery/blocs/gallery_bloc/gallery_bloc.dart';
import 'package:gallery/models/photo.dart';
import 'package:gallery/services/image_service.dart';
import 'package:gallery/views/home/home_screen.dart';
import 'package:gallery/views/login/login_screen.dart';
import 'package:gallery/views/splash_screen.dart';

import 'package:http/http.dart' as http;

import 'constant.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>GalleryBloc(imageService: ImageService(client: http.Client()))..add(const GetImageFromApi(1)))
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashPage(),
      ),
    );
  }
}
