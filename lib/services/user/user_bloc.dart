import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kdofavoris/models/profile_model.dart';
import 'package:kdofavoris/models/user_model.dart';
import 'package:kdofavoris/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc(this._userRepository) : super(UserInitialState());

  @override
  Stream<UserInitialState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is LoadUserEvent) {
      UserModel userModel = (state as UserInitialState).userModel;
      List<ProfileModel> followings = (state as UserInitialState).followings;
      List<ProfileModel> followers = (state as UserInitialState).followers;

      yield UserLoadingState();

      if (userModel.uid.isEmpty) {
        userModel = await _userRepository.user;
        followings = await _userRepository.followingrs;
        followers = await _userRepository.followers;
      }

      yield (state as UserInitialState).copyWith(
        userModel: userModel,
        followings: followings,
        followers: followers,
      );
    } else if (event is CleanUserEvent) {
      yield (state as UserInitialState).copyWith(
        userModel: UserModel(
          uid: "",
          displayName: "",
          avatar: "",
          slug: "",
        ),
        followings: [],
        followers: [],
      );
    }
  }
}
