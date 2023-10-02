import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:street_calle/main.dart';
import 'package:street_calle/models/user.dart' as userModel;
import 'package:street_calle/utils/constant/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Either<String ,User?>> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(userCredential.user);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return const Left('Email address is already in use.');
        // case 'weak-password':
        //   return const Left('Password is too weak. Please choose a stronger password.');
        case 'invalid-email':
          return const Left('Invalid email address.');
        case 'user-not-found':
          return const Left('No user found for that email.');
        case 'wrong-password':
          return const Left('Invalid credentials. Please check your email and password.');
        case 'too-many-requests':
          return const Left('Too many login attempts. Please try again later.');
        case 'user-disabled':
          return const Left('Your account has been disabled.');
        case 'operation-not-allowed':
          return const Left('This operation is not allowed.');
        case 'network-request-failed':
          return const Left('Network request failed. Please check your internet connection.');
        default:
          return Left('Error during sign-up: ${e.message}');
      }
    } catch (e) {
      return Left('Error during sign-up: ${e.toString()}');
    }
  }

  Future<Either<String, User?>> logInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(userCredential.user);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        // case 'email-already-in-use':
        //   return const Left('Email address is already in use.');
        // case 'weak-password':
        //   return const Left('Password is too weak. Please choose a stronger password.');
        case 'INVALID_LOGIN_CREDENTIALS':
          return const Left('Invalid credentials. Please check your email and password.');
        case 'invalid-email':
          return const Left('Invalid email address.');
        case 'user-not-found':
          return const Left('No user found for that email.');
        case 'wrong-password':
          return const Left('Invalid credentials. Please check your email and password.');
        case 'too-many-requests':
          return const Left('Too many login attempts. Please try again later.');
        case 'user-disabled':
          return const Left('Your account has been disabled.');
        case 'operation-not-allowed':
          return const Left('This operation is not allowed.');
        case 'network-request-failed':
          return const Left('Network request failed. Please check your internet connection.');
        default:
          return Left('Error during sign-up: ${e.message}');
      }
    } catch (e) {
      return Left('Error during login: $e');
    }
  }

  Future<Either<String, bool>> resetPassword(String email) async {
    try {
      final user = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (user.isEmpty) {
        // Email does not exist
        return const Left('No user found for that email.');
      }

      await _auth.sendPasswordResetEmail(email: email);
      return const Right(true); // Password reset email sent successfully
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many reset password requests. Please try again later.';
          break;
        default:
          errorMessage = 'Error during password reset: ${e.message}';
          break;
      }
      return Left(errorMessage); // Return the error message
    } catch (e) {
      return Left('Error during password reset: $e'); // Generic error message
    }
  }

  static Future<User?> signInWithGoogle() async {

    FirebaseAuth auth = FirebaseAuth.instance;

    User? user;
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential = await auth.signInWithCredential(credential);

      user = userCredential.user!;

      var doc = null;

      try {
        doc  = await userService.userByUid(user.uid);
      } catch (e) {
      }

      var uModel = userModel.User(
        uid: user.uid,
        email: user.email,
        phone: user.phoneNumber
      );

      if (doc == null) {

        uModel = uModel.copyWith(
          updatedAt: Timestamp.now(),
          createdAt: Timestamp.now()
        );

        await userService.addDocumentWithCustomId(user.uid, uModel);

      } else {

        uModel = uModel.copyWith();
        await userService.updateDocument({
          UserKey.updatedAt: Timestamp.now(),
        }, user.uid);


      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
       // toast('The account already exists with a different credential');
      } else if (e.code == 'invalid-credential') {
        //toast('Error occurred while accessing credentials. Try again.');
      }

      return null;
    } catch (e) {
      //toast('Error occurred using Google Sign In. Try again.');
      return null;
    }

    return user;
  }
}