import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/home/profile/cubit/profile_status_cubit.dart';

import 'package:street_calle/generated/locale_keys.g.dart';

class UserOnlineOfflineWidget extends StatelessWidget {
  const UserOnlineOfflineWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
          width: 50,
          child: FittedBox(
            child: BlocBuilder<ProfileStatusCubit, bool>(
              builder: (context, state) {
                return Switch(
                  value: state,
                  activeColor: const Color(0xff4BC551),
                  onChanged: (bool value) {
                    final profileCubit = context.read<ProfileStatusCubit>();
                    final userCubit = context.read<UserCubit>();

                    if (state) {
                      profileCubit.goOffline();
                      userCubit.setIsOnline(false);
                    } else {
                      profileCubit.goOnline();
                      userCubit.setIsOnline(true);
                    }
                  },
                );
              },
            ),
          ),
        ),
        BlocBuilder<ProfileStatusCubit, bool>(
          builder: (context, state) {
            return Text(
              //state ? TempLanguage().lblOnline : TempLanguage().lblOffline,
              state ? LocaleKeys.online.tr() : LocaleKeys.offline.tr(),
              style: const TextStyle(
                // fontFamily: RIFTSOFT,
                fontSize: 18,
              ),
            );
          },
        ),
      ],
    );
  }
}
