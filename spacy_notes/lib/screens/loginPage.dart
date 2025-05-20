import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spacy_notes/models/user_model.dart';
import 'package:spacy_notes/providers/user_provider.dart';
import 'package:uuid/uuid.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isLoginSelected = true;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  void _handleAuth() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final username = _usernameController.text.trim();

      if (!isLoginSelected &&
          password != _confirmPasswordController.text.trim()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match!")),
        );
        return;
      }

      try {
        if (isLoginSelected) {

          final userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);

          final uid = userCredential.user!.uid;

          final doc =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .get();

          print("Login correct");
          ref.invalidate(userStreamProvider);
          Navigator.pushReplacementNamed(context, '/profile');
        } else {
          final userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);

          final uid = userCredential.user!.uid;

          final defaultTeam = await FirebaseFirestore.instance
              .collection('teams')
              .add({
                'name': 'My Notes',
                'description': 'Your personal notes space',
                'createdAt': FieldValue.serverTimestamp(),
                'createdBy': uid,
                'members': [uid],
                'code': const Uuid().v4().substring(0, 6),
                'settings': {
                  'canBeSeen': false,
                  'canChangeDescName': false,
                  'canChangeIcon': false,
                  'canBeJoined': false,
                  'canOnlyMyself': true,
                },
              });

          final teamCode = (await defaultTeam.get())['code'];

          final newUser = UserModel(
            uid: uid,
            username: username,
            email: email,
            joinedTeams: [teamCode],
            balance: 1000,
            purchasedPalettes: [],
            purchasedProfiles: [],
            purchasedPlanets: [],
          );

          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .set(newUser.toMap());

          print("Sign up correct");
          ref.invalidate(userStreamProvider);
          Navigator.pushReplacementNamed(context, '/profile');
        }
      } on FirebaseAuthException catch (e) {
        print("Firebase Error: ${e.message}");

        String message = "Something went wrong";

        if (e.code == 'user-not-found') {
          message = "User not found.";
        } else if (e.code == 'wrong-password' || e.code == 'invalid-email') {
          message = "Invalid email address or wrong password.";
        } else if (e.code == 'user-disabled') {
          message = "You have banned.";
        } else {
          message = "Unable to login. Please try again.";
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      } catch (e) {
        print("General Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("An unexpected error occurred")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(child: Container(color: AppColors.background)),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IntrinsicHeight(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.lightGrayBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(48),
                    topRight: Radius.circular(48),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildToggleButtons(),
                        _buildTextField(
                          "Email Address",
                          _emailController,
                          Icons.email,
                          validator: _validateEmail,
                        ),
                        if (!isLoginSelected)
                          _buildTextField(
                            "Username",
                            _usernameController,
                            Icons.person,
                            validator: _validateRequired,
                          ),
                        _buildTextField(
                          "Password",
                          _passwordController,
                          Icons.lock,
                          isPassword: true,
                          isVisible: _passwordVisible,
                          onToggleVisibility: () {
                            setState(
                              () => _passwordVisible = !_passwordVisible,
                            );
                          },
                        ),
                        if (!isLoginSelected)
                          _buildTextField(
                            "Confirm Password",
                            _confirmPasswordController,
                            Icons.lock,
                            isPassword: true,
                            isVisible: _confirmPasswordVisible,
                            onToggleVisibility: () {
                              setState(
                                () =>
                                    _confirmPasswordVisible =
                                        !_confirmPasswordVisible,
                              );
                            },
                          ),
                        const SizedBox(height: 24),
                        _buildMainButton(),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Image.asset("assets/images/logo.png", width: 200),
                const CustomText(
                  text: "SPACY NOTES",
                  fontSize: 40,
                  color: AppColors.mainTextColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppColors.onSurface,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _buildToggle("Log In", isLoginSelected, () {
            setState(() => isLoginSelected = true);
          }),
          _buildToggle("Sign Up", !isLoginSelected, () {
            setState(() => isLoginSelected = false);
          }),
        ],
      ),
    );
  }

  Widget _buildToggle(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.onPrimary : AppColors.mainTextColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: CustomText(
              text: label,
              fontSize: 18,
              color:
                  isSelected
                      ? AppColors.primary
                      : AppColors.unselectedTaskColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller,
    IconData icon, {
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !isVisible,
        style: const TextStyle(color: AppColors.primary),
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.unselectedTaskColor),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon, color: AppColors.secondary),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      isVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.unselectedTaskColor,
                    ),
                    onPressed: onToggleVisibility,
                  )
                  : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildMainButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFA726), Color(0xFFFFB74D)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: _handleAuth,
        child: CustomText(
          text: isLoginSelected ? "Log In" : "Sign Up",
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email cannot be empty";
    if (!value.contains('@')) return "Enter a valid email";
    return null;
  }

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) return "This field cannot be empty";
    return null;
  }
}
