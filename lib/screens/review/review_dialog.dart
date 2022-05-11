import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../core/service/service_locator.dart';
import '../../providers/products_provider.dart';
import '../../widgets/custom_snack_bar.dart';

class ReviewDialog extends StatefulWidget {
  final String? productId;
  final String? productTitle;

  const ReviewDialog({Key? key, required this.productId, this.productTitle})
      : super(key: key);

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _rating, _review;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(!_isLoading);
      },
      child: AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        title: Text(widget.productTitle ?? ''),
        contentPadding: EdgeInsets.zero,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 15.0),
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    _rating = '$rating';
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: "Write a review"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Review is required";
                    }
                    if (value.length < 5) {
                      return "Review should at least be 5 characters";
                    }
                    return null;
                  },
                  maxLines: 3,
                  maxLength: 100,
                  onSaved: (value) {
                    _review = value!;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
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
                        await locator<ProductsProvider>().reviewProduct(
                            review: _review!,
                            rating: _rating!,
                            productId: widget.productId!);
                        showCustomSnackBar(
                          isError: false,
                          message:
                              'Success! Your review and rating has been submitted',
                          context: context,
                        );
                      } catch (error) {
                        showCustomSnackBar(
                          isError: true,
                          message:
                              'Something went wrong! Couldn\'t review the product',
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
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ))
        ],
      ),
    );
  }
}
