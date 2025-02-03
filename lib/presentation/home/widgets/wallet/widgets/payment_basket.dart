import 'dart:async'; // لإضافة Timer

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_share/business_logic/wallet/wallet_cubit.dart';
import 'package:ride_share/core/shared/widgets/custom_button.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/shared/widgets/custom_text_button.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';
import 'package:ride_share/core/themes/images.dart';
import 'package:ride_share/data/models/home/wallet/get_wallet_transactions.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentBasket extends StatefulWidget {
  const PaymentBasket({super.key});

  @override
  _PaymentBasketState createState() => _PaymentBasketState();
}

class _PaymentBasketState extends State<PaymentBasket> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      context.read<WalletCubit>().getWalletBasketTransactions();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<WalletCubit>();
    return BlocConsumer<WalletCubit, WalletState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                  context.read<WalletCubit>().getUserBalance();
                });
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: ColorsManager.white,
                size: 20.00,
              ),
            ),
            titleSpacing: 0.00,
            title: CustomText(
              text: 'محفظتي',
              fontSize: 16.00.sp,
              fontFamily: FontManager.bold,
              color: ColorsManager.white,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: [
                  cubit.basketTransactions.isEmpty
                      ? const SizedBox()
                      : Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: const CustomText(
                              text: 'انتظر 30 ثانية بعد الدفع'),
                        ),
                  cubit.basketTransactions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 100.h),
                              SvgPicture.asset(
                                ImagesManagers.noData,
                                height: 200.h,
                              ),
                              const CustomText(
                                text: 'لا توجد عمليات معلقة لعرضها',
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            // Reversed list
                            final reversedIndex =
                                cubit.basketTransactions.length - 1 - index;
                            return transactionsCard(
                              context,
                              walletModel:
                                  cubit.basketTransactions[reversedIndex],
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 10.h,
                          ),
                          itemCount: cubit.basketTransactions.length,
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchURL(int id) async {
    final Uri url = Uri.parse(
        'https://ride-share.commuterscarpoling.net/api/kashier/payment/$id');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget transactionsCard(
    BuildContext context, {
    WalletTransactions? walletModel,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 20.w),
                Expanded(
                  child: Center(
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '${walletModel!.initialAmount}',
                          style: TextStyle(
                            fontSize: 25.sp,
                            color: ColorsManager.secondaryColor,
                            fontFamily: FontManager.extraBold,
                          ),
                        ),
                        const TextSpan(text: '  '),
                        TextSpan(
                          text: 'جنيهًا',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: ColorsManager.secondaryColor,
                            fontFamily: FontManager.regular,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: ColorsManager.red,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const CustomText(text: 'تأكيد الحذف'),
                        content: const CustomText(
                            text: 'هل أنت متأكد أنك تريد حذف هذه المعاملة؟'),
                        actions: [
                          CustomTextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            text: 'إلغاء',
                          ),
                          CustomTextButton(
                            onPressed: () {
                              context
                                  .read<WalletCubit>()
                                  .deleteWalletTransaction(id: walletModel.id!);
                              Navigator.of(context).pop();
                            },
                            text: 'تأكيد الحذف',
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 10.h),
            CustomButton(
              text: 'تأكيد الدفع',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const CustomText(text: 'تأكيد الدفع'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          text:
                              'هل أنت متأكد أنك تريد تأكيد دفع مبلغ ${walletModel.initialAmount}؟',
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: CustomText(
                                text:
                                    'https://ride-share.commuterscarpoling.net/api/kashier/payment/${walletModel.id!}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text:
                                        'https://ride-share.commuterscarpoling.net/api/kashier/payment/${walletModel.id!}'));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: CustomText(
                                        text: 'تم نسخ الرابط إلى الحافظة'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const CustomText(text: 'إلغاء'),
                      ),
                      TextButton(
                        onPressed: () {
                          _launchURL(walletModel.id!);
                          Navigator.of(context).pop();
                        },
                        child: const CustomText(text: 'تأكيد الدفع'),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 10.h),
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
    );
  }
}
