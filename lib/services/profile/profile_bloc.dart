import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kdofavoris/models/profile_model.dart';
import 'package:kdofavoris/repositories/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc(this._profileRepository) : super(ProfileInitialState());

  @override
  Stream<ProfileInitialState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is LoadProfilesEvent) {
      List<ProfileModel> profiles = (state as ProfileInitialState).profiles;

      yield ProfileListLoading();

      if (profiles.length == 0) {
        profiles = await _profileRepository.profiles;
      }

      yield (state as ProfileInitialState).copyWith(
        profiles: profiles,
      );
    }
  }
}
