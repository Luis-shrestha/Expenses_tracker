import 'package:expense_tracker/ui/mainScreen/goal/widget/goalItem.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/floorDatabase/database/database.dart';
import 'package:expense_tracker/floorDatabase/entity/goalEntity.dart';
import 'package:expense_tracker/ui/mainScreen/goal/widget/addGoal.dart';
import 'package:expense_tracker/utility/ToastUtils.dart';
import '../../../configs/palette.dart';
import '../../../floorDatabase/entity/registerEntity.dart';
import '../../userData/userDataService.dart';

class GoalScreen extends StatefulWidget {
  final int userId;
  final AppDatabase appDatabase;

  const GoalScreen({super.key, required this.appDatabase, required this.userId});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  List<GoalEntity> allGoal = [];
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
    setState(() => isLoading = false);
    if (user != null) getAllGoal();
  }

  Future<void> getAllGoal() async {
    final list = await widget.appDatabase.goalDao.findGoalsByUserId(user!.id!);
    setState(() => allGoal = list);
  }

  void deleteGoal(GoalEntity goal) async {
    await widget.appDatabase.goalDao.deleteGoal(goal);
    Toastutils.showToast('Goal deleted successfully');
    getAllGoal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade600,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddGoalView(appDatabase: widget.appDatabase, updateGoal: getAllGoal),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          color: Colors.grey.shade100,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : allGoal.isEmpty
              ? const Center(
            child: Text(
              "No goals yet.\nTap + to create one!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
              : ListView.separated(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: allGoal.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final goal = allGoal[index];
              return GoalItem(
                goalEntity: goal,
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddGoalView(
                        appDatabase: widget.appDatabase,
                        updateGoal: getAllGoal,
                        goalEntity: goal,
                      ),
                    ),
                  );
                },
                onDelete: () => deleteGoal(goal),
                icon: Icons.flag_rounded,
              );
            },
          ),
        ),
      ),
    );
  }
}
