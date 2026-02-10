import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../home/widgets/blurred_background.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Paleta de culori
  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);
  static const Color deepBlack = Color(0xFF030303);

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _baptismDateController = TextEditingController();
  final _churchLocationController = TextEditingController();

  String? _profileImagePath;
  String? _selectedDepartment;

  final List<String> _departments = [
    'Departamentul de întâmpinare',
    'Departamentul social',
    'Departamentul de școală duminicală',
    'Departamentul de întreținere și curățenie',
    'Departamentul media',
    'Departamentul de rugăciune',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _baptismDateController.dispose();
    _churchLocationController.dispose();
    super.dispose();
  }

  // ✅ ÎNCARCĂ DATELE SALVATE
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstNameController.text = prefs.getString('profile_firstName') ?? '';
      _lastNameController.text = prefs.getString('profile_lastName') ?? '';
      _emailController.text = prefs.getString('profile_email') ?? '';
      _phoneController.text = prefs.getString('profile_phone') ?? '';
      _birthDateController.text = prefs.getString('profile_birthDate') ?? '';
      _baptismDateController.text = prefs.getString('profile_baptismDate') ?? '';
      _churchLocationController.text = prefs.getString('profile_churchLocation') ?? '';
      _profileImagePath = prefs.getString('profile_imagePath');
      _selectedDepartment = prefs.getString('profile_department');
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImagePath = pickedFile.path;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: navy,
              onPrimary: lightGrey,
              surface: deepBlack,
              onSurface: lightGrey,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = '${picked.day}/${picked.month}/${picked.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlurredBackground(
        blurAmount: 15.0,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Despre',
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: lightGrey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Poză profil
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: navy,
                              border: Border.all(color: lightGrey, width: 3),
                            ),
                            child: _profileImagePath != null
                                ? ClipOval(
                                    child: Image.file(
                                      File(_profileImagePath!),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt, color: lightGrey, size: 32),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Adaugă poză',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: lightGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Informații obligatorii
                      Text(
                        'Informații de bază',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: lightGrey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildTextField(
                        controller: _firstNameController,
                        label: 'Prenume',
                        icon: Icons.person,
                        required: true,
                      ),
                      const SizedBox(height: 16),
                      
                      _buildTextField(
                        controller: _lastNameController,
                        label: 'Nume',
                        icon: Icons.person_outline,
                        required: true,
                      ),
                      const SizedBox(height: 16),
                      
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        required: true,
                      ),
                      const SizedBox(height: 16),
                      
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Număr de telefon',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        required: true,
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Informații opționale
                      Text(
                        'Informații opționale',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: lightGrey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildDateField(
                        controller: _birthDateController,
                        label: 'Data nașterii',
                        icon: Icons.cake,
                      ),
                      const SizedBox(height: 16),
                      
                      _buildDateField(
                        controller: _baptismDateController,
                        label: 'Data botezului',
                        icon: Icons.water_drop,
                      ),
                      const SizedBox(height: 16),
                      
                      _buildTextField(
                        controller: _churchLocationController,
                        label: 'Locul bisericii',
                        icon: Icons.church,
                      ),
                      const SizedBox(height: 16),
                      
                      // Departament dropdown
                      _buildDepartmentDropdown(),
                      
                      const SizedBox(height: 40),
                      
                      // Buton salvează
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: navy,
                            foregroundColor: lightGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Salvează',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: navy.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: lightGrey),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: beige,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFFEF4444),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(color: lightGrey),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: navy),
            filled: true,
            fillColor: navy.withValues(alpha: 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: navy.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: navy.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: navy, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: beige,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: () => _selectDate(context, controller),
          style: GoogleFonts.inter(color: lightGrey),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: navy),
            suffixIcon: const Icon(Icons.calendar_today, color: navy),
            filled: true,
            fillColor: navy.withValues(alpha: 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: navy.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: navy.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: navy, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Departamentul în care slujești',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: beige,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: navy.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: navy.withValues(alpha: 0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedDepartment,
              hint: Text(
                'Selectează departamentul',
                style: GoogleFonts.inter(color: beige.withValues(alpha: 0.5)),
              ),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: navy),
              dropdownColor: deepBlack,
              style: GoogleFonts.inter(color: lightGrey),
              items: _departments.map((dept) {
                return DropdownMenuItem<String>(
                  value: dept,
                  child: Text(dept),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDepartment = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  // ✅ SALVEAZĂ TOATE DATELE
  Future<void> _saveProfile() async {
    // Validare câmpuri obligatorii
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Completează toate câmpurile obligatorii',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
      return;
    }

    // Salvează în SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_firstName', _firstNameController.text);
    await prefs.setString('profile_lastName', _lastNameController.text);
    await prefs.setString('profile_email', _emailController.text);
    await prefs.setString('profile_phone', _phoneController.text);
    await prefs.setString('profile_birthDate', _birthDateController.text);
    await prefs.setString('profile_baptismDate', _baptismDateController.text);
    await prefs.setString('profile_churchLocation', _churchLocationController.text);
    if (_profileImagePath != null) {
      await prefs.setString('profile_imagePath', _profileImagePath!);
    }
    if (_selectedDepartment != null) {
      await prefs.setString('profile_department', _selectedDepartment!);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profilul a fost salvat cu succes',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: navy,
        ),
      );
    }
  }
}


class OldProfilePage extends StatefulWidget {
  const OldProfilePage({super.key});

  @override
  State<OldProfilePage> createState() => _OldProfilePageState();
}

class _OldProfilePageState extends State<OldProfilePage> {
  // Paleta de culori
  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);
  static const Color deepBlack = Color(0xFF030303);

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _baptismDateController = TextEditingController();
  final _churchLocationController = TextEditingController();

  File? _profileImage;
  String? _selectedDepartment;

  final List<String> _departments = [
    'Departamentul de întâmpinare',
    'Departamentul social',
    'Departamentul de școală duminicală',
    'Departamentul de întreținere și curățenie',
    'Departamentul media',
    'Departamentul de rugăciune',
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _baptismDateController.dispose();
    _churchLocationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: navy,
              onPrimary: lightGrey,
              surface: deepBlack,
              onSurface: lightGrey,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = '${picked.day}/${picked.month}/${picked.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlurredBackground(
        blurAmount: 15.0,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Despre',
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: lightGrey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Poză profil
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: navy,
                              border: Border.all(color: lightGrey, width: 3),
                            ),
                            child: _profileImage != null
                                ? ClipOval(
                                    child: Image.file(
                                      _profileImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt, color: lightGrey, size: 32),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Adaugă poză',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: lightGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Informații obligatorii
                      Text(
                        'Informații de bază',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: lightGrey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildTextField(
                        controller: _firstNameController,
                        label: 'Prenume',
                        icon: Icons.person,
                        required: true,
                      ),
                      const SizedBox(height: 16),
                      
                      _buildTextField(
                        controller: _lastNameController,
                        label: 'Nume',
                        icon: Icons.person_outline,
                        required: true,
                      ),
                      const SizedBox(height: 16),
                      
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        required: true,
                      ),
                      const SizedBox(height: 16),
                      
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Număr de telefon',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        required: true,
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Informații opționale
                      Text(
                        'Informații opționale',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: lightGrey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildDateField(
                        controller: _birthDateController,
                        label: 'Data nașterii',
                        icon: Icons.cake,
                      ),
                      const SizedBox(height: 16),
                      
                      _buildDateField(
                        controller: _baptismDateController,
                        label: 'Data botezului',
                        icon: Icons.water_drop,
                      ),
                      const SizedBox(height: 16),
                      
                      _buildTextField(
                        controller: _churchLocationController,
                        label: 'Locul bisericii',
                        icon: Icons.church,
                      ),
                      const SizedBox(height: 16),
                      
                      // Departament dropdown
                      _buildDepartmentDropdown(),
                      
                      const SizedBox(height: 40),
                      
                      // Buton salvează
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: navy,
                            foregroundColor: lightGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Salvează',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: navy.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: lightGrey),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: beige,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFFEF4444),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(color: lightGrey),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: navy),
            filled: true,
            fillColor: navy.withValues(alpha: 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: navy.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: navy.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: navy, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: beige,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: () => _selectDate(context, controller),
          style: GoogleFonts.inter(color: lightGrey),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: navy),
            suffixIcon: const Icon(Icons.calendar_today, color: navy),
            filled: true,
            fillColor: navy.withValues(alpha: 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: navy.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: navy.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: navy, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Departamentul în care slujești',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: beige,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: navy.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: navy.withValues(alpha: 0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedDepartment,
              hint: Text(
                'Selectează departamentul',
                style: GoogleFonts.inter(color: beige.withValues(alpha: 0.5)),
              ),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: navy),
              dropdownColor: deepBlack,
              style: GoogleFonts.inter(color: lightGrey),
              items: _departments.map((dept) {
                return DropdownMenuItem<String>(
                  value: dept,
                  child: Text(dept),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDepartment = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  void _saveProfile() {
    // Validare câmpuri obligatorii
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Completează toate câmpurile obligatorii',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
      return;
    }

    // TODO: Salvează în Firebase/database
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Profilul a fost salvat cu succes',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: navy,
      ),
    );
  }
}