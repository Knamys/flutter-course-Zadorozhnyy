  import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/plants_bloc.dart';
import '../bloc/plants_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _resetPassword(BuildContext context, String email) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      messenger.showSnackBar(
        SnackBar(content: Text('Письмо отправлено на $email')),
      );
    } on FirebaseAuthException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Ошибка: ${e.code}')));
    }
  }

  void _signOut(BuildContext context) {
    // сначала возвращаемся на корневой экран, потом выходим
    Navigator.of(context).popUntil((route) => route.isFirst);
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    return Scaffold(
      backgroundColor: const Color(0xFFE8EEE7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8EEE7),
        title: const Text('Профиль'),
      ),
      body: BlocBuilder<PlantsBloc, PlantsState>(
        builder: (context, state) {
          final liked = state is PlantsLoadSuccess ? state.likedCount : 0;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: $email', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('В избранном: $liked',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _resetPassword(context, email),
                  child: const Text('Сбросить пароль по почте'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _signOut(context),
                  child: const Text('Выйти'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}