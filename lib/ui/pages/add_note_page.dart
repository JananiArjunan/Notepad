import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Make sure you have intl package in pubspec.yaml
import 'package:note_app/core/controllers/note_controller.dart';
import 'package:note_app/core/models/note_model.dart'; // Correct import for NoteModel
import 'package:note_app/ui/pages/home_page.dart';
import 'package:note_app/ui/styles/colors.dart';
import 'package:note_app/ui/styles/text_styles.dart';
import 'package:note_app/ui/widgets/icon_button.dart';

class AddNotePage extends StatefulWidget {
  final bool isUpdate;
  final NoteModel? note;
  const AddNotePage({super.key, this.isUpdate = false, this.note});

  @override
  AddNotePageState createState() => AddNotePageState();
}

class AddNotePageState extends State<AddNotePage> {
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _noteTextController = TextEditingController();
  final NoteController _noteController = Get.find<NoteController>();
  final DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    if (widget.isUpdate && widget.note != null) {
      _titleTextController.text = widget.note!.title;
      _noteTextController.text = widget.note!.content;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _noteTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),
            _body(),
          ],
        ),
      ),
    );
  }

  Container _appBar() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyIconButton(
            onTap: () {
              Get.back();
            },
            icon: Icons.keyboard_arrow_left,
          ),
          MyIconButton(
            onTap: () {
              _validateInput();
            },
            txt: widget.isUpdate ? "Update" : "Save",
          ),
        ],
      ),
    );
  }

  Expanded _body() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleTextController,
              style: titleTextStyle.copyWith(color: Colors.white),
              cursorColor: Colors.white,
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                hintText: "Title",
                hintStyle: titleTextStyle.copyWith(color: Colors.grey),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: TextFormField(
                controller: _noteTextController,
                style: bodyTextStyle.copyWith(color: Colors.white),
                cursorColor: Colors.white,
                minLines: null,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Type something...",
                  hintStyle: bodyTextStyle.copyWith(color: Colors.grey),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _validateInput() async {
    bool isNotEmpty = _titleTextController.text.isNotEmpty &&
        _noteTextController.text.isNotEmpty;

    if (isNotEmpty && !widget.isUpdate) {
      _addNoteToDB();
      Get.back();
    } else if (widget.isUpdate &&
        widget.note != null &&
        (_titleTextController.text != widget.note!.title ||
            _noteTextController.text != widget.note!.content)) {
      _updateNote();
      Get.offAll(() => HomePage());
    } else {
      Get.snackbar(
        widget.isUpdate ? "Not Updated" : "Required*",
        widget.isUpdate
            ? "Fields are not updated yet."
            : "All fields are required.",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _addNoteToDB() async {
    await _noteController.addNote(
      note: NoteModel(
        content: _noteTextController.text,
        title: _titleTextController.text,
        createdAt: _currentDate,
      ),
    );
  }

  Future<void> _updateNote() async {
    await _noteController.updateNote(
      note: NoteModel(
        id: widget.note!.id,
        content: _noteTextController.text,
        title: _titleTextController.text,
        createdAt: widget.note!.createdAt,
      ),
    );
  }
}