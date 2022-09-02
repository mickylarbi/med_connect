import 'package:flutter/material.dart';

class OutlineIconButton extends StatelessWidget {
  final IconData iconData;
  final void Function()? onPressed;
  const OutlineIconButton(
      {Key? key, required this.iconData, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onPressed,
        child: Center(
          child: Icon(iconData),
        ),
      ),
    );
  }
}

class ElevatedIconButton extends StatelessWidget {
  final IconData iconData;
  final void Function()? onPressed;
  const ElevatedIconButton(
      {Key? key, required this.iconData, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.3),
                blurRadius: 30,
                offset: Offset(0, 10))
          ]),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onPressed,
        child: Center(
          child: Icon(iconData, color: Colors.white),
        ),
      ),
    );
  }
}

class SolidIconButton extends StatelessWidget {
  final IconData iconData;
  final Color? color;
  final void Function()? onPressed;
  const SolidIconButton(
      {Key? key,
      required this.iconData,
      required this.onPressed,
      this.color = Colors.blueGrey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: color!.withOpacity(.2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onPressed,
        child: Center(
          child: Icon(iconData, color: color),
        ),
      ),
    );
  }
}
