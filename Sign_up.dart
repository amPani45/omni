import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:omni/Home.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameSurnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? selectedGender;
  String? selectedAgencyId;
  File? _image;
  final picker = ImagePicker();

  bool _obscureText = true;
  bool _obscureConfirmText = true;

  final List<Map<String, String>> agencies = [
    {'id': '1', 'name': 'หน่วยงานที่เกี่ยวข้องที่ 1'},
    {'id': '2', 'name': 'หน่วยงานที่เกี่ยวข้องที่ 2'},
    {'id': '3', 'name': 'หน่วยงานที่เกี่ยวข้องที่ 3'},
    {'id': '4', 'name': 'หน่วยงานที่เกี่ยวข้องที่ 4'},
    {'id': '5', 'name': 'หน่วยงานที่เกี่ยวข้องที่ 5'},
  ];

  Future<void> register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('https://192.168.131.241/omni/Register_users.php');
      var request = http.MultipartRequest('POST', url);

      request.fields['user_name_surname'] = _nameSurnameController.text;
      request.fields['user_email'] = _emailController.text;
      request.fields['user_password'] = _passwordController.text;
      request.fields['user_gender'] = selectedGender ?? '';
      request.fields['user_birthday'] = _birthdayController.text;
      request.fields['user_phone'] = _phoneController.text;
      request.fields['user_address'] = _addressController.text;
      request.fields['agency_id'] = selectedAgencyId ?? '';

      if (_image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('user_image', _image!.path),
        );
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);

      if (jsonResponse['status'] == 'success') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text(jsonResponse['message']),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        userName: _nameSurnameController.text,
                        userId: 1, // ใส่ ID ที่ได้จากการลงทะเบียน
                        userType: 'agency', 
                        agencyData: {}, // หรือข้อมูลหน่วยงานที่เกี่ยวข้อง
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(jsonResponse['message']),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _takePhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image captured.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                      userName: '',
                                      userId: 0,
                                      userType: 'agency', 
                                      agencyData: {},
                                    )),
                          );
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _nameSurnameController,
                    labelText: 'Name-Surname',
                    icon: Icons.person,
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    icon: Icons.email,
                  ),
                  SizedBox(height: 16.0),
                  _buildDropdownField(
                    labelText: 'Gender',
                    icon: Icons.wc_rounded,
                    items: [
                      {'id': 'Male', 'name': 'Male'},
                      {'id': 'Female', 'name': 'Female'},
                      {'id': 'Other', 'name': 'Other'},
                    ],
                    selectedValue: selectedGender,
                    onChanged: (newValue) {
                      setState(() {
                        selectedGender = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _birthdayController,
                    labelText: 'Birthday (YYYY-MM-DD)',
                    icon: Icons.cake,
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _phoneController,
                    labelText: 'Phone',
                    icon: Icons.phone,
                  ),
                  SizedBox(height: 16.0),
                  _buildDropdownField(
                    labelText: 'Agency',
                    icon: Icons.business,
                    items: agencies,
                    selectedValue: selectedAgencyId,
                    onChanged: (newValue) {
                      setState(() {
                        selectedAgencyId = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _addressController,
                    labelText: 'Address',
                    icon: Icons.home,
                  ),
                  SizedBox(height: 16.0),
                  _buildPasswordField(
                    controller: _passwordController,
                    labelText: 'Password',
                    obscureText: _obscureText,
                    toggleObscureText: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirm Password',
                    obscureText: _obscureConfirmText,
                    toggleObscureText: () {
                      setState(() {
                        _obscureConfirmText = !_obscureConfirmText;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  if (_image != null)
                    Image.file(_image!, height: 200, width: 200)
                  else
                    Icon(Icons.image, size: 200, color: Colors.grey[300]),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _pickImage,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.photo,),
                              SizedBox(width: 8),
                              Text('เพิ่มรูปภาพ',style: TextStyle(color: Colors.orange)),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _takePhoto,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera,),
                              SizedBox(width: 8),
                              Text('ถ่ายภาพ',style: TextStyle(color: Colors.orange)),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => register(context),
                    child: Text('Register',style: TextStyle(color: Colors.orange)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }

  TextFormField _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
    required VoidCallback toggleObscureText,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: toggleObscureText,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        if (labelText == 'Confirm Password' &&
            value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  DropdownButtonFormField<String> _buildDropdownField({
    required String labelText,
    required IconData icon,
    required List<Map<String, String>> items,
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      value: selectedValue,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((Map<String, String> item) {
        return DropdownMenuItem<String>(
          value: item['id'],
          child: Text(item['name']!),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select $labelText';
        }
        return null;
      },
    );
  }
}
