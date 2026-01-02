import 'package:expense_tracker/ui/mainScreen/statistics/income/widget/IncomeListItem.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/floorDatabase/database/database.dart';
import 'package:expense_tracker/ui/mainScreen/statistics/income/widget/addIncome.dart';
import '../../../../configs/dimension.dart';
import '../../../../configs/palette.dart';
import '../../../../floorDatabase/entity/incomeEntity.dart';
import '../../../../floorDatabase/entity/registerEntity.dart';
import '../../../../supports/routeTransition/routeTransition.dart';
import '../../../../utility/ToastUtils.dart';
import '../../../../utility/applog.dart';
import '../../../../utility/textStyle.dart';
import '../../../userData/userDataService.dart';
import '../widgets/chart/chart.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class IncomeView extends StatefulWidget {
  final AppDatabase appDatabase;

  const IncomeView({super.key, required this.appDatabase});

  @override
  State<IncomeView> createState() => _IncomeViewState();
}

class _IncomeViewState extends State<IncomeView> {
  List<IncomeEntity> allIncome = [];
  RegisterEntity? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }
  // Hashing function for the password
  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
  Future<void> getUserData() async {
    UserDataService userDataService = UserDataService(widget.appDatabase);
    user = await userDataService.getUserData(context);
    setState(() {
      isLoading = false;
    });
    if (user != null) {
      await getAllIncome();
    }
  }

  Future<void> getAllIncome() async {
    try {
      if (user != null) {
        List<IncomeEntity> list = await widget.appDatabase.incomeDao
            .findIncomesByUserId(user!.id!);

        setState(() {
          allIncome = list;
          for (int i = 0; i < allIncome.length; i++) {
            AppLog.d(
              "All Income",
              allIncome[i].category,
            ); // Handle null category
          }
        });
      }
    } catch (e) {
      AppLog.e('Error fetching income: ', '$e'); // Log the error for debugging
      Toastutils.showToast('Failed to load income data');
    }
  }

  Future<void> deleteIncome(IncomeEntity income) async {
    await widget.appDatabase.incomeDao.deleteIncome(income);
    Toastutils.showToast('Delete Successfully');
    getAllIncome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            customPageRouteBuilder(
              AddIncomeView(
                database: widget.appDatabase,
                updateIncome: getAllIncome,
              ),
            ),
          );
        },
        backgroundColor: Palette.backgroundColor,
        child: Icon(Icons.add, color: Colors.blue),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: allIncome.isEmpty?
              emptyIncomeItems():
              Column(children: [chartData(), recentlyAddedIncome()])
        ),
      ),
    );
  }

  Widget emptyIncomeItems(){
    return Center(
      heightFactor: 5.0,
      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("No Income Till Now", style: largeTextStyle(textColor: Colors.black, ),),
          Text("Press add icon to add income"),
        ],
      ),
    );
  }

  // Widget to show the chart with dynamically generated data
  Widget chartData() {
    if (allIncome.isEmpty) {
      return const Center(child: Text("No income data available"));
    }

    // Step 1: Group incomes by category and calculate total income for each category
    Map<String, double> categoryTotalIncome = {};

    for (var income in allIncome) {
      String category =
          income.category ;// Provide default value if null
      if (categoryTotalIncome.containsKey(category)) {
        categoryTotalIncome[category] =
            categoryTotalIncome[category]! + income.amount;
      } else {
        categoryTotalIncome[category] = income.amount;
      }
    }

    // Step 2: Calculate the total income
    double totalIncome = categoryTotalIncome.values.fold(
      0.0,
      (sum, value) => sum + value,
    );

    // Step 3: Generate chart data with percentages
    List<Map<String, dynamic>> chartData = categoryTotalIncome.entries.map((
      entry,
    ) {
      double percentage = (entry.value / totalIncome) * 100;
      Color color = getCategoryColor(entry.key); // Get color based on category
      return {'title': entry.key, 'color': color, 'percentage': percentage};
    }).toList();

    // Step 4: Display the chart with dynamically generated data
    return CustomChart(chartData: chartData);
  }

  // Function to get a color based on the category name
  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'salary':
        return Colors.pink;
      case 'side hustle':
        return Colors.green;
      case 'savings':
        return Colors.orange;
      case 'extra':
        return Colors.blue;
      case 'commission':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget recentlyAddedIncome() {
    return Column(
      children: [
        Text(
          "Monthly Income",
          style: mediumTextStyle(textColor: Colors.black, fontSize: 18),
        ),
        Container(
          color: Colors.grey.shade100,
          child: isLoading
              ? Center(child: CircularProgressIndicator()) // Loading indicator
              : allIncome.isEmpty
              ? const Center(child: Text("Income details will be shown here"))
              : ListView.builder(
                  itemCount: allIncome.length,
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
                      child: IncomeListItem(
                        key: ValueKey(allIncome[index].id),
                        icon: Icons.money,
                        income: allIncome[index],
                        onEdit: () {
                          AppLog.d("Edit Pressed", "text");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddIncomeView(
                                database: widget.appDatabase,
                                updateIncome: getAllIncome,
                                incomeEntity: allIncome[index],
                              ),
                            ),
                          );
                        },
                        onDelete: () => deleteIncome(allIncome[index]),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
