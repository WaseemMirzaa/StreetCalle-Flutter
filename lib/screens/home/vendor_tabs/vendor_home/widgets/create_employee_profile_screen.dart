
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/screens/auth/widgets/custom_text_field.dart';
import 'package:street_calle/screens/home/main_screen.dart';
import 'package:street_calle/services/auth_service.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';




class CreateEmployeeProfileScreen extends StatefulWidget {
   CreateEmployeeProfileScreen({Key? key}) : super(key: key);

  @override
  State<CreateEmployeeProfileScreen> createState() => _CreateEmployeeProfileScreenState();
}

class _CreateEmployeeProfileScreenState extends State<CreateEmployeeProfileScreen> {
  final userName = TextEditingController();

  final email = TextEditingController();

  final password = TextEditingController();
   File? url;

   bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                AppAssets.backIcon,
                width: 20,
                height: 20,
              )
            ],
          ),
        ),
        title: Text(
          TempLanguage().lblCreateEmployeeProfile,
          style: context.currentTextTheme.titleMedium
              ?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultHorizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 24,
                ),
                GestureDetector(
                  onTap: ()async{
                    File? imagePath = await pickImage();
                    if (imagePath != null) {
                      setState(() {
                        url = imagePath;
                      });
                    }

                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blackColor.withOpacity(0.35),
                          spreadRadius: 0.5, // Spread radius
                          blurRadius: 4, // Blur radius
                          offset: const Offset(1, 4), // Offset in the Y direction
                        ),
                      ],
                    ),
                    child: Center(
                      child:
                      url != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                            child: Image.file(url!,fit: BoxFit.cover, width: 80,
                        height: 80,),
                          )
                          :
                      Image.asset(
                        AppAssets.camera,
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const Divider(
                  color: AppColors.dividerColor,
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomTextField(
                  hintText: TempLanguage().lblUserName,
                  keyboardType: TextInputType.name,
                  asset: AppAssets.person,
                  // controller: TextEditingController(),
                  controller: userName,
                  isPassword: false,
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomTextField(
                  hintText: TempLanguage().lblEmail,
                  keyboardType: TextInputType.emailAddress,
                  asset: AppAssets.emailIcon,
                  // controller: TextEditingController(),
                  controller: email,
                  isPassword: false,
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomTextField(
                  hintText: TempLanguage().lblPassword,
                  keyboardType: TextInputType.visiblePassword,
                  asset: AppAssets.passwordIcon,
                  // controller: TextEditingController(),
                  controller: password,
                  isPassword: true,
                  isObscure: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: AppColors.primaryFontColor),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: Text(
                        TempLanguage().lblSetEmployeeCredentials,
                        style: context.currentTextTheme.displaySmall
                            ?.copyWith(color: AppColors.primaryFontColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44.0),
              child: SizedBox(
                width: context.width,
                height: defaultButtonSize,
                child:
                isLoading
                    ? const Column(
                  mainAxisSize: MainAxisSize.min,
                      children: [
                         CircularProgressIndicator(),
                      ],
                    ):
                AppButton(
                  text: TempLanguage().lblAddNewEmployee,
                  elevation: 0.0,
                  onTap: () async {
                    //context.pushNamed(AppRoutingName.loginScreen);
                    //context.pushNamed(AppRoutingName.createEmployeeProfileScreen);

                    //this is for create a new employee

                    if(userName.text.isEmpty){
                      toast('Username is required');
                    }else if(email.text.isEmpty){
                      toast('Email is required');
                    }
                    else if(password.text.isEmpty){
                      toast('Password is required');
                    }else if(url == null){
                      toast('Image is required');
                    }
                    else {
                      setState(() {
                        isLoading = true;
                      });

                     String? image = await uploadImageToFirestore(url!);

                     await signUpEmployee(
                        email: email.text.toString(),
                        password: password.text.toString(),
                        name: userName.text.toString(),
                       image: image,

                      ).then((value) {
                       setState(() {
                         isLoading = false;
                       });
                       context.pushReplacement(AppRoutingName.manageEmployee);
                     }).onError((error, stackTrace) {
                       print(('Error: $error'));
                       setState(() {
                         isLoading = false;
                       });
                     });

                    }


                  },
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  textStyle: context.currentTextTheme.labelLarge
                      ?.copyWith(color: AppColors.whiteColor),
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<File?> pickImage() async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }


  Future<String?> uploadImageToFirestore(File imageFile) async {
    try {
      var imageName = Timestamp.now().millisecondsSinceEpoch.toString();
      final Reference storageReference = FirebaseStorage.instance.ref().child(imageName);
      await storageReference.putFile(imageFile);

      final imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }


  Future<void> signUpEmployee({required String email,
    required String password,
     String? name,
     String? phone,
     String? image,
   }) async {
     try {
       final firebaseUser = await AuthService().signUpWithEmailAndPassword(
           email, password);
       var userId = auth!.uid;
       if (firebaseUser != null) {
         var userId = auth!.uid;
         User user = User(
           uid: userId,
           vendorId: context.read<UserCubit>().state.userId,
           name: name,
           email: email,
           phone: phone ?? '',
           countryCode: '',
           isVendor: false,
           isOnline: true,
           isEmployee: true,
           isEmployeeBlocked: false,
           employeeItemsList: [],
           createdAt: Timestamp.now(),
           updatedAt: Timestamp.now(),
           image: image,

         );

         await FirebaseFirestore.instance
             .collection('users')
             .doc(userId)
             .set(user.toJson());

       // if(firebaseUser != null){
       //
       // await FirebaseFirestore.instance.collection('users').doc(userId).set(
       //     {
       //       'uid': userId,
       //           'vendorId': context.read<UserCubit>().state.userId,
       //           'name': name,
       //           'email': email,
       //           'phone': phone ?? '',
       //           'countryCode': '',
       //           'isVendor': false,
       //           'isOnline': true,
       //           'isEmployee': true,
       //           'isEmployeeBlocked': false,
       //           'employeeItemsList': [],
       //           'createdAt': Timestamp.now(),
       //           'updatedAt': Timestamp.now(),
       //           'image': image,
       //     });

       } else {
         print('error');
       }
     } catch (e) {
       debugPrint(e.toString());
     }
   }
}


// Future<void> signUpEmployee2()async{
//   FirebaseApp app = await Firebase.initializeApp(
//       name: 'Secondary', options: Firebase.app().options);
//   try {
//     var userId;
//     await FirebaseAuth.instanceFor(
//         app: app)
//         .createUserWithEmailAndPassword(email: email, password: password)
//         .then((value) {
//       userId = value.user!.uid.toString();
//       FirebaseFirestore.instance
//           .collection('employees')
//           .doc(userId)
//           .set({
//         'name': fullName,
//         'email': email,
//         'address': address,
//         'contact': contact,
//         // 'id': value.user!.uid.toString(),
//         'id':userId,
//         'image': imageUrl,
//         'joinDate': joinDate,
//         'status': 'Active',
//         'salary': salary,
//         'team': team,
//         'teamId': teamId,
//         'type': type,
//         'role': 'user',
//         'date': DateTime.now(),
//         'fcmToken': '',
//         'accountTitle': '',
//         'accountNo': '',
//         'iban': '',
//         'bankName': '',
//         'salaryStatus': 'UnPaid',
//       }).then((value) {
//         toast('Successfully Saved');
//       });
//     });
//   } on FirebaseAuthException catch (e) {
//     if (e.code == 'email-already-in-use') {
//       toast('Email already in use , try another email');
//     } else if (e.code == 'wrong-password') {
//       toast('Wrong Password , Try Again');
//     }
//
//   }
//   await app.delete();
// }