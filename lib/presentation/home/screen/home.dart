import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_share/business_logic/home/home_cubit.dart';
import 'package:ride_share/business_logic/trips/trips_cubit.dart';
import 'package:ride_share/business_logic/wallet/wallet_cubit.dart';
import 'package:ride_share/core/routing/routes.dart';
import 'package:ride_share/core/shared/functions/functions.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/shared/widgets/custom_text_button.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';
import 'package:ride_share/core/themes/images.dart';
import 'package:ride_share/data/models/home/admin_messages.dart';
import 'package:ride_share/data/models/home/instructions.dart';
import 'package:ride_share/presentation/home/widgets/instructions/instructions_details.dart';

// ignore:must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  int isView = 0;

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<HomeCubit>();
    Widget buildInstructionItem(InstructionModel model) {
      return SizedBox(
        width: 150.w,
        height: 100.00.h,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InstructionsDetails(title: model.title),
              ),
            );
          },
          child: Card(
            color: ColorsManager.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  model.image,
                  height: 40.00.h,
                  color: ColorsManager.secondaryColor,
                ),
                SizedBox(height: 5.00.h),
                Flexible(
                  child: CustomText(
                    text: model.title,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget buildMessageItem(AdminMessagesModel model) {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: 10.00.w,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.00.w, vertical: 10.00.h),
        decoration: BoxDecoration(
          color: ColorsManager.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(16.00.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (model.content != null)
              Center(child: CustomText(text: model.content!)),
            SizedBox(height: 5.h),
            if (model.read != null)
              Row(
                children: [
                  Checkbox(
                      value: model.read,
                      onChanged: (value) {
                        cubit.changeVisibilityTrueOrFalse(
                            currentVisibility: model.read ?? false,
                            updateVisibility: (value) {
                              model.read = value;
                            });
                        cubit.updateAdminMessages(
                          content: model.content!,
                          priority: model.priority!,
                          read: model.read!,
                          id: model.id!,
                          date: model.date!,
                        );
                      }),
                  const CustomText(text: 'قرأت'),
                ],
              ),
            SizedBox(height: 5.h),
            Row(
              children: [
                if (model.priority != null)
                  CustomText(
                    text: model.priority == 'high'
                        ? 'غاية الأهمية'
                        : model.priority == 'low'
                            ? 'توضع في الاعتبار'
                            : 'مهمة نسبيًا',
                    fontSize: 12.0.sp,
                    fontFamily: FontManager.regular,
                    color: ColorsManager.whiteBrown,
                  ),
                const Spacer(),
                if (model.date != null)
                  CustomText(
                    text:
                        '${'${model.date}'.split('T')[0]}, ${'${model.date}'.split('T')[1].substring(0, 8)}',
                    fontSize: 12.0.sp,
                    fontFamily: FontManager.regular,
                    color: ColorsManager.grey,
                  ),
              ],
            ),
          ],
        ),
      );
    }

    Widget drawerItem(String image, String title, Function onPressed) {
      return Card(
        color: ColorsManager.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.00.h),
          child: InkWell(
            onTap: () {
              onPressed();
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  image,
                  height: 30.00.h,
                ),
                Expanded(
                  child: CustomText(text: title),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          drawer: SafeArea(
            child: Drawer(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 50.h,
                ),
                child: Column(
                  children: [
                    CustomText(
                      text: 'شارك طريقك الآن',
                      fontSize: 20.sp,
                      fontFamily: FontManager.extraBold,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Flexible(
                      child: SvgPicture.asset(
                        ImagesManagers.rideShareLogo,
                        height: 350.h,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    drawerItem(
                      ImagesManagers.home,
                      'الصفحة الرئيسية',
                      () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: 10.h),
                    drawerItem(
                      ImagesManagers.person,
                      'الملف الشخصي',
                      () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, Routes.profileScreen);
                      },
                    ),
                    SizedBox(height: 10.h),
                    drawerItem(
                      ImagesManagers.trip,
                      'الرحلات',
                      () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, Routes.tripsScreen);
                      },
                    ),
                    SizedBox(height: 10.h),
                    drawerItem(
                      ImagesManagers.rate,
                      'تقييم الرحلات',
                      () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, Routes.feedBackTrip);
                        context.read<TripsCubit>().getCompletedTrips();
                      },
                    ),
                    SizedBox(height: 10.h),
                    drawerItem(
                      ImagesManagers.message,
                      'رسائلي',
                      () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, Routes.chatTrip);

                        context.read<TripsCubit>().chatTrips = [];
                        context.read<TripsCubit>().getAllChatTrips();
                      },
                    ),
                    SizedBox(height: 10.h),
                    drawerItem(
                      ImagesManagers.compass,
                      'مواقعي المفضلة',
                      () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, Routes.locationsScreen);
                      },
                    ),
                    SizedBox(height: 10.h),
                    drawerItem(
                      ImagesManagers.logout,
                      'تسجيل الخروج',
                      () {
                        logout(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          appBar: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: SvgPicture.asset(
                  ImagesManagers.menu,
                  color: ColorsManager.white,
                  height: 25.h,
                ),
              ),
            ),
            titleSpacing: 0.00,
            title: Center(
              child: cubit.getUserProfileModel == null
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : Column(
                      children: [
                        CustomText(
                          text:
                              '${cubit.getUserProfileModel!.body!.firstName} ${cubit.getUserProfileModel!.body!.secondName}',
                          fontSize: 16.00.sp,
                          fontFamily: FontManager.bold,
                          color: ColorsManager.white,
                        ),
                        CustomText(
                          text: '${cubit.getUserProfileModel!.body!.email} ',
                          fontSize: 12.00.sp,
                          color: ColorsManager.grey,
                        ),
                      ],
                    ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0.w,
                vertical: 16.0.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.walletScreen,
                      );
                      context.read<WalletCubit>().getUserBalance();
                      context.read<WalletCubit>().getAllWalletTransactions();
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity.w,
                          height: 200.h,
                          child: Card(
                            color: ColorsManager.mainColor.withOpacity(0.2),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 32.w,
                            right: 32.w,
                            top: 20.h,
                          ),
                          child: SizedBox(
                            width: double.infinity.w,
                            height: 180.h,
                            child: const Card(
                              color: ColorsManager.whiteBrown,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 16.w,
                            right: 16.w,
                            top: 40.h,
                          ),
                          child: SizedBox(
                            width: double.infinity.w,
                            height: 160.h,
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 16.h,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      text: 'تفقد \n حساب محفظتك',
                                      fontSize: 18.0.sp,
                                      height: 1,
                                      color: Colors.brown,
                                      fontWeight: FontWeight.bold,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          bottom: 0,
                          child: SvgPicture.asset(
                            ImagesManagers.walletVector,
                            height: 180.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0.h),
                  CustomText(
                    text: 'معلومات هامة',
                    fontSize: 16.sp,
                    fontFamily: FontManager.bold,
                  ),
                  SizedBox(
                    height: 100.00.h,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => buildInstructionItem(
                        cubit.instructionModelList[index],
                      ),
                      separatorBuilder: (context, index) => SizedBox(
                        width: 10.00.w,
                      ),
                      itemCount: cubit.instructionModelList.length,
                    ),
                  ),
                  SizedBox(height: 20.0.h),
                  CustomText(
                    text: 'رسائل الإدارة',
                    fontSize: 16.sp,
                    fontFamily: FontManager.bold,
                  ),
                  SizedBox(height: 20.0.h),
                  cubit.unReadMessages.isEmpty
                      ? const Center(
                          child: CustomText(text: 'لا توجد رسائل جديدة لعرضها'),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return buildMessageItem(cubit.unReadMessages.last);
                          },
                          itemCount: 1,
                        ),
                  SizedBox(height: 10.0.h),
                  cubit.readMessages.isEmpty && cubit.unReadMessages.isEmpty
                      ? const SizedBox()
                      : Row(
                          children: [
                            Expanded(
                              child: CustomTextButton(
                                text: 'عرض الكل',
                                onPressed: () {
                                  cubit.changeVisibilityTrueOrFalse(
                                      currentVisibility: cubit.showAllMessages,
                                      updateVisibility: (value) {
                                        cubit.showAllMessages = value;
                                        isView = 1;
                                      });
                                },
                              ),
                            ),
                            Expanded(
                              child: CustomTextButton(
                                text: 'الرسائل المقروءة',
                                onPressed: () {
                                  cubit.changeVisibilityTrueOrFalse(
                                      currentVisibility: cubit.showAllMessages,
                                      updateVisibility: (value) {
                                        cubit.showAllMessages = value;
                                        isView = 2;
                                      });
                                },
                              ),
                            ),
                          ],
                        ),
                  isView == 1
                      ? cubit.generalAdminMessagesModel == null
                          ? const Center(
                              child: CustomText(text: 'لا توجد رسائل لعرضها'))
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return buildMessageItem(cubit
                                    .generalAdminMessagesModel!.body![index]);
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 20.00.h),
                              itemCount:
                                  cubit.generalAdminMessagesModel!.body!.length,
                            )
                      : const SizedBox(),
                  isView == 2
                      ? cubit.readMessages.isEmpty
                          ? const Center(
                              child: CustomText(
                                  text: 'لا توجد رسائل مقروءة لعرضها'),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return buildMessageItem(
                                    cubit.readMessages[index]);
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 20.00.h),
                              itemCount: cubit.readMessages.length,
                            )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
