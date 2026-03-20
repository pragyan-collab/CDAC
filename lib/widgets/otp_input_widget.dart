// lib/widgets/otp_input_widget.dart
// Custom OTP input - avoids PinCodeTextField's _elements.contains(element) crash on dispose
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

class OtpInputWidget extends StatefulWidget {
  final int length;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;

  const OtpInputWidget({
    Key? key,
    this.length = 6,
    required this.onChanged,
    this.onCompleted,
  }) : super(key: key);

  @override
  State<OtpInputWidget> createState() => OtpInputWidgetState();
}

class OtpInputWidgetState extends State<OtpInputWidget> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String _getOtp() => _controllers.map((c) => c.text).join();

  void _notifyChange() {
    final otp = _getOtp();
    widget.onChanged(otp);
    if (otp.length == widget.length) {
      widget.onCompleted?.call(otp);
    }
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    _notifyChange();
  }

  void unfocusAll() {
    for (final node in _focusNodes) {
      node.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 50,
          height: 60,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppConstants.primaryBlue,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppConstants.primaryBlue.withOpacity(0.3),
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppConstants.primaryOrange,
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) => _onChanged(value, index),
          ),
        );
      }),
    );
  }
}
