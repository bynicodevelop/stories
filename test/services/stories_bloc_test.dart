import 'package:bloc_test/bloc_test.dart';
import 'package:kdofavoris/models/profile_model.dart';
import 'package:kdofavoris/services/stories/stories_bloc.dart';

main() {
  final ProfileModel _profileModel = ProfileModel(
    slug: "slug",
    displayName: "displayName",
    avatar: "avatar",
  );

  blocTest<StoriesBloc, StoriesState>(
    "Doit permettre de charger la liste des stories en fonction du profil selectionné",
    build: () {
      return StoriesBloc();
    },
    act: (bloc) => bloc.add(LoadStoriesEvent(_profileModel)),
    expect: () => [
      StoriesLoadingState(),
      StoriesLoadedState(_profileModel),
    ],
  );
}
