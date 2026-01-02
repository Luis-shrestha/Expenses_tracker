import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/configs/dimension.dart';
import 'package:expense_tracker/floorDatabase/database/database.dart';
import 'package:expense_tracker/floorDatabase/entity/goalEntity.dart';
import 'package:expense_tracker/ui/custom/customProceedButton.dart';
import 'package:expense_tracker/ui/reusableWidget/customTextFormField.dart';
import 'package:expense_tracker/utility/ToastUtils.dart';
import 'package:expense_tracker/utility/textStyle.dart';
import '../../../../../floorDatabase/entity/registerEntity.dart';
import '../../../../../supports/utils/sharedPreferenceManager.dart';
import '../../../userData/userDataService.dart';

class AddGoalView extends StatefulWidget {
  final AppDatabase appDatabase;
  final Function updateGoal;
  final GoalEntity? goalEntity;

  const AddGoalView({
    super.key,
    required this.appDatabase,
    required this.updateGoal,
    this.goalEntity,
  });

  @override
  State<AddGoalView> createState() => _AddGoalViewState();
}

class _AddGoalViewState extends State<AddGoalView> {
  TextEditingController targetAmountController = TextEditingController();
  TextEditingController savedAmountController = TextEditingController();
  TextEditingController goalNameController = TextEditingController();
  TextEditingController goalDescriptionController = TextEditingController();
  TextEditingController createdDateController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  RegisterEntity? user;
  bool isLoading = true;
  bool? achievedGoal = false; // To track whether the goal is achieved

  @override
  void initState() {
    super.initState();
    if (widget.goalEntity != null) {
      targetAmountController.text = widget.goalEntity!.targetAmount.toString();
      savedAmountController.text = widget.goalEntity!.savedAmount.toString();
      goalNameController.text = widget.goalEntity!.goalName;
      goalDescriptionController.text = widget.goalEntity!.goalDescription;
      createdDateController.text = widget.goalEntity!.createdDate;
      dueDateController.text = widget.goalEntity!.dueDate;
      achievedGoal = widget.goalEntity!.achievedGoal ?? false;
    }
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      UserDataService userDataService = UserDataService(widget.appDatabase);
      user = await userDataService.getUserData(context);
      setState(() {
        isLoading = false;
      });

      if (user == null) {
        // Handle null user, maybe show an error or a default state
        return;
      }
    } catch (e) {
      print("Error loading user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load user data')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void save() async {
    if (key.currentState!.validate()) {
      if (user == null) {
        // Show a message if the user data is not loaded yet
        Toastutils.showToast('User data is not loaded. Please try again.');
        return; // Exit the function if the user is not loaded
      }

      if (widget.goalEntity == null) {
        GoalEntity newGoal = GoalEntity(
          userId: user!.id!, // Safe to use after the null check
          goalName: goalNameController.text,
          targetAmount: double.tryParse(targetAmountController.text) ?? 0.0,
          savedAmount: double.tryParse(savedAmountController.text) ?? 0.0,
          createdDate: createdDateController.text,
          dueDate: dueDateController.text,
          goalDescription: goalDescriptionController.text,
          achievedGoal: achievedGoal,
        );
        await widget.appDatabase.goalDao.insertGoal(newGoal);
        Toastutils.showToast('Goal Added Successfully');
        Navigator.pop(context);
        widget.updateGoal();
      } else {
        GoalEntity updatedGoal = GoalEntity(
          id: widget.goalEntity!.id,
          userId: user!.id!, // Safe to use after the null check
          goalName: goalNameController.text,
          targetAmount: double.tryParse(targetAmountController.text) ?? 0.0,
          savedAmount: double.tryParse(savedAmountController.text) ?? 0.0,
          createdDate: createdDateController.text,
          dueDate: dueDateController.text,
          goalDescription: goalDescriptionController.text,
          achievedGoal: achievedGoal,
        );
        await widget.appDatabase.goalDao.updateGoal(updatedGoal);
        Toastutils.showToast("Goal Updated Successfully");
        Navigator.pop(context);
        widget.updateGoal();
      }
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          widget.goalEntity == null ? "Add Goal" : "Update Goal",
          style: largeTextStyle(textColor: Colors.black, fontSize: 25),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (isLoading)
                CircularProgressIndicator() // Show a loading spinner if user data is being fetched
              else
                Container(
                  padding: EdgeInsets.all(padding),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Form(
                    key: key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFormField(
                          line: 1,
                          controller: goalNameController,
                          hintText: 'Enter Goal Name',
                          labelText: 'Name',
                          prefixIcon: Icons.drive_file_rename_outline_outlined,
                        ),
                        SizedBox(height: 12.0),
                        CustomTextFormField(
                          line: 1,
                          controller: goalDescriptionController,
                          hintText: 'Enter goal description',
                          labelText: 'Description',
                          prefixIcon: Icons.description,
                        ),
                        SizedBox(height: 12.0),
                        CustomTextFormField(
                          line: 1,
                          controller: targetAmountController,
                          hintText: 'Enter target amount',
                          labelText: 'Target Amount',
                          prefixIcon: Icons.money,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 12.0),
                        CustomTextFormField(
                          line: 1,
                          controller: savedAmountController,
                          hintText: 'Enter saved amount',
                          labelText: 'Saved Amount',
                          prefixIcon: Icons.money_off,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 12.0),
                        CustomTextFormField(
                          line: 1,
                          controller: createdDateController,
                          hintText: 'Enter creation date',
                          labelText: 'Created Date',
                          prefixIcon: Icons.calendar_today,
                          readOnly: true,
                          onTap: () => _selectDate(context, createdDateController),
                        ),
                        SizedBox(height: 12.0),
                        CustomTextFormField(
                          line: 1,
                          controller: dueDateController,
                          hintText: 'Enter due date',
                          labelText: 'Due Date',
                          prefixIcon: Icons.calendar_today,
                          readOnly: true,
                          onTap: () => _selectDate(context, dueDateController),
                        ),
                        SizedBox(height: 12.0),
                        Row(
                          children: [
                            Text('Goal Achieved'),
                            Checkbox(
                              value: achievedGoal,
                              onChanged: (bool? value) {
                                setState(() {
                                  achievedGoal = value;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 12.0),
                        GestureDetector(
                          onTap: () {
                            save();
                          },
                          child: CustomProceedButton(
                            titleName: 'Save',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
