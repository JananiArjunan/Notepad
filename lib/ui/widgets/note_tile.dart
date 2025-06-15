// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/core/models/note_model.dart';
import 'package:note_app/ui/pages/note_detailed_page.dart';
import 'package:note_app/ui/styles/colors.dart';
import 'package:note_app/ui/styles/text_styles.dart';
import 'package:intl/intl.dart';

enum TileType {
  Square,
  VerRect,
  HorRect,
}

class NoteTile extends StatelessWidget {
  final NoteModel note;
  final TileType tileType;
  final int index;

  const NoteTile({
    super.key,
    required this.note,
    required this.tileType,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
              () => NoteDetailPage(note: note),
          transition: Transition.leftToRight,
        );
      },
      child: Container(
        // margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: tileColors[index % 7],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: tileType == TileType.HorRect
                  ? const EdgeInsets.only(right: 100)
                  : null,
              child: Text(
                note.title,
                maxLines: _getMaxLines(tileType),
                style: noteTitleTextStyle.copyWith(
                  fontSize: _getTxtSize(tileType),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  DateFormat.yMMMd().format(note.createdAt),
                  style: dateTextStyle.copyWith(
                    color: Colors.black.withAlpha(179),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Fix 1: Added a 'default' case to ensure a return value for all possible TileType values
  double _getTxtSize(TileType tileType) {
    switch (tileType) {
      case TileType.Square:
        return 21.0;
      case TileType.VerRect:
        return 24.0;
      case TileType.HorRect:
        return 29.0;
      default:
      // This case should ideally not be reached if all enum values are handled.
      // Returning a default value or throwing an error are common practices.
      // Throwing an error is often preferred for unhandled enum cases.
        throw UnimplementedError('Unhandled TileType: $tileType in _getTxtSize');
    }
  }

  // Fix 1 & 2: Added a 'default' case and ensured 'return 3;' is correct
  int _getMaxLines(TileType tileType) {
    switch (tileType) {
    case TileType.Square:
    return 4;
    case TileType.VerRect:
    return 8;
    case TileType.HorRect:
    return 3; // Ensure this is 'return 3;' and not 'return3'
    default:
    // This case should ideally not be reached if all enum values are handled.
    // Throwing an error is often preferred for unhandled enum cases.
    throw UnimplementedError('Unhandled TileType: $tileType in _getMaxLines');
    }
    }
}