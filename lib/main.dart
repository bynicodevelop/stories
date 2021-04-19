import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kdofavoris/arguments/profile_arguments.dart';
import 'package:kdofavoris/forms/types/auth/form_auth_bloc.dart';
import 'package:kdofavoris/repositories/auth_repository.dart';
import 'package:kdofavoris/repositories/profile_repository.dart';
import 'package:kdofavoris/repositories/user_repository.dart';
import 'package:kdofavoris/screens/auth/login_screen.dart';
import 'package:kdofavoris/screens/auth/profile_screen.dart';
import 'package:kdofavoris/screens/auth/register_screen.dart';
import 'package:kdofavoris/screens/explorer_screen.dart';
import 'package:kdofavoris/screens/main_screen.dart';
import 'package:kdofavoris/screens/story_view_screen.dart';
import 'package:kdofavoris/services/authentication/authentication_bloc.dart';
import 'package:kdofavoris/services/profile/profile_bloc.dart';
import 'package:kdofavoris/services/stories/stories_bloc.dart';
import 'package:kdofavoris/services/user/user_bloc.dart';
import 'package:kdofavoris/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  firebaseAuth.useEmulator('http://localhost:9099');

  runApp(App(
    firebaseAuth,
    firestore,
  ));
}

// ignore: must_be_immutable
class App extends StatelessWidget {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  App(
    this._firebaseAuth,
    this._firestore,
  );

  @override
  Widget build(BuildContext context) {
    AuthRepository authRepository = AuthRepository(_firebaseAuth);
    ProfileRepository profileRepository = ProfileRepository(_firestore);
    UserRepository userRepository = UserRepository(authRepository, _firestore);

    return MultiBlocProvider(
      providers: [
        BlocProvider<FormAuthBloc>(
          create: (context) => FormAuthBloc(),
        ),
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(authRepository),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(profileRepository),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(userRepository),
        ),
        BlocProvider<StoriesBloc>(
          create: (context) => StoriesBloc(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(
              color: Colors.white,
            ),
            fillColor: Colors.white.withOpacity(.3),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: Colors.white,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: Colors.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: Colors.white,
              ),
            ),
          ),
          textTheme: Theme.of(context).textTheme.copyWith(
                headline1: Theme.of(context).textTheme.headline1!.copyWith(
                      fontSize: kFontSize * 1.3,
                      color: kPrimaryColor,
                    ),
                headline2: Theme.of(context).textTheme.headline1!.copyWith(
                      fontSize: kFontSize * 1.1,
                      color: kPrimaryColor,
                    ),
                headline6: Theme.of(context).textTheme.headline1!.copyWith(
                      fontSize: kFontSize * .9,
                      color: kPrimaryColor,
                      fontStyle: FontStyle.italic,
                    ),
              ),
        ),
        initialRoute: MainScreen.ROUTE,
        routes: {
          MainScreen.ROUTE: (_) => MainScreen(),
          RegisterScreen.ROUTE: (_) => RegisterScreen(),
          LoginScreen.ROUTE: (_) => LoginScreen(),
          ProfileScreen.ROUTE: (_) => ProfileScreen(),
          ExplorerScreen.ROUTE: (_) => ExplorerScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == StoryViewScreen.ROUTE) {
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => StoryViewScreen(
                profileModel:
                    (settings.arguments as ProfileArguments).profileModel,
              ),
            );
          }
        },
      ),
    );
  }
}
