import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'like_event.dart';
part 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  LikeBloc() : super(LikeInitialState());

  @override
  Stream<LikeState> mapEventToState(
    LikeEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
