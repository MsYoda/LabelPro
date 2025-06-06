import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/core_ui/submit_button.dart';
import 'package:label_pro_client/features/settings/bloc/settings_cubit.dart';
import 'package:label_pro_client/features/settings/bloc/settings_state.dart';

class SettingsContent extends StatefulWidget {
  final SettingsState state;

  const SettingsContent({
    required this.state,
    super.key,
  });

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  static InputDecoration _inputDecoration({
    required String labelText,
    required String hintText,
  }) {
    return InputDecoration(
      hintStyle: TextStyle(color: Colors.grey.shade500),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.blue),
      ),
      labelText: labelText,
      hintText: hintText,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();

    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Настройки',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(1, 1),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Доступ к датасету',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: cubit.serverAddressController,
                              decoration: _inputDecoration(
                                labelText: 'Адрес хоста',
                                hintText: 'Введите IP адресс',
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(':', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 4),
                          Expanded(
                            child: TextField(
                              controller: cubit.serverPortController,
                              decoration: _inputDecoration(
                                labelText: 'Порт хоста',
                                hintText: 'Введите число',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: cubit.datasetIdController,
                        decoration: _inputDecoration(
                          labelText: 'Идентифкатор датасета',
                          hintText: 'Введите число',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 150,
                          child: SubmitButton(
                            text: 'Проверить соединение',
                            isLoading: widget.state.serverTestInProgress,
                            onPressed: () {
                              cubit.testSeverConfig(
                                serverIp: cubit.serverAddressController.text,
                                port:
                                    int.parse(cubit.serverPortController.text),
                                datasetId:
                                    int.parse(cubit.datasetIdController.text),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      if (widget.state.serverAvailable ?? false)
                        Text(
                          'Датасет доступен для разметки!',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.green,
                          ),
                        ),
                      if (widget.state.serverAvailable == false)
                        Text(
                          'Ошибка при подключении к датасету!',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 24),
                Container(
                  padding: EdgeInsets.all(12),
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(1, 1),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Авторизация',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: cubit.usernameController,
                        decoration: _inputDecoration(
                          labelText: 'Имя пользователя',
                          hintText: 'Введите имя пользователя',
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: cubit.passwordController,
                        decoration: _inputDecoration(
                          labelText: 'Пароль',
                          hintText: 'Введите пароль',
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 150,
                          child: SubmitButton(
                            text: 'Авторизоваться',
                            isLoading: widget.state.authInProgress,
                            onPressed: () {
                              cubit.signIn();
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      if (widget.state.authSucceded ?? false)
                        Text(
                          'Авторизация прошла успешно',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.green,
                          ),
                        ),
                      if (widget.state.authSucceded == false)
                        Text(
                          'Введены неправильные данные',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            SizedBox(
              width: 150,
              child: SubmitButton(
                onPressed: () {
                  cubit.updateSettings();
                },
                text: 'Сохранить',
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
