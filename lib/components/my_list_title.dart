import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyListTitle extends StatelessWidget {
  final String title;
  final String trailing;
  final void Function(BuildContext)? onEditPressed;
  final void Function(BuildContext)? onDeletePressed;

  const MyListTitle({
    super.key,
    required this.title,
    required this.trailing,
    this.onEditPressed,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            // TODO settings option
            SlidableAction(
              onPressed: onEditPressed,
              icon: Icons.settings,
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),

            // TODO delete option
            SlidableAction(
              onPressed: onDeletePressed,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
              title: Text(title),
              trailing: Text(trailing)),
        ),
      ),
    );
  }
}
