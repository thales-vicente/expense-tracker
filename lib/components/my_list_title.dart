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
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          // TODO settings option
          SlidableAction(
              onPressed: onEditPressed,
              icon: Icons.settings
          ),

          // TODO delete option
          SlidableAction(
              onPressed: onEditPressed,
              icon: Icons.delete,
          ),
        ],
      ),
      child: ListTile(title: Text(title), trailing: Text(trailing)),
    );
  }
}
