import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/job_provider.dart';
import '../../widgets/job_card.dart';
import 'job_details_screen.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({Key? key}) : super(key: key);

  @override
  _JobListScreenState createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load both types of jobs when the screen initializes
    _loadAllJobs();
    _loadRecommendedJobs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllJobs() async {
    try {
      await Provider.of<JobProvider>(context, listen: false).getAllJobs();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading jobs: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _loadRecommendedJobs() async {
    try {
      await Provider.of<JobProvider>(context, listen: false).getRecommendedJobs();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading recommended jobs: ${e.toString()}')),
        );
      }
    }
  }

  void _searchJobs(String query) {
    setState(() {
      _searchQuery = query;
    });
    // In a real app, you'd update the filtering here
    // For now, we'll just reload all jobs
    _loadAllJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Listings"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "All Jobs"),
            Tab(text: "Recommended"),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllJobsList(),
                _buildRecommendedJobsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for jobs, companies...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchController.clear();
                _searchQuery = '';
              });
              _loadAllJobs();
            },
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onSubmitted: _searchJobs,
      ),
    );
  }

  Widget _buildAllJobsList() {
    return Consumer<JobProvider>(
      builder: (context, jobProvider, child) {
        if (jobProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final jobs = jobProvider.allJobs;

        if (jobs.isEmpty) {
          return const Center(
            child: Text(
              'No jobs found',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _loadAllJobs,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailsScreen(job: jobs[index]),
                    ),
                  );
                },
                child: JobCard(job: jobs[index]),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRecommendedJobsList() {
    return Consumer<JobProvider>(
      builder: (context, jobProvider, child) {
        if (jobProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final jobs = jobProvider.recommendedJobs;

        if (jobs.isEmpty) {
          return const Center(
            child: Text(
              'No recommended jobs found',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _loadRecommendedJobs,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailsScreen(job: jobs[index]),
                    ),
                  );
                },
                child: JobCard(job: jobs[index]),
              );
            },
          ),
        );
      },
    );
  }
}