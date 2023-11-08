import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:street_calle/models/user.dart' as userModel;
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/utils/constant/temp_language.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Either<String ,User?>> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.sendEmailVerification();
      return Right(userCredential.user);
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      switch (e.code) {
        case 'email-already-in-use':
          return Left(TempLanguage().lblEmailAddressInUse);
        // case 'weak-password':
        //   return const Left('Password is too weak. Please choose a stronger password.');
        case 'invalid-email':
          return Left(TempLanguage().lblInvalidEmailAddress);
        case 'user-not-found':
          return Left(TempLanguage().lblNoUserFound);
        case 'wrong-password':
          return  Left(TempLanguage().lblInvalidCredentials);
        case 'too-many-requests':
          return  Left(TempLanguage().lblTooManyRequest);
        case 'user-disabled':
          return  Left(TempLanguage().lblAccountDisable);
        case 'operation-not-allowed':
          return  Left(TempLanguage().lblOperationNotAllowed);
        case 'network-request-failed':
          return  Left(TempLanguage().lblNetworkRequestFailed);
        default:
          return Left(TempLanguage().lblErrorDuringSignUp);
      }
    } catch (e) {
      log(e.toString());
      return Left(TempLanguage().lblErrorDuringSignUp);
    }
  }

  Future<Either<String, User?>> logInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      try {
        userModel.User user = await UserService().userByUid(userCredential.user!.uid);
        if (!user.isEmployee) {
          // Check if the user's email is verified
          if (!userCredential.user!.emailVerified) {
            await userCredential.user!.sendEmailVerification();
            return Left(TempLanguage().lblEmailNotVerified);
          }
        }
      } catch(e) {
        log(e.toString());
        return Left(TempLanguage().lblErrorDuringLogIn);
      }

      return Right(userCredential.user);
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      switch (e.code) {
        // case 'email-already-in-use':
        //   return const Left('Email address is already in use.');
        // case 'weak-password':
        //   return const Left('Password is too weak. Please choose a stronger password.');
        case 'INVALID_LOGIN_CREDENTIALS':
          return Left(TempLanguage().lblInvalidCredentials);
        case 'invalid-email':
          return Left(TempLanguage().lblInvalidEmailAddress);
        case 'user-not-found':
          return Left(TempLanguage().lblNoUserFound);
        case 'wrong-password':
          return  Left(TempLanguage().lblInvalidCredentials);
        case 'too-many-requests':
          return  Left(TempLanguage().lblTooManyRequest);
        case 'user-disabled':
          return  Left(TempLanguage().lblAccountDisable);
        case 'operation-not-allowed':
          return  Left(TempLanguage().lblOperationNotAllowed);
        case 'network-request-failed':
          return  Left(TempLanguage().lblNetworkRequestFailed);
        default:
          return Left(TempLanguage().lblErrorDuringLogIn);
      }
    } catch (e) {
      log(e.toString());
      return Left(TempLanguage().lblErrorDuringLogIn);
    }
  }

  Future<Either<String, bool>> resetPassword(String email) async {
    try {
      final user = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (user.isEmpty) {
        // Email does not exist
        return Left(TempLanguage().lblNoUserFound);
      }

      await _auth.sendPasswordResetEmail(email: email);
      return const Right(true); // Password reset email sent successfully
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          return Left(TempLanguage().lblInvalidEmailAddress);
        case 'user-not-found':
          return Left(TempLanguage().lblNoUserFound);
        case 'too-many-requests':
          return Left(TempLanguage().lblTooManyRequest);
        default:
          return Left(TempLanguage().lblErrorDuringResetPassword);
      }
    } catch (e) {
      log(e.toString());
      return Left(TempLanguage().lblErrorDuringResetPassword);
    }
  }

  Future<bool> isUserEmailVerified() async {
    if (_auth.currentUser == null) {
      return false;
    }
    await _auth.currentUser!.reload();
    return _auth.currentUser!.emailVerified;
  }

  Future<bool> sendEmailVerificationAgain() async {
    try{
      if (_auth.currentUser == null) {
        return false;
      }
      await _auth.currentUser!.sendEmailVerification();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<Either<String, User?>> guestSignIn() async {
    try {
      final UserCredential userCredential = await _auth.signInAnonymously();
      return Right(userCredential.user);
    } catch (e) {
      log(e.toString());
      if (e is FirebaseAuthException) {
        // Handle specific exceptions here
        if (e.code == 'operation-not-allowed') {
          // The operation is not allowed (e.g., anonymous sign-in is disabled)
         return Left(TempLanguage().lblGuestSignInDisable);
        } else {
          // Other Firebase Authentication exceptions
          return Left(TempLanguage().lblErrorDuringLogIn);
        }
      } else {
        // Handle other types of exceptions (e.g., network errors)
        return Left(TempLanguage().lblErrorDuringLogIn);
      }
    }
  }

  bool isUserGuest() {
    if (_auth.currentUser == null) {
      return false;
    }
    return _auth.currentUser!.isAnonymous;
  }

  Future<Either<String, User?>> signInWithGoogle() async {

    //FirebaseAuth auth = FirebaseAuth.instance;
    final auth = sl.get<FirebaseAuth>();
    final userService = sl.get<UserService>();

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

      userModel.User? doc;

      try {
        doc  = await userService.userByUid(user.uid);
      } catch (e) {
        log(e.toString());
      }

      var uModel = userModel.User(
        uid: user.uid,
        email: user.email,
        phone: user.phoneNumber,
        name: user.displayName,
        image: user.photoURL,
        isVendor: false,
      );

      if (doc == null) {

        uModel = uModel.copyWith(
          updatedAt: Timestamp.now(),
          createdAt: Timestamp.now(),
        );

        await userService.addDocumentWithCustomId(user.uid, uModel);

      } else {

        //uModel = uModel.copyWith();
        await userService.updateDocument({
          UserKey.updatedAt: Timestamp.now(),
        }, user.uid);
      }

      return Right(user);
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      if (e.code == 'account-exists-with-different-credential') {
        return Left(TempLanguage().lblAccountExistWithDifferentCredentials);
      } else if (e.code == 'invalid-credential') {
        return Left(TempLanguage().lblErrorAccessingCredentials);
      }
    } catch (e) {
      log(e.toString());
      return Left(TempLanguage().lblGoogleSignInError);
    }
    return Left(TempLanguage().lblGoogleSignInError);
  }
}