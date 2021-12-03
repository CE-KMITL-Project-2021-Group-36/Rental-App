import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rental_app/application/auth/sign_in_form/sign_in_form_bloc.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
            () {},
            (either) => either.fold(
                    (failure) => {
                          FlushbarHelper.createError(
                            message: failure.map(
                              cancelledByUser: (_) => 'ยกเลิก',
                              serverError: (_) => 'ระบบผิดพลาด',
                              emailAlreadyInUse: (_) =>
                                  'อีเมลนี้มีผู้ใช้งานแล้ว',
                              invalidEmailAndPasswordCombination: (_) =>
                                  'อีเมลหรือรหัสผ่านไม่ถูกต้อง',
                            ),
                          ).show(context)
                        }, (_) {
                  //todo
                }));
      },
      builder: (context, state) {
        return Form(
          autovalidateMode: state.showErrorMessages
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 50),
                  child: const Text(
                    'ลงชื่อเข้าใช้',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'อีเมล',
                  ),
                  autocorrect: false,
                  onChanged: (value) => context
                      .read<SignInFormBloc>()
                      .add(SignInFormEvent.emailChanged(value)),
                  validator: (_) => context
                          .read<SignInFormBloc>()
                          .state
                          .emailAddress
                          .isValid()
                      ? null
                      : 'อีเมลไม่ถูกต้อง',
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'รหัสผ่าน',
                  ),
                  autocorrect: false,
                  obscureText: true,
                  onChanged: (value) => context
                      .read<SignInFormBloc>()
                      .add(SignInFormEvent.passwordChanged(value)),
                  validator: (_) =>
                      context.read<SignInFormBloc>().state.password.isValid()
                          ? null
                          : 'รหัสผ่านไม่ถูกต้อง',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'ลืมรหัสผ่าน?',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    context.read<SignInFormBloc>().add(
                          const SignInFormEvent
                              .signInWithEmailAndPasswordPressed(),
                        );
                  },
                  child: const Text(
                    'เข้าสู่ระบบ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
                const SizedBox(height: 30),
                OutlinedButton.icon(
                  onPressed: () {
                    context.read<SignInFormBloc>().add(
                          const SignInFormEvent.signInWithGooglePressed(),
                        );
                  },
                  icon: const Icon(FontAwesomeIcons.google),
                  label: const Text(
                    'ดำเนินการต่อด้วย Google',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'หรือ',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    context.read<SignInFormBloc>().add(
                          const SignInFormEvent
                              .registerWithEmailAndPasswordPressed(),
                        );
                  },
                  child: const Text(
                    'สมัครสมาชิกด้วยอีเมล',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    alignment: Alignment.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
