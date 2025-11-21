import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_project/auth/cubit/auth_cubit.dart';
import 'package:translation_project/profile/cubit/profile_cubit.dart';
import 'package:translation_project/repository/auth_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final userEmail = authState is Authenticated ? authState.user.email : '';

    return BlocProvider(
      create: (context) => ProfileCubit(context.read<AuthRepository>())..getUser(userEmail),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${state.user.email}', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    Text('Puan: ${state.user.score}', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text('Rütbe: ${state.user.rank}', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              );
            } else if (state is ProfileError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Kullanıcı verisi bulunamadı'));
            }
          },
        ),
      ),
    );
  }
}
