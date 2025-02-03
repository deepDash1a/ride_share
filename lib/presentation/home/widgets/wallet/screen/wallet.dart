import 'dart:async'; // لإضافة Timer

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_share/business_logic/wallet/wallet_cubit.dart';
import 'package:ride_share/core/routing/routes.dart';
import 'package:ride_share/core/shared/functions/functions.dart';
import 'package:ride_share/core/shared/widgets/custom_button.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/shared/widgets/custom_text_button.dart';
import 'package:ride_share/core/shared/widgets/custom_text_form_field.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';
import 'package:ride_share/core/themes/images.dart';
import 'package:ride_share/data/models/home/wallet/get_wallet_transactions.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 2), (timer) {
      context.read<WalletCubit>().getAllWalletTransactions();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget transactionsCard(
    BuildContext context, {
    WalletTransactions? walletModel,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                child: SvgPicture.asset(
                  ImagesManagers.swapArrows,
                  fit: BoxFit.cover,
                  height: 25.h,
                ),
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: walletModel!.reason ?? 'إيداع'),
                  SizedBox(height: 5.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomText(
                      text:
                          '${walletModel.operationType ?? 'إيداع'} بقيمة ${walletModel.initialAmount ?? '0'}',
                      fontSize: 14.sp,
                      color: ColorsManager.red,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  CustomText(
                    text: ' الإجمالي ${walletModel.balance ?? '0'}',
                    fontSize: 14.sp,
                    color: ColorsManager.grey,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: walletModel.createdAt!.split('T').first ?? '0',
                      fontSize: 14.sp,
                      color: ColorsManager.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<WalletCubit>();
    var formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: ColorsManager.white,
            size: 20.00,
          ),
        ),
        titleSpacing: 0.00,
        title: CustomText(
          text: 'المحفظة',
          fontSize: 16.00.sp,
          fontFamily: FontManager.bold,
          color: ColorsManager.white,
        ),
      ),
      body: BlocConsumer<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state is SuccessDepositToWalletAppState) {
            customSnackBar(
              context: context,
              text:
                  'تم إضافة ${cubit.amountValueController.text} جنية، برجاء الذهاب للمحفظة للتأكيد',
              color: ColorsManager.mainColor,
            );
            cubit.amountValueController.clear();
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    width: double.infinity.w,
                    decoration: BoxDecoration(
                      color: ColorsManager.secondaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.r),
                        bottomRight: Radius.circular(30.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          CustomText(
                            text: 'رصيدك الفعلي',
                            color: ColorsManager.white,
                            fontSize: 18.sp,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              context.read<WalletCubit>().getUserBalanceModel ==
                                      null
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : CustomText(
                                      text:
                                          ' ${context.read<WalletCubit>().getUserBalanceModel!.body!.lastBalance}',
                                      color: ColorsManager.white,
                                      fontSize: 35.sp,
                                    ),
                              CustomText(
                                text: 'ج.م',
                                color: ColorsManager.white,
                                fontSize: 25.sp,
                                fontFamily: FontManager.extraBold,
                              ),
                            ],
                          ),
                          CustomText(
                            text: 'قم بالإيداع الآن واستمتع بالرحلات',
                            color: ColorsManager.white.withOpacity(0.7),
                          ),
                          SizedBox(height: 20.h),
                          state is SuccessDepositToWalletAppState
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 35.r,
                                          ),
                                          CustomTextButton(
                                            text: 'محفظتي',
                                            textColor: ColorsManager.mainColor,
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                context,
                                                Routes.walletBasketScreen,
                                              );
                                              cubit
                                                  .getWalletBasketTransactions();
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                    ],
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: CustomTextButton(
                                    text: 'محفظتي',
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.walletBasketScreen,
                                      );
                                      cubit.getWalletBasketTransactions();
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity.w,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextFormField(
                            hintText: 'قيمة مقترح الإيداع',
                            prefixIcon: SvgPicture.asset(
                              ImagesManagers.pay,
                              height: 10.00.h,
                            ),
                            controller: cubit.amountValueController,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'أدخل قيمة الإيداع';
                              }
                              return null;
                            },
                            inputType: TextInputType.number,
                          ),
                          SizedBox(height: 20.h),
                          state is LoadingDepositToWalletAppState
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Center(
                                  child: CustomButton(
                                  text: 'أكد المُقترح',
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.depositToWallet();
                                    }
                                  },
                                )),
                          SizedBox(height: 25.h),
                          state is LoadingGetWalletTransactionsAppState
                              ? const SizedBox()
                              : cubit.transactions.isEmpty
                                  ? Center(
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            ImagesManagers.noData,
                                            height: 200.h,
                                          ),
                                          const CustomText(
                                              text:
                                                  'لا توجد عمليات ناجحة لعرضها'),
                                        ],
                                      ),
                                    )
                                  : ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) =>
                                          transactionsCard(context,
                                              walletModel:
                                                  cubit.transactions[index]),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        height: 10,
                                      ),
                                      itemCount: cubit.transactions.length,
                                    ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
