import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kdofavoris/components/video_player_component.dart';
import 'package:kdofavoris/services/stories/stories_bloc.dart';

class StoryViewScreen extends StatefulWidget {
  static const String ROUTE = "/storyview";

  final String slug;

  const StoryViewScreen({
    Key? key,
    required this.slug,
  }) : super(key: key);

  @override
  _StoryViewScreenState createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  @override
  void initState() {
    super.initState();

    context.read<StoriesBloc>().add(LoadStoriesEvent(widget.slug));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoriesBloc, StoriesState>(
      builder: (context, state) {
        print("BlocBuilder<StoriesBloc, StoriesState> $state");
        if ((state is StoriesLoadedState || state is StoriesLikedState) &&
            (state as StoriesInitialState).profileModel.slug == widget.slug) {
          return Scaffold(
            body: Stack(
              children: [
                VideoPlayerComponent(
                  completed: () => Navigator.pop(context),
                  profileModel: state.profileModel,
                ),
                Positioned(
                  top: 20.0,
                  right: 10.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          );
        }

        return SizedBox.fromSize();
      },
    );
  }
}
