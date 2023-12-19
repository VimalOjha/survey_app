import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/configs/firebase/firebase_options.dart';
import 'package:survey_app/configs/services/storage_service.dart';
import 'package:survey_app/features/authentication/login/application/bloc/authentication_bloc.dart';
import 'package:survey_app/features/authentication/login/application/use_cases/authentication_use_case.dart';
import 'package:survey_app/features/authentication/login/presentation/auth.dart';
import 'package:survey_app/features/splash/presentation/splash.dart';
import 'package:survey_app/features/home/survey/application/survey_form_bloc.dart';
import 'package:survey_app/features/home/survey/application/use_cases/survey_use_cases.dart';
import 'package:survey_app/features/home/survey/domain/survey_form_repository.dart';
import 'package:survey_app/features/home/survey/presentation/home.dart';
import '../features/authentication/login/application/provider/user_auth_provider.dart';
import '../features/authentication/login/application/provider/user_data_provider.dart';
import '../features/authentication/login/domain/user_repository.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = SharedPreferencesService();
  await prefs.init();
  final UserRepository userRepo = UserRepository();
  final SurveyFormRepository surveyFormRepository = SurveyFormRepository();
  final SurveyUseCases surveyUseCases = SurveyUseCases(surveyFormRepository);
  final AuthenticationUseCase useCase = AuthenticationUseCase(userRepository: userRepo);
  runApp(App(useCase: useCase, surveyUseCases: surveyUseCases));
}

class App extends StatefulWidget {

  const App({super.key, required this.useCase, required this.surveyUseCases});
  final AuthenticationUseCase useCase;
  final SurveyUseCases surveyUseCases;

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
            create: (context) =>  AuthenticationBloc(authUseCase: widget.useCase)
        ),
        BlocProvider<SurveyFormBloc>(
            create: (context) => SurveyFormBloc(widget.surveyUseCases)
        ),
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
                      )
                    ],
                     child: const HomeScreen()
                );
              }
              return   const AuthScreen();
            },
          ),
        ),
      ),
    );
  }
}