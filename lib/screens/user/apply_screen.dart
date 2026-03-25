// lib/screens/user/apply_screen.dart
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../utils/argument_helper.dart';
import '../../widgets/header_widget.dart';
import '../../services/auth_service.dart';
import '../../services/service_catalog_service.dart';
import '../../widgets/safe_navigation.dart';

class ApplyScreen extends StatefulWidget {
  const ApplyScreen({Key? key}) : super(key: key);

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  String? selectedService;
  String? selectedGender;
  bool _agreeToTerms = false;

  late final List<String> _allServices;

  bool _argsLoaded = false;

  @override
  void initState() {
    super.initState();
    // Centralized service list to keep Apply/Pay/Services consistent.
    _allServices = ServiceCatalogService().getSelectableServiceTitles();
    _prefillUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_argsLoaded) {
      _argsLoaded = true;
      _getArguments();
    }
  }

  void _getArguments() {
    final args = ArgumentHelper.getArgument<Map>(
      context,
      routeName: AppRoutes.apply,
    );
    if (args != null && args.containsKey('service')) {
      final service = args['service'] as String?;
      // Only set if it exists in our combined list (schemes + services)
      if (service != null && _allServices.contains(service)) {
        selectedService = service;
      }
    }
  }

  void _prefillUserData() {
    final user = AuthService().currentUser;
    _nameController.text = user?.name ?? '';
    _emailController.text = user?.email ?? '';
    _mobileController.text = user?.phone ?? '';
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppConstants.primaryBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please agree to terms and conditions'),
            backgroundColor: AppConstants.errorRed,
          ),
        );
        return;
      }

      SafeNavigation.navigateTo(
        AppRoutes.upload,
        arguments: {
          'service': selectedService,
          'formData': {
            'name': _nameController.text,
            'fatherName': _fatherNameController.text,
            'dob': _dobController.text,
            'gender': selectedGender,
            'address': _addressController.text,
            'mobile': _mobileController.text,
            'email': _emailController.text,
          }
        },
      );
    }
  }

  @override
  void dispose() {
    ArgumentHelper.clearArguments(AppRoutes.apply);
    _nameController.dispose();
    _fatherNameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderWidget(showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).padding.bottom + 24,
          ),
          child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppConstants.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppConstants.buttonShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Service',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedService != null &&
                              _allServices.contains(selectedService)
                          ? selectedService
                          : null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      hint: const Text('Choose a service'),
                      items: _allServices.map((service) {
                        return DropdownMenuItem(
                          value: service,
                          child: Text(service),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedService = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a service';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppConstants.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppConstants.buttonShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textDark,
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _fatherNameController,
                      decoration: const InputDecoration(
                        labelText: 'Father\'s Name',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter father\'s name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      onTap: _selectDate,
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select date of birth';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Gender',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppConstants.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final fontSize =
                            constraints.maxWidth < 360 ? 12.0 : 14.0;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Male',
                                    style: TextStyle(fontSize: fontSize),
                                  ),
                                ),
                                value: 'Male',
                                groupValue: selectedGender,
                                onChanged: (value) {
                                  setState(() => selectedGender = value);
                                },
                                activeColor: AppConstants.primaryBlue,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Female',
                                    style: TextStyle(fontSize: fontSize),
                                  ),
                                ),
                                value: 'Female',
                                groupValue: selectedGender,
                                onChanged: (value) {
                                  setState(() => selectedGender = value);
                                },
                                activeColor: AppConstants.primaryBlue,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Other',
                                    style: TextStyle(fontSize: fontSize),
                                  ),
                                ),
                                value: 'Other',
                                groupValue: selectedGender,
                                onChanged: (value) {
                                  setState(() => selectedGender = value);
                                },
                                activeColor: AppConstants.primaryBlue,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppConstants.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppConstants.buttonShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Address & Contact',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textDark,
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _addressController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Residential Address',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: const InputDecoration(
                        labelText: 'Mobile Number',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter mobile number';
                        }
                        if (value.length != 10) {
                          return 'Enter valid 10-digit number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Enter valid email';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppConstants.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppConstants.buttonShadow,
                ),
                child: CheckboxListTile(
                  title: const Text(
                    'I confirm that the information provided is true and correct',
                    style: TextStyle(fontSize: 14),
                  ),
                  value: _agreeToTerms,
                  onChanged: (value) {
                    setState(() {
                      _agreeToTerms = value ?? false;
                    });
                  },
                  activeColor: AppConstants.primaryBlue,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.successGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Next: Upload Documents',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}