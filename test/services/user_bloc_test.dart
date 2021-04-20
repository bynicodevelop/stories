import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kdofavoris/models/profile_model.dart';
import 'package:kdofavoris/models/user_model.dart';
import 'package:kdofavoris/services/user/user_bloc.dart';
import 'package:mockito/mockito.dart';

import '../mocks/user_respository_mock.dart';

main() {
  late UserRepositoryMock _userRepositoryMock;

  final UserModel _userModel = UserModel(
    uid: "123456789",
    displayName: "john doe",
    avatar: "http://avatar.com",
    slug: "johndoe",
  );

  final List<ProfileModel> _profiles = <ProfileModel>[
    ProfileModel(
      slug: "johndoe",
      displayName: "John Doe",
      avatar: "avatar",
    ),
    ProfileModel(
      slug: "janndoe",
      displayName: "Jane Doe",
      avatar: "avatar",
    )
  ];
  setUp(() {
    _userRepositoryMock = UserRepositoryMock();
  });

  group("Get User Data", () {
    blocTest<UserBloc, UserState>(
      "Doit permettre le chargement du profile utilisateur",
      build: () {
        when(_userRepositoryMock.user)
            .thenAnswer((realInvocation) => Future.value(_userModel));

        when(_userRepositoryMock.followingrs)
            .thenAnswer((realInvocation) => Future.value(_profiles));

        when(_userRepositoryMock.followers)
            .thenAnswer((realInvocation) => Future.value(_profiles));

        return UserBloc(_userRepositoryMock);
      },
      act: (bloc) => bloc.add(LoadUserEvent()),
      expect: () => {
        UserLoadingState(),
        UserInitialState(
          userModel: _userModel,
          followings: _profiles,
          followers: _profiles,
        ),
      },
      verify: (bloc) {
        verify(_userRepositoryMock.user);
        verify(_userRepositoryMock.followingrs);
        verify(_userRepositoryMock.followers);

        expect((bloc.state as UserInitialState).userModel, _userModel);

        expect(
          (bloc.state as UserInitialState).followings.length,
          _profiles.length,
        );

        expect(
          (bloc.state as UserInitialState).followers.length,
          _profiles.length,
        );
      },
    );

    blocTest<UserBloc, UserState>(
      "Vérifie que l'utilisateur n'est pas rechargé si les données sont à jour",
      build: () {
        UserBloc userBloc = UserBloc(_userRepositoryMock);

        userBloc.emit(UserInitialState(userModel: _userModel));

        return userBloc;
      },
      act: (bloc) => bloc.add(LoadUserEvent()),
      expect: () => {
        UserLoadingState(),
        UserInitialState(
          userModel: _userModel,
        ),
      },
      verify: (bloc) {
        verifyNever(_userRepositoryMock.user);
        verifyNever(_userRepositoryMock.followingrs);
        verifyNever(_userRepositoryMock.followers);

        expect((bloc.state as UserInitialState).userModel, _userModel);
      },
    );
  });

  blocTest<UserBloc, UserState>(
    "Doit permettre de clean un utilisateur quand celui-ci se déconnecte",
    build: () {
      UserBloc userBloc = UserBloc(_userRepositoryMock);

      userBloc.emit(UserInitialState(userModel: _userModel));

      return userBloc;
    },
    act: (bloc) => bloc.add(CleanUserEvent()),
    verify: (bloc) {
      expect((bloc.state as UserInitialState).userModel.uid, "");
      expect((bloc.state as UserInitialState).followers.length, 0);
      expect((bloc.state as UserInitialState).followings.length, 0);
    },
  );
}
