import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/authentication/auth.export.dart';
import 'config.export.dart';

MultiBlocProvider listOfBlocProviders(Widget child) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => AuthBloc(getIt(), getIt())),
    ],
    child: child,
  );
}
