import 'package:expense_tracker/configs/dimension.dart';
import 'package:expense_tracker/configs/palette.dart';
import 'package:expense_tracker/ui/custom/customIncomeExpensesView.dart';
import 'package:expense_tracker/ui/mainScreen/dashboard/widget/monthlySpendingChart.dart';
import 'package:expense_tracker/utility/applog.dart';
import 'package:expense_tracker/utility/routeTransition.dart';
import 'package:expense_tracker/utility/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/floorDatabase/database/database.dart';
import 'package:expense_tracker/floorDatabase/entity/expensesEntity.dart';
import 'package:expense_tracker/floorDatabase/entity/incomeEntity.dart';
import 'package:expense_tracker/ui/mainScreen/dashboard/widget/incomeExpensesCard.dart';
import 'package:expense_tracker/utility/ToastUtils.dart';
import '../../../floorDatabase/entity/registerEntity.dart';
import '../../../supports/utils/sharedPreferenceManager.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class DashboardView extends StatefulWidget {
  final int userId;
  final AppDatabase appDatabase;

  const DashboardView({super.key, required this.appDatabase, required this.userId});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  List<IncomeEntity> allIncome = [];
  List<ExpensesEntity> allExpenses = [];

  bool isLoading = true;

  // Variables to hold total amounts
  double totalIncome = 0.0;
  double totalExpenses = 0.0;

  List<double> dailyExpenses = List.filled(7, 0.0);

  // List of months for dropdown
  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  // Variable to store the selected month
  late String selectedMonth = months[DateTime.now().month - 1];


  void didPopNext() {
    getAllIncomeAndExpenses();
  }

  Future<void> _refresh() async {
    getAllIncomeAndExpenses();
  }

  @override
  void initState() {
    super.initState();
    if(widget.userId != null) {
      try{
        getAllIncomeAndExpenses();
      }catch(e){
        AppLog.e("user id not found", "$e");
      }
    }
    selectedMonth = months[DateTime.now().month - 1]; // Set to current month
  }

  Future<void> getAllIncomeAndExpenses() async {
    setState(() => isLoading = true);

    try {
      // Use widget.userId directly
      allIncome = await widget.appDatabase.incomeDao.findIncomesByUserId(widget.userId);
      allExpenses = await widget.appDatabase.expensesDao.findExpensesByUserId(widget.userId);

      totalIncome = (await widget.appDatabase.incomeDao.getTotalIncomeByUserId(widget.userId) ?? 0.0).toDouble();
      totalExpenses = (await widget.appDatabase.expensesDao.getTotalExpensesByUserId(widget.userId) ?? 0.0).toDouble();

      // Weekly/daily expenses calculation
      List<double> weeklyExpenses = List.filled(4, 0.0);
      final now = DateTime.now();
      final selectedMonthIndex = months.indexOf(selectedMonth) + 1;
      final selectedYear = now.year;

      for (var expense in allExpenses) {
        if (expense.date != null) {
          final DateTime dt = DateTime.parse(expense.date!);

          if (dt.month == selectedMonthIndex && dt.year == selectedYear) {
            int weekIndex = ((dt.day - 1) ~/ 7);
            if (weekIndex < 4) weeklyExpenses[weekIndex] += expense.amount;
          }
        }
      }

      setState(() {
        dailyExpenses = weeklyExpenses;
        isLoading = false; // stop loading
      });
    } catch (e) {
      AppLog.e("Dashboard fetch error", e.toString());
      setState(() => isLoading = false);
      Toastutils.showToast("Failed to load dashboard data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
      child: CircularProgressIndicator(),
    ) // Show loading indicator if loading
        : SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              balanceAmount(),
              SizedBox(height: 10.0),
              totalAmount(),
              SizedBox(height: 10.0),
              spendingChart(),
              SizedBox(height: 10.0),
              recentTransaction(),
            ],
          ),
        ),
      ),
    );
  }

  Widget recentTransaction() {
    // List to hold transaction cards
    List<Widget> recentTransactions = [];

    // Combine income and expense transactions and show the most recent ones
    int count = 4; // Show the most recent 4 transactions (can adjust as needed)

    for (int i = 0; i < count; i++) {
      if (i < allIncome.length) {
        // For Income transactions
        recentTransactions.add(
          GestureDetector(
            onTap: () {
              // Navigate to income details
              Navigator.push(
                context,
                customPageRouteFromRight(
                  CustomIncomeExpensesView(
                    incomeEntity: allIncome[i],
                    title: "Income",
                  ),
                ),
              );
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.symmetric(vertical: halfMargin),
              color: Colors.green.shade50,
              // Light green background for income
              child: ListTile(
                contentPadding: const EdgeInsets.all(halfPadding),
                leading: Icon(
                  Icons.arrow_upward,
                  color: Colors.green,
                  size: 30,
                ),
                // Upward arrow for income
                title: Text(
                  "Income: Rs. ${allIncome[i].amount}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                subtitle: Text(
                  "Date: ${allIncome[i].date}",
                  style: TextStyle(color: Colors.green.shade600),
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.green.shade800),
              ),
            ),
          ),
        );
      }

      if (i < allExpenses.length) {
        // For Expense transactions
        recentTransactions.add(
          GestureDetector(
            onTap: () {
              // Navigate to expense details
              Navigator.push(
                context,
                customPageRouteFromRight(
                  CustomIncomeExpensesView(
                    expenseEntity: allExpenses[i],
                    title: "Expenses",
                  ),
                ),
              );
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.symmetric(vertical: halfMargin),
              color: Colors.red.shade50,
              // Light red background for expenses
              child: ListTile(
                contentPadding: const EdgeInsets.all(halfPadding),
                leading: Icon(
                  Icons.arrow_downward,
                  color: Colors.red,
                  size: 30,
                ),
                // Downward arrow for expense
                title: Text(
                  "Expense: Rs. ${allExpenses[i].amount}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                  ),
                ),
                subtitle: Text(
                  "Date: ${allExpenses[i].date}",
                  style: TextStyle(color: Colors.red.shade600),
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.red.shade800),
              ),
            ),
          ),
        );
      }
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: halfPadding,
        vertical: padding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Palette.primaryContainer,
        boxShadow: [
          BoxShadow(spreadRadius: 0, color: Colors.black12, blurRadius: 10.0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Transactions",
                style: mediumTextStyle(textColor: Colors.black),
              ),
              Text(
                "View more >>",
                style: regularTextStyle(textColor: Colors.black),
              ),
            ],
          ),
          // Display the recent transactions
          recentTransactions.isNotEmpty
              ? ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: recentTransactions.length,
            itemBuilder: (context, index) {
              return recentTransactions[index];
            },
          )
              : Padding(
            padding: const EdgeInsets.all(halfPadding),
            child: Text(
              "No recent transactions.",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget balanceAmount() {
    late double balance = totalIncome - totalExpenses;
      AppLog.d("balance", "$balance, $totalIncome, $totalExpenses");
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: halfPadding,
        vertical: padding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Palette.primaryContainer,
        boxShadow: [
          BoxShadow(spreadRadius: 0, color: Colors.black12, blurRadius: 10.0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Balance", style: largeTextStyle(textColor: Colors.black)),
          allExpenses.isNotEmpty
              ? Text(
            "RS ${balance}",
            style: mediumTextStyle(textColor: Colors.black),
          )
              : Text(
            "RS ${totalIncome}",
            style: mediumTextStyle(textColor: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget totalAmount() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 2,
      children: [
        IncomeExpensesCardView(
          title: "Total Income",
          amount: totalIncome.toStringAsFixed(2),
          icon: Icons.insert_chart,
          color: Palette.primaryContainer,
          iconColor: Colors.black,
          textColor: Colors.black,
        ),
        IncomeExpensesCardView(
          title: "Total Expenses",
          amount: totalExpenses.toStringAsFixed(2),
          icon: Icons.insert_chart_sharp,
          color: Palette.primaryContainer,
          iconColor: Colors.black,
          textColor: Colors.black,
        ),
      ],
    );
  }

  /*Widget spendingChart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: halfPadding,
              bottom: doublePadding,
              left: halfPadding,
              right: halfPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Monthly Spending Data",
                  style: mediumTextStyle(textColor: Colors.black),
                ),
                Row(
                  children: [
                    Text(
                      selectedMonth,
                      style: regularTextStyle(textColor: Colors.black),
                    ),
                    SizedBox(width: 8),
                    DropdownButton<String>(
                      value: selectedMonth,
                      onChanged: (newMonth) {
                        setState(() {
                          selectedMonth = newMonth!;
                        });
                        getAllIncomeAndExpenses(); // Optionally, fetch data based on selected month
                      },
                      items: months.map((month) {
                        return DropdownMenuItem<String>(
                          value: month,
                          child: Text(month),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 🔥 Pass your dynamic data here
          Container(
            height: MediaQuery.of(context).size.height * .25,
            child: MonthlySpendingChart(
              weeklyExpenses: dailyExpenses, // Pass the data for the current month
            ),
          ),
        ],
      ),
    );
  }*/

  Widget spendingChart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: halfPadding,
              bottom: doublePadding,
              left: halfPadding,
              right: halfPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Monthly Spending Data",
                  style: mediumTextStyle(textColor: Colors.black),
                ),
                Row(
                  children: [
                    Text(
                      selectedMonth,
                      style: regularTextStyle(textColor: Colors.black),
                    ),
                    SizedBox(width: 8),
                    DropdownButton<String>(
                      value: selectedMonth.isNotEmpty ? selectedMonth : months[0], // Ensure a valid value
                      onChanged: (newMonth) {
                        setState(() {
                          selectedMonth = newMonth!;
                        });
                        getAllIncomeAndExpenses(); // Optionally, fetch data based on selected month
                      },
                      items: months.map((month) {
                        return DropdownMenuItem<String>(
                          value: month,
                          child: Text(month),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 🔥 Pass your dynamic data here
          Container(
            height: MediaQuery.of(context).size.height * .25,
            child: MonthlySpendingChart(
              weeklyExpenses: dailyExpenses, // Pass the data for the current month
            ),
          ),
        ],
      ),
    );
  }
}
