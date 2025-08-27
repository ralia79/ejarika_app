import 'dart:io';
import 'package:ejarika_app/models/category.dart';
import 'package:ejarika_app/utils/colors.dart';
import 'package:ejarika_app/services/ad_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class NewAdScreen extends StatefulWidget {
  @override
  _NewAdScreenState createState() => _NewAdScreenState();
}

class _NewAdScreenState extends State<NewAdScreen> {
  final _formKey = GlobalKey<FormState>();
  Category? _category;
  String? _title;
  String? _price;
  String? _description;
  final ImagePicker _picker = ImagePicker();
  final AdService adService = AdService();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }


  List<File> _images = [];
  bool _isSubmitting = false;

  List<Category> _categories = [];

  Future<void> _loadCategories() async {
    try {
      List<Category> categories = await adService.getCategories();
      setState(() {
        _categories = categories;
      });
      print('شهرها با موفقیت دریافت و ذخیره شدند: $categories');
    } catch (e) {
      print('خطا در بارگذاری شهرها: $e');
    }
  }

  Future<void> _pickImage() async {
    if (_images.length >= 8) return;
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSubmitting = true;
      });

      try {
        FormData formData = FormData.fromMap({
          "advertisement": await MultipartFile.fromString(
            jsonEncode({
              "isActive": false,
              "title": _title,
              "description": _description,
              "price": int.tryParse(_price ?? "0"),
              "address": "آدرس اشتباه",
              "user": {"id": 3},
              "category": {"id": 1},
              "city": {"id": 1}
            }),
            contentType: MediaType("application", "json"),
          ),
          "images": [
            for (var image in _images)
              await MultipartFile.fromFile(
                image.path,
                filename: image.path.split('/').last,
              ),
          ],
        });

        Dio dio = Dio();
        final response = await dio.post(
          'https://ejarika.clipboardapp.online/api/advertisements',
          data: formData,
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('آگهی با موفقیت ثبت شد!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ثبت آگهی با خطا مواجه شد!')),
          );
        }
      } catch (e) {
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا در ارسال داده‌ها')),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('ساخت آگهی جدید', style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.primary,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<Category>(
                  decoration: InputDecoration(
                    labelText: 'دسته‌بندی',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  value: _category,
                  items: _categories.map((Category category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _category = value),
                  validator: (value) =>
                      value == null ? 'لطفاً یک دسته‌بندی انتخاب کنید' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'عنوان',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'لطفاً عنوان را وارد کنید'
                      : null,
                  onSaved: (value) => _title = value,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'توضیحات',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  maxLines: 5,
                  validator: (value) => value == null || value.isEmpty
                      ? 'لطفاً توضیحات را وارد کنید'
                      : null,
                  onSaved: (value) => _description = value,
                ),
                SizedBox(height: 24),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'قیمت',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'لطفاً قیمت را وارد کنید'
                      : null,
                  onSaved: (value) => _price = value,
                ),
                SizedBox(height: 24),
                Text('عکس آگهی',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._images.asMap().entries.map((entry) {
                      final index = entry.key;
                      final imageFile = entry.value;
                      return Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.redAccent),
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(imageFile),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.delete,
                                    color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    if (_images.length < 8)
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child:
                                Icon(Icons.add, size: 32, color: Colors.grey),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'تعداد عکس‌های انتخاب شده نباید بیشتر از ۸ باشد.\nویرایش عکس‌ها فقط تا ۳ روز پس از انتشار ممکن است.',
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      child: const Text('انصراف'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      child: _isSubmitting
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : Text('ثبت آگهی',
                              style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
