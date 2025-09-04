import 'dart:convert';
import 'package:dhan_manthan/constant.dart';
import 'package:dhan_manthan/models/new_debts_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewExpense extends StatefulWidget {
  const NewExpense(this.addexp, {super.key});
  final void Function(Debt exp) addexp;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Catgory _selectedCategory = Catgory.plus;
  DateTime? _selectedDate;

  void savingExpense() {
    final amount = double.tryParse(_amountController.text);
    final amountIsINValid = amount == null || amount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsINValid ||
        _selectedDate == null) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Invalid Entries'),
            content: const Text("Please make sure all entries were valid."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Okay'),
              ),
            ],
          );
        },
      );
      return;
    }

    final url = Uri.https(
      'dhan-manthan-default-rtdb.firebaseio.com',
      'girls.json',
    );
    http.post(url, body: json.encode({'Name': 'Shivangi Pathak'}));

    widget.addexp(
      Debt(
        title: _titleController.text,
        amount: amount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyBoard = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: BoxDecoration(color: bgColor),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, keyBoard + 20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              maxLength: 10,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(label: Text("Person Name")),
            ),
            const SizedBox(height: 1),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      label: Text("Amount"),
                      prefix: Icon(Icons.currency_rupee),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        (_selectedDate == null)
                            ? "Not Selected"
                            : formatter.format(_selectedDate!),
                      ),
                      const SizedBox(width: 1),
                      IconButton(
                        onPressed: () async {
                          final pickedData = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(
                              DateTime.now().year - 1,
                              DateTime.now().month,
                              DateTime.now().day,
                            ),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Colors
                                        .blue, // <-- color of selected date
                                    onPrimary: Colors
                                        .white, // <-- text color on selected date
                                    onSurface:
                                        Colors.black, // <-- default text color
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor:
                                          Colors.blue, // <-- button text color
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                            lastDate: DateTime.now(),
                          );
                          setState(() {
                            _selectedDate = pickedData;
                          });
                        },
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 10),
                DropdownButton(
                  value: _selectedCategory,
                  items: Catgory.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "cancil",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  onPressed: savingExpense,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Add",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
