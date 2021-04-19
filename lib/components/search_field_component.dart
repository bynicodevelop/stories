import 'package:flutter/material.dart';

class SearchFieldComponent extends StatefulWidget {
  const SearchFieldComponent({Key? key}) : super(key: key);

  @override
  _SearchFieldComponentState createState() => _SearchFieldComponentState();
}

class _SearchFieldComponentState extends State<SearchFieldComponent> {
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _textEditingController = TextEditingController();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {}
    });

    _textEditingController.addListener(() {
      setState(() => null);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      controller: _textEditingController,
      decoration: InputDecoration(
        fillColor: Colors.grey.withOpacity(.1),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: Colors.grey.withOpacity(.1),
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: Colors.grey.withOpacity(.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: Colors.grey.withOpacity(.1),
          ),
        ),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.grey,
        ),
        suffixIcon: _textEditingController.text.isNotEmpty
            ? IconButton(
                onPressed: () => _textEditingController.clear(),
                icon: Icon(
                  Icons.close,
                ),
              )
            : null,
        hintText: "Search",
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
      cursorColor: Colors.black,
      textInputAction: TextInputAction.search,
      autocorrect: false,
    );
  }
}
