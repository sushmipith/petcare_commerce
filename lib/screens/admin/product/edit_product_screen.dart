import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/constants.dart';
import '../../../core/service/service_locator.dart';
import '../../../models/product_model.dart';
import '../../../providers/products_provider.dart';
import '../../../widgets/custom_snack_bar.dart';

/// Screen [EditProductScreen] : EditProductScreen for editing product or adding new product
class EditProductScreen extends StatefulWidget {
  static const String routeName = "/edit_product_screen";

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  ThemeData? themeConst;
  double? mHeight, mWidth;
  final _formKey = GlobalKey<FormState>();
  String? _selectedType;
  String? _id;

  //product vars
  String? _title, _price, _description, _selectedCategory;
  ProductModel? _editProduct;

  //image picker
  File? _imageFile;
  final _imagePicker = ImagePicker();
  bool _isLoading = false;
  bool _isInit = true;

  void _saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (_id == null) {
      if (_imageFile == null) {
        showCustomSnackBar(
            message: "Please add a product image",
            isError: true,
            context: context);
        return;
      }
    } else {
      if (_imageFile == null && _editProduct!.imageURL.isEmpty) {
        showCustomSnackBar(
            message: "Please add a product image",
            isError: true,
            context: context);
        return;
      }
    }
    if (isValid) {
      _formKey.currentState!.save();
      await _addOrUpdateProduct();
    }
  }

  Future<void> _addOrUpdateProduct() async {
    setState(() {
      _isLoading = true;
    });

    final newProduct = ProductModel(
      id: DateTime.now().toString(),
      price: double.parse(_price!),
      category: _selectedCategory!,
      description: _description!,
      rating: "4.0",
      type: _selectedType!,
      title: _title!,
      imageURL: '',
    );
    try {
      if (_id != null) {
        await locator<ProductsProvider>().updateProduct(
            _id!, newProduct, _editProduct!.imageURL, _imageFile);
      } else {
        await locator<ProductsProvider>().addProduct(newProduct, _imageFile!);
      }
      showCustomSnackBar(
          message: "Successfully updated the product",
          isError: false,
          context: context);
      Navigator.pop(context);
    } catch (error) {
      showCustomSnackBar(
          message: "Something went wrong! Please try again",
          isError: true,
          context: context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  // capture image from camera or gallery
  void _getImageForProfile(ImageSource imgSrc) async {
    Navigator.of(context).pop();
    final pickedFile =
        await _imagePicker.pickImage(source: imgSrc, imageQuality: 50);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Select Region',
          toolbarColor: themeConst?.primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );
      if (croppedFile != null) {
        final size = await croppedFile.length();
        double fileSizeMB = size / (1000000);
        if (fileSizeMB > 1) {
          showCustomSnackBar(
            context: context,
            message: 'Sorry, please select image size less than 1MB',
            isError: true,
          );
          return;
        }
        setState(() {
          _imageFile = croppedFile;
        });
      }
    }
  }

  void _buildChoosePhotoDialog() {
    showDialog(
        context: context,
        builder: (dCtx) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.all(0),
            children: [
              SimpleDialogOption(
                onPressed: () => _getImageForProfile(ImageSource.camera),
                child: const ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Icon(Icons.camera_alt),
                    title: Text(
                      'Take a Picture',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    )),
              ),
              const Divider(
                height: 0,
              ),
              SimpleDialogOption(
                onPressed: () => _getImageForProfile(ImageSource.gallery),
                child: const ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Icon(Icons.collections),
                    title: Text(
                      'Select from Gallery',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    )),
              ),
            ],
          );
        });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _id = ModalRoute.of(context)!.settings.arguments as String?;
      if (_id != null) {
        _editProduct = locator<ProductsProvider>().findProductById(_id!);
        _selectedType = _editProduct!.type;
        _selectedCategory = _editProduct!.category;
      } else {
        _editProduct = ProductModel(
            id: "",
            type: "",
            category: "",
            title: "",
            description: "",
            rating: "",
            price: 0.0,
            imageURL: "");
      }
    }
    _isInit = false;
  }

  Widget _getImageWidget() {
    if (_imageFile != null) {
      return Image.file(
        _imageFile!,
        fit: BoxFit.contain,
      );
    } else if (_editProduct!.imageURL.isNotEmpty) {
      return Image.network(
        _editProduct!.imageURL,
        fit: BoxFit.contain,
      );
    } else {
      return const Center(
          child: Text(
        "Upload product picture",
        textAlign: TextAlign.center,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaConst = MediaQuery.of(context);
    mHeight = mediaConst.size.height;
    mWidth = mediaConst.size.width;
    themeConst = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_id == null ? "Add Product" : "Edit Product"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: _buildChoosePhotoDialog,
                  child: Container(
                      height: mHeight! * 0.2,
                      width: mWidth! * 0.4,
                      decoration: BoxDecoration(
                        border: Border.all(color: greyColor, width: 1),
                      ),
                      child: _getImageWidget()),
                ),
              ],
            ),
            TextFormField(
              initialValue: _editProduct!.title,
              decoration: const InputDecoration(
                labelText: "Title",
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Title is required";
                }
                if (value.length < 5) {
                  return "Title must have at least 5 letters";
                }
                return null;
              },
              onSaved: (value) {
                _title = value;
              },
            ),
            TextFormField(
              initialValue: _id == null ? "" : _editProduct!.price.toString(),
              decoration: const InputDecoration(
                labelText: "Price",
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Price is required";
                }
                if (double.tryParse(value) == null) {
                  return "Price should be in number format";
                }
                if (double.parse(value) < 0) {
                  return "Price cannot be negative value";
                }
                return null;
              },
              onSaved: (value) {
                _price = value;
              },
            ),
            TextFormField(
              initialValue: _editProduct!.description,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Description is required";
                }
                if (value.length < 10) {
                  return "Description is too short";
                }
                return null;
              },
              onSaved: (value) {
                _description = value;
              },
            ),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration:
                  const InputDecoration(labelText: "Select product type"),
              items: categoryTypes
                  .map((type) =>
                      DropdownMenuItem(child: Text(type), value: type))
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              validator: (value) {
                if (value == null) {
                  return "Product Category is required";
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration:
                  const InputDecoration(labelText: "Select product type"),
              items: productTypes
                  .map((type) =>
                      DropdownMenuItem(child: Text(type), value: type))
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedType = newValue;
                });
              },
              validator: (value) {
                if (value == null) {
                  return "Product Type is required";
                }
                return null;
              },
            ),
            SizedBox(
              height: mHeight! * 0.05,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: greenColor,
              ),
              icon: _isLoading
                  ? Container()
                  : const Icon(Icons.save, color: Colors.white),
              onPressed: _isLoading ? null : _saveForm,
              label: _isLoading
                  ? const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    )
                  : const Text("Save", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
