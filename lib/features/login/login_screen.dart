import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/features/login/bloc/login_bloc.dart';
import 'package:pruzi_korak/shared_ui/components/loading_components.dart';
import '../../app/navigation/app_routes.dart';
import '../../core/localization/app_localizations.dart';
import '../../shared_ui/components/buttons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AppLocalizations? _localizedStrings;
  final TextEditingController _emailInputFieldController =
      TextEditingController();
  final TextEditingController _passwordInputFieldController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    _localizedStrings = AppLocalizations.of(context);
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (BuildContext context, LoginState state) {
        switch (state) {
          case LoginInitial() || Loading():
            break;

          case LoginSuccess():
            context.go(AppRoutes.home.path());

          case LoginFailure():
            //TODO display toast?
            break;
        }
      },
      buildWhen: (context, state) {
        return state is LoginInitial || state is Loading;
      },
      builder: (BuildContext context, LoginState state) {
        switch (state) {
          case LoginInitial():
            return _content();
          case Loading():
            return AppLoader();
          case LoginSuccess():
          case LoginFailure():
            return _content();
        }
      },
    );
  }

  Widget _content() {
    return Scaffold(
      appBar: null,
      backgroundColor: AppColors.backgroundPrimary,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _screenContainer([
          _appLogoIcon(),
          _componentSeparator(64),
          _loginMessage(),
          _loginForm(),
        ]),
      ),
    );
  }

  SizedBox _screenContainer(List<Widget> components) => SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: components,
    ),
  );

  SvgPicture _appLogoIcon() =>
      SvgPicture.asset("assets/icons/app_logo.svg", width: 64);

  Column _loginForm() => Column(
    children: [
      _emailInputTextField(),
      _componentSeparator(22),
      _passwordInputField(),
      _componentSeparator(22),
      _loginButton(),
    ],
  );

  TextField _emailInputTextField() => TextField(
    controller: _emailInputFieldController,
    keyboardType: TextInputType.emailAddress,
    decoration: _textInputDecoration(
      _localizedStrings?.email,
      _localizedStrings?.email_hint,
    ),
  );

  TextField _passwordInputField() => TextField(
    controller: _passwordInputFieldController,
    keyboardType: TextInputType.visiblePassword,
    decoration: _textInputDecoration(
      _localizedStrings?.password,
      _localizedStrings?.password_hint,
    ),
  );

  InputDecoration _textInputDecoration(String? labelText, String? hintText) =>
      InputDecoration(
        labelText: labelText,
        hintText: hintText,
        focusedBorder: _textFieldUnderlineDecor(),
        enabledBorder: _textFieldUnderlineDecor(),
      );

  UnderlineInputBorder _textFieldUnderlineDecor() => UnderlineInputBorder(
    borderSide: BorderSide(color: AppColors.primaryVariant),
  );

  SizedBox _componentSeparator([double height = 0, double width = 0]) =>
      SizedBox(height: height, width: width);

  Text _loginMessage() => Text(
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 14),
    _localizedStrings!.login_message,
  );

  AppButton _loginButton() => AppButton(
    text: _localizedStrings!.log_in,
    onPressed: () {
      context.dispatchEvent(
        LoginUser(
          _emailInputFieldController.text,
          _passwordInputFieldController.text,
        ),
      );
    },
  );
}

extension on BuildContext {
  void dispatchEvent(LoginEvent event) => read<LoginBloc>().add(event);
}
