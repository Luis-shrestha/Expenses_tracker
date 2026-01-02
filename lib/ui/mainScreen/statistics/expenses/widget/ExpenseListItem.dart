import 'package:expense_tracker/floorDatabase/entity/expensesEntity.dart';
import 'package:expense_tracker/utility/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseListItem extends StatelessWidget {
  final ExpensesEntity expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final IconData? icon;

  const ExpenseListItem({
    Key? key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(expense.id),  // Ensure each item has a unique key

      // Start action pane (actions that appear when swiped from left)
      endActionPane: ActionPane(
        motion: const DrawerMotion(), // Control the sliding motion
        dismissible: DismissiblePane(onDismissed: () {}), // Optional dismiss behavior
        children: [
          SlidableAction(
            onPressed: (context) {
              onDelete();
            },
            backgroundColor: Color(0xFFFE4A49), // Red color for delete
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete', // Label for the action
          ),
          SlidableAction(
            onPressed: (context) {
              onEdit();
            },
            backgroundColor: const Color(0xFF21B7CA), // Blue color for Edit
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit', // Label for edit action
          ),
        ],
      ),

      // The child widget that represents the item to be slide
      child: ListTile(
        leading: icon != null
            ? Icon(icon, color: Colors.grey)
            : const SizedBox.shrink(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              expense.category!,
              style: regularTextStyle(
                textColor: Colors.black,
                fontSize: 15,
                fontFamily: 'arial',
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "NPR. ${expense.amount}",
              style: regularTextStyle(
                textColor: Colors.black,
                fontSize: 13,
                fontFamily: 'arial',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        subtitle: Text(
          expense.date!,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 13.0,
            color: Colors.green,
            fontFamily: 'arial',
          ),
        ),
      ),
    );
  }
}
