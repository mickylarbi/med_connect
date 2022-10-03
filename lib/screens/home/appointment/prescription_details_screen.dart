import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:med_connect/firebase_services/firestore_service.dart';
import 'package:med_connect/models/doctor/prescription.dart';
import 'package:med_connect/models/pharmacy/drug.dart';
import 'package:med_connect/models/pharmacy/order.dart';
import 'package:med_connect/screens/home/appointment/map_screen.dart';
import 'package:med_connect/screens/home/pharmacy/drug_details_screen.dart';
import 'package:med_connect/screens/home/pharmacy/pharmacy_page.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/custom_buttons.dart';
import 'package:med_connect/screens/shared/custom_textformfield.dart';
import 'package:med_connect/utils/constants.dart';
import 'package:med_connect/utils/dialogs.dart';
import 'package:med_connect/utils/functions.dart';

class PrescriptionDetailsScreen extends StatelessWidget {
  const PrescriptionDetailsScreen({Key? key, required this.prescription})
      : super(key: key);

  final Prescription prescription;

  @override
  Widget build(BuildContext context) {
    FirestoreService db = FirestoreService();

    String? locationString;
    LatLng? locationGeo;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 100, horizontal: 36),
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: prescription.cart!.length,
                    itemBuilder: (context, index) {
                      MapEntry<String, int> entry = prescription.cart!.entries
                          .map((e) =>
                              MapEntry<String, int>(e.key, e.value.toInt()))
                          .toList()[index];

                      return StatefulBuilder(builder: (context, setState) {
                        return FutureBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                          future: db.drugDocument(entry.key).get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                  child: IconButton(
                                      icon: const Icon(Icons.refresh),
                                      onPressed: () {
                                        setState(() {});
                                      }));
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              Drug drug = Drug.fromFirestore(
                                  snapshot.data!.data()!, snapshot.data!.id);

                              return GestureDetector(
                                onTap: () {
                                  navigate(
                                      context, DrugDetailsScreen(drug: drug));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                      color: Colors.blueGrey.withOpacity(.2),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    children: [
                                      DrugImageWidget(
                                        drugId: drug.id!,
                                        height: 70,
                                        width: 70,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              drug.brandName!,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              drug.genericName!,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              drug.group!,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'GH¢ ${drug.price!.toStringAsFixed(2)}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  'Qty: ${entry.value.toString()}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          },
                        );
                      });
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 14),
                  ),
                  const SizedBox(height: 30),
                  if (prescription.otherDetails != null &&
                      prescription.otherDetails!.trim().isNotEmpty)
                    const Text(
                      'Other details',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 10),
                  if (prescription.otherDetails != null &&
                      prescription.otherDetails!.trim().isNotEmpty)
                    Text(prescription.otherDetails!),
                  const SizedBox(height: 30),
                  const SizedBox(height: 30),
                  ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      CustomTextFormField(
                        hintText: 'Delivery location',
                        onChanged: (value) {
                          locationString = value;
                        },
                      ),
                      const SizedBox(height: 10),
                      StatefulBuilder(builder: (context, setState) {
                        return Center(
                          child: Column(
                            children: [
                              TextButton(
                                child: Text(
                                  locationGeo == null
                                      ? 'Choose on map'
                                      : 'View on map',
                                  style: locationGeo == null
                                      ? null
                                      : const TextStyle(color: Colors.pink),
                                ),
                                style: TextButton.styleFrom(
                                    fixedSize: locationGeo == null
                                        ? null
                                        : Size(kScreenWidth(context) - 72, 48),
                                    backgroundColor: locationGeo == null
                                        ? null
                                        : Colors.pink.withOpacity(.1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14))),
                                onPressed: () async {
                                  LatLng? result = await navigate(
                                      context,
                                      MapScreen(
                                          initialSelectedPostion: locationGeo));

                                  if (result != null) {
                                    locationGeo = result;
                                    setState(() {});
                                  }
                                },
                              ),
                              const SizedBox(height: 10),
                              if (locationGeo != null)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      locationGeo = null;
                                      setState(() {});
                                    },
                                    child: const Text(
                                      'Clear geolocation',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Price'),
                          Text(
                            'GH¢ ${prescription.totalPrice!.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      if (!prescription.isUsed!)
                        CustomFlatButton(
                          child: const Text('Order medication'),
                          onPressed: () {
                            Order newOrder = Order(
                              cart: prescription.cart,
                              pharmacyIds: prescription.cart!.keys.toList(),
                              locationGeo: locationGeo,
                              locationString: locationString?.trim(),
                              totalPrice: prescription.totalPrice,
                              status: OrderStatus.pending,
                              confirmDelivery: false,
                              dateTime: DateTime.now(),
                            );

                            if (newOrder.locationString!.isEmpty) {
                              showAlertDialog(context,
                                  message: 'Enter a location for delivery');
                            } else if (newOrder.locationGeo == null) {
                              showAlertDialog(context,
                                  message: 'Choose a location from map');
                            } else {
                              showConfirmationDialog(context,
                                  message: 'Place order?', confirmFunction: () {
                                showLoadingDialog(context,
                                    message: 'Placing order');

                                db
                                    .addOrder(newOrder)
                                    .timeout(ktimeout)
                                    .then((value) {
                                  db.instance
                                      .collection('prescriptions')
                                      .doc(prescription.id)
                                      .update({'isUsed': true})
                                      .timeout(ktimeout)
                                      .then((value) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      })
                                      .onError((error, stackTrace) {});
                                }).onError((error, stackTrace) {
                                  Navigator.pop(context);
                                  showAlertDialog(context,
                                      message: 'Could not place order');
                                });
                              });
                            }
                          },
                        ),
                    ],
                  ),
                ],
              ),
              const CustomAppBar(title: 'Prescription details'),
            ],
          ),
        ),
      ),
    );
  }
}
