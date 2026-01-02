import 'package:expense_tracker/configs/dimension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/floorDatabase/database/database.dart';
import 'package:expense_tracker/floorDatabase/entity/incomeEntity.dart';
import 'package:expense_tracker/floorDatabase/entity/expensesEntity.dart';
import 'package:intl/intl.dart';

class DetailsScreen extends StatefulWidget {
  final AppDatabase appDatabase;
  final int userId;

  const DetailsScreen({super.key, required this.appDatabase, required this.userId});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int selectedMonth = DateTime.now().month - 1; // Default to current month (0-based index)
  int selectedYear = DateTime.now().year;
  List<IncomeEntity> allIncome = [];
  List<ExpensesEntity> allExpenses = [];
  double totalIncome = 0.0;
  double totalExpenses = 0.0;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);

    try {
      // Fetch all income and expenses for this user
      allIncome = await widget.appDatabase.incomeDao.findIncomesByUserId(widget.userId);
      allExpenses = await widget.appDatabase.expensesDao.findExpensesByUserId(widget.userId);

      // Get total income and expenses for the selected month and year
      String selectedMonthStr = (selectedMonth + 1).toString().padLeft(2, '0'); // Make sure month is 2 digits
      String selectedYearStr = selectedYear.toString();

      totalIncome = await widget.appDatabase.incomeDao.getTotalIncomeByUserIdAndMonth(
          widget.userId, selectedMonthStr, selectedYearStr
      ) ?? 0.0;

      totalExpenses = await widget.appDatabase.expensesDao.getTotalExpensesByUserIdAndMonth(
          widget.userId, selectedMonthStr, selectedYearStr
      ) ?? 0.0;

    } catch (e) {
      print("Error loading details: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(halfPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // CustomTextFormField(line: 1, controller: searchController, hintText: "search", labelText: "search"),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            // MONTH SELECTOR
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 12,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => setState(() {
                      selectedMonth = index;
                      _loadData(); // Reload data when a new month is selected
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: selectedMonth == index ? Colors.blueAccent.shade100 : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          _monthName(index + 1),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: selectedMonth == index ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // CATEGORY SUMMARY
            if (allExpenses.isNotEmpty || allIncome.isNotEmpty)
              Text("Category Summary", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),

            // Dynamic category summary
            if (allExpenses.isNotEmpty)
              ..._getCategoriesFromExpenses().map((category) => _categoryTile(category, _getCategoryAmount(category))),

            const SizedBox(height: 20),

            // FILTER CHIPS
            Wrap(
              spacing: 10,
              children: [
                _filterChip("All", true),
                _filterChip("Income", false),
                _filterChip("Expense", false),
                _filterChip("Cash", false),
                _filterChip("Card", false),
              ],
            ),

            const SizedBox(height: 20),

            // FAKE CHART (You can replace with a real chart library like `fl_chart`)
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(child: Text("📊 Chart Placeholder", style: TextStyle(color: Colors.black54))),
            ),

            const SizedBox(height: 20),

            // TRANSACTIONS LIST
            Text("All Transactions", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),

            // Display income transactions for the selected month
            if (allIncome.isNotEmpty)
              ..._getTransactionsByMonth(allIncome).map((income) => _transactionTile(
                income.category ?? "Income",
                "+RS${income.amount}",
                Icons.wallet,
                Colors.green,
                income.date ?? DateTime.now().toString(),  // Display actual date
              )),

            // Display expense transactions for the selected month
            if (allExpenses.isNotEmpty)
              ..._getTransactionsByMonth(allExpenses).map((expense) => _transactionTile(
                expense.category ?? "Expense",
                "-RS${expense.amount}",
                Icons.shopping_bag,
                Colors.red,
                expense.date ?? DateTime.now().toString(),  // Display actual date
              )),
          ],
        ),
      ),
    );
  }

  // Helper function to filter transactions by selected month and year
  List<T> _getTransactionsByMonth<T>(List<T> transactions) {
    return transactions.where((transaction) {
      DateTime date;
      if (transaction is IncomeEntity) {
        date = DateTime.parse(transaction.date!);
      } else if (transaction is ExpensesEntity) {
        date = DateTime.parse(transaction.date!);
      } else {
        return false;
      }

      return date.month == selectedMonth + 1 && date.year == selectedYear;
    }).toList();
  }

  // Helper function to get the amount for a specific category
  String _getCategoryAmount(String category) {
    double categoryTotal = 0.0;
    for (var expense in allExpenses) {
      if (expense.category == category) {
        categoryTotal += expense.amount;
      }
    }
    return "RS${categoryTotal.toStringAsFixed(2)}";
  }

  // Helper function to get all unique categories from expenses
  List<String> _getCategoriesFromExpenses() {
    Set<String> categories = {};
    for (var expense in allExpenses) {
      if (expense.category != null && expense.category!.isNotEmpty) {
        categories.add(expense.category!);
      }
    }
    return categories.toList();
  }

  // Category tile
  Widget _categoryTile(String title, String amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(.3),
                child: const Icon(Icons.category_outlined, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
          Text(amount,
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
        ],
      ),
    );
  }

  // Transaction Tile
  Widget _transactionTile(String title, String amount, IconData icon, Color color, String date) {
    DateTime transactionDate = DateTime.parse(date);
    String formattedDate = DateFormat('yyyy-MM-dd').format(transactionDate);

    return Card(
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: GoogleFonts.poppins()),
        subtitle: Text(formattedDate, style: GoogleFonts.poppins(fontSize: 12)),
        trailing: Text(amount,
            style: GoogleFonts.poppins(fontSize: 16, color: amount.contains('+') ? Colors.green : Colors.red)),
      ),
    );
  }

  // Filter Chip
  Widget _filterChip(String text, bool selected) {
    return Chip(
      label: Text(text),
      backgroundColor: selected ? Colors.blueAccent : Colors.white,
      labelStyle: GoogleFonts.poppins(color: selected ? Colors.white : Colors.black),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    );
  }

  // Get month name from month number
  String _monthName(int m) {
    const names = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return names[m - 1];
  }
}
