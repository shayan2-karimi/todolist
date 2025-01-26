import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckBox extends StatelessWidget {
  final bool value;
  final GestureTapCallback onTap;

  const CheckBox({
    super.key,
    required this.value,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final ThemeData themeDataC = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: value ? themeDataC.colorScheme.primary : null,
            border: value
                ? Border.all(
                    color: Colors.black,
                    width: 0.2,
                  )
                : Border.all(
                    color: Colors.black,
                    width: 0.5,
                  ),
          ),
          child: value
              ? const Icon(
                  CupertinoIcons.check_mark,
                  size: 16,
                  color: Colors.white,
                )
              : null,
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/empty_state.svg',
          height: 100,
        ),
        const SizedBox(
          height: 20,
        ),
        const Text('Your task list is empty'),
      ],
    );
  }
}

class MyColor {
  static const Color primaryColor = Color(0xff794CFF);
  static const Color primaryVariantColor = Color(0xff5C0AFF);
  static const secondaryTextColor = Color(0xffAFBED0);
  static const normalPriority = Color(0xffF09819);
  static const lowPriority = Color(0xff3BE1F1);
  static const highPriority = primaryColor;
}
