import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dua/providers/auth_provider.dart';
import 'package:dua/utils/auth.dart';
import 'package:dua/utils/colors.dart';
import 'package:dua/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _userDetails;
  late AuthProvider authProvider;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _isLoading = true;
    _userDetails = {
      'firstname': '',
      'lastname': '',
      'email': '',
      'countryCode': '',
      'phone': '',
      'gender': ''
    };
    _getUserDetails();
  }

  void _submitForm() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();

      updateProfile(
          _userDetails,
          authProvider.userId!,
          onSuccess: (message) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Update Profile'),
                  content: Text(formatHeading(message)),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );          },
          onError: (message) {
            // Show alert dialog
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Update Profile'),
                  content: Text(formatHeading(message)),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
      );
    }
  }

  Future<void> _getUserDetails() async {
    try {
      getProfile(authProvider.userId!, onSuccess: (userInfo) {
        setState(() {
          _userDetails['firstname'] = userInfo.firstname;
          _userDetails['lastname'] = userInfo.lastname;
          _userDetails['email'] = userInfo.email;
          _userDetails['phone'] = userInfo.phone;
          _userDetails['gender'] = userInfo.gender;
          _isLoading = false;
        });
      });
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
              'assets/images/logoi.png',
              width: 225
          ),
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
    : SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(20),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text(
                              'First Name',
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              initialValue: _userDetails['firstname'],
                              decoration: InputDecoration(
                                  labelText: 'First Name',
                                  floatingLabelBehavior: FloatingLabelBehavior
                                      .never,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.black)
                                  ),
                                  fillColor: Colors.white,
                                  filled: true
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _userDetails['firstname'] = value!;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Last Name',
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              initialValue: _userDetails['lastname'],
                              decoration: InputDecoration(
                                  labelText: 'Last Name',
                                  floatingLabelBehavior: FloatingLabelBehavior
                                      .never,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.black)
                                  ),
                                  fillColor: Colors.white,
                                  filled: true
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _userDetails['lastname'] = value!;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Email',
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              enabled: false,
                              keyboardType: TextInputType.emailAddress,
                              initialValue: _userDetails['email'],
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  floatingLabelBehavior: FloatingLabelBehavior
                                      .never,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.black)
                                  ),
                                  fillColor: Colors.white,
                                  filled: true
                              ),
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  return 'Invalid email';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _userDetails['email'] = value!;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Phone',
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                CountryCodePicker(
                                  initialSelection: 'IN',
                                  onChanged: (value) =>
                                  _userDetails['countryCode'] = value,
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child:
                                  TextFormField(
                                    keyboardType: TextInputType.phone,
                                    initialValue: _userDetails['phone'],
                                    decoration: InputDecoration(
                                        labelText: 'Phone',
                                        floatingLabelBehavior: FloatingLabelBehavior
                                            .never,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                10),
                                            borderSide: BorderSide(
                                                color: Colors.black)
                                        ),
                                        fillColor: Colors.white,
                                        filled: true
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your phone number';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _userDetails['phone'] = value!;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Gender',
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            CustomDropdown<String>(
                              hintText: 'Select Gender',
                              items: const ['Male', 'Female', 'Others'],
                              initialItem: _userDetails['gender'] != "" ? _userDetails['gender'] : null,
                              decoration: CustomDropdownDecoration(
                                  closedBorder: Border.all(color: Colors.black),
                                  closedBorderRadius: BorderRadius.circular(10)
                              ),
                              onChanged: (value) {
                                _userDetails['gender'] = value;
                              },
                            ),
                            SizedBox(height: 20),
                            FilledButton(
                              onPressed: _submitForm,
                              child: Text('Save', style: TextStyle(
                                  fontSize: 15)),
                            ),
                          ],
                        )
                    )
                ),
              )
    );
  }
}