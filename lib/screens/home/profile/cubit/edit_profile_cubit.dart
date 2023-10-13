import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/services/shared_preferences_service.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/utils/constant/constants.dart';
part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState>{
  final TextEditingController nameController = TextEditingController();
  final UserService userService;
  final SharedPreferencesService sharedPref;

  EditProfileCubit(this.userService, this.sharedPref) : super(EditProfileInitial());

  @override
  Future<void> close() {
    nameController.dispose();
    return super.close();
  }

  Future<void> editProfile({required String image, required bool isUpdate}) async {
    emit(EditProfileLoading());
    final firebaseUser = await userService.updateProfile(nameController.text, sharedPref.getStringAsync(SharePreferencesKey.USER_ID) ,isUpdated: isUpdate, image: image);
    firebaseUser.fold(
            (l) => emit(EditProfileFailure(l)),
            (r) => emit(EditProfileSuccess(r))
    );
  }
}