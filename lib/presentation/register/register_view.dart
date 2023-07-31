import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maps_app/app/di.dart';
import 'package:maps_app/presentation/common/widgets/widgets.dart';
import 'package:maps_app/presentation/register/cubit/cubit.dart';
import 'package:maps_app/presentation/register/cubit/states.dart';
import 'package:maps_app/presentation/resourses/assets_manager.dart';
import 'package:maps_app/presentation/resourses/color_manager.dart';
import 'package:maps_app/presentation/resourses/routes_manager.dart';
import 'package:maps_app/presentation/resourses/strings_manager.dart';
import 'package:maps_app/presentation/resourses/values_manager.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterStates>(
      listener: (context, state) {
        if (state is UploadLoadingState) {
          dismissDialog(context);
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => showLoadingDialog(context),
          );
        } else if (state is RegisterErrorState) {
          dismissDialog(context);
          showSnackBar(context, text: state.errorMessage);
        }
      },
      builder: (context, state) {
        var cubit = instance<RegisterCubit>();
        return Scaffold(
            backgroundColor: ColorManager.white,
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.whatAboutYou.tr(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: AppSize.s24,
                        ),
                        Text(
                          AppStrings.pleaseAddYourInfo.tr(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: AppSize.s40,
                        ),
                        Center(
                            child: InkWell(
                          onTap: () {
                            _showPicker(context, cubit);
                          },
                          child: cubit.image == null
                              ? SvgPicture.asset(
                                  ImageAssets.addPicIcon,
                                )
                              : _showImageWidget(cubit),
                        )),
                        const SizedBox(
                          height: AppSize.s40,
                        ),
                        TextFormField(
                          controller: firstNameController,
                          validator: _validate,
                          decoration: InputDecoration(
                            labelText: AppStrings.firstName.tr(),
                          ),
                        ),
                        const SizedBox(
                          height: AppSize.s24,
                        ),
                        TextFormField(
                          controller: lastNameController,
                          validator: _validate,
                          decoration: InputDecoration(
                            labelText: AppStrings.lastName.tr(),
                          ),
                        ),
                        const SizedBox(
                          height: AppSize.s80,
                        ),
                        buildElevatedButton(
                          width: double.infinity,
                          onPressed: () {
                            uploadDataFunction(cubit, context);
                          },
                          text: AppStrings.getStarted.tr(),
                        )
                      ]),
                ),
              ),
            ));
      },
    );
  }

  Widget _showImageWidget(RegisterCubit cubit) {
    return Container(
      height: AppSize.s120,
      width: AppSize.s120,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Image.file(
        cubit.image!,
        fit: BoxFit.cover,
      ),
    );
  }

  void _showPicker(BuildContext context, RegisterCubit cubit) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
            child: Container(
          color: ColorManager.white,
          child: Wrap(
            children: [
              ListTile(
                trailing: const Icon(Icons.arrow_forward_ios,
                    size: AppSize.s18, color: ColorManager.blue),
                leading: const Icon(Icons.camera, color: ColorManager.blue),
                title: const Text(AppStrings.fromGallery).tr(),
                onTap: () {
                  cubit.imageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                trailing: const Icon(Icons.arrow_forward_ios,
                    size: AppSize.s18, color: ColorManager.blue),
                leading: const Icon(Icons.camera_alt_outlined,
                    color: ColorManager.blue),
                title: const Text(AppStrings.fromCamera).tr(),
                onTap: () {
                  cubit.imageFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ));
      },
    );
  }

  String? _validate(String? text) {
    if (text == null || text.isEmpty) {
      return "Can't be empty";
    } else {
      return null;
    }
  }

  void uploadDataFunction(RegisterCubit cubit, BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (cubit.image == null) {
        cubit.uploadUserData(
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            whenCompleted: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.doneRoute,
                (route) => false,
              );
            });
      } else {
        cubit.uploadImage(whenCompleted: () {
          cubit.uploadUserData(
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              whenCompleted: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.doneRoute,
                  (route) => false,
                );
              });
        });
      }
    }
  }
}
