import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:med_connect/firebase_services/firestore_service.dart';
import 'package:med_connect/models/drug.dart';
import 'package:med_connect/models/order.dart';
import 'package:med_connect/screens/home/appointment/map_screen.dart';
import 'package:med_connect/screens/home/pharmacy/orders_list_screen.dart';
import 'package:med_connect/screens/home/pharmacy/pharmacy_page.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/custom_buttons.dart';
import 'package:med_connect/screens/shared/custom_textformfield.dart';
import 'package:med_connect/utils/constants.dart';
import 'package:med_connect/utils/dialogs.dart';
import 'package:med_connect/utils/functions.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  TextEditingController locationStringController = TextEditingController();
  LatLng? locationGeo;

  FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                children: [
                  const SizedBox(height: 100),
                  ValueListenableBuilder<Map<Drug, int>>(
                      valueListenable: cart,
                      builder: (context, value, child) {
                        return ListView.separated(
                          shrinkWrap: true,
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cart.value.length,
                          itemBuilder: (context, index) => Slidable(
                            endActionPane: ActionPane(
                              extentRatio: .2,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    removeFromCart(
                                        cart.value.keys.toList()[index]);

                                    if (cart.value.isEmpty) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                              motion: const ScrollMotion(),
                            ),
                            child: CheckoutCard(
                              entry: cart.value.entries.toList()[index],
                            ),
                          ),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 14),
                        );
                      }),
                  const SizedBox(height: 30),
                  ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      CustomTextFormField(
                        hintText: 'Delivery location',
                        controller: locationStringController,
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
                          ValueListenableBuilder<Map<Drug, int>>(
                              valueListenable: cart,
                              builder: (context, value, child) {
                                return Text(
                                  'GH¢ ${calculateTotalPrice().toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                );
                              }),
                        ],
                      ),
                      const SizedBox(height: 50),
                      CustomFlatButton(
                        child: const Text('Order medication'),
                        onPressed: () {
                          Order newOrder = Order(
                            cart: cart.value
                                .map((key, value) => MapEntry(key.id!, value)),
                            locationGeo: locationGeo,
                            locationString:
                                locationStringController.text.trim(),
                            totalPrice: calculateTotalPrice(),
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
                                cart.value = {};
                                Navigator.pop(context);
                                Navigator.pop(context);
                                navigate(context, OrdersListScreen());
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
                  const SizedBox(height: 50),
                ],
              ),
              CustomAppBar(
                // title: 'Checkout',
                actions: [
                  ValueListenableBuilder<Map<Drug, int>>(
                    valueListenable: cart,
                    builder: (context, value, child) {
                      return value.isEmpty
                          ? const SizedBox()
                          : TextButton.icon(
                              onPressed: () {
                                showConfirmationDialog(
                                  context,
                                  message: 'Clear cart?',
                                  confirmFunction: () {
                                    cart.value = {};
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.remove_shopping_cart_rounded,
                                color: Colors.red,
                              ),
                              label: const Text(
                                'Clear cart',
                                style: TextStyle(color: Colors.red),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red.withOpacity(.2),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                            );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    locationStringController.dispose();

    super.dispose();
  }
}

final ValueNotifier<Map<Drug, int>> cart = ValueNotifier<Map<Drug, int>>({});

addToCart(Drug drug) {
  Map<Drug, int> temp = cart.value;
  if (cart.value.keys.contains(drug)) {
    int qty = temp[drug] ?? 0;
    temp[drug] = qty + 1;
  } else {
    temp[drug] = 1;
  }
  cart.value = {...temp};
}

removeFromCart(Drug drug) {
  Map<Drug, int> temp = cart.value;
  if (cart.value.keys.contains(drug)) {
    int qty = temp[drug] ?? 0;

    if (qty == 0 || qty == 1) {
      temp.remove(drug);
    } else {
      temp[drug] = qty - 1;
    }
  }
  cart.value = {...temp};
}

deleteFromCart(Drug drug) {
  if (cart.value.keys.contains(drug)) {
    Map<Drug, int> temp = cart.value;

    temp.remove(drug);
    cart.value = {...temp};
  }
}

calculateTotalPrice() {
  double sum = 0;
  for (MapEntry<Drug, int> entry in cart.value.entries) {
    sum += entry.key.price! * entry.value;
  }
  return sum;
}

class CheckoutCard extends StatelessWidget {
  final MapEntry<Drug, int> entry;
  const CheckoutCard({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 36),
      decoration: BoxDecoration(
          color: Colors.blueGrey.withOpacity(.2),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          DrugImageWidget(
            drugId: entry.key.id!,
            height: 100,
            width: 100,
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key.genericName!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                entry.key.brandName!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                'GH¢ ${entry.key.price!.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              ValueListenableBuilder<Map<Drug, int>>(
                  valueListenable: cart,
                  builder: (context, value, child) {
                    return Row(
                      children: [
                        IconButton(
                          onPressed: value[entry.key] == 1
                              ? null
                              : () {
                                  removeFromCart(entry.key);
                                },
                          icon: const Icon(Icons.remove_circle),
                        ),
                        Text(value[entry.key].toString()),
                        IconButton(
                          onPressed: () {
                            addToCart(entry.key);
                          },
                          icon: const Icon(Icons.add_circle),
                        )
                      ],
                    );
                  })
            ],
          ),
        ],
      ),
    );
  }
}
