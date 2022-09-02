import 'dart:io';

import 'package:flutter/material.dart';
import 'package:med_connect/models/drug.dart';
import 'package:med_connect/screens/home/pharmacy/checkout_screen.dart';
import 'package:med_connect/screens/home/pharmacy/pharmacy_page.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/custom_icon_buttons.dart';

class DrugDetailsScreen extends StatelessWidget {
  final Drug drug;
  final bool showButton;
  const DrugDetailsScreen(
      {Key? key, required this.drug, this.showButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Center(
                    child: DrugImageWidget(
                      drugId: drug.id!,
                      height: 200,
                      width: 200,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'GH¢ ${drug.price!.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 14),
                  Text(drug.brandName!),
                  const SizedBox(height: 14),
                  Text(drug.genericName!),
                  const SizedBox(height: 14),
                  Text(drug.group!),
                  const SizedBox(height: 14),
                  Text(drug.otherDetails!),
                ],
              ),
            ),
            CustomAppBar(
              actions: [
                if (showButton)
                  ValueListenableBuilder<Map<Drug, int>>(
                      valueListenable: cart,
                      builder: (context, value, child) {
                        Color color = value.keys.contains(drug)
                            ? Colors.orange
                            : Colors.green;

                        return TextButton.icon(
                          onPressed: () {
                            if (drug.inStock!) {
                              if (value.keys.contains(drug)) {
                                deleteFromCart(drug);
                              } else {
                                addToCart(drug);
                              }
                            }
                          },
                          icon: Icon(
                            value.keys.contains(drug)
                                ? Icons.delete
                                : Icons.add_shopping_cart,
                            color: color,
                          ),
                          label: Text(
                            value.keys.contains(drug)
                                ? 'Remove from cart'
                                : 'Add to cart',
                            style: TextStyle(color: color),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: color.withOpacity(.2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                        );
                      }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
