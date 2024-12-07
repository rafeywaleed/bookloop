import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.isObscured = false,
    this.keyboard = TextInputType.text,
    this.isLast = false,
    this.label = '',
    this.onFieldSubmitted,
    this.onTap,
    this.trailing,
    this.onSaved,
    this.onTapOutside,
  });
  final TextEditingController controller;
  final TextInputType keyboard;
  final String label;
  final bool isObscured;
  final bool isLast;
  final Widget? trailing;
  final Function(String?)? onSaved;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function(PointerDownEvent)? onTapOutside;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool obscured;
  @override
  void initState() {
    obscured = widget.isObscured ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.maxFinite,
      child: TextFormField(
        style: const TextStyle(color: Colors.black),
        controller: widget.controller,
        obscureText: obscured,
        onFieldSubmitted: widget.onFieldSubmitted,
        onTap: widget.onTap,
        onChanged: widget.onSaved,
        onTapOutside: widget.onTapOutside ??
            (event) {
              FocusScope.of(context).unfocus();
            },
        keyboardType: widget.keyboard,
        textInputAction:
            !widget.isLast ? TextInputAction.next : TextInputAction.done,
        decoration: InputDecoration(
            labelText: widget.label,
            suffixIcon: widget.isObscured
                ? IconButton(
                    tooltip: obscured ? 'Show Password' : 'Hide Password',
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      setState(
                        () => obscured = !obscured,
                      );
                    },
                    icon: Icon(
                      obscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color.fromRGBO(156, 163, 200, 1),
                    ),
                  )
                : widget.trailing,
            fillColor: const Color.fromRGBO(233, 233, 242, 1),
            filled: true,
            border: OutlineInputBorder(
                borderSide: const BorderSide(width: 0.8),
                borderRadius: BorderRadius.circular(15))),
      ),
    );
  }
}
