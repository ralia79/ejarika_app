import 'dart:io';

import 'package:Ejarika/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewAdScreen extends StatefulWidget {
  @override
  _NewAdScreenState createState() => _NewAdScreenState();
}

class _NewAdScreenState extends State<NewAdScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _category;
  String? _title;
  String? _description;
  bool? callAccess = false;
  bool? chatAccess = false;
  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];

  final List<String> _categories = [
    'املاک',
    'وسایل نقلیه',
    'لوازم خانگی',
    'خدمات',
    'سایر',
  ];

  // انتخاب تصویر از گالری
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

  // ارسال فرم
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('آگهی با موفقیت ثبت شد!')),
      );
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
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'دسته‌بندی',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      value: _category,
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _category = value),
                      validator: (value) => value == null
                          ? 'لطفاً یک دسته‌بندی انتخاب کنید'
                          : null,
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
                    Text(
                      'عکس آگهی',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
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
                                child: Icon(Icons.add,
                                    size: 32, color: Colors.grey),
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
                    SizedBox(height: 24),
                    CheckboxListTile(
                      title: Text('امکان چت فعال باشد'),
                      contentPadding: EdgeInsets.zero,
                      checkColor: AppColors.white,
                      activeColor: AppColors.primary,
                      value: chatAccess,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (newValue) {
                        setState(() {
                          chatAccess = newValue;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('تماس تلفنی'),
                      contentPadding: EdgeInsets.zero,
                      checkColor: AppColors.white,
                      activeColor: AppColors.primary,
                      value: callAccess,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (newValue) {
                        setState(() {
                          callAccess = newValue;
                        });
                      },
                    ),
                    if (callAccess ?? false)
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text('شماره ی شما روی اجاریکا نمایش داده میشود'),
                      ),
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        print('back');
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      child: const Text('انصراف'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      child: const Text('ثبت آگهی',
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
