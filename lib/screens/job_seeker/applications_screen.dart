import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/job_provider.dart';
import '../../models/application_model.dart';
import 'cv_upload_screen.dart';

class ApplicationsScreen extends StatefulWidget {
  @override
  _ApplicationsScreenState createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Load user applications when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadApplications();
    });
  }

  Future<void> _loadApplications() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<JobProvider>(context, listen: false).getUserApplications();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildApplicationsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CVUploadScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.upload_file),
        tooltip: 'Upload CV',
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: Colors.grey,
        indicatorColor: AppColors.primary,
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Pending'),
          Tab(text: 'Reviewing'),
          Tab(text: 'Completed'),
        ],
        onTap: (index) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildApplicationsList() {
    final jobProvider = Provider.of<JobProvider>(context);
    final applications = jobProvider.userApplications;

    if (applications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No applications found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Find Jobs'),
              onPressed: () {
                // Navigate to Jobs tab - would need to be handled by parent widget
              },
            ),
          ],
        ),
      );
    }

    // Filter applications based on selected tab
    List<Application> filteredApplications = applications;

    if (_tabController.index == 1) {
      filteredApplications = applications.where((app) =>
      app.status.toLowerCase() == 'pending').toList();
    } else if (_tabController.index == 2) {
      filteredApplications = applications.where((app) =>
      app.status.toLowerCase() == 'reviewing').toList();
    } else if (_tabController.index == 3) {
      filteredApplications = applications.where((app) =>
      app.status.toLowerCase() == 'accepted' ||
          app.status.toLowerCase() == 'rejected').toList();
    }

    if (filteredApplications.isEmpty) {
      return Center(
        child: Text(
          'No ${_tabController.index == 1 ? 'pending' :
          _tabController.index == 2 ? 'reviewing' :
          _tabController.index == 3 ? 'completed' : ''} applications',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadApplications,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredApplications.length,
        itemBuilder: (context, index) {
          final application = filteredApplications[index];
          return _buildApplicationCard(application);
        },
      ),
    );
  }

  Widget _buildApplicationCard(Application application) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showApplicationDetails(application);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      application.job.jobType, // Changed from title to jobType
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _getStatusChip(application.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                application.job.companyName ?? 'Unknown Company', // Changed from company to companyName with null safety
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                application.job.location ?? 'No Location', // Added null safety for location
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Applied on: ${_formatDate(application.appliedDate)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showApplicationDetails(Application application) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    application.job.jobType, // Changed from title to jobType
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              application.job.companyName ?? 'Unknown Company', // Changed from company to companyName with null safety
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              application.job.location ?? 'No Location', // Added null safety for location
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            _getStatusChip(application.status),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Application Date'),
              subtitle: Text(_formatDate(application.appliedDate)),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.attach_money),
              title: const Text('Date Posted'),
              subtitle: Text(_formatDate(application.job.datePosted)), // Changed from salary to datePosted
            ),
            const SizedBox(height: 16),
            const Text(
              'Job Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              application.job.description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Requirements',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Changed from .map to split the requirements string into a list
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: application.job.requirements.split(',').map((requirement) =>
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontSize: 14)),
                        Expanded(
                          child: Text(
                            requirement.trim(),
                            style: const TextStyle(fontSize: 14, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  )
              ).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Additional action based on status
                  if (application.status.toLowerCase() == 'rejected') {
                    // Perhaps show similar jobs
                  } else if (application.status.toLowerCase() == 'accepted') {
                    // Perhaps show next steps
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  _getActionButtonText(application.status),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getActionButtonText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'reviewing':
        return 'Check Status Later';
      case 'accepted':
        return 'View Next Steps';
      case 'rejected':
        return 'Find Similar Jobs';
      default:
        return 'View Details';
    }
  }

  Widget _getStatusChip(String status) {
    Color chipColor;
    IconData chipIcon;

    switch (status.toLowerCase()) {
      case 'pending':
        chipColor = Colors.orange;
        chipIcon = Icons.hourglass_empty;
        break;
      case 'reviewing':
        chipColor = Colors.blue;
        chipIcon = Icons.search;
        break;
      case 'accepted':
        chipColor = Colors.green;
        chipIcon = Icons.check_circle;
        break;
      case 'rejected':
        chipColor = Colors.red;
        chipIcon = Icons.cancel;
        break;
      default:
        chipColor = Colors.grey;
        chipIcon = Icons.help_outline;
    }

    return Chip(
      backgroundColor: chipColor.withOpacity(0.1),
      label: Text(
        status,
        style: TextStyle(
          color: chipColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      avatar: Icon(
        chipIcon,
        color: chipColor,
        size: 16,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}