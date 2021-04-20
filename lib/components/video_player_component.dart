import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kdofavoris/components/avatar_component.dart';
import 'package:kdofavoris/components/like_button_component.dart';
import 'package:kdofavoris/models/profile_model.dart';
import 'package:kdofavoris/models/story_model.dart';
import 'package:kdofavoris/services/stories/stories_bloc.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerComponent extends StatefulWidget {
  final Function completed;
  final ProfileModel profileModel;

  const VideoPlayerComponent({
    Key? key,
    required this.completed,
    required this.profileModel,
  }) : super(key: key);

  @override
  _VideoPlayerComponentState createState() => _VideoPlayerComponentState();
}

class _VideoPlayerComponentState extends State<VideoPlayerComponent>
    with TickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _animationController;

  int _index = 0;

  void _initializeVideo(StoryModel storyModel) {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 0),
    )..addListener(() {
        setState(() {});
      });

    _animationController.addListener(() {
      if (_animationController.isDismissed) {
        _controller.pause();
      }
      if (_animationController.isCompleted) {
        _controller.pause();
        widget.completed();
      }
    });

    _controller = VideoPlayerController.network(
      storyModel.storyPath,
    )..initialize().then((_) {
        if (mounted) {
          setState(() {
            _animationController.duration = _controller.value.duration;
            _animationController.repeat(max: 1);

            _controller.play();
          });
        }
      });
  }

  @override
  void initState() {
    super.initState();

    _initializeVideo(widget.profileModel.stories[_index]);
  }

  @override
  void dispose() {
    _animationController.removeListener(() {});
    _controller.removeListener(() {});

    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _controller.value.isInitialized
            ? SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              )
            : Container(),
        Positioned(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (_index > 0) {
                setState(() => _index--);
                _animationController.stop();
                _initializeVideo(widget.profileModel.stories[_index]);
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height,
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (_index < widget.profileModel.stories.length - 1) {
                setState(() => _index++);
                _animationController.stop();
                _initializeVideo(widget.profileModel.stories[_index]);
              } else {
                widget.completed();
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height,
            ),
          ),
        ),
        Positioned(
          left: 8.0,
          top: 10.0,
          child: Row(
            children: widget.profileModel.stories
                .asMap()
                .entries
                .map((entry) => SizedBox(
                      height: 5,
                      width: (MediaQuery.of(context).size.width - 20) /
                          widget.profileModel.stories.length,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2.0,
                        ),
                        child: LinearProgressIndicator(
                          value: entry.key == _index
                              ? _animationController.value
                              : entry.key < _index
                                  ? 1
                                  : 0,
                          semanticsLabel: "Story progress indicator",
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        Positioned(
          width: 50.0,
          bottom: 60.0,
          right: 20.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: AvatarComponent(
                  avatar: widget.profileModel.avatar,
                  size: 25,
                  borderRadius: 3,
                ),
              ),
              LikeButtonComponent(
                likes: widget.profileModel.stories[_index].likes,
                onLike: () => context.read<StoriesBloc>().add(
                      LikeStoriesEvent(
                        widget.profileModel.stories[_index],
                      ),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
