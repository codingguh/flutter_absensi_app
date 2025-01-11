import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absensi_app/core/core.dart';
import 'package:flutter_absensi_app/main.dart';
import 'package:flutter_absensi_app/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/pages/login_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Setting page'),
        ),
        body: Center(
          child: BlocConsumer<LogoutBloc, LogoutState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                success: () {
                  context.pushReplacement(const LoginPage());
                },
                error: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(value),
                    backgroundColor: AppColors.red,
                  ));
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(orElse: () {
                return Button.filled(
                    onPressed: () {
                      context
                          .read<LogoutBloc>()
                          .add(const LogoutEvent.logout());
                    },
                    label: 'logout');
              }, loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              });
            },
          ),
        ));
  }
}
