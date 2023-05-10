import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/api.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_page_settings.dart';
import 'package:fuodz/services/custom_form_builder_validator.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/register.view_model.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/cards/document_selection.view.dart';
import 'package:fuodz/widgets/states/custom_loading.state.dart';

import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    final inputDec = InputDecoration(
      border: OutlineInputBorder(),
    );

    //
    return ViewModelBuilder<RegisterViewModel>.reactive(
      viewModelBuilder: () => RegisterViewModel(context),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          isLoading: vm.isBusy,
          body: FormBuilder(
            key: vm.formBuilderKey,
            autoFocusOnValidationFailure: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: VStack(
              [
                //appbar
                SafeArea(
                  child: HStack(
                    [
                      Icon(
                        FlutterIcons.close_ant,
                        size: 24,
                        color: Utils.textColorByTheme(),
                      ).p8().onInkTap(() {
                        context.pop();
                      }).p12(),
                    ],
                  ),
                ).box.color(AppColor.primaryColor).make().wFull(context),

                //
                VStack(
                  [
                    //
                    VStack(
                      [
                        "Become a partner"
                            .tr()
                            .text
                            .xl3
                            .color(Utils.textColorByTheme())
                            .bold
                            .make(),
                        "Fill form below to continue"
                            .tr()
                            .text
                            .light
                            .color(Utils.textColorByTheme())
                            .make(),
                      ],
                    )
                        .p20()
                        .box
                        .color(AppColor.primaryColor)
                        .make()
                        .wFull(context),

                    //form
                    VStack(
                      [
                        //
                        "Business Information"
                            .tr()
                            .text
                            .underline
                            .xl
                            .semiBold
                            .make(),
                        UiSpacer.vSpace(30),
                        //
                        FormBuilderTextField(
                          name: "vendor_name",
                          validator: CustomFormBuilderValidator.required,
                          decoration: inputDec.copyWith(
                            labelText: "Name".tr(),
                          ),
                        ),

                        //
                        CustomLoadingStateView(
                          loading: vm.busy(vm.vendorTypes),
                          child: FormBuilderDropdown(
                            name: 'vendor_type_id',
                            decoration: inputDec.copyWith(
                              labelText: "Vendor Type".tr(),
                              hintText: 'Select Vendor Type'.tr(),
                            ),
                            validator: CustomFormBuilderValidator.required,
                            items: vm.vendorTypes
                                .map(
                                  (vendorType) => DropdownMenuItem(
                                    value: vendorType.id,
                                    child: '${vendorType.name}'.text.make(),
                                  ),
                                )
                                .toList(),
                          ),
                        ).py20(),

                        FormBuilderTextField(
                          name: "vendor_email",
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              CustomFormBuilderValidator.compose(
                            [
                              CustomFormBuilderValidator.required(value),
                              CustomFormBuilderValidator.email(value),
                            ],
                          ),
                          decoration: inputDec.copyWith(
                            labelText: "Email".tr(),
                          ),
                        ),

                        FormBuilderTextField(
                          name: "vendor_phone",
                          keyboardType: TextInputType.phone,
                          validator: CustomFormBuilderValidator.required,
                          decoration: inputDec.copyWith(
                            labelText: "Phone".tr(),
                            prefixIcon: HStack(
                              [
                                //icon/flag
                                Flag.fromString(
                                  vm.selectedVendorCountry.countryCode,
                                  width: 20,
                                  height: 20,
                                ),
                                UiSpacer.horizontalSpace(space: 5),
                                //text
                                ("+" + vm.selectedVendorCountry.phoneCode)
                                    .text
                                    .make(),
                              ],
                            )
                                .px8()
                                .onInkTap(() => vm.showCountryDialPicker(true)),
                          ),
                        ).py20(),

                        //business documents
                        DocumentSelectionView(
                          title: "Documents".tr(),
                          instruction:
                              AppPageSettings.vendorDocumentInstructions,
                          max: AppPageSettings.maxVendorDocumentCount,
                          onSelected: vm.onDocumentsSelected,
                        ),

                        UiSpacer.divider().py12(),
                        "Personal Information"
                            .tr()
                            .text
                            .underline
                            .xl
                            .semiBold
                            .make(),
                        UiSpacer.vSpace(30),

                        FormBuilderTextField(
                          name: "name",
                          validator: CustomFormBuilderValidator.required,
                          decoration: inputDec.copyWith(
                            labelText: "Name".tr(),
                          ),
                        ),

                        FormBuilderTextField(
                          name: "email",
                          keyboardType: TextInputType.emailAddress,
                          validator: CustomFormBuilderValidator.email,
                          decoration: inputDec.copyWith(
                            labelText: "Email".tr(),
                          ),
                        ).py20(),

                        FormBuilderTextField(
                          name: "phone",
                          keyboardType: TextInputType.phone,
                          validator: CustomFormBuilderValidator.required,
                          decoration: inputDec.copyWith(
                            labelText: "Phone".tr(),
                            prefixIcon: HStack(
                              [
                                //icon/flag
                                Flag.fromString(
                                  vm.selectedCountry.countryCode,
                                  width: 20,
                                  height: 20,
                                ),
                                UiSpacer.horizontalSpace(space: 5),
                                //text
                                ("+" + vm.selectedCountry.phoneCode)
                                    .text
                                    .make(),
                              ],
                            ).px8().onInkTap(vm.showCountryDialPicker),
                          ),
                        ),

                        FormBuilderTextField(
                          name: "password",
                          obscureText: vm.hidePassword,
                          validator: CustomFormBuilderValidator.required,
                          decoration: inputDec.copyWith(
                            labelText: "Password".tr(),
                            suffixIcon: Icon(
                              vm.hidePassword
                                  ? FlutterIcons.ios_eye_ion
                                  : FlutterIcons.ios_eye_off_ion,
                            ).onInkTap(() {
                              vm.hidePassword = !vm.hidePassword;
                              vm.notifyListeners();
                            }),
                          ),
                        ).py20(),

                        FormBuilderCheckbox(
                          name: "agreed",
                          title: "I agree with"
                              .tr()
                              .richText
                              .semiBold
                              .withTextSpanChildren(
                            [
                              " ".textSpan.make(),
                              "terms and conditions"
                                  .tr()
                                  .textSpan
                                  .underline
                                  .semiBold
                                  .tap(() {
                                    vm.openWebpageLink(Api.terms);
                                  })
                                  .color(AppColor.primaryColor)
                                  .make(),
                            ],
                          ).make(),
                          validator: (value) =>
                              CustomFormBuilderValidator.required(
                            value,
                            errorTitle:
                                "Please confirm you have accepted our terms and conditions"
                                    .tr(),
                          ),
                        ),
                        //
                        CustomButton(
                          title: "Sign Up".tr(),
                          loading: vm.isBusy,
                          onPressed: vm.processLogin,
                        ).centered().py20(),
                      ],
                    ).p20(),
                  ],
                )
                    .wFull(context)
                    .scrollVertical()
                    .box
                    .color(context.cardColor)
                    .make()
                    .pOnly(
                      bottom: context.mq.viewInsets.bottom,
                    )
                    .expand(),
              ],
            ),
          ),
        );
      },
    );
  }
}
