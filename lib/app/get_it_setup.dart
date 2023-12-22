import 'package:get_it/get_it.dart';
import 'package:survey_app/configs/services/shared_preferences_service.dart';
import 'package:survey_app/features/authentication/login/application/use_cases/create_user_use_case.dart';
import 'package:survey_app/features/authentication/login/application/use_cases/get_user_use_case.dart';
import 'package:survey_app/features/authentication/login/application/use_cases/save_user_use_case.dart';
import 'package:survey_app/features/authentication/login/application/use_cases/sign_in_use_case.dart';
import 'package:survey_app/features/authentication/login/application/use_cases/sign_out_use_case.dart';
import 'package:survey_app/features/authentication/login/domain/user_repository.dart';
import 'package:survey_app/features/home/survey/application/use_cases/add_new_survey_use_case.dart';
import 'package:survey_app/features/home/survey/application/use_cases/get_survey_list_use_case.dart';
import 'package:survey_app/features/home/survey/application/use_cases/load_survey_config_use_case.dart';
import 'package:survey_app/features/home/survey/application/use_cases/save_survey_user_input_use_case.dart';
import 'package:survey_app/features/home/survey/application/use_cases/set_survey_status_use_case.dart';
import 'package:survey_app/features/home/survey/domain/survey_form_repository.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async{
   //await _registerServices();
  _registerRepositories();
  _registerUseCases();
}

Future<void> _registerServices() async{
  getIt.registerSingletonAsync<SharedPreferencesService>(() async {
      final sharedPreference = SharedPreferencesService();
      await sharedPreference.init();
      return sharedPreference;
  });
}

void _registerRepositories(){
  getIt.registerLazySingleton<UserRepository>(
      () => UserRepository()
  );

  getIt.registerLazySingleton<SurveyFormRepository>(
          () => SurveyFormRepository()
  );
}

void _registerUseCases(){
  getIt.registerFactory<SignInUseCase>(
        () => SignInUseCase(userRepository: getIt()),
  );

  getIt.registerFactory<SignOutUseCase>(
        () => SignOutUseCase(userRepository: getIt()),
  );

  getIt.registerFactory<CreateUserUserCase>(
        () => CreateUserUserCase(userRepository: getIt()),
  );

  getIt.registerFactory<GetUserUseCase>(
        () => GetUserUseCase(userRepository: getIt()),
  );

  getIt.registerFactory<SaveUserUseCase>(
        () => SaveUserUseCase(userRepository: getIt()),
  );

  getIt.registerFactory<GetSurveyListUseCase>(
        () => GetSurveyListUseCase(surveyFormRepository: getIt()),
  );

  getIt.registerFactory<AddNewSurveyUseCase>(
        () => AddNewSurveyUseCase(surveyFormRepository: getIt()),
  );

  getIt.registerFactory<LoadSurveyConfigUseCase>(
        () => LoadSurveyConfigUseCase(surveyFormRepository: getIt()),
  );

  getIt.registerFactory<SaveSurveyUserInputUseCase>(
        () => SaveSurveyUserInputUseCase(surveyFormRepository: getIt()),
  );

  getIt.registerFactory<SetSurveyStatusUseCase>(
        () => SetSurveyStatusUseCase(surveyFormRepository: getIt()),
  );
}