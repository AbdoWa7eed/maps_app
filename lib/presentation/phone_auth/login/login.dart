// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:maps_app/app/di.dart';
import 'package:maps_app/presentation/phone_auth/cubit/cubit.dart';
import 'package:maps_app/presentation/phone_auth/cubit/states.dart';
import 'package:maps_app/presentation/resourses/color_manager.dart';
import 'package:maps_app/presentation/resourses/routes_manager.dart';
import 'package:maps_app/presentation/resourses/strings_manager.dart';
import 'package:maps_app/presentation/resourses/values_manager.dart';
import 'package:maps_app/presentation/common/widgets/widgets.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneAuthCubit, PhoneAuthStates>(
      listener: (context, state) {
        if (state is SendCodeLoadingState) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => showLoadingDialog(context),
          );
        } else if (state is SendCodeErrorState) {
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
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.askForPhoneNumber.tr(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: AppSize.s24,
                    ),
                    Text(
                      AppStrings.enterYourPhoneNumber.tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: AppSize.s80,
                    ),
                    IntlPhoneField(
                      invalidNumberMessage: AppStrings.invalidNumber.tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                      onChanged: (phone) {
                        cubit.phoneNumber = phone.completeNumber;
                      },
                      decoration: InputDecoration(
                          labelText: AppStrings.phoneNumber.tr()),
                      dropdownTextStyle:
                          Theme.of(context).textTheme.titleMedium,
                      initialValue: '+20',
                      pickerDialogStyle: PickerDialogStyle(
                          countryCodeStyle:
                              Theme.of(context).textTheme.titleMedium),
                    ),
                    const SizedBox(
                      height: AppSize.s80,
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: buildElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                cubit.phoneNumber != null) {
                              cubit.sendVerificationCode(codeSent: () {
                                dismissDialog(context);
                                Navigator.of(context)
                                    .pushNamed(Routes.otbRoute);
                              });
                            }
                          },
                          text: AppStrings.next.tr()),
                    )
                  ]),
            ),
          ),
        );
      },
    );
  }
}
