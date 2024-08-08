import 'package:flutter/material.dart';
import 'package:rider/ui/form_validations/form_validator.dart';
import 'package:rider/ui/views/forgot_password/forgot_password_view.form.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import '../../widgets/validation_widget.dart';
import 'forgot_password_viewmodel.dart';
import 'package:rider/constants/asesets.dart';
import 'package:rider/ui/buttons/custom_elevated_button.dart';
import 'package:rider/ui/dialogs/progress_indicator/progress.dart';
import 'package:rider/ui/widgets/common/custom_text_field/custom_text_field.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@FormView(fields: [
  FormTextField(
    name: 'email',
    validator: FormFieldsValidator.validateEmailText,
  )
])
class ForgotPasswordView extends StackedView<ForgotPasswordViewModel>
    with $ForgotPasswordView {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, ForgotPasswordViewModel viewModel, Widget? child) {
    return CustomProgressIndicator(
      isLoading: viewModel.isBusy,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 50.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    viewModel.back();
                  },
                ),
                40.verticalSpace,
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Forgot Password",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 22.sp, fontWeight: FontWeight.w600),
                  ),
                ),
                40.verticalSpace,
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "$kcStaticImagesPath/forgot/forgot.png",
                    height: 191.h,
                    width: 214.w,
                  )
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .scale()
                      .then(delay: 400.ms),
                ),
                50.verticalSpace,
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Enter your email address to \nretrieve your password",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16.sp, fontWeight: FontWeight.normal),
                  ),
                ),
                50.verticalSpace,
                CustomTextField(
                  hintText: "E-mail",
                  prefix: const Icon(Icons.mail_outline),
                  controller: emailController,
                  focusNode: emailFocusNode,
                  noSpace: true,
                  onChanged: (val) {
                    viewModel.email = (val ?? "").trim();
                  },
                ),
                if (viewModel.hasEmailValidationMessage ||
                    viewModel.isForgotPressed && !viewModel.hasEmail)
                  ValidationWidget(
                    message: viewModel.emailValidationMessage ??
                        "This field is required",
                    // "S.of(getContext).fieldRequiredText",
                  ),
                40.verticalSpace,
                CustomElevatedButton(
                    text: 'Forgot Password',
                    onPressed: () async {
                      viewModel.onForgotPressed();
                      if (viewModel.isFormValid && viewModel.hasEmail) {
                        await viewModel.requestForgotPassword();
                        disposeForm();
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onViewModelReady(ForgotPasswordViewModel viewModel) {
    syncFormWithViewModel(viewModel);
    super.onViewModelReady(viewModel);
  }

  @override
  void onDispose(ForgotPasswordViewModel viewModel) {
    disposeForm();
    super.onDispose(viewModel);
  }

  @override
  ForgotPasswordViewModel viewModelBuilder(BuildContext context) =>
      ForgotPasswordViewModel(context);
}
