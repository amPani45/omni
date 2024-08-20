import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:omni/Home.dart';
import 'package:omni/Login.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class SignUpAgencyPage extends StatefulWidget {
  @override
  _SignUpAgencyPageState createState() => _SignUpAgencyPageState();
}

class _SignUpAgencyPageState extends State<SignUpAgencyPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _wedController = TextEditingController();
  final TextEditingController _callController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  Uint8List? _imageData;
  String? _imageFileName;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _imageData = imageBytes;
        _imageFileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';
      });
    }
  }

  Future<void> registerAgency(BuildContext context) async {
    final String userType = 'Agency'; // เพิ่ม userType
    final String agency_name = _nameController.text;
    final String agency_details = _detailsController.text;
    final String agency_wed = _wedController.text;
    final String agency_call = _callController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    // เช็คการกรอกข้อมูลเช่นเดิม

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.131.241/omni/Register_agency.php'),
    );

    request.fields['userType'] = userType; // เพิ่ม userType
    request.fields['agency_name'] = agency_name;
    request.fields['agency_details'] = agency_details;
    request.fields['agency_wed'] = agency_wed;
    request.fields['agency_call'] = agency_call;
    request.fields['email'] = email;
    request.fields['password'] = password;

    if (_imageData != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'agency_image',
          _imageData!,
          filename: _imageFileName,
          contentType: MediaType.parse(lookupMimeType(_imageFileName!)!),
        ),
      );
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = json.decode(responseData);

      if (data['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              userName: agency_name,
              userId: data['agency_id'] ?? 0,
              userType: '', agencyData: {},
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Server error: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
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
                                      userType: 'agency', agencyData: {},
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
                    'Sign Up Agency',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _nameController,
                    labelText: 'Agency Name',
                    icon: Icons.business,
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _detailsController,
                    labelText: 'Agency Details',
                    icon: Icons.info,
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _wedController,
                    labelText: 'Agency Website',
                    icon: Icons.web,
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _callController,
                    labelText: 'Agency Call',
                    icon: Icons.call,
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    icon: Icons.email,
                  ),
                  SizedBox(height: 16.0),
                  _buildPasswordField(
                    controller: _passwordController,
                    labelText: 'Password',
                    icon: Icons.lock,
                  ),
                  SizedBox(height: 16.0),
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirm Password',
                    icon: Icons.lock,
                  ),
                  SizedBox(height: 16.0),
                  _buildImagePicker(context),
                  SizedBox(height: 16.0),
                  _buildSignUpButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอก$labelText';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอก$labelText';
        }
        return null;
      },
    );
  }

  Widget _buildImagePicker(BuildContext context) {
    return Column(
      children: [
        _imageData == null
            ? Text('No image selected.')
            : Image.memory(
                _imageData!,
                height: 100,
              ),
        SizedBox(height: 16.0),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _pickImage,
            child: Text(
              'Select Image',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 144, 144, 144),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            registerAgency(context);
          }
        },
        child: Text(
          'Sign Up Agency',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.0),
        ),
      ),
    );
  }
}
