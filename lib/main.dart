import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
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
import 'package:kdofavoris/screens/settings_screen.dart';
import 'package:kdofavoris/screens/story_view_screen.dart';
import 'package:kdofavoris/services/authentication/authentication_bloc.dart';
import 'package:kdofavoris/services/profile/profile_bloc.dart';
import 'package:kdofavoris/services/stories/stories_bloc.dart';
import 'package:kdofavoris/services/user/user_bloc.dart';
import 'package:kdofavoris/style.dart';
import 'package:kdofavoris/transitions/remove_transition.dart';
import 'package:kdofavoris/widgets/auth_guard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String host = defaultTargetPlatform == TargetPlatform.android
      ? '10.0.2.2:8080'
      : 'localhost:8080';

  firestore.settings = Settings(
    host: host,
    sslEnabled: false,
  );

  firebaseAuth.useEmulator('http://localhost:9099');

  runApp(App(
    firebaseAuth,
    firestore,
  ));
}

// ignore: must_be_immutable
class App extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

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
          create: (context) => AuthenticationBloc(authRepository)
            ..add(AuthenticationInializeEvent()),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(profileRepository),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(userRepository),
        ),
        BlocProvider<StoriesBloc>(
          create: (context) => StoriesBloc(profileRepository),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(),
            fillColor: Colors.white.withOpacity(.3),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.solid,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.solid,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.solid,
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
          MainScreen.ROUTE: (_) => AuthGuard(
                child: MainScreen(),
              ),
          RegisterScreen.ROUTE: (_) => RegisterScreen(),
          // LoginScreen.ROUTE: (_) => LoginScreen(),
          ProfileScreen.ROUTE: (_) => AuthGuard(
                child: ProfileScreen(),
              ),
          ExplorerScreen.ROUTE: (_) => AuthGuard(
                child: ExplorerScreen(),
              ),
          SettingsScreen.ROUTE: (_) => AuthGuard(
                child: SettingsScreen(),
              ),
        },
        onGenerateRoute: (settings) {
          RegExp storyview = RegExp(r"\/storyview\/([a-z0-9\-\_]+)");

          if (storyview.hasMatch(settings.name!)) {
            RegExpMatch? match = storyview.firstMatch(settings.name!);

            return MaterialPageRoute(
              settings: settings,
              builder: (context) => AuthGuard(
                child: StoryViewScreen(
                  slug: match!.group(1)!,
                ),
              ),
            );
          } else if (settings.name == LoginScreen.ROUTE) {
            return RemoveTransitionPageRoute(
              settings: settings,
              builder: (_) => LoginScreen(),
            );
          }
        },
      ),
    );
  }
}
