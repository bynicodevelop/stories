import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kdofavoris/arguments/profile_arguments.dart';
import 'package:kdofavoris/components/avatar_component.dart';
import 'package:kdofavoris/models/profile_model.dart';
import 'package:kdofavoris/screens/story_view_screen.dart';
import 'package:kdofavoris/services/stories/stories_bloc.dart';
import 'package:video_player/video_player.dart';

class CardStoryComponent extends StatefulWidget {
  final ProfileModel profileModel;

  final double ratio;

  const CardStoryComponent({
    Key? key,
    required this.profileModel,
    this.ratio = 16 / 9,
  }) : super(key: key);

  @override
  _CardStoryComponentState createState() => _CardStoryComponentState();
}

class _CardStoryComponentState extends State<CardStoryComponent> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(
      widget.profileModel.stories.first.storyPath,
    )..initialize().then((_) {
        if (mounted) {
          setState(() => print("Video loaded..."));
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: FittedBox(
        fit: BoxFit.cover,
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            _controller.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.only(
                bottom: 30.0 * widget.ratio,
                left: 30.0 * widget.ratio,
              ),
              child: AvatarComponent(
                size: 50.0 * widget.ratio,
                avatar: widget.profileModel.avatar,
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(onTap: () {
                  Navigator.pushNamed(
                    context,
                    "${StoryViewScreen.ROUTE}/${widget.profileModel.slug}",
                    arguments: ProfileArguments(widget.profileModel),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
