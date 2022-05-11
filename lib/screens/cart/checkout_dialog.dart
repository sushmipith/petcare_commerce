import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/service/service_locator.dart';
import '../../models/cart_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/custom_snack_bar.dart';

class CheckoutDialog extends StatefulWidget {
  final Map<String, CartModel> cartMap;

  const CheckoutDialog({Key? key, required this.cartMap}) : super(key: key);

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _phoneNumber, _deliveryLocation, _remarks;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(!_isLoading);
      },
      child: AlertDialog(
        title: const Text('Proceed with following details'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: const TextInputType.numberWithOptions(),
                maxLength: 10,
                decoration: const InputDecoration(labelText: "Contact Number"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Contact Number is required";
                  }
                  if (value.length < 10) {
                    return "Contact Number is invalid";
                  }
                  return null;
                },
                onSaved: (value) {
                  _phoneNumber = value!;
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Delivery Location"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Delivery Location is required";
                  }
                  if (value.length < 10) {
                    return "Delivery Location must properly specified";
                  }
                  return null;
                },
                maxLength: 40,
                onSaved: (value) {
                  _deliveryLocation = value!;
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Remarks (Optional)"),
                onSaved: (value) {
                  _remarks = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      _formKey.currentState!.save();
                      try {
                        setState(() {
                          _isLoading = true;
                        });

                        await locator<OrderProvider>().addOrder(
                            remarks: _remarks,
                            deliveryLocation: _deliveryLocation ?? '',
                            mobileNumber: _phoneNumber ?? '',
                            cartProducts: widget.cartMap.values.toList(),
                            total: locator<CartProvider>().totalAmount);
                        showCustomSnackBar(
                          isError: false,
                          message:
                              'Success! Your items have been ordered! Add new items to the cart ',
                          context: context,
                        );
                        locator<CartProvider>().clearCart();
                      } catch (error) {
                        showCustomSnackBar(
                          isError: true,
                          message:
                              'Something went wrong! Couldn\'t order your items',
                          context: context,
                        );
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.of(context).pop();
                      }
                    },
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const Text(
                      'Checkout',
                      style: TextStyle(color: Colors.white),
                    ))
        ],
      ),
    );
  }
}
