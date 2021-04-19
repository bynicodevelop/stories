part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitialState extends ProfileState {
  List<ProfileModel> profiles;

  ProfileInitialState({
    this.profiles = const <ProfileModel>[],
  });

  ProfileInitialState copyWith({
    List<ProfileModel>? profiles,
  }) =>
      ProfileInitialState(
        profiles: profiles ?? this.profiles,
      );

  @override
  List<Object> get props => [profiles];
}

class ProfileListLoading extends ProfileInitialState {}
