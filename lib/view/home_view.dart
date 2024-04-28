import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/constants/colors.dart';
import 'package:flutter_task/constants/fonts_styles.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_task/helper/db_helper.dart';
import 'package:flutter_task/model/cart_model.dart';
import 'package:flutter_task/view-model/cart_view_model.dart';
import 'package:flutter_task/view/cart_view.dart';
import 'package:flutter_task/view/item_detail_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  DBHelper dbHelper = DBHelper();

  List<String> productName = ['Mango', 'Orange', 'Banana', 'Apple'];
  List<String> productUnit = ['kg', 'dozen', 'dozen', 'kg'];
  List<int> productPrice = [120, 100, 80, 150];
  List<String> productImage = [
    'https://images.unsplash.com/photo-1628695323145-5be0b8fde365?q=80&w=1526&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1580052614034-c55d20bfee3b?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?q=80&w=1480&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1589217157232-464b505b197f?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  ];

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartViewModel>(context, listen: false);

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: constantColor,
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: Text('Products List', style: kHeadWhite),
              actions: [
                InkWell(
                  onTap: () => Get.to(() => const CartView(),
                      transition: Transition.rightToLeft),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 15.w),
                      child: badges.Badge(
                        badgeContent: Consumer<CartViewModel>(
                            builder: (context, value, child) {
                          return Text(
                              value != null
                                  ? value.getCounter().toString()
                                  : '0',
                              style: kBody2White);
                        }),
                        child: const Icon((Icons.badge_outlined)),
                      ),
                    ),
                  ),
                )
              ],
            ),
            body: FutureBuilder(
                future: cartProvider.fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return buildShimmer();
                  }
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text(
                        'No Data',
                        style: kHeadBlack,
                      ),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: ListTile(
                            onTap: () => Get.to(
                                () => ItemDetailView(
                                    snapshot: snapshot.data!['products'][index],
                                    categoryName:
                                        snapshot.data!['categoryName']),
                                transition: Transition.size),
                            tileColor: Colors.grey.shade100,
                            leading: Image.network(
                                'https://${snapshot.data!['products'][index]['imageUrl']}',
                                width: 70.w,
                                height: 130.h,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error);
                            }),
                            title: Text(
                                snapshot.data!['products'][index]['brandName'],
                                style: kBody1Black),
                            subtitle: Text(
                                '${snapshot.data!['products'][index]['price']['current']['text']}',
                                style: kBody2Black),
                            trailing: InkWell(
                              onTap: () async {
                                bool itemExists =
                                    await dbHelper.isItemInCart(index);

                                if (itemExists) {
                                  Fluttertoast.showToast(
                                      msg: 'Item already added to cart');
                                  return;
                                }
                                dbHelper
                                    .insert(CartModel(
                                        primaryKey: index,
                                        id: snapshot.data!['products'][index]
                                            ['id'],
                                        categoryName:
                                            snapshot.data!['categoryName'],
                                        name: snapshot.data!['products'][index]
                                                ['name'] ??
                                            '',
                                        quantity: 1,
                                        colour: snapshot.data!['products']
                                                [index]['colour'] ??
                                            '',
                                        brandName: snapshot.data!['products']
                                            [index]['brandName'],
                                        price: snapshot.data!['products'][index]
                                            ['price']['current']['text'],
                                        totalPrice: snapshot.data!['products']
                                            [index]['price']['current']['text'],
                                        image: 'https://${snapshot.data!['products'][index]['imageUrl']}'))
                                    .then((value) {
                                  Fluttertoast.showToast(msg: 'Added to cart');

                                  cartProvider.addCounter();
                                }).onError((error, stackTrace) {});
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: Colors.green),
                                child: Text('Add to cart', style: kBody1White),
                              ),
                            ),
                          ),
                        );
                      });
                })));
  }
}

Widget buildShimmer() {
  return ListView.builder(
    itemCount: 5, // Number of shimmering items
    itemBuilder: (context, index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListTile(
          leading: Container(
            width: 70.w,
            height: 130.h,
            color: Colors.white, // Placeholder color for leading widget
          ),
          title: Container(
            width: double.infinity,
            height: 20,
            color: Colors.white,
          ),
          subtitle: Container(
            width: double.infinity,
            height: 15,
            color: Colors.white,
          ),
          trailing: InkWell(
            onTap: () {}, // Placeholder onTap function
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.green,
              ),
              child: Text('Add to cart', style: kBody1White),
            ),
          ),
        ),
      );
    },
  );
}
