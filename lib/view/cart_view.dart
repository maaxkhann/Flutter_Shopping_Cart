import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/constants/colors.dart';
import 'package:flutter_task/constants/fonts_styles.dart';
import 'package:flutter_task/helper/db_helper.dart';
import 'package:flutter_task/model/cart_model.dart';
import 'package:flutter_task/view-model/cart_view_model.dart';
import 'package:flutter_task/view/cart_detail_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  DBHelper dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartViewModel>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: constantColor,
          centerTitle: true,
          title: Text('My Products', style: kHeadWhite),
          actions: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(right: 15.w),
                child: badges.Badge(
                  badgeContent:
                      Consumer<CartViewModel>(builder: (context, value, child) {
                    return Text(
                        value != null ? value.getCounter().toString() : '0',
                        style: kBody2White);
                  }),
                  child: const Icon((Icons.badge_outlined)),
                ),
              ),
            )
          ],
        ),
        body: FutureBuilder(
            future: cartProvider.getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                    child: Text(
                  'No Data',
                  style: kHeadBlack,
                ));
              }

              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Consumer<CartViewModel>(
                            builder: (ctx, value, child) {
                          return ListTile(
                              onTap: () => Get.to(
                                  () => CartDetailView(
                                      snapshot: snapshot.data![index]),
                                  transition: Transition.size),
                              tileColor: Colors.grey.shade100,
                              leading: Image.network(
                                  snapshot.data![index].image.toString(),
                                  width: 70.w,
                                  height: 130.h,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error);
                              }),
                              title: Text(
                                  snapshot.data![index].brandName.toString(),
                                  style: kBody1Black),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data![index].totalPrice,
                                      style: kBody2Black),
                                  Row(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            setState(() {});
                                            int quantity =
                                                snapshot.data![index].quantity;

                                            if (quantity > 1) {
                                              value.decrementQuantity(
                                                  snapshot.data![index], index);
                                            }
                                          },
                                          child: const Icon(Icons.remove)),
                                      SizedBox(width: 6.w),
                                      Text(
                                          snapshot.data![index].quantity
                                              .toString(),
                                          style: kBody1Black),
                                      SizedBox(width: 6.w),
                                      InkWell(
                                          onTap: () {
                                            setState(() {});
                                            int quantity =
                                                snapshot.data![index].quantity;

                                            if (quantity > 0) {
                                              value.incrementQuantity(
                                                  snapshot.data![index], index);
                                            }
                                          },
                                          child: const Icon(Icons.add)),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: InkWell(
                                  onTap: () {
                                    value
                                        .delete(
                                            snapshot.data![index].primaryKey)
                                        .then((val) {
                                      value.removeCounter();
                                      setState(() {});
                                    });
                                  },
                                  child: const Icon(Icons.delete)));
                        }));
                  });
            }),
      ),
    );
  }
}
