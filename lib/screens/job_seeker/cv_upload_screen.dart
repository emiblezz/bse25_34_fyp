import 'package:flutter/material.dart';
import 'dart:io';
import '../../constants/app_colors.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class CVUploadScreen extends StatefulWidget {
  @override
  _CVUploadScreenState createState() => _CVUploadScreenState();
}

class _CVUploadScreenState extends State<CVUploadScreen> {
  File? _cvFile;
  String? _fileError;
  bool _isUploading = false;
  final _formKey = GlobalKey<FormState>();

  final _coverLetterController = TextEditingController();
  String? _selectedCVFormat;
  final List<String> _cvFormats = [
    'PDF',
    'DOC/DOCX',
    'TXT',
  ];

  @override
  void dispose() {
    _coverLetterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload CV'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(),
              const SizedBox(height: 24),
              _buildProfileSection(user?.name ?? 'User'),
              const SizedBox(height: 24),
              _buildCVUploadSection(),
              const SizedBox(height: 24),
              _buildCoverLetterSection(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _handleUpload,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: _isUploading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Text(
                    'Upload CV',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Tips for an effective CV',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '• Keep it concise and relevant to the job youre applying for\n'
            '• Highlight your key skills and achievements\n'
            '• Use bullet points for better readability\n'
              '• Include quantifiable achievements where possible\n'
              '• Proofread carefully for errors',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(String userName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Text(
              userName.isNotEmpty ? userName[0] : '?',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            userName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: const Text('Job Seeker'),
          trailing: TextButton(
            onPressed: () {
              // Navigate to profile edit screen
            },
            child: const Text('Edit Profile'),
          ),
        ),
      ],
    );
  }

  Widget _buildCVUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload CV',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Upload your CV in PDF, DOC, DOCX, or TXT format',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'CV Format',
            border: OutlineInputBorder(),
          ),
          value: _selectedCVFormat,
          onChanged: (newValue) {
            setState(() {
              _selectedCVFormat = newValue;
            });
          },
          items: _cvFormats.map((format) {
            return DropdownMenuItem<String>(
              value: format,
              child: Text(format),
            );
          }).toList(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a CV format';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: _pickCVFile,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: _cvFile != null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.description, size: 40, color: Colors.blue),
                  const SizedBox(height: 8),
                  Text(
                    _getFileName(_cvFile!.path),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${(_cvFile!.lengthSync() / 1024).toStringAsFixed(2)} KB',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file, size: 40, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    'Click to browse files',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_fileError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _fileError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildCoverLetterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cover Letter (Optional)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Add a personalized message to accompany your CV',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _coverLetterController,
          maxLines: 6,
          decoration: const InputDecoration(
            hintText: 'Enter your cover letter here...',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Future<void> _pickCVFile() async {
    // This would use a file picker in a real app
    // For example using file_picker package:
    //
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    // );
    //
    // if (result != null) {
    //   setState(() {
    //     _cvFile = File(result.files.single.path!);
    //     _fileError = null;
    //   });
    // }

    // For this demo, we'll simulate selecting a file
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // Simulate a file being selected
      _cvFile = File('dummy_path/my_resume.pdf');
      _fileError = null;
    });
  }

  String _getFileName(String path) {
    return path.split('/').last;
  }

  Future<void> _handleUpload() async {
    if (_formKey.currentState!.validate()) {
      if (_cvFile == null) {
        setState(() {
          _fileError = 'Please select a CV file';
        });
        return;
      }

      setState(() {
        _isUploading = true;
        _fileError = null;
      });

      // Simulate upload process
      await Future.delayed(const Duration(seconds: 2));

      // After successful upload
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('CV uploaded successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }
}