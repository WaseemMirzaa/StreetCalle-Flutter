// import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/models/user.dart' as userModel;
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Either<String, User?>> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.sendEmailVerification();
      return Right(userCredential.user);
    } on FirebaseAuthException catch (e) {
      return _handleException(e);
    } catch (e) {
      log(e.toString());
      return Left(TempLanguage().lblErrorDuringSignUp);
    }
  }

  Future<Either<String, User?>> logInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      try {
        userModel.User user =
            await UserService().userByUid(userCredential.user!.uid);
        if (!user.isEmployee) {
          // Check if the user's email is verified
          if (!userCredential.user!.emailVerified) {
            await userCredential.user!.sendEmailVerification();
            return Left(TempLanguage().lblEmailNotVerified);
          }
        }
      } catch (e) {
        log(e.toString());
        return Left(TempLanguage().lblErrorDuringLogIn);
      }

      return Right(userCredential.user);
    } on FirebaseAuthException catch (e) {
      return _handleException(e);
    } catch (e) {
      log(e.toString());
      return Left(TempLanguage().lblErrorDuringLogIn);
    }
  }

  Future<Either<String, bool>> resetPassword(String email) async {
    try {
      // final user =
      //     await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      // if (user.isEmpty) {
      //   // Email does not exist
      //   return Left(TempLanguage().lblNoUserFound);
      // }

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
    try {
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
    try {
      final auth = sl.get<FirebaseAuth>();
      final userService = sl.get<UserService>();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final AuthCredential credential = _getGoogleAuthCredential(googleAuth);

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      final userModel.User? existingUser =
          await _getUserByUid(userService, user?.uid);
      final userModel.User uModel = _buildUserModel(user, existingUser);

      await _updateOrCreateUser(
          userService, user?.uid, uModel, existingUser != null);

      return Right(user);
    } on FirebaseAuthException catch (e) {
      return _handleException(e);
    } catch (e) {
      log(e.toString());
      return Left(TempLanguage().lblGoogleSignInError);
    }
  }

  AuthCredential _getGoogleAuthCredential(
      GoogleSignInAuthentication? googleAuth) {
    return GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
  }

  Future<userModel.User?> _getUserByUid(
      UserService userService, String? uid) async {
    try {
      return await userService.userByUid(uid);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  userModel.User _buildUserModel(User? user, userModel.User? existingUser) {
    if (existingUser != null) {
      print('here is user model build if condition true');

      var uModel = userModel.User.fromJson(
          existingUser.toJson(), existingUser.uid ?? '');
      return uModel;
    } else {
      print('here is user model build else condition');

      var uModel = userModel.User(
        uid: user?.uid,
        email: user?.email,
        phone: user?.phoneNumber,
        name: user?.displayName,
        image: user?.photoURL,
        isVendor: false,
        isEmployee: false,
        isEmployeeBlocked: false,
        isOnline: true,
        isSubscribed: false,
        subscriptionType: SubscriptionType.none.name,
        updatedAt: Timestamp.now(),
        createdAt: Timestamp.now(),
      );
      return uModel;
    }
  }

  Future<void> _updateOrCreateUser(UserService userService, String? uid,
      userModel.User uModel, bool isUpdate) async {
    if (uid == null) {
      throw Left(TempLanguage().lblAppleeSignInError);
    }
    if (isUpdate) {

      await userService.updateDocument({
        UserKey.UPDATED_AT: Timestamp.now(),
      }, uid);
    } else {
        await userService.addDocumentWithCustomId( uid,uModel,);
     }
  }

  Future<Either<String, User?>> signInWithFacebook() async {
    try {
      final userService = sl.get<UserService>();

      final LoginResult loginResult = await FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken?.token ?? '');

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      final User? user = userCredential.user;

      final userModel.User? existingUser =
          await _getUserByUid(userService, user?.uid);

      final userModel.User uModel = _buildUserModel(user, existingUser);

      await _updateOrCreateUser(
          userService, user?.uid, uModel, existingUser != null);

      return Right(user);
    } on FirebaseAuthException catch (e) {
      return _handleException(e);
    } catch (e) {
      return Left(TempLanguage().lblFacebookSignInError);
    }
  }

  Future<Either<String, User?>> signInWithTwitter() async {
    try {
      final userService = sl.get<UserService>();

      TwitterAuthProvider twitterProvider = TwitterAuthProvider();
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithProvider(twitterProvider);
      final User? user = userCredential.user;

      final userModel.User? existingUser =
          await _getUserByUid(userService, user?.uid);
      final userModel.User uModel = _buildUserModel(user, existingUser);

      await _updateOrCreateUser(
          userService, user?.uid, uModel, existingUser != null);

      return Right(user);
    } on FirebaseAuthException catch (e) {
      return _handleException(e);
    } catch (e) {
      log(e.toString());
      return Left(TempLanguage().lblGoogleSignInError);
    }
  }

  // Future<UserCredential> signInWithFacebook() async {
  //   try {
  //     final LoginResult loginResult = await FacebookAuth.instance.login();
  //
  //     if (loginResult.status == LoginStatus.success) {
  //       final AccessToken accessToken = loginResult.accessToken!;
  //       final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.token);
  //       return await FirebaseAuth.instance.signInWithCredential(credential);
  //     } else {
  //       throw FirebaseAuthException(
  //         code: 'Facebook Login Failed',
  //         message: 'The Facebook login was not successful.',
  //       );
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     // Handle Firebase authentication exceptions
  //     print('Firebase Auth Exception: ${e.message}');
  //     throw e; // rethrow the exception
  //   } catch (e) {
  //     // Handle other exceptions
  //     print('Other Exception: $e');
  //     throw e; // rethrow the exception
  //   }
  // }
  // Future<Either<String, User?>> signInWithApple() async {
  //   try {
  //     print('here in apple sign in=========================');
  //     final userService = sl.get<UserService>();
  //
  //     final appleProvider = AppleAuthProvider();
  //     print('just before apple sign in=========================');
  //
  //     UserCredential userCredential =  await FirebaseAuth.instance.signInWithProvider(appleProvider);
  //
  //
  //     final User? user = userCredential.user;
  //
  //     final userModel.User? existingUser =
  //     await _getUserByUid(userService, user?.uid);
  //     print('existing user====================');
  //     print(existingUser);
  //     final userModel.User uModel = _buildUserModel(user, existingUser);
  //     print('here is back from user model build');
  //
  //     print(uModel);
  //     print(uModel.uid);
  //     print(uModel.email);
  //     print(uModel.name);
  //     print(existingUser != null);
  //     print(user?.uid);
  //
  //     await _updateOrCreateUser(
  //         userService, user?.uid, uModel, existingUser != null);
  //
  //     return Right(user);
  //   } on FirebaseAuthException catch (e) {
  //     print('firrebase exception-----------');
  //     return _handleException(e);
  //   } catch (e) {
  //     print('in the catch $e');
  //     log(e.toString());
  //     return Left(TempLanguage().lblGoogleSignInError);
  //   }
  // }

  Future<Either<String, User?>> signInWithApple() async {
    try {
      final userService = sl.get<UserService>();
      // final SharedPreferences prefs = await SharedPreferences.getInstance();
      // final bool hasSavedCredentials = prefs.containsKey('email')&& prefs.containsKey('name');
      //
      // if(hasSavedCredentials){
      //   final appleCredentials = await SignInWithApple.getAppleIDCredential(scopes: [
      //     AppleIDAuthorizationScopes.email,
      //     AppleIDAuthorizationScopes.fullName,
      //   ]);
      // }

      final appleProvider = AppleAuthProvider();
      appleProvider.addScope('email');
      appleProvider.addScope('name');

      UserCredential userCredential =  await FirebaseAuth.instance.signInWithProvider(appleProvider);


      final User? user = userCredential.user;

      final userModel.User? existingUser =
      await _getUserByUid(userService, user?.uid);
      final userModel.User uModel = _buildUserModel(user, existingUser);

      await _updateOrCreateUser(
          userService, user?.uid, uModel, existingUser != null);

      return Right(user);
    } on FirebaseAuthException catch (e) {
      return _handleException(e);
    } catch (e) {
      log(e.toString());
      return Left(TempLanguage().lblAppleeSignInError);
    }
  }

  Future<Either<String, String?>> deleteAccount(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        await userCredential.user!.delete();
        return Right(TempLanguage().lblAccountDeletedSuccessfully);
      } else {
       return Left(TempLanguage().lblNoUserFound);
      }
    } on FirebaseAuthException catch (e) {
      return _handleDeleteException(e);
    } catch (e) {
      log(e.toString());
      return Left(TempLanguage().lblErrorDuringDeleteAccount);
    }
  }

  Either<String, User?> _handleException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return Left(TempLanguage().lblEmailAddressInUse);
      case 'invalid-email':
        return Left(TempLanguage().lblInvalidEmailAddress);
      case 'user-not-found':
        return Left(TempLanguage().lblNoUserFound);
      case 'wrong-password':
        return Left(TempLanguage().lblInvalidCredentials);
      case 'too-many-requests':
        return Left(TempLanguage().lblTooManyRequest);
      case 'user-disabled':
        return Left(TempLanguage().lblAccountDisable);
      case 'operation-not-allowed':
        return Left(TempLanguage().lblOperationNotAllowed);
      case 'network-request-failed':
        return Left(TempLanguage().lblNetworkRequestFailed);
      case 'weak-password':
        return const Left(
            'Password is too weak. Please choose a stronger password.');
      case 'INVALID_LOGIN_CREDENTIALS':
        return Left(TempLanguage().lblInvalidCredentials);
      case 'account-exists-with-different-credential':
        return Left(TempLanguage().lblAccountExistWithDifferentCredentials);
      case 'invalid-credential':
        return Left(TempLanguage().lblErrorAccessingCredentials);
      default:
        return Left(TempLanguage().lblErrorDuringLogIn);
    }
  }

  Either<String, String> _handleDeleteException(FirebaseAuthException e) {
    log(e.toString());
    switch (e.code) {
      case 'invalid-email':
        return Left(TempLanguage().lblInvalidEmailAddress);
      case 'user-not-found':
        return Left(TempLanguage().lblNoUserFound);
      case 'wrong-password':
        return Left(TempLanguage().lblInvalidCredentials);
      case 'too-many-requests':
        return Left(TempLanguage().lblTooManyRequest);
      case 'user-disabled':
        return Left(TempLanguage().lblAccountDisable);
      case 'operation-not-allowed':
        return Left(TempLanguage().lblOperationNotAllowed);
      case 'network-request-failed':
        return Left(TempLanguage().lblNetworkRequestFailed);
      case 'INVALID_LOGIN_CREDENTIALS':
        return Left(TempLanguage().lblInvalidCredentials);
      case 'invalid-credential':
        return Left(TempLanguage().lblErrorAccessingCredentials);
      default:
        return Left(TempLanguage().lblErrorDuringDeleteAccount);
    }
  }
}