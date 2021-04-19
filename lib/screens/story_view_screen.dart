import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kdofavoris/components/avatar_component.dart';
import 'package:kdofavoris/components/like_button_component.dart';
import 'package:kdofavoris/models/profile_model.dart';
import 'package:kdofavoris/models/story_model.dart';
import 'package:kdofavoris/services/stories/stories_bloc.dart';
import 'package:video_player/video_player.dart';

class StoryViewScreen extends StatefulWidget {
  static const String ROUTE = "/storyview";

  final ProfileModel profileModel;

  const StoryViewScreen({
    Key? key,
    required this.profileModel,
  }) : super(key: key);

  @override
  _StoryViewScreenState createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen>
    with TickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _animationController;

  void _initializeVideoPlayer(int index, List<StoryModel> storyModel) {
    print("_initializeAndPlay ---------> $index");
    final story = storyModel[index];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 0),
    )..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });

    _animationController.addListener(() {
      if (_animationController.isCompleted && mounted) {
        setState(() => _index++);
        _initializeVideoPlayer(_index, storyModel);
      }
    });

    _controller = VideoPlayerController.network(
      story.storyPath,
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

  int _index = 0;

  @override
  void initState() {
    super.initState();

    _initializeVideoPlayer(_index, widget.profileModel.stories);
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
    return Scaffold(
      body: Stack(
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
                  setState(() {
                    _index--;
                    _initializeVideoPlayer(_index, widget.profileModel.stories);
                  });
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
                  setState(() {
                    _index++;
                    _initializeVideoPlayer(_index, widget.profileModel.stories);
                  });
                } else {
                  _controller.pause();
                  _animationController.stop();

                  Navigator.pop(context);
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
                  likes: 1236,
                  onLike: () => print("liked"),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 65.0,
            left: 30.0,
            child: SizedBox(
              width: 290.0,
              height: 45.0,
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Envoyer un commentaire...',
                    hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.white,
                        ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () => print("send comment"),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
