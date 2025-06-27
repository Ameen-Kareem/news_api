import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_api/appConfig.dart';
import 'package:news_api/auth_gate.dart';
import 'package:news_api/bloc/news_bloc.dart';
import 'package:news_api/routes.dart';
import 'package:news_api/views/login/login.dart';
import 'package:news_api/views/splash/splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Appconfig.supabaseUrl,
    anonKey: Appconfig.supabaseKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => NewsBloc())],
      child: MaterialApp(home: Splash(), routes: Routes.routes),
    );
  }
}
