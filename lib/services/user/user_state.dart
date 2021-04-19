part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitialState extends UserState {
  final UserModel userModel;
  final List<ProfileModel> followings;
  final List<ProfileModel> followers;

  UserInitialState({
    this.userModel = const UserModel(
      uid: "",
      displayName: "",
      avatar: "",
      slug: "",
    ),
    this.followings = const <ProfileModel>[],
    this.followers = const <ProfileModel>[],
  });

  UserInitialState copyWith({
    UserModel? userModel,
    List<ProfileModel>? followings,
    List<ProfileModel>? followers,
  }) =>
      UserInitialState(
        userModel: userModel ?? this.userModel,
        followings: followings ?? this.followings,
        followers: followers ?? this.followers,
      );

  @override
  List<Object> get props => [
        userModel,
        followings,
        followers,
      ];
}

class UserLoadingState extends UserInitialState {}
