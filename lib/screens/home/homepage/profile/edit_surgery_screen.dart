import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect/models/patient/surgery.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/custom_buttons.dart';
import 'package:med_connect/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect/screens/shared/custom_textformfield.dart';
import 'package:med_connect/utils/constants.dart';
import 'package:med_connect/utils/dialogs.dart';

class EditSurgeryScreen extends StatefulWidget {
  final Surgery? surgery;
  const EditSurgeryScreen({Key? key, this.surgery}) : super(key: key);

  @override
  State<EditSurgeryScreen> createState() => _EditSurgeryScreenState();
}

class _EditSurgeryScreenState extends State<EditSurgeryScreen> {
  ValueNotifier<DateTime?> dateNotifier = ValueNotifier<DateTime?>(null);
  TextEditingController doctorController = TextEditingController();
  TextEditingController hospitalController = TextEditingController();
  TextEditingController surgicalProcedureController = TextEditingController();
  TextEditingController resultsController = TextEditingController();
  TextEditingController commentsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.surgery != null) {
      dateNotifier.value = widget.surgery!.date;
      doctorController.text = widget.surgery!.doctor!;
      hospitalController.text = widget.surgery!.hospital!;
      surgicalProcedureController.text = widget.surgery!.surgicalProcedure!;
      resultsController.text = widget.surgery!.results!;
      commentsController.text = widget.surgery!.comments!;
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
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        hintText: 'Doctor',
                        keyboardType: TextInputType.number,
                        controller: doctorController,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        hintText: 'Hospital',
                        keyboardType: TextInputType.number,
                        controller: hospitalController,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        hintText: 'Surgical Procedure',
                        keyboardType: TextInputType.number,
                        controller: surgicalProcedureController,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        hintText: 'Results',
                        keyboardType: TextInputType.number,
                        controller: resultsController,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        hintText: 'Comments',
                        keyboardType: TextInputType.number,
                        controller: commentsController,
                      ),
                    ],
                  ),
                ),
              ),
              CustomAppBar(
                title: 'Surgery',
                actions: [
                  if (widget.surgery != null)
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
                      child: Text(widget.surgery == null ? 'Add' : 'Save'),
                      onPressed: () {
                        if (dateNotifier.value != null &&
                            doctorController.text.trim().isNotEmpty &&
                            hospitalController.text.trim().isNotEmpty &&
                            surgicalProcedureController.text
                                .trim()
                                .isNotEmpty) {
                          Navigator.pop(
                            context,
                            EditObject(
                              action: EditAction.edit,
                              object: Surgery(
                                date: dateNotifier.value,
                                doctor: doctorController.text.trim(),
                                hospital: hospitalController.text.trim(),
                                surgicalProcedure:
                                    surgicalProcedureController.text.trim(),
                                results: resultsController.text.trim(),
                                comments: commentsController.text.trim(),
                              ),
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
    dateNotifier.dispose();
    doctorController.dispose();
    hospitalController.dispose();
    surgicalProcedureController.dispose();
    resultsController.dispose();
    commentsController.dispose();

    super.dispose();
  }
}
