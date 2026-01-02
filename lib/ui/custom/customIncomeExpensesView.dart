import 'package:flutter/material.dart';
import 'package:expense_tracker/floorDatabase/entity/expensesEntity.dart';
import 'package:expense_tracker/floorDatabase/entity/incomeEntity.dart';
import 'package:expense_tracker/configs/palette.dart'; // Assuming Palette contains your color definitions.

class CustomIncomeExpensesView extends StatelessWidget {
  final String title;
  final IncomeEntity? incomeEntity;
  final ExpensesEntity? expenseEntity;

  const CustomIncomeExpensesView({
    super.key,
    required this.title,
    this.expenseEntity,
    this.incomeEntity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.primaryColor, // Custom color defined in Palette
        title: Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Displaying the transaction amount
              Text(
                title == "Income" ? "Rs. ${incomeEntity?.amount}" : "Rs. ${expenseEntity?.amount}",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: title == "Income" ? Colors.green.shade800 : Colors.red.shade800,
                ),
              ),
              SizedBox(height: 10),

              // Displaying the transaction category and date
              Text(
                title == "Income"
                    ? "Category: ${incomeEntity?.category} - ${incomeEntity?.date}"
                    : "Category: ${expenseEntity?.category} - ${expenseEntity?.date}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 10),

              // Payment Method and Recurring Status
              Row(
                children: [
                  Icon(
                    Icons.payment,
                    color: title == "Income" ? Colors.green.shade600 : Colors.red.shade600,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    title == "Income"
                        ? "Payment Method: ${incomeEntity?.paymentMethod}"
                        : "Payment Method: ${expenseEntity?.paymentMethod}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Recurring Status (if applicable)
              if (title == "Income" && incomeEntity?.recurringIncome == true)
                Row(
                  children: [
                    Icon(Icons.repeat, color: Colors.green.shade600, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Recurring Income",
                      style: TextStyle(fontSize: 14, color: Colors.green.shade600),
                    ),
                  ],
                ),
              if (title == "Expense" && expenseEntity?.isRecurring == true)
                Row(
                  children: [
                    Icon(Icons.repeat, color: Colors.red.shade600, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Recurring Expense",
                      style: TextStyle(fontSize: 14, color: Colors.red.shade600),
                    ),
                  ],
                ),
              SizedBox(height: 20),

              // Description (Optional)
              if (title == "Income" && incomeEntity?.note != '')
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Note: ${incomeEntity?.note}",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ),
              if (title == "Expense" && expenseEntity?.description != '')
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Description: ${expenseEntity?.description}",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ),

              // Tags (if available)
              if (title == "Income" && incomeEntity?.source != '')
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Source: ${incomeEntity?.source}",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ),
              if (title == "Expense" && expenseEntity?.tags != '')
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Tags: ${expenseEntity?.tags}",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ),

              // Action Buttons (optional)
              Spacer(),

            ],
          ),
        ),
      ),
    );
  }
}
