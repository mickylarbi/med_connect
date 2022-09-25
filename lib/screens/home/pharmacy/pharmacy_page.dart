import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_connect/firebase_services/firestore_service.dart';
import 'package:med_connect/firebase_services/storage_service.dart';
import 'package:med_connect/models/pharmacy/drug.dart';
import 'package:med_connect/screens/home/pharmacy/checkout_screen.dart';
import 'package:med_connect/screens/home/pharmacy/drug_details_screen.dart';
import 'package:med_connect/screens/home/pharmacy/drugs_search_delegate.dart';
import 'package:med_connect/screens/home/pharmacy/orders_list_screen.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect/utils/functions.dart';

class PharmacyPage extends StatefulWidget {
  const PharmacyPage({Key? key}) : super(key: key);

  @override
  State<PharmacyPage> createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  ScrollController scrollController = ScrollController();

  FirestoreService db = FirestoreService();

  List<Drug> drugsList = [];
  List<String> groups = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      children: [
        ListView(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 36),
          children: [
            const SizedBox(height: 150),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: db.drugsCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Reload'),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                drugsList = snapshot.data!.docs
                    .map((e) => Drug.fromFirestore(e.data(), e.id))
                    .toList();

                for (Drug drug in drugsList) {
                  if (!groups.contains(drug.group!.toLowerCase())) {
                    groups.add(drug.group!);
                  }
                }

                groups
                    .sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

                return drugsList.isEmpty
                    ? const Center(
                        child: Text('No drugs to show'),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: .55,
                        ),
                        itemCount: drugsList.length,
                        itemBuilder: (BuildContext context, int categoryIndex) {
                          return DrugCard(drug: drugsList[categoryIndex]);
                        },
                      );
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
        ValueListenableBuilder<Map<Drug, int>>(
            valueListenable: cart,
            builder: (context, value, child) {
              return value.isEmpty
                  ? const SizedBox()
                  : Positioned(
                      bottom: 24,
                      right: 24,
                      child: Stack(
                        children: [
                          FloatingActionButton(
                            onPressed: () {
                              navigate(context, const CheckoutScreen());
                            },
                            child: const Icon(Icons.shopping_cart_checkout),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 10,
                              child: Text(
                                value.length.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
            }),
        ...fancyAppBar(
          context,
          scrollController,
          'Pharmacy',
          [
            OutlineIconButton(
              iconData: Icons.search,
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: DrugSearchDelegate(drugsList, groups));
              },
            ),
            const SizedBox(width: 10),
            OutlineIconButton(
              iconData: Icons.view_list_rounded,
              onPressed: () {
                navigate(context, OrdersListScreen());
              },
            ),
          ],
        )
      ],
    ));
  }
}

class DrugCard extends StatelessWidget {
  final Drug drug;
  const DrugCard({Key? key, required this.drug}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigate(
            context,
            DrugDetailsScreen(
              drug: drug,
              showButton: true,
            ));
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: Center(
                    child: DrugImageWidget(
              drugId: drug.id!,
              width: double.maxFinite,
            ))),
            const SizedBox(height: 10),
            Text(
              drug.genericName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Text(
              drug.brandName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Text(
              'GH¢ ${drug.price!.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            ValueListenableBuilder<Map<Drug, int>>(
                valueListenable: cart,
                builder: (context, value, child) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: drug.quantityInStock == 0
                        ? Container(
                            alignment: Alignment.centerRight,
                            height: 40,
                            child: const Text('Out of stock'))
                        : SolidIconButton(
                            iconData: value.keys.contains(drug)
                                ? Icons.delete_rounded
                                : Icons.add_shopping_cart_rounded,
                            color: value.keys.contains(drug)
                                ? Colors.orange
                                : Colors.green,
                            onPressed: () {
                              if (value.keys.contains(drug)) {
                                deleteFromCart(drug);
                              } else {
                                addToCart(drug);
                              }
                            },
                          ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class DrugImageWidget extends StatelessWidget {
  final String drugId;
  final double? height;
  final double? width;
  DrugImageWidget({Key? key, required this.drugId, this.height, this.width})
      : super(key: key);

  StorageService storage = StorageService();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return FutureBuilder(
          future: storage.drugImageDownloadUrl(drugId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return SizedBox(
                height: height,
                width: width,
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {});
                    },
                  ),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CachedNetworkImage(
                  imageUrl: snapshot.data!,
                  height: height,
                  width: width,
                  fit: BoxFit.fitWidth,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator.adaptive(
                        value: downloadProgress.progress),
                  ),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.person)),
                ),
              );
            }

            return SizedBox(
              height: height,
              width: width,
              child: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          },
        );
      },
    );
  }
}
