import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect/models/medical_history_entry.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/custom_buttons.dart';
import 'package:med_connect/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect/screens/shared/custom_textformfield.dart';
import 'package:med_connect/utils/constants.dart';
import 'package:med_connect/utils/dialogs.dart';

class EditMedicalHistoryScreen extends StatefulWidget {
  final MedicalHistoryEntry? medicalHistoryEntry;
  const EditMedicalHistoryScreen({Key? key, this.medicalHistoryEntry})
      : super(key: key);

  @override
  State<EditMedicalHistoryScreen> createState() =>
      _EditMedicalHistoryScreenState();
}

class _EditMedicalHistoryScreenState extends State<EditMedicalHistoryScreen> {
  TextEditingController illnessController = TextEditingController();
  ValueNotifier<DateTime?> dateOfOnsetNotifier = ValueNotifier<DateTime?>(null);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.medicalHistoryEntry != null) {
      illnessController.text = widget.medicalHistoryEntry!.illness!;
      dateOfOnsetNotifier.value = widget.medicalHistoryEntry!.dateOfOnset;
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
                          hintText: 'Illness', controller: illnessController),
                      const SizedBox(height: 20),
                      ValueListenableBuilder<DateTime?>(
                        valueListenable: dateOfOnsetNotifier,
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
                                  dateOfOnsetNotifier.value = result;
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
                                      'Date of onset',
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
                title: 'Medical History Entry',
                actions: [
                  if (widget.medicalHistoryEntry != null)
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
                      child: Text(
                          widget.medicalHistoryEntry == null ? 'Add' : 'Save'),
                      onPressed: () {
                        if (illnessController.text.trim().isNotEmpty &&
                            dateOfOnsetNotifier.value != null) {
                          Navigator.pop(
                            context,
                            EditObject(
                              action: EditAction.edit,
                              object: MedicalHistoryEntry(
                                  illness: illnessController.text.trim(),
                                  dateOfOnset: dateOfOnsetNotifier.value),
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
    illnessController.dispose();
    dateOfOnsetNotifier.dispose();

    super.dispose();
  }
}
