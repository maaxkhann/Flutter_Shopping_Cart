import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/constants/colors.dart';
import 'package:flutter_task/constants/fonts_styles.dart';
import 'package:get/get.dart';

class ItemDetailView extends StatelessWidget {
  final dynamic snapshot;
  final String categoryName;
  const ItemDetailView(
      {super.key, required this.snapshot, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: constantColor,
      appBar: AppBar(
        backgroundColor: constantColor,
        centerTitle: true,
        title: Text(
          'Item Details',
          style: kHeadWhite,
        ),
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          margin: EdgeInsets.only(top: Get.height * 0.06),
          width: double.infinity,
          height: Get.height * 0.6,
          decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Image.network(
                'https://${snapshot['imageUrl']}',
                width: 70.h,
                height: 130.h,
              )),
              ReUsableRow(title: 'Category', value: categoryName),
              ReUsableRow(title: 'Name', value: snapshot['name']),
              ReUsableRow(title: 'Brand Name', value: snapshot['brandName']),
              ReUsableRow(title: 'Color', value: snapshot['colour']),
              ReUsableRow(
                  title: 'Price', value: snapshot['price']['current']['text']),
            ],
          ),
        ),
      ),
    ));
  }
}

class ReUsableRow extends StatelessWidget {
  final String title;
  final String value;
  const ReUsableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: kBody1Black,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: kBody1Black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
