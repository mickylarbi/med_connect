import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect/models/allergy.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/custom_buttons.dart';
import 'package:med_connect/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect/screens/shared/custom_textformfield.dart';
import 'package:med_connect/utils/constants.dart';
import 'package:med_connect/utils/dialogs.dart';

class EditAllergyScreen extends StatefulWidget {
  final Allergy? allergy;
  const EditAllergyScreen({Key? key, this.allergy}) : super(key: key);

  @override
  State<EditAllergyScreen> createState() => _EditAllergyScreenState();
}

class _EditAllergyScreenState extends State<EditAllergyScreen> {
  TextEditingController allergyController = TextEditingController();
  TextEditingController reactionController = TextEditingController();
  ValueNotifier<DateTime?> dateNotifier = ValueNotifier<DateTime?>(null);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.allergy != null) {
      allergyController.text = widget.allergy!.allergy!;
      reactionController.text = widget.allergy!.reaction!;
      dateNotifier.value = widget.allergy!.dateOfLastOccurence;
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
                          hintText: 'Allergy', controller: allergyController),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                          hintText: 'Reaction', controller: reactionController),
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
                                      'Date of last occurence',
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
                title: 'Allergy',
                actions: [
                  if (widget.allergy != null)
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
                      child: Text(widget.allergy == null ? 'Add' : 'Save'),
                      onPressed: () {
                        if (allergyController.text.trim().isNotEmpty &&
                            reactionController.text.trim().isNotEmpty &&
                            dateNotifier.value != null) {
                          Navigator.pop(
                            context,
                            EditObject(
                              action: EditAction.edit,
                              object: Allergy(
                                  allergy: allergyController.text.trim(),
                                  reaction: reactionController.text.trim(),
                                  dateOfLastOccurence: dateNotifier.value),
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
    allergyController.dispose();
    dateNotifier.dispose();

    super.dispose();
  }
}
