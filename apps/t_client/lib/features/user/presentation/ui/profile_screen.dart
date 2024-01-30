import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t_client/core/helper/extension/context_extension.dart';
import 'package:t_client/core/helper/gap.dart';
import 'package:t_client/core/theme/app_colors.dart';
import 'package:t_client/core/widgets/custom_button.dart';
import 'package:t_client/features/user/domain/entities/user_entity.dart';
import 'package:t_client/features/user/presentation/cubit/credential/cubit/auth_cubit.dart';
import 'package:t_client/features/user/presentation/cubit/profile/cubit/profile_cubit.dart';

/// Profile Screen
class ProfileScreen extends StatefulWidget {
  /// Public Constructor
  const ProfileScreen({
    required this.uid,
    super.key,
  });

  /// User ID
  final String uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProfileCubit>().getProfile(uid: widget.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.6,
        centerTitle: true,
        // leading: GestureDetector(
        //   onTap: () => context.pop(),
        //   child: const Icon(
        //     Icons.arrow_back,
        //     color: LightColor.eclipse,
        //   ),
        // ),
        title: Text(
          'Profile',
          style: context.textTheme.headlineLarge?.copyWith(
            fontSize: 22,
            color: LightColor.eclipse,
            height: 1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Center(
          child: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileFailure) {
                context.showSnackBar(
                  message: state.message,
                  toastType: ToastType.error,
                );
              }
              if (state is AccDeleteSuccess) {
                context.showSnackBar(
                  message: state.message,
                  toastType: ToastType.error,
                );
              }
            },
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const CircularProgressIndicator();
              }
              if (state is ProfileLoaded) {
                return BuildProfileDetail(
                  user: state.currentUser,
                );
              }
              return const Text('Error Loading Data');
            },
          ),
        ),
      ),
    );
  }
}

/// Build Profile Detail Widget
class BuildProfileDetail extends StatelessWidget {
  ///
  const BuildProfileDetail({
    required this.user,
    super.key,
  });

  /// User Entity
  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileImage(user: user),
        CustomElevatedButton(
          onButtonPressed: () async {
            await context.read<AuthCubit>().signOut();
            if (context.mounted) {
              GoRouter.of(context).pop();
            }
          },
          buttonText: 'signout',
        ),
        VerticalGap.m,
        CustomElevatedButton(
          onButtonPressed: () async {
            if (context.mounted) {
              GoRouter.of(context).pop();
            }
            await context.read<ProfileCubit>().deleteAccount(uid: user.uid!);
          },
          buttonText: 'delete account',
        ),
      ],
    );
  }
}

/// Profile Image
class ProfileImage extends StatelessWidget {
  ///
  const ProfileImage({
    required this.user,
    super.key,
  });

  /// User Entity
  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * .4,
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VerticalGap.s,
          CircleAvatar(
            radius: 44,
            backgroundColor: context.secondary,
            child: user.profileUrl != null
                ? CircleAvatar(
                    radius: 40,
                    backgroundColor: context.primary,
                    backgroundImage: NetworkImage(user.profileUrl!),
                  )
                : CircleAvatar(
                    backgroundColor: context.primary,
                    child: Text(
                      user.uname![0],
                      style: context.textTheme.headlineLarge,
                    ),
                  ),
          ),
          VerticalGap.l,
          customText(
            type: 'username',
            text: user.uname!,
            context: context,
          ),
          VerticalGap.s,
          customText(
            type: 'uid',
            text: user.uid!,
            context: context,
          ),
          VerticalGap.s,
          customText(
            type: 'email',
            text: user.email!,
            context: context,
          ),
        ],
      ),
    );
  }
}

/// Custom Underlined text
Widget customText({
  required String type,
  required String text,
  required BuildContext context,
}) {
  return SizedBox(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type,
          style: context.textTheme.bodySmall,
        ),
        Container(
          width: context.width,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: context.primary),
            ),
          ),
          child: Text(text),
        ),
      ],
    ),
  );
}
