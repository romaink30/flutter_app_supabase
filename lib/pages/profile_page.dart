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

  // Modification de logout pour aller à la page d'accueil
  void logout() async {
    try {
      await authService.logout();  // Utilisation de logout au lieu de signOut
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,  // Cela supprime toutes les pages précédentes
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la déconnexion: $e")),
      );
    }
  }

  // Fonction pour choisir un fichier
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

  // Fonction pour uploader le fichier
  Future uploadFile(String fileName, Uint8List fileBytes) async {
    setState(() {
      _isUploading = true;
    });

    // Récupérer l'UID de l'utilisateur
    final userUid = authService.getCurrentUserUid();

    // Encoder le nom du fichier pour éviter les caractères spéciaux invalides
    final bettername = fileName.replaceAll(RegExp(r'[^\w\-\.]'), "");
    final encodedFileName = Uri.encodeComponent(bettername);
    final path = '/$userUid/$encodedFileName';  // Créer le chemin basé sur l'UID de l'utilisateur

    try {
      // Upload du fichier dans le bucket 'upload' à l'emplacement spécifique
      final response = await Supabase.instance.client.storage
          .from('upload')
          .uploadBinary(
            path,  // Utilisation du chemin avec l'UID de l'utilisateur
            fileBytes,
            fileOptions: const FileOptions(upsert: true), // 'upsert' assure que le fichier sera écrasé s'il existe déjà
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fichier téléchargé avec succès")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du téléversement: $e")),
      );
      print("Erreur lors du téléversement: $e"); // Log de l'erreur pour plus de détails
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
      appBar: AppBar(
        title: Text(currentEmail ?? "Utilisateur"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,  // Modification de la fonction de déconnexion
          )
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Sélectionner un fichier à téléverser",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                _selectedFile != null
                    ? Text("📄 ${_selectedFile!.name}")
                    : const Text("Aucun fichier sélectionné"),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: pickAnyFile,
                  icon: const Icon(Icons.attach_file),
                  label: const Text("Choisir un fichier"),
                ),
                const SizedBox(height: 20),
                // Nouveau bouton pour uploader les fichiers
                ElevatedButton.icon(
                  onPressed: _selectedFile == null || _isUploading
                      ? null
                      : () async {
                          await uploadFile(_selectedFile!.name, _selectedFile!.bytes!);
                        },
                  icon: const Icon(Icons.upload),
                  label: const Text("Upload"),
                ),
                if (_isUploading) ...[
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
