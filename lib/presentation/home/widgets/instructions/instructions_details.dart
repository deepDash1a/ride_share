import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';

class InstructionsDetails extends StatelessWidget {
  const InstructionsDetails({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
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
          text: title,
          fontSize: 16.00.sp,
          fontFamily: FontManager.bold,
          color: ColorsManager.white,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.00.w, vertical: 16.00.h),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
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
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.00.w,
                    vertical: 20.00.h,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          getInstructionsDetails(title),
                          maxLines: 200,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            height: 2.2,
                            fontSize: 14.00.sp,
                            fontFamily: FontManager.bold,
                            color: ColorsManager.secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getInstructionsDetails(String text) {
    switch (text) {
      case 'السيارة':
        return '''ارتداء حزام الأمان:
ارتدِ حزام الأمان طوال الرحلة لضمان سلامتك.

تجنب الأكل والشرب:
إذا لم يكن ذلك مسموحًا، امتنع عن الأكل أو الشرب داخل السيارة.

التخلص من النفايات بشكل صحيح:
لا تترك أي نفايات داخل السيارة، واحملها معك عند النزول.

التواصل بأدب:
تحدث إلى السائق بلطف واحترام.

تجنب النقاشات الحساسة:
امتنع عن الحديث في مواضيع قد تسبب توترًا، مثل السياسة أو الدين.
        ''';
      case 'الركاب':
        return '''الجلوس بشكل صحيح:
اجلس في مكانك المخصص وتجنب تغيير وضعك أثناء حركة السيارة.

عدم فتح الأبواب أثناء السير:
لا تفتح الأبواب أو تحاول النزول إلا بعد توقف السيارة تمامًا.

التحدث بصوت منخفض:
لتجنب تشتيت السائق، تحدث بصوت هادئ.

الامتناع عن الإزعاج:
تجنب التصرفات التي تزعج السائق أو الركاب الآخرين، مثل الضجيج أو الجدال.

عدم التدخل في القيادة:
لا تقدم اقتراحات غير ضرورية للسائق بشأن القيادة أو المسار، إلا إذا طُلب منك ذلك.

        ''';
      case 'معلومات عامة':
        return '''التأكد من بيانات السيارة والكابتن:
قبل ركوب السيارة، تحقق من رقم السيارة واسم الكابتن عبر التطبيق المستخدم لضمان الأمان.

الحفاظ على النظافة والنظام داخل السيارة:
تجنب تناول الطعام أو ترك النفايات داخل السيارة، واحرص على احترام ممتلكات الكابتن.

التواصل بأدب واحترام:
تعامل مع الكابتن بلطف، وقدم تعليمات واضحة حول الوجهة إذا لزم الأمر، وتجنب النقاشات غير الضرورية.

التقييم والملاحظات:
بعد انتهاء الرحلة، قيّم الخدمة بشكل صادق وأضف أي ملاحظات لتحسين التجربة لك ولغيرك.
        ''';
    }
    return '';
  }
}
