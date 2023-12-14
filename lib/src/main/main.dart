import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/src/features/surveyform/data/repositories/survey_form_repository.dart';
import 'package:survey_app/src/features/auth/data/repositories/user_repository.dart';
import 'package:survey_app/src/features/auth/presentation/screens/auth.dart';
import 'package:survey_app/src/features/home/presentation/screens/home.dart';
import 'package:survey_app/src/features/common/presentation/screens/splash.dart';
import 'package:survey_app/src/utils/configs/services/storage_service.dart';
import '../utils/configs/firebase_options.dart';
import '../features/auth/logic/providers/user_auth_provider.dart';
import '../features/common/users/logic/providers/user_data_provider.dart';
import '../features/surveyform/logic/providers/survey_forms_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = SharedPreferencesService();
  await prefs.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FlutterChat',
        theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 63, 17, 177)),
            textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
              titleSmall: GoogleFonts.ubuntuCondensed(
                fontWeight: FontWeight.bold,
              ),
              titleMedium: GoogleFonts.ubuntuCondensed(
                fontWeight: FontWeight.bold,
              ),
              titleLarge: GoogleFonts.ubuntuCondensed(
                fontWeight: FontWeight.bold,
              ),
            )
        ),
        home: SafeArea(
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return const SplashScreen();
              }
              if(snapshot.hasData){
                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider<UserDataProvider>(
                      create: (context) => UserDataProvider(UserRepository()),
                    ),
                    ChangeNotifierProvider<SurveyDataProvider>(
                      create: (context) => SurveyDataProvider(SurveyFormRepository()),
                    ),
                    ChangeNotifierProvider<UserAuthProvider>(
                      create: (context) => UserAuthProvider(UserRepository()),
                    )
                  ],
                    child: const HomeScreen());
              }
              return  ChangeNotifierProvider<UserAuthProvider>(
                create: (context) => UserAuthProvider(UserRepository()),
                lazy: true,
                child: const AuthScreen(),
              );
            },
          ),
        )
    );
  }
}