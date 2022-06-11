import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final void Function()? _onPressed;
  final String labelText;
  const CustomElevatedButton(
      {Key? key, required void Function()? onPressed, required this.labelText})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        child: Text(labelText),
        onPressed: _onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class SkipTextButton extends StatelessWidget {
  const SkipTextButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: TextButton(
        onPressed: () {},
        child: const Text('Skip'),
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final String labelText;
  final void Function()? onPressed;
  const CustomTextButton(
      {Key? key, required this.labelText, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        labelText,
        style: const TextStyle(color: Colors.blue),
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class GoogleButton extends StatelessWidget {
  const GoogleButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: SizedBox(
        child: TextButton.icon(
          onPressed: () {},
          icon: Image.asset(
            'assets/images/google_icon.png',
            height: 24,
          ),
          label: const Text('Continue with Google'),
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(),
            ),
          ),
        ),
      ),
    );
  }
}
