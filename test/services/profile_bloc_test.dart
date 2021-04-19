import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kdofavoris/models/profile_model.dart';
import 'package:kdofavoris/services/profile/profile_bloc.dart';
import 'package:mockito/mockito.dart';

import '../mocks/profile_repository_mock.dart';

main() {
  late ProfileRepositoryMock _profileRepositoryMock;

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
    _profileRepositoryMock = ProfileRepositoryMock();
  });

  group("Load profiles", () {
    blocTest<ProfileBloc, ProfileState>(
      "Doit permettre la récupérer des profiles",
      build: () {
        when(_profileRepositoryMock.profiles)
            .thenAnswer((realInvocation) => Future.value(_profiles));

        return ProfileBloc(_profileRepositoryMock);
      },
      act: (bloc) => bloc.add(LoadProfilesEvent()),
      expect: () => [
        ProfileListLoading(),
        ProfileInitialState(profiles: _profiles),
      ],
      verify: (bloc) {
        verify(_profileRepositoryMock.profiles);

        expect((bloc.state as ProfileInitialState).profiles.length, 2);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      "Doit permettre la récupérer des profiles (mais vide)",
      build: () {
        when(_profileRepositoryMock.profiles)
            .thenAnswer((realInvocation) => Future.value([]));

        return ProfileBloc(_profileRepositoryMock);
      },
      act: (bloc) => bloc.add(LoadProfilesEvent()),
      expect: () => [
        ProfileListLoading(),
        ProfileInitialState(profiles: []),
      ],
      verify: (bloc) {
        verify(_profileRepositoryMock.profiles);

        expect((bloc.state as ProfileInitialState).profiles.length, 0);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      "Ne doit pas recharger les données si la listes est déjà existante",
      build: () {
        ProfileBloc profileBloc = ProfileBloc(_profileRepositoryMock);

        profileBloc.emit(ProfileInitialState(profiles: _profiles));

        return profileBloc;
      },
      act: (bloc) => bloc.add(LoadProfilesEvent()),
      expect: () => [
        ProfileListLoading(),
        ProfileInitialState(profiles: _profiles),
      ],
      verify: (bloc) {
        verifyNever(_profileRepositoryMock.profiles);

        expect((bloc.state as ProfileInitialState).profiles.length, 2);
      },
    );
  });
}
