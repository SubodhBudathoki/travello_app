import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_admin/core/helper/extension/context_extension.dart';
import 'package:t_admin/features/user/presentation/cubit/profile/profile_cubit.dart';

/// Profile Widget Calss
class ProfileWidget extends StatelessWidget {
  ///
  const ProfileWidget({
    required this.onTap,
    super.key,
  });

  /// callback
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: Container(
          height: 42,
          width: 42,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const CircularProgressIndicator();
              }
              if (state is ProfileLoaded) {
                return state.currentUser.profileUrl!.isNotEmpty
                    ? Image.network(state.currentUser.profileUrl!)
                    : ColoredBox(
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            state.currentUser.uname![0],
                            style: context.textTheme.bodyLarge,
                          ),
                        ),
                      );
              }
              return const Icon(Icons.verified_user);
            },
          ),
        ),
      ),
    );
  }
}
