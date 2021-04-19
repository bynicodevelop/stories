import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kdofavoris/models/profile_model.dart';

part 'stories_event.dart';
part 'stories_state.dart';

class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  StoriesBloc() : super(StoriesInitialState());

  @override
  Stream<StoriesState> mapEventToState(
    StoriesEvent event,
  ) async* {
    if (event is LoadStoriesEvent) {
      yield StoriesLoadingState();

      yield StoriesLoadedState(event.profileModel);
    }
  }
}
