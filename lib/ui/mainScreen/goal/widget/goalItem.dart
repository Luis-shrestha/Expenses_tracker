import 'package:expense_tracker/floorDatabase/entity/goalEntity.dart';
import 'package:expense_tracker/utility/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class GoalItem extends StatelessWidget {
  final GoalEntity goalEntity;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final IconData? icon;

  const GoalItem({
    Key? key,
    required this.goalEntity,
    required this.onEdit,
    required this.onDelete,
    this.icon,
  }) : super(key: key);

  double get progress =>
      goalEntity.savedAmount / goalEntity.targetAmount;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(goalEntity.id),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onDelete(),
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (context) => onEdit(),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (icon != null)
                      Icon(icon, color: Colors.blue.shade600, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      goalEntity.goalName,
                      style: regularTextStyle(
                        textColor: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  "NPR.${goalEntity.targetAmount}",
                  style: regularTextStyle(
                    textColor: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Description
            Text(
              goalEntity.goalDescription,
              style: regularTextStyle(
                textColor: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress > 1 ? 1 : progress,
                minHeight: 8,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation(
                  progress >= 1 ? Colors.green : Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Progress Text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Saved: NPR ${goalEntity.savedAmount}",
                  style: TextStyle(
                    color: Colors.blueGrey.shade700,
                    fontSize: 13,
                  ),
                ),
                Text(
                  "Due: ${goalEntity.dueDate}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.arrow_right_outlined
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
