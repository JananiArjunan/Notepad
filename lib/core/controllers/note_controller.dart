
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/core/db/db_helper.dart';
import 'package:note_app/core/models/note_model.dart';
class NoteController extends GetxController {

  final RxList<NoteModel> noteList = <NoteModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    DBHelper.initDb().then((_) {
      getNotes();
    });
  }
  Future<void> addNote({required NoteModel note}) async {
    try {
      await DBHelper.insert(note);
    } catch (e) {
      log('Exception (NoteController - addNote): $e');
    }
    getNotes();
  }

  Future<void> getNotes() async {
    List<Map<String, dynamic>> notes = await DBHelper.query();

    noteList.assignAll(notes.map((data) => NoteModel.fromJson(data)).toList()); // <-- FIX: Use NoteModel.fromJson
  }
  Future<void> deleteNote({required NoteModel note}) async {
    bool? confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await DBHelper.delete(note);
        Get.snackbar(
          'Success', 'Note deleted!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.snackBarTheme.actionTextColor,
          colorText: Colors.black,
        );
      } catch (e) {
        log('Exception (NoteController - deleteNote): $e');
        Get.snackbar('Error', 'An error occurred while deleting note: $e');
      } finally {
        getNotes();
      }
    }
  }


  Future<void> updateNote({required NoteModel note}) async {
    try {
      await DBHelper.update(note);
      Get.snackbar(
        'Success', 'Note updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      log('Exception (NoteController - updateNote): $e');
      Get.snackbar('Error', 'An error occurred while updating note: $e');
    } finally {
      getNotes();
    }
  }
}