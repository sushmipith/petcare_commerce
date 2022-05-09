import 'package:flutter/material.dart';
import 'package:petcare_commerce/core/constants/constants.dart';
import 'package:petcare_commerce/core/service/service_locator.dart';
import 'package:petcare_commerce/core/utils/order_utils.dart';
import 'package:petcare_commerce/providers/admin_order_provider.dart';
import 'package:petcare_commerce/providers/auth_provider.dart';
import 'package:petcare_commerce/providers/order_provider.dart';
import 'package:petcare_commerce/widgets/custom_snack_bar.dart';
import 'package:petcare_commerce/widgets/custom_textformfield.dart';
import 'package:provider/provider.dart';

import '../../core/constants/assets_source.dart';

class CancelOrderScreen extends StatefulWidget {
  static const String routeName = "/cancel_order_screen";

  const CancelOrderScreen({Key? key}) : super(key: key);

  @override
  _CancelOrderScreenState createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _cancelReason, _cancelDetails, _orderId;
  bool _isLoading = false;

  void _saveForm() async {
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      setState(() => _isLoading = true);
      _formKey.currentState!.save();

      if (locator<AuthProvider>().isAdmin) {
        await locator<AdminOrderProvider>().cancelOrder(
            cancelDetails: _cancelDetails!.trim(),
            cancelReason: _cancelReason!,
            orderId: _orderId!);
      } else {
        await locator<OrderProvider>().cancelOrder(
            cancelDetails: _cancelDetails!.trim(),
            cancelReason: _cancelReason!,
            orderId: _orderId!);
      }
      setState(() => _isLoading = false);
      await showDialog(
          context: context,
          builder: (dCtx) {
            return WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
                    title: const Text(
                      'Order Cancelled',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.cancel_outlined,
                          size: 40,
                          color: Colors.redAccent,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Your order has been cancelled',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ]));
          });
    } catch (error) {
      setState(() => _isLoading = false);
      showCustomSnackBar(
        context: context,
        message: 'Sorry, couldn\'t cancel your order.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _orderId = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cancel Order'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Image.asset(
                AssetsSource.cancelOrder,
                height: 250,
                fit: BoxFit.contain,
              ),
              const Text(
                'Why do you want to cancel?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 30,
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonFormField(
                  elevation: 12,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select cancel reason';
                    }
                    return null;
                  },
                  items: OrderUtils.cancelReasons.map((reason) {
                    return DropdownMenuItem<String>(
                      child: Text(reason),
                      value: reason,
                    );
                  }).toList(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      color: Colors.black87),
                  decoration: InputDecoration(
                    isDense: true,
                    fillColor: Colors.grey,
                    prefixIcon: const Icon(
                      Icons.cancel_outlined,
                      size: 30,
                      color: Colors.redAccent,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        style: BorderStyle.solid,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        style: BorderStyle.solid,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (String? value) {
                    _cancelReason = value;
                  },
                  hint: const Text('Select Cancel Reason'),
                  isExpanded: true,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextFormField(
                labelText: 'Cancel Details',
                isDense: true,
                maxLines: 3,
                borderRadius: 12,
                value: '',
                isOptionalValidation: false,
                validatorFunc: (value) {
                  if (value.length < 3) {
                    return 'Please enter full details of your cancellation';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cancelDetails = value;
                },
              ),
              const SizedBox(
                height: 40,
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: const Text(
                    'Cancel Order',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  onPressed: _isLoading ? null : _saveForm)
            ],
          ),
        ),
      ),
    );
  }
}
