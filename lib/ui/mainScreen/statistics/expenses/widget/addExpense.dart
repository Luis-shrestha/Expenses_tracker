import 'package:expense_tracker/ui/custom/customProceedButton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/configs/dimension.dart';
import 'package:expense_tracker/floorDatabase/database/database.dart';
import 'package:expense_tracker/floorDatabase/entity/expensesEntity.dart';import 'package:expense_tracker/ui/reusableWidget/customTextFormField.dart';
import 'package:expense_tracker/utility/ToastUtils.dart';
import 'package:expense_tracker/utility/textStyle.dart';

import '../../../../../floorDatabase/entity/registerEntity.dart';
import '../../../../../utility/applog.dart';
import '../../../../userData/userDataService.dart';

enum CategoryLabel {
  Food_and_Drinks,
  Loan_Payment,
  Daily_Expenses,
  Transportation,
  Shopping,
  Clothes,
  Medicine,
  Bill_payment,
  Others
  // Add other categories as needed
}

class AddExpenseView extends StatefulWidget {
  final AppDatabase database;
  final Function updateIncome;
  final ExpensesEntity? expenseEntity;

  const AddExpenseView({
    super.key,
    required this.database,
    required this.updateIncome,
    this.expenseEntity,
  });

  @override
  State<AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController paymentMethodController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController tagsController = TextEditingController();

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  RegisterEntity? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.expenseEntity != null) {
      amountController.text = widget.expenseEntity!.amount!.toString();
      dateController.text = widget.expenseEntity!.date!.toString();
      categoryController.text = widget.expenseEntity!.category!;
      paymentMethodController.text = widget.expenseEntity!.paymentMethod ?? '';
      descriptionController.text = widget.expenseEntity!.description ?? '';
      tagsController.text = widget.expenseEntity!.tags ?? '';
    }
    getUserData();
  }

  Future<void> getUserData() async {
    UserDataService userDataService = UserDataService(widget.database);
    user = await userDataService.getUserData(context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.expenseEntity == null ? "Add Expense" : "Update Expense",
          style: largeTextStyle(textColor: Colors.black, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                        controller: amountController,
                        hintText: 'Enter amount',
                        labelText: 'Amount',
                        prefixIcon: Icons.money,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 12.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownMenu<CategoryLabel>(
                            width: MediaQuery.of(context).size.width * .92,
                            controller: categoryController,
                            enableFilter: true,
                            enableSearch: true,
                            requestFocusOnTap: true,
                            leadingIcon: const Icon(
                              Icons.category_outlined,
                              color: Colors.grey,
                            ),
                            label: const Text(
                              'Select Category',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            inputDecorationTheme: InputDecorationTheme(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueAccent,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                            dropdownMenuEntries: <DropdownMenuEntry<CategoryLabel>>[
                              DropdownMenuEntry(
                                value: CategoryLabel.Food_and_Drinks,
                                label: 'Food_and_Drinks',
                              ),
                              DropdownMenuEntry(
                                value: CategoryLabel.Loan_Payment,
                                label: 'Loan_Payment',
                              ),
                              DropdownMenuEntry(
                                value: CategoryLabel.Daily_Expenses,
                                label: 'Daily_Expenses',
                              ), DropdownMenuEntry(
                                value: CategoryLabel.Clothes,
                                label: 'Clothes',
                              ), DropdownMenuEntry(
                                value: CategoryLabel.Bill_payment,
                                label: 'Bill_payment',
                              ), DropdownMenuEntry(
                                value: CategoryLabel.Transportation,
                                label: 'Transportation',
                              ),DropdownMenuEntry(
                                value: CategoryLabel.Medicine,
                                label: 'Medicine',
                              ),DropdownMenuEntry(
                                value: CategoryLabel.Shopping,
                                label: 'Shopping',
                              ),DropdownMenuEntry(
                                value: CategoryLabel.Others,
                                label: 'Others',
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 12.0),
                      CustomTextFormField(
                        line: 1,
                        controller: dateController,
                        hintText: 'Enter date',
                        labelText: 'Date',
                        prefixIcon: Icons.calendar_month,
                        readOnly: true,
                        onTap: _selectDate,
                      ),
                      SizedBox(height: 12.0),
                      CustomTextFormField(
                        line: 1,
                        controller: paymentMethodController,
                        hintText: 'Enter payment method',
                        labelText: 'Payment Method',
                        prefixIcon: Icons.payment,
                      ),
                      SizedBox(height: 12.0),
                      CustomTextFormField(
                        line: 1,
                        controller: descriptionController,
                        hintText: 'Enter description',
                        labelText: 'Description',
                        prefixIcon: Icons.description,
                      ),
                      SizedBox(height: 12.0),
                      CustomTextFormField(
                        line: 1,
                        controller: tagsController,
                        hintText: 'Enter tags (comma separated)',
                        labelText: 'Tags',
                        prefixIcon: Icons.tag,
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

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void save() async {
    if (key.currentState!.validate()) {
      ExpensesEntity expenses = ExpensesEntity(
        userId: user!.id!,
        amount: double.tryParse(amountController.text)!,
        date: dateController.text,
        category: categoryController.text,
        paymentMethod: paymentMethodController.text.isEmpty
            ? null
            : paymentMethodController.text,
        description: descriptionController.text.isEmpty
            ? null
            : descriptionController.text,
        tags: tagsController.text.isEmpty ? null : tagsController.text,
      );

      if (widget.expenseEntity == null) {
        await widget.database.expensesDao.insertExpenses(expenses);
        Toastutils.showToast('Added Successfully');
        AppLog.d("Expense Details", expenses.toString());
      } else {
        expenses.id = widget.expenseEntity!.id;
        await widget.database.expensesDao.updateExpenses(expenses);
        Toastutils.showToast("Data has been updated.");
        AppLog.d("Expense Details", expenses.toString());
      }

      Navigator.pop(context);
      widget.updateIncome();
    }
  }
}
