import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.iconData,
    this.isPassword = false,
    this.onChanged,
    
  });
  final String hintText;
  final String labelText;
  final IconData iconData;
  final bool isPassword;
  final Function(String)? onChanged;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
   bool isSecure = true; // Variable to toggle password visibility
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      validator: (data) {
        if (data == null || data.isEmpty) {
          return 'This field cannot be empty';
        } 
        return null; // Return null if the input is valid
      },
      onChanged: widget.onChanged,
      obscureText: widget.isPassword? isSecure : false,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(isSecure ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    isSecure = !isSecure; // Toggle password visibility
                  });
                },
              )
            : Icon(widget.iconData),
        hint: Text(widget.hintText),
        label: Text(widget.labelText),
         
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
    );
  }
}
