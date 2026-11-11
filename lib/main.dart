import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/plants_repository.dart';
import 'firebase_options.dart';
import 'ui/bloc/plants_bloc.dart';
import 'ui/bloc/plants_event.dart';
import 'ui/screens/catalog_screen.dart';
import 'ui/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Sans Liberation'),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final user = snapshot.data;
          if (user == null) return const LoginScreen();
          return BlocProvider(
            key: ValueKey(user.uid),
            create: (_) => PlantsBloc(PlantsRepository(), user.uid)
              ..add(PlantsLoadRequested()),
            child: const CatalogScreen(),
          );
        },
      ),
    );
  }
}