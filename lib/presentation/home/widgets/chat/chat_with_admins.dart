import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ride_share/business_logic/trips/trips_cubit.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences.dart';
import 'package:ride_share/core/shared/shared_preferences/shared_preferences_keys.dart';
import 'package:ride_share/core/shared/widgets/custom_text.dart';
import 'package:ride_share/core/shared/widgets/custom_text_form_field.dart';
import 'package:ride_share/core/themes/colors.dart';
import 'package:ride_share/core/themes/fonts.dart';
import 'package:ride_share/core/themes/images.dart';

class ChatWithAdmins extends StatefulWidget {
  const ChatWithAdmins({super.key});

  @override
  State<ChatWithAdmins> createState() => _ChatWithAdminsState();
}

class _ChatWithAdminsState extends State<ChatWithAdmins> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripsCubit, TripsState>(
      listener: (context, state) {
        if (state is SuccessStoreConversationAppState) {
          _controller.clear();
          context.read<TripsCubit>().getCustomConversation(
                id: SharedPreferencesService.getData(
                  key: SharedPreferencesKeys.saveChatTripId,
                ),
              );
          Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
        }
      },
      builder: (context, state) {
        var cubit = context.watch<TripsCubit>();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorsManager.secondaryColor,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            title: CustomText(
              text: 'تحدث مع الإدارة',
              fontSize: 18.sp,
              fontFamily: FontManager.bold,
              color: Colors.white,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.arrow_downward, color: Colors.white),
                onPressed: _scrollToBottom,
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  // إعادة تحميل الرسائل
                  context.read<TripsCubit>().getCustomConversation(
                        id: SharedPreferencesService.getData(
                          key: SharedPreferencesKeys.saveChatTripId,
                        ),
                      );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                  child: state is LoadingGetCustomConversationAppState
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount:
                              cubit.getCustomChatModel?.body?.length ?? 0,
                          itemBuilder: (context, index) {
                            final message =
                                cubit.getCustomChatModel!.body![index];
                            final bool isUser = message.senderType == "user";

                            return Align(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 10.w),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12.h, horizontal: 16.w),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? ColorsManager.secondaryColor
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: CustomText(
                                  text: message.message!,
                                  fontSize: 14.sp,
                                  color: isUser ? Colors.white : Colors.black,
                                ),
                              ),
                            );
                          },
                        )),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        hintText: 'اكتب رسالتك هنا...',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(10.w),
                          child: SvgPicture.asset(ImagesManagers.message,
                              height: 24.h),
                        ),
                        controller: _controller,
                        inputType: TextInputType.text,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: ColorsManager.mainColor,
                      child: IconButton(
                        onPressed: () {
                          if (_controller.text.trim().isNotEmpty) {
                            context.read<TripsCubit>().storeConversation(
                                  message: _controller.text.trim(),
                                  tripId: SharedPreferencesService.getData(
                                      key:
                                          SharedPreferencesKeys.saveChatTripId),
                                );
                          }
                        },
                        icon: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
