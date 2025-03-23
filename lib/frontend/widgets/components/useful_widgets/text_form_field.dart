// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcript_of_records/backend/design/screen_size.dart';
import 'package:transcript_of_records/backend/riverpod/provider.dart';
import 'package:transcript_of_records/frontend/widgets/animations/moving_animation.dart';
import 'package:transcript_of_records/frontend/widgets/components/text/stroke_text.dart';


class CustomTextFormField extends ConsumerStatefulWidget {

  final String hintText;
  final bool obscureText;
  final TextEditingController textController;
  final bool readOnly;
  final FocusNode? currentFocusNode;
  final FocusNode? nextFocusNode;
  final bool autoFocus;
  final double width;
  final double height;
  final String? provider;

  const CustomTextFormField({super.key, required this.hintText,
    required this.obscureText, required this.textController, required this.readOnly,
    this.currentFocusNode, this.nextFocusNode, required this.autoFocus,
    required this.width, required this.height, this.provider});

  @override
  ConsumerState<CustomTextFormField> createState() => CustomTextFormFieldState();
}

class CustomTextFormFieldState extends ConsumerState<CustomTextFormField> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  String? _errorStatus;
  bool _errorMessageVisible = false;
  String _errorMessage = '';
  late bool _textEditingActive;
  final double _fontSize = ScreenSize.height * 0.018 +
      ScreenSize.width * 0.016;
  final GlobalKey<MovingAnimationState> _errorTextMovingKey = GlobalKey<MovingAnimationState>();

  // Method to get the right suffix icon based on the given widget parameters
  Widget? _getSuffixIcon() {
    if (widget.readOnly) {
      return IconButton(
        onPressed: widget.provider == null
            ? () {_changeTextEditingStatus();}
            : null,
        icon: Icon(
          _textEditingActive
              ? Icons.edit
              : Icons.check,
          size: ScreenSize.height * 0.025 +
              ScreenSize.width * 0.025,
          color: widget.provider == null ? Colors.black : Colors.grey[800],
        ),
      );
    } else if (widget.obscureText) {
      return IconButton(
        onPressed: () {
          setState(() {
            _passwordVisible = !_passwordVisible;
          });
        },
        icon: Icon(
          _passwordVisible
              ? Icons.visibility
              : Icons.visibility_off,
          size: ScreenSize.height * 0.04,
          color: Colors.white,
        ),
      );
    }
    return null;
  }

  void _changeTextEditingStatus() {
    setState(() {
      _textEditingActive = !_textEditingActive;
      if (!_textEditingActive) {
        // Focus on the text field if we click on the edit button
        FocusScope.of(context).requestFocus(widget.currentFocusNode);
      }
    });
  }

  // Giving the error status a value and showing the error message
  void showError(String message) {
    _errorStatus = '';
    setState(() {
      _errorMessage = message;
    });
    _validate();
  }

  // Setting the error status to null and covers the error message
  bool resetsErrors() {
    if (_errorStatus != null) {
      _errorStatus = null;
      _validate();
      return true;
    }
    return false;
  }

  void _validate() {
    _formKey.currentState?.validate();
  }

  void changeText(String newText) {
    setState(() {
      widget.textController.text = newText;
    });
  }

  @override
  void initState() {
    _textEditingActive = widget.readOnly;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final appTheme = ref.watch(appThemeProvider);

    return SizedBox(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          MovingAnimation(
            key: _errorTextMovingKey,
            duration: const Duration(milliseconds: 350),
            firstLeftPosition: ScreenSize.width * 0.025,
            firstTopPosition: ScreenSize.height * 0.025,
            secondLeftPosition: ScreenSize.width * 0.025,
            secondTopPosition: ScreenSize.height * 0.065,
            child: StrokeText(
              text: _errorMessage,
              fontSize: ScreenSize.height * 0.015 + ScreenSize.width * 0.015,
              textColor: Colors.red,
              strokeWidth: 3,
              strokeColor: Colors.black,
              underline: false,
            ),
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: widget.textController,
              obscureText: (widget.obscureText)? !_passwordVisible : false,
              readOnly: _textEditingActive,
              focusNode: widget.currentFocusNode,
              onFieldSubmitted: (value) {
                if (widget.readOnly) {
                  _changeTextEditingStatus();
                } else if (widget.nextFocusNode != null) {
                  FocusScope.of(context).requestFocus(widget.nextFocusNode);
                }
              },
              autofocus: widget.autoFocus,
              decoration: InputDecoration(
                // Background color
                filled: true,
                fillColor: appTheme.tertiaryColor,
                // Size
                contentPadding: EdgeInsets.fromLTRB(ScreenSize.width * 0.03,
                    ScreenSize.height * 0.03, ScreenSize.width * 0.03, 0
                ),
                constraints: BoxConstraints(
                  maxWidth: widget.width,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 3,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 3,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: widget.readOnly ? 3.0 : 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 3,
                  ),
                ),
                errorStyle: const TextStyle(
                  fontSize: 0,
                ),
                // hide button for the password
                suffixIcon: _getSuffixIcon(),
                suffixIconColor: Colors.black,
                // Style for the text
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: _fontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: _fontSize,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
              maxLines: 1,
              validator: (value) {
                if (!_errorMessageVisible && _errorStatus != null) {
                  _errorMessageVisible = true;
                  _errorTextMovingKey.currentState?.animate();
                } else if (_errorMessageVisible && _errorStatus == null) {
                  _errorMessageVisible = false;
                  _errorTextMovingKey.currentState?.animate();
                }
                return _errorStatus;
              },
            ),
          ),
        ],
      ),
    );
  }
}
