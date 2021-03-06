import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kdofavoris/components/card_story_component.dart';
import 'package:kdofavoris/components/search_field_component.dart';
import 'package:kdofavoris/services/profile/profile_bloc.dart';

class ExplorerScreen extends StatefulWidget {
  static const String ROUTE = "/explorer";

  ExplorerScreen({Key? key}) : super(key: key);

  @override
  _ExplorerScreenState createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  final List<Map<String, dynamic>> _listStories = [
    {
      "previewStory":
          "https://images.pexels.com/photos/2728829/pexels-photo-2728829.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
      "avatar":
          "https://images.pexels.com/photos/4842558/pexels-photo-4842558.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
    },
    {
      "previewStory":
          "https://images.pexels.com/photos/2668417/pexels-photo-2668417.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
      "avatar":
          "https://images.pexels.com/photos/4842558/pexels-photo-4842558.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
    },
    {
      "previewStory":
          "https://images.pexels.com/photos/1887195/pexels-photo-1887195.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
      "avatar":
          "https://images.pexels.com/photos/4842558/pexels-photo-4842558.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
    },
    {
      "previewStory":
          "https://images.pexels.com/photos/6300215/pexels-photo-6300215.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
      "avatar":
          "https://images.pexels.com/photos/4842558/pexels-photo-4842558.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
    },
    {
      "previewStory":
          "https://images.pexels.com/photos/2728829/pexels-photo-2728829.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
      "avatar":
          "https://images.pexels.com/photos/4842558/pexels-photo-4842558.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
    },
    {
      "previewStory":
          "https://images.pexels.com/photos/2668417/pexels-photo-2668417.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
      "avatar":
          "https://images.pexels.com/photos/4842558/pexels-photo-4842558.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
    },
    {
      "previewStory":
          "https://images.pexels.com/photos/1887195/pexels-photo-1887195.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
      "avatar":
          "https://images.pexels.com/photos/4842558/pexels-photo-4842558.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
    },
    {
      "previewStory":
          "https://images.pexels.com/photos/6300215/pexels-photo-6300215.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
      "avatar":
          "https://images.pexels.com/photos/4842558/pexels-photo-4842558.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
    }
  ];

  @override
  void initState() {
    super.initState();

    context.read<ProfileBloc>().add(LoadProfilesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              "Explorer",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            floating: false,
            pinned: false,
            snap: false,
            centerTitle: false,
            expandedHeight: 100.0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(
                  top: kToolbarHeight,
                  left: 15.0,
                  right: 15.0,
                ),
                child: SearchFieldComponent(),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            sliver: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileInitialState && state.profiles.length > 0) {
                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200.0,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 9 / 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return CardStoryComponent(
                          profileModel: state.profiles[index],
                          ratio: 1,
                        );
                      },
                      childCount: state.profiles.length,
                    ),
                  );
                }

                return SliverFixedExtentList(
                  itemExtent: 110,
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      // 7
                      child: SpinKitThreeBounce(
                        color: Colors.black,
                        size: 15.0,
                      ),
                    ),
                    childCount: 1,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
