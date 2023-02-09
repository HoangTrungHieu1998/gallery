
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constant.dart';
import '../models/user_model.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: <String>["email"]
  );
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final CollectionReference _userCollection = firestore.collection(Constant.userCollection);
  UserModel userModel = UserModel();

  User? getCurrentUser(){
    return _auth.currentUser;
  }

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    print("AAA:$googleUser");

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await _auth.signInWithCredential(credential);
  }

  Future<bool> authenticateUser (UserCredential user) async{
    QuerySnapshot result = await firestore
        .collection(Constant.userCollection).where(Constant.emailField,isEqualTo: user.user?.email).get();
    final List<DocumentSnapshot> docs = result.docs;

    // If user is register then doc is not empty
    return docs.isEmpty ? true:false;
  }

  Future<void> addDataToDB ({required UserCredential user, String? username}) async{
    userModel = UserModel(
        uid: user.user?.uid,
        name: user.user?.displayName ?? username,
        email: user.user?.email,
        username: user.user?.email
    );
    firestore.collection(Constant.userCollection).doc(user.user!.uid).set(userModel.toJson(userModel) as Map<String,dynamic>);
  }
}