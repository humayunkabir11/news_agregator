import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class NewsShimmer extends StatelessWidget {
  const NewsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 4,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        itemBuilder: (_, __) => Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 180.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 10.h, width: 80.w, color: Colors.white),
                      SizedBox(height: 10.h),
                      Container(height: 16.h, width: double.infinity, color: Colors.white),
                      SizedBox(height: 6.h),
                      Container(height: 16.h, width: 200.w, color: Colors.white),
                      SizedBox(height: 10.h),
                      Container(height: 12.h, width: double.infinity, color: Colors.white),
                      SizedBox(height: 4.h),
                      Container(height: 12.h, width: double.infinity, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
