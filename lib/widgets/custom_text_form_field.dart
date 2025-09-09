import 'package:flutter/material.dart';


class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.iconData,
    this.isPassword = false,
    this.onChanged,
    this.validator,
    required this.controller,
    this.color,

  });
  final String hintText;
  final String labelText;
  final IconData iconData;
  final bool isPassword;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
  final TextEditingController controller;
  final Color? color;
  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isSecure = true; // Variable to toggle password visibility
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,

      validator: widget.validator,
      onChanged: widget.onChanged,
      obscureText: widget.isPassword ? isSecure : false,
      style: TextStyle(color: widget.color ?? Theme.of(context).colorScheme.primary),   
      decoration: InputDecoration(
      
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey),
        label: Text(widget.labelText),
        labelStyle: TextStyle(color: widget.color ?? Theme.of(context).colorScheme.primary),
        fillColor: widget.color ?? Theme.of(context).colorScheme.primaryContainer,
        suffixIconColor: widget.color ?? Theme.of(context).colorScheme.primary,
        focusColor: widget.color ?? Theme.of(context).colorScheme.primaryContainer,
        hoverColor: widget.color ?? Theme.of(context).colorScheme.primaryContainer,
        
        suffixIcon: widget.isPassword
        
        
            ? IconButton(
                icon: Icon(isSecure ? Icons.visibility_off : Icons.visibility,),
                onPressed: () {
                  setState(() {
                    isSecure = !isSecure; // Toggle password visibility
                  });
                },
              )
            : Icon(widget.iconData),
        

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: widget.color ?? Theme.of(context).colorScheme.primary),),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: widget.color ?? Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
