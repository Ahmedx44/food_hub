import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_hub/features/auth/data/model/reset_model.dart';
import 'package:food_hub/features/auth/data/model/sigin_model.dart';
import 'package:food_hub/features/auth/data/model/signup_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthService {
  Future<Either<String, String>> signinWithGoogle();
  Future<Either<String, String>> signin(SigninModel signinModel);
  Future<Either<String, String>> signup(SignupModel signupModel);
  Future<Either<String, String>> resetPassword(ResetModel resetModel);
}

class AuthServiceImpl extends AuthService {
  final _auth = FirebaseAuth.instance;

  // Google Sign-In
  @override
  Future<Either<String, String>> signinWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        return const Left('Google sign-in was canceled');
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User? userDetail = result.user;

      if (userDetail != null) {
        // User data for Firestore
        Map<String, dynamic> userInfoMap = {
          'email': userDetail.email,
          'fullName': userDetail.displayName,
          'imageUrl': userDetail.photoURL
        };

        // Save user to Firestore
        await FirebaseFirestore.instance
            .collection('User')
            .doc(userDetail.uid)
            .set(userInfoMap, SetOptions(merge: true));

        return const Right('Successfully signed in with Google');
      } else {
        return const Left('Failed to sign in with Google');
      }
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'Google Sign-In failed');
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Email Sign-In
  @override
  Future<Either<String, String>> signin(SigninModel signinModel) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: signinModel.email, password: signinModel.password);
      return const Right('User successfully logged in');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'wrong-password') {
        message = 'Wrong password';
      } else if (e.code == 'user-not-found') {
        message = 'User with that email not found';
      } else {
        message = 'Something went wrong';
      }
      return Left(message);
    }
  }

  // Email Sign-Up
  @override
  Future<Either<String, String>> signup(SignupModel signupModel) async {
    try {
      final UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: signupModel.email, password: signupModel.password);

      await FirebaseFirestore.instance
          .collection('User')
          .doc(user.user!.uid)
          .set({
        'email': signupModel.email,
        'username': signupModel.username,
      });

      return const Right('User account successfully created!');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'Your password is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with this email';
      } else {
        message = 'There was an error creating the account';
      }

      return Left(message);
    }
  }

  @override
  Future<Either<String, String>> resetPassword(ResetModel resetModel) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: resetModel.email);
      return const Right('Rest link has been sent to your email');
    } catch (e) {
      return const Left('Some Error Occured');
    }
  }
}
