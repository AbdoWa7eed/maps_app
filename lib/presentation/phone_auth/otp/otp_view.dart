import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/app/di.dart';
import 'package:maps_app/presentation/phone_auth/cubit/cubit.dart';
import 'package:maps_app/presentation/phone_auth/cubit/states.dart';
import 'package:maps_app/presentation/resourses/color_manager.dart';
import 'package:maps_app/presentation/resourses/language_manager.dart';
import 'package:maps_app/presentation/resourses/routes_manager.dart';
import 'package:maps_app/presentation/resourses/strings_manager.dart';
import 'package:maps_app/presentation/resourses/values_manager.dart';
import 'package:maps_app/presentation/common/widgets/widgets.dart';
import 'package:pinput/pinput.dart';

class OTPView extends StatelessWidget {
  OTPView({super.key});
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneAuthCubit, PhoneAuthStates>(
      listener: (context, state) {
        if (state is VerifiactionCodeLoadingState) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => showLoadingDialog(context),
          );
        } else if (state is VerifiactionCodeErrorState) {
          dismissDialog(context);
          showSnackBar(context, text: state.error);
        }
      },
      builder: (context, state) {
        var cubit = instance<PhoneAuthCubit>();
        return Scaffold(
          appBar: AppBar(),
          backgroundColor: ColorManager.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                AppStrings.verifyYourPhoneNumber.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: AppSize.s24,
              ),
              RichText(
                  text: TextSpan(
                      text: AppStrings.enterDigitsText.tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                      children: <TextSpan>[
                    TextSpan(
                      text: cubit.phoneNumber!,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: ColorManager.blue),
                    )
                  ])),
              const SizedBox(
                height: AppSize.s80,
              ),
              Pinput(
                controller: _controller,
                length: 6,
                androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                onCompleted: (value) {
                  cubit.signIn(
                      smsCode: _controller.text,
                      whenCompleted: () {
                        _whenSignInCompelete(cubit, context);
                      });
                },
                defaultPinTheme: PinTheme(
                  width: AppSize.s56,
                  height: AppSize.s56,
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorManager.blue),
                    borderRadius: BorderRadius.circular(AppSize.s10),
                  ),
                ),
              ),
              const SizedBox(
                height: AppSize.s80,
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: buildElevatedButton(
                  onPressed: () {
                    cubit.signIn(
                        smsCode: _controller.text,
                        whenCompleted: () {
                          _whenSignInCompelete(cubit, context);
                        });
                  },
                  text: AppStrings.verify.tr(),
                ),
              )
            ]),
          ),
        );
      },
    );
  }

  _whenSignInCompelete(PhoneAuthCubit cubit, BuildContext context) {
    if (cubit.isRegisterd != null) {
      if (!cubit.isRegisterd!) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Routes.registerRoute, (route) => false);
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Routes.homeRoute, (route) => false);
      }
    }
  }

  bool isRTL(BuildContext context) {
    return context.locale == arabicLocal;
  }
}
