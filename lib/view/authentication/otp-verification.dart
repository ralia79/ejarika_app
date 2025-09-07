import 'dart:async';

import 'package:ejarika_app/services/adService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String? phone;

  const OtpVerificationScreen({super.key, this.phone});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final AdService adService = AdService();
  bool _isResendAvailable = false;
  bool sending = false;
  int _resendSeconds = 60;
  Timer? _timer;
  String? _phone;

  void _startResendTimer() {
    setState(() {
      _isResendAvailable = false;
      _resendSeconds = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds == 0) {
        setState(() {
          _isResendAvailable = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _resendSeconds--;
        });
      }
    });
  }

  Future<void> _loadPhone() async {
    if (widget.phone != null && widget.phone!.isNotEmpty) {
      setState(() {
        _phone = widget.phone;
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _phone = prefs.getString('user_phone') ?? '';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPhone();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _resendOtp() async {
    if (!_isResendAvailable) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('کد تایید مجدداً ارسال شد')),
    );
    setState(() {
      sending = true;
    });

    try {
      var response = await adService.loginRequest(_phone ?? "");
      _startResendTimer();
    } catch (e) {
      _showSnackbar(context, "خطایی رخ داده است لطفا دوباره تلاش کنید");
    } finally {
      setState(() {
        sending = false;
      });
    }
  }

  void _submitOtp() async {
    FocusScope.of(context).unfocus();
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('کد تایید باید ۶ رقم باشد')),
      );
      return;
    }
    setState(() {
      sending = true;
    });

    try {
      var jwtToken = await adService.confirmLogin(_phone ?? "", otp);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', jwtToken);
      print(jwtToken);
      Navigator.pushNamed(context, '/');
    } catch (e) {
      _showSnackbar(context, "خطایی رخ داده است لطفا دوباره تلاش کنید");
    } finally {
      setState(() {
        sending = false;
      });
    }
  }

  void _showSnackbar(context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color mainColor = Color(0xFF1b4965);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 70,
                    child: Image.asset(
                      'assets/images/colorfull-logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    _phone != null && _phone!.isNotEmpty
                        ? 'کد ۶ رقمی ارسال شده به شماره $_phone را وارد کنید'
                        : 'کد ۶ رقمی ارسال شده را وارد کنید',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: 'کد تایید',
                      labelStyle: TextStyle(color: mainColor),
                      prefixIcon: Icon(Icons.lock, color: mainColor),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _submitOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: sending
                        ? SizedBox(
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                              color: Colors.white,
                            ),
                            height: 20,
                            width: 20,
                          )
                        : const Text(
                            'تایید',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _isResendAvailable ? _resendOtp : null,
                    child: Text(
                      _isResendAvailable
                          ? 'ارسال مجدد کد'
                          : 'ارسال مجدد کد در $_resendSeconds ثانیه',
                      style: TextStyle(
                        color: _isResendAvailable ? mainColor : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
