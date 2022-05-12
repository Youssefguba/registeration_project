import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/cache/cache.export.dart';
import '../core/network/network.export.dart';
import '../features/authentication/auth.export.dart';
import 'config.export.dart';

/// Instance of Get It
final GetIt getIt = GetIt.instance;

/// Initialize dependencies for the project and inject them into context.
Widget setupDependencies({required Widget child}) =>
    listOfBlocProviders(child);

/// {@start_documentation}
///
/// [DependencyInjectionInit] the base class that contains all dependencies that
/// registered while the app opened some of them registered lazy and others
/// immediately registered.
/// That class help to register (UseCases), (DataSource) and (Repositories) classes
/// and inject one to another to help app to use one instance of some important classes.
///
/// {@end_documentation}
class DependencyInjectionInit {
  static final DependencyInjectionInit _singleton = DependencyInjectionInit._();

  factory DependencyInjectionInit() => _singleton;

  DependencyInjectionInit._();

  /// Register the Basic Singleton
  Future<void> registerSingleton() async {

    /// create a instance of Shared Prefs classes.
    final sharedPreferences = await SharedPreferences.getInstance();
    final sharedPrefsClient = SharedPrefsClient(sharedPreferences);
    getIt.registerLazySingleton(() => sharedPreferences);
    getIt.registerLazySingleton(() => sharedPrefsClient);

    /// register Dio Package
    getIt.registerLazySingleton(() => Dio());

    /// network info
    final networkInterface = NetworkImpl(getIt());
    getIt.registerLazySingleton(() => networkInterface);

    final authUseCase = _initAuth(networkInterface);

    /// register auth use case
    getIt.registerLazySingleton(() => authUseCase);

  }


  /// Init Auth [ DataSources, Repositories ]
  AuthUseCases _initAuth(NetworkInterface networkInterface) {
    AuthRemoteDataSource? _authRemoteDSImpl;
    AuthRepository? _authRepository;
    UserLocalDataSource? _userLocalDataSource;

    // init Remote Data Source
    _authRemoteDSImpl = AuthRemoteDataSourceImpl(networkInterface);

    // init local data source
    _userLocalDataSource = UserLocalDataSourceImpl(getIt());

    // init repositories
    _authRepository = AuthRepositoryImpl(
      _authRemoteDSImpl,
      _userLocalDataSource,
    );

    // use cases
    return AuthUseCases(_authRepository);
  }

}
