import 'package:bloc_test/bloc_test.dart';
import 'package:kdofavoris/services/like/like_bloc.dart';

main() {
  blocTest<LikeBloc, LikeState>(
    "Doit permette de liker un contenu",
    build: () {
      return LikeBloc();
    },
    act: (bloc) => bloc.add(OnLikeEvent()),
    expect: () => [
      LikeInitialState(),
      LikedState(),
    ],
    verify: (bloc) {},
  );

  blocTest<LikeBloc, LikeState>(
    "Doit permettre de ne plus liker un contenu",
    build: () {
      return LikeBloc();
    },
    act: (bloc) => bloc.add(OnLikeEvent()),
    expect: () => [
      LikeInitialState(),
      UnLikedState(),
    ],
    verify: (bloc) {},
  );
}
