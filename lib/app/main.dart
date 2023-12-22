import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:survey_app/app/get_it_setup.dart';
import 'package:survey_app/configs/firebase/firebase_options.dart';
import 'package:survey_app/configs/services/shared_preferences_service.dart';
import 'package:survey_app/features/authentication/login/application/bloc/authentication_bloc.dart';
import 'package:survey_app/features/authentication/login/application/bloc/authentication_state.dart';
import 'package:survey_app/features/authentication/login/presentation/auth.dart';
import 'package:survey_app/features/home/survey/application/survey_form_bloc.dart';
import 'package:survey_app/features/home/survey/presentation/home.dart';
import 'package:survey_app/features/splash/presentation/splash.dart';
import '../features/authentication/login/application/bloc/authentication_event.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = SharedPreferencesService();
  await prefs.init();
  await setupGetIt();
  runApp(const App());
}

class App extends StatefulWidget {

  const App({super.key});


  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
                authUseCase: getIt(),
                createUserUserCase: getIt(),
                getUserUseCase: getIt(),
                saveUserUseCase: getIt(),
                signOutUseCase: getIt())
              ..add(AuthenticationLoggedIn())),
        BlocProvider<SurveyFormBloc>(
            create: (context) => SurveyFormBloc(
                getSurveyListUseCases: getIt(),
                addNewSurveyUseCase: getIt(),
                loadSurveyConfigUseCase: getIt(),
                saveUserSurveyInput: getIt(),
                setSurveyStatusUseCase: getIt())),
      ],
      child: MaterialApp(
        title: 'Survey App',
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
        home: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state){
            if(state.authState ==  AuthState.authenticated){
               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const HomeScreen()));
            }
            if(state.authState ==  AuthState.unauthenticated){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const AuthScreen()));
            }
          },
          child: const SafeArea (child: SplashScreen()),
        ),
      ),
    );
  }
}