import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect/models/patient/immunization.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/custom_buttons.dart';
import 'package:med_connect/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect/screens/shared/custom_textformfield.dart';
import 'package:med_connect/utils/constants.dart';
import 'package:med_connect/utils/dialogs.dart';

class EditImmunizationScreen extends StatefulWidget {
  final Immunization? immunization;
  const EditImmunizationScreen({Key? key, this.immunization}) : super(key: key);

  @override
  State<EditImmunizationScreen> createState() => _EditImmunizationScreenState();
}

class _EditImmunizationScreenState extends State<EditImmunizationScreen> {
  TextEditingController immunizationController = TextEditingController();
  ValueNotifier<DateTime?> dateNotifier = ValueNotifier<DateTime?>(null);

  @override
  void initState() {
    super.initState();

    if (widget.immunization != null) {
      immunizationController.text = widget.immunization!.immunization!;
      dateNotifier.value = widget.immunization!.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(36),
                  child: Column(
                    children: [
                      CustomTextFormField(
                          hintText: 'Immunization',
                          controller: immunizationController),
                      const SizedBox(height: 20),
                      ValueListenableBuilder<DateTime?>(
                        valueListenable: dateNotifier,
                        builder: (context, value, child) {
                          return Material(
                            color: Colors.blueGrey.withOpacity(.2),
                            borderRadius: BorderRadius.circular(14),
                            child: InkWell(
                              onTap: () async {
                                var result = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime.now());

                                if (result != null) {
                                  dateNotifier.value = result;
                                }
                              },
                              borderRadius: BorderRadius.circular(14),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Date',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    Text(
                                      value == null
                                          ? '-'
                                          : DateFormat.yMMMMd().format(value),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              CustomAppBar(
                title: 'Immunization',
                actions: [
                  if (widget.immunization != null)
                    OutlineIconButton(
                      iconData: Icons.delete,
                      onPressed: () {
                        showConfirmationDialog(context,
                            message: 'Delete entry?', confirmFunction: () {
                          Navigator.pop(
                              context, EditObject(action: EditAction.delete));
                        });
                      },
                    ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 48 + 72,
                  child: Padding(
                    padding: const EdgeInsets.all(36),
                    child: CustomFlatButton(
                      child: Text(widget.immunization == null ? 'Add' : 'Save'),
                      onPressed: () {
                        if (immunizationController.text.trim().isNotEmpty &&
                            dateNotifier.value != null) {
                          Navigator.pop(
                            context,
                            EditObject(
                              action: EditAction.edit,
                              object: Immunization(
                                  immunization:
                                      immunizationController.text.trim(),
                                  date: dateNotifier.value),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    immunizationController.dispose();
    dateNotifier.dispose();

    super.dispose();
  }
}
