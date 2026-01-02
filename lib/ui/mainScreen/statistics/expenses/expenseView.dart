import 'package:expense_tracker/configs/dimension.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/floorDatabase/database/database.dart';
import 'package:expense_tracker/floorDatabase/entity/expensesEntity.dart';
import 'package:expense_tracker/ui/mainScreen/statistics/expenses/widget/addExpense.dart';
import 'package:expense_tracker/ui/mainScreen/statistics/expenses/widget/ExpenseListItem.dart';
import '../../../../configs/palette.dart';
import '../../../../floorDatabase/entity/registerEntity.dart';
import '../../../../supports/routeTransition/routeTransition.dart';
import '../../../../utility/ToastUtils.dart';
import '../../../../utility/applog.dart';
import '../../../../utility/textStyle.dart';
import '../../../userData/userDataService.dart';
import '../widgets/chart/chart.dart';

class ExpenseView extends StatefulWidget {
  final AppDatabase appDatabase;
  const ExpenseView({super.key, required this.appDatabase});

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  List<ExpensesEntity> allExpenses = [];
  RegisterEntity? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    UserDataService userDataService = UserDataService(widget.appDatabase);
    user = await userDataService.getUserData(context);
    setState(() {
      isLoading = false;
    });
    if (user != null) {
      await getAllExpenses();
    }
  }

  Future<void> getAllExpenses() async {
    try {
      if (user != null) {
        List<ExpensesEntity> list = await widget.appDatabase.expensesDao.findExpensesByUserId(user!.id!);

        setState(() {
          allExpenses = list;
          for (int i = 0; i < allExpenses.length; i++) {
            AppLog.d("All Expenses", allExpenses[i].category ?? 'No Category');
          }
        });
      }
    } catch (e) {
      AppLog.e('Error fetching expenses: ', '$e');
      Toastutils.showToast('Failed to load expense data');
    }
  }

  Future<void> deleteExpense(ExpensesEntity expense) async {
    await widget.appDatabase.expensesDao.deleteExpenses(expense);
    Toastutils.showToast('Deleted Successfully');
    getAllExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            customPageRouteBuilder(
              AddExpenseView(
                database: widget.appDatabase,
                updateIncome: getAllExpenses,
              ),
            ),
          );
        },
        backgroundColor: Palette.backgroundColor,
        child: Icon(Icons.add, color: Colors.blue),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: allExpenses.isEmpty
              ? emptyExpenseItems()
              : Column(
            children: [
              chartData(),
              SizedBox(height: 8.0,),
              recentlyAddedExpenses(),
            ],
          ),
        ),
      ),
    );
  }

  Widget emptyExpenseItems() {
    return Center(
      heightFactor: 5.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "No Expenses Till Now",
            style: largeTextStyle(
              textColor: Colors.black,
            ),
          ),
          Text("Press the add icon to add expense"),
        ],
      ),
    );
  }

  // Widget to show the chart with dynamically generated data
  Widget chartData() {
    if (allExpenses.isEmpty) {
      return const Center(child: Text("No expense data available"));
    }

    // Step 1: Group expenses by category and calculate total expenses for each category
    Map<String, double> categoryTotalExpenses = {};

    for (var expense in allExpenses) {
      String category = expense.category ?? 'Unknown'; // Default value if null
      if (categoryTotalExpenses.containsKey(category)) {
        categoryTotalExpenses[category] = categoryTotalExpenses[category]! + expense.amount!;
      } else {
        categoryTotalExpenses[category] = expense.amount!;
      }
    }

    // Step 2: Calculate total expense
    double totalExpense = categoryTotalExpenses.values.fold(
      0.0,
          (sum, value) => sum + value,
    );

    // Step 3: Generate chart data with percentages
    List<Map<String, dynamic>> chartData = categoryTotalExpenses.entries.map((
        entry,
        ) {
      double percentage = (entry.value / totalExpense) * 100;
      Color color = getCategoryColor(entry.key); // Get color based on category
      return {'title': entry.key, 'color': color, 'percentage': percentage};
    }).toList();

    // Step 4: Display the chart with dynamically generated data
    return CustomChart(chartData: chartData);
  }

  // Function to get a color based on the category name
  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'transport':
        return Colors.blue;
      case 'utilities':
        return Colors.green;
      case 'entertainment':
        return Colors.red;
      case 'miscellaneous':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget recentlyAddedExpenses() {
    return Column(
      children: [
        Text(
          "Monthly Expenses",
          style: mediumTextStyle(textColor: Colors.black, fontSize: 18),
        ),
        Container(
          color: Colors.grey.shade100,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : allExpenses.isEmpty
              ? const Center(child: Text("Expense details will be shown here"))
              : ListView.builder(
            itemCount: allExpenses.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: halfMargin),
                decoration: BoxDecoration(
                  color: Palette.primaryContainer,
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 0,
                      blurRadius: 1,
                      color: Colors.black12,
                    )
                  ]
                ),
                child: ExpenseListItem(
                  key: ValueKey(allExpenses[index].id),
                  icon: Icons.money,
                  expense: allExpenses[index],
                  onEdit: () {
                    AppLog.d("Edit Pressed", "text");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddExpenseView(
                          database: widget.appDatabase,
                          updateIncome: getAllExpenses,
                          expenseEntity: allExpenses[index],
                        ),
                      ),
                    );
                  },
                  onDelete: () => deleteExpense(allExpenses[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
