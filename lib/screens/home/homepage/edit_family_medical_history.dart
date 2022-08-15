import 'package:flutter/material.dart';
import 'package:med_connect/models/family_medical_history_entry.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/custom_buttons.dart';
import 'package:med_connect/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect/screens/shared/custom_textformfield.dart';
import 'package:med_connect/utils/constants.dart';
import 'package:med_connect/utils/dialogs.dart';

class EditFamilyMedicalHistoryScreen extends StatefulWidget {
  final FamilyMedicalHistoryEntry? entry;
  const EditFamilyMedicalHistoryScreen({Key? key, this.entry})
      : super(key: key);

  @override
  State<EditFamilyMedicalHistoryScreen> createState() =>
      _EditFamilyMedicalHistoryScreenState();
}

class _EditFamilyMedicalHistoryScreenState
    extends State<EditFamilyMedicalHistoryScreen> {
  TextEditingController conditionController = TextEditingController();
  TextEditingController relationController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.entry != null) {
      conditionController.text = widget.entry!.condition!;
      relationController.text = widget.entry!.relation!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(36),
                child: Column(
                  children: [
                    CustomTextFormField(
                      hintText: 'Condition',
                      controller: conditionController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      hintText: 'Relation',
                      controller: relationController,
                    ),
                  ],
                ),
              ),
            ),
            CustomAppBar(
              title: 'Family Medical History',
              actions: [
                if (widget.entry != null)
                  OutlineIconButton(
                    iconData: Icons.delete,
                    onPressed: () {
                      showConfirmationDialog(context, message: 'Delete entry?',
                          confirmFunction: () {
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
                    child: Text(widget.entry == null ? 'Add' : 'Save'),
                    onPressed: () {
                      if (conditionController.text.trim().isNotEmpty &&
                          relationController.text.trim().isNotEmpty) {
                        Navigator.pop(
                          context,
                          EditObject(
                            action: EditAction.edit,
                            object: FamilyMedicalHistoryEntry(
                                condition: conditionController.text.trim(),
                                relation: relationController.text.trim()),
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
    );
  }

  @override
  void dispose() {
    conditionController.dispose();
    relationController.dispose();

    super.dispose();
  }
}
