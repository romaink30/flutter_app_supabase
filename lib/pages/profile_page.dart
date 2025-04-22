import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthService();
  PlatformFile? _selectedFile;
  bool _isUploading = false;

  void logout() async {
    try {
      await authService.logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la déconnexion: $e")),
      );
    }
  }

  Future pickAnyFile() async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
      allowMultiple: false,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _selectedFile = result.files.single;
      });
    }
  }

  Future uploadFile(String fileName, Uint8List fileBytes) async {
    setState(() {
      _isUploading = true;
    });

    final userUid = authService.getCurrentUserUid();
    final bettername = fileName.replaceAll(RegExp(r'[^\w\-\.]'), "");
    final encodedFileName = Uri.encodeComponent(bettername);
    final path = '/$userUid/$encodedFileName';

    try {
      await Supabase.instance.client.storage
          .from('upload')
          .uploadBinary(
            path,
            fileBytes,
            fileOptions: const FileOptions(upsert: true),
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Fichier téléchargé avec succès")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Erreur lors du téléversement: $e")),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentEmail = authService.getCurrentUserEmail();

    if (currentEmail == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Vous devez être connecté pour accéder à cette page."),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text("Se connecter"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      appBar: AppBar(
       title: Text(
          currentEmail,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2C3E50),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Color.fromARGB(255, 255, 255, 255),
            onPressed: logout,
          )
        ],
      ),
      body: Center(
        child: Card(
          color: Colors.white,
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "📁 Uploader un fichier",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _selectedFile != null
                      ? "Fichier sélectionné : ${_selectedFile!.name}"
                      : "Aucun fichier sélectionné",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: pickAnyFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3498DB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.attach_file),
                  label: const Text("Choisir un fichier"),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _selectedFile == null || _isUploading
                      ? null
                      : () async {
                          await uploadFile(_selectedFile!.name, _selectedFile!.bytes!);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF27AE60),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.upload),
                  label: const Text("Téléverser"),
                ),
                if (_isUploading) ...[
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(color: Color(0xFF2980B9)),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
