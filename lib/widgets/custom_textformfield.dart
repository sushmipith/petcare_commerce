import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget [CustomTextFormField] : CustomTextField for creating custom button
class CustomTextFormField extends StatefulWidget {
  //Variables
  final String? labelText, hintText, value;
  final bool isPassword;
  final bool? isInitialValue;
  final IconData? suffixIcon;
  final Widget? prefixWidget;
  final Function(String?) onSaved;
  final Function(String?)? onChanged;
  final Function? validatorFunc;
  final Function(String?)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final BoxConstraints? prefixConstraint;
  final Color? borderColor;
  final bool? isFilled;
  final bool? isDense;
  final bool? isEnabled;
  final double? borderRadius;
  final bool isOptionalValidation;
  final bool isAllCaps;
  final int? maxLines;
  final InputDecoration? inputDecoration;
  final double? fontSize;
  final List<TextInputFormatter>? textInputFormatter;

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    this.hintText,
    this.value,
    this.isPassword = false,
    this.isInitialValue = false,
    this.suffixIcon,
    required this.onSaved,
    this.onChanged,
    this.validatorFunc,
    this.onFieldSubmitted,
    this.textInputAction,
    this.textInputType,
    this.prefixWidget,
    this.prefixConstraint,
    this.borderColor,
    this.isFilled = false,
    this.isDense = false,
    this.borderRadius = 8,
    this.isEnabled = true,
    this.isOptionalValidation = false,
    this.isAllCaps = false,
    this.maxLines,
    this.textInputFormatter,
    this.inputDecoration,
    this.fontSize,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField>
    with AutomaticKeepAliveClientMixin {
  bool showPassword = false;
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value ?? '');
    controller!.addListener(() {});
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TextFormField(
      controller: controller,
      validator: (value) =>
          widget.isOptionalValidation && (value == null || value.isEmpty)
              ? null
              : widget.validatorFunc!(value),
      enabled: widget.isEnabled,
      inputFormatters: widget.textInputFormatter ?? [],
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted ?? (value) {},
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      style: TextStyle(fontSize: widget.fontSize ?? 16),
      maxLines: widget.maxLines ?? 1,
      decoration: widget.inputDecoration ??
          InputDecoration(
              filled: widget.isFilled,
              fillColor: const Color(0xFFF2F7FF),
              isDense: widget.isDense,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderColor ?? Colors.grey.shade400,
                  style: BorderStyle.solid,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(widget.borderRadius!),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderColor ?? Colors.grey.shade400,
                  style: BorderStyle.solid,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(widget.borderRadius!),
              ),
              prefixIcon: widget.prefixWidget,
              prefixIconConstraints: widget.prefixConstraint ??
                  const BoxConstraints(
                    minHeight: 40,
                    minWidth: 40,
                  ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    )
                  : null,
              hintText: widget.hintText,
              labelText: widget.labelText,
              errorMaxLines: 3,
              labelStyle: const TextStyle(fontSize: 16)),
      obscureText: widget.isPassword && !showPassword,
      keyboardType: widget.textInputType ?? TextInputType.text,
      enableSuggestions: true,
      textCapitalization: widget.isAllCaps
          ? TextCapitalization.characters
          : TextCapitalization.none,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
