import 'package:expense_tracker/utility/applog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/configs/dimension.dart';
import 'package:expense_tracker/floorDatabase/database/database.dart';
import 'package:expense_tracker/floorDatabase/entity/incomeEntity.dart';
import 'package:expense_tracker/ui/custom/customProceedButton.dart';
import 'package:expense_tracker/ui/reusableWidget/customTextFormField.dart';
import 'package:expense_tracker/utility/ToastUtils.dart';
import 'package:expense_tracker/utility/textStyle.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../../../../floorDatabase/entity/registerEntity.dart';
import '../../../../../supports/utils/sharedPreferenceManager.dart';

enum CategoryLabel {
  salary,
  bonus,
  commission,
  sideHustle,
  // Add other categories as needed
}

class AddIncomeView extends StatefulWidget {
  final AppDatabase database;
  final Function updateIncome;
  final IncomeEntity? incomeEntity;

  const AddIncomeView({
    super.key,
    required this.database,
    required this.updateIncome,
    this.incomeEntity,
  });

  @override
  State<AddIncomeView> createState() => _AddIncomeViewState();
}

class _AddIncomeViewState extends State<AddIncomeView> {
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController paymentMethodController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController taxController = TextEditingController();

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  RegisterEntity? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.incomeEntity != null) {
      amountController.text = widget.incomeEntity!.amount.toString();
      dateController.text = widget.incomeEntity!.date;
      categoryController.text = widget.incomeEntity!.category;
      noteController.text = widget.incomeEntity!.note ;
      paymentMethodController.text = widget.incomeEntity!.paymentMethod ;
      sourceController.text = widget.incomeEntity!.source ;
      taxController.text = widget.incomeEntity!.taxDeducted.toString();
    }
    getUserData();
  }
  // Hashing function for the password
  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> getUserData() async {
    try {
      String? username = await SharedPreferenceManager.getUsername();
      String? password = await SharedPreferenceManager.getPassword();
      String? hashedPassword = hashPassword(password!);

      if (username != null && hashedPassword != null) {
        user = await widget.database.registerDao.getUserByUsernameAndPassword(username, hashedPassword);
      }
      AppLog.i("username and password", "$username, $hashedPassword");
    } catch (e) {
      print("Error loading user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load user data')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.incomeEntity == null ? "Add Income" : "Update Income", style: largeTextStyle(textColor: Colors.black, fontSize: 25),),
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
                          DropdownMenu<CategoryLabel>(
                            width: MediaQuery.of(context).size.width * .92,
                            controller: categoryController,
                            enableFilter: true,
                            enableSearch: true,
                            requestFocusOnTap: true,
                            leadingIcon: const Icon(Icons.category_outlined, color: Colors.grey),
                            label: const Text('Select Category', style: TextStyle(fontSize: 16, color: Colors.grey)),
                            inputDecorationTheme: InputDecorationTheme(
                              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                              ),
                            ),
                            dropdownMenuEntries: <DropdownMenuEntry<CategoryLabel>>[
                              DropdownMenuEntry(value: CategoryLabel.salary, label: 'Salary'),
                              DropdownMenuEntry(value: CategoryLabel.bonus, label: 'Bonus'),
                              DropdownMenuEntry(value: CategoryLabel.commission, label: 'Commission'),
                              // Add more entries as needed
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
                            controller: noteController,
                            hintText: 'Enter any notes',
                            labelText: 'Note',
                            prefixIcon: Icons.note,
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
                            controller: taxController,
                            hintText: 'Enter tax deducted (if any)',
                            labelText: 'Tax Deducted',
                            prefixIcon: Icons.attach_money,
                            keyboardType: TextInputType.number,

                          ),
                          SizedBox(height: 12.0),
                          CustomTextFormField(
                            line: 1,
                            controller: sourceController,
                            hintText: 'Enter income source',
                            labelText: 'Source',
                            prefixIcon: Icons.source,
                          ),
                          SizedBox(height: 12.0),
                          GestureDetector(
                            onTap: () {
                              save();
                            },
                            child: CustomProceedButton(titleName: 'Save'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
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
        dateController.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(picked);
      });
    }
  }

  void save() async {
    if (key.currentState!.validate()) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now); // Format the current DateTime
      if (widget.incomeEntity == null) {
        IncomeEntity income = IncomeEntity(
          amount: double.tryParse(amountController.text)!,
          date: dateController.text,
          category: categoryController.text,
          userId: user!.id!,
          note: noteController.text,
          paymentMethod: paymentMethodController.text,
          taxDeducted: double.tryParse(taxController.text)!,
          source: sourceController.text,
          createdAt: formattedDate,
          updatedAt: formattedDate,
        );
        await widget.database.incomeDao.insertIncome(income);
        Toastutils.showToast('Added Successfully');
        Navigator.pop(context);
        widget.updateIncome();
      } else {
        IncomeEntity income = IncomeEntity(
          userId: user!.id!,
          id: widget.incomeEntity!.id,
          amount: double.tryParse(amountController.text)!,
          date: dateController.text,
          category: categoryController.text,
          note: noteController.text,
          paymentMethod: paymentMethodController.text,
          taxDeducted: double.tryParse(taxController.text)!,
          source: sourceController.text,
          updatedAt: formattedDate,
          createdAt: formattedDate,
        );
        await widget.database.incomeDao.updateIncome(income);
        Toastutils.showToast('Data Updated Successfully');
        Navigator.pop(context);
        widget.updateIncome();
      }
    }
  }
}
