part of 'like_bloc.dart';

abstract class LikeState extends Equatable {
  const LikeState();

  @override
  List<Object> get props => [];
}

class LikeInitialState extends LikeState {}

class LikedState extends LikeState {}

class UnLikedState extends LikeState {}
