import 'package:flutter/material.dart';

import '../models/application_model.dart';
import '../models/job_model.dart';


class JobProvider with ChangeNotifier {
  List<Job> _allJobs = [];
  List<Job> _recommendedJobs = [];
  List<Application> _userApplications = [];
  bool _isLoading = false;

  // Getters
  List<Job> get allJobs => _allJobs;
  List<Job> get recommendedJobs => _recommendedJobs;
  List<Application> get userApplications => _userApplications;
  bool get isLoading => _isLoading;

  // Fetch all jobs
  Future<void> getAllJobs() async {
    _setLoading(true);

    try {
      // In a real app, this would be an API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      _allJobs = [
        Job(
          id: 1,
          recruiterId: 101,
          jobType: 'Flutter Developer',
          description: 'We are looking for an experienced Flutter developer...',
          requirements: '3+ years Flutter experience, Dart proficiency, Mobile app development',
          status: 'Active',
          datePosted: DateTime.now().subtract(const Duration(days: 2)),
          deadline: DateTime.now().add(const Duration(days: 30)),
          companyName: 'Tech Solutions',
          location: 'New York, NY',
        ),
        Job(
          id: 2,
          recruiterId: 102,
          jobType: 'Senior React Developer',
          description: 'Senior React developer needed for a growing startup...',
          requirements: '5+ years React experience, JavaScript expertise, Frontend development',
          status: 'Active',
          datePosted: DateTime.now().subtract(const Duration(days: 3)),
          deadline: DateTime.now().add(const Duration(days: 25)),
          companyName: 'WebCraft',
          location: 'Remote',
        ),
        Job(
          id: 3,
          recruiterId: 103,
          jobType: 'UI/UX Designer',
          description: 'Looking for a talented UI/UX designer to join our team...',
          requirements: '3+ years UI/UX experience, Figma, User research',
          status: 'Active',
          datePosted: DateTime.now().subtract(const Duration(days: 1)),
          deadline: DateTime.now().add(const Duration(days: 20)),
          companyName: 'Creative Labs',
          location: 'San Francisco, CA',
        ),
        Job(
          id: 4,
          recruiterId: 104,
          jobType: 'Product Manager',
          description: 'Experienced product manager needed to lead our mobile team...',
          requirements: '5+ years product management, Agile methodologies, Technical background',
          status: 'Active',
          datePosted: DateTime.now().subtract(const Duration(days: 5)),
          deadline: DateTime.now().add(const Duration(days: 15)),
          companyName: 'InnovateTech',
          location: 'Austin, TX',
        ),
        Job(
          id: 5,
          recruiterId: 105,
          jobType: 'Backend Developer',
          description: 'Backend developer with Node.js experience needed...',
          requirements: '3+ years Node.js, Database design, API development',
          status: 'Active',
          datePosted: DateTime.now().subtract(const Duration(days: 4)),
          deadline: DateTime.now().add(const Duration(days: 28)),
          companyName: 'DataSystems',
          location: 'Chicago, IL',
        ),
      ];

      notifyListeners();
    } catch (error) {
      // Handle error
      print('Error fetching jobs: $error');
    }

    _setLoading(false);
  }

  // Fetch recommended jobs
  Future<void> getRecommendedJobs() async {
    _setLoading(true);

    try {
      // In a real app, this would be an API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - in a real app, these would be algorithmically recommended
      _recommendedJobs = [
        Job(
          id: 1,
          recruiterId: 101,
          jobType: 'Flutter Developer',
          description: 'We are looking for an experienced Flutter developer...',
          requirements: '3+ years Flutter experience, Dart proficiency, Mobile app development',
          status: 'Active',
          datePosted: DateTime.now().subtract(const Duration(days: 2)),
          deadline: DateTime.now().add(const Duration(days: 30)),
          companyName: 'Tech Solutions',
          location: 'New York, NY',
        ),
        Job(
          id: 3,
          recruiterId: 103,
          jobType: 'UI/UX Designer',
          description: 'Looking for a talented UI/UX designer to join our team...',
          requirements: '3+ years UI/UX experience, Figma, User research',
          status: 'Active',
          datePosted: DateTime.now().subtract(const Duration(days: 1)),
          deadline: DateTime.now().add(const Duration(days: 20)),
          companyName: 'Creative Labs',
          location: 'San Francisco, CA',
        ),
        Job(
          id: 5,
          recruiterId: 105,
          jobType: 'Backend Developer',
          description: 'Backend developer with Node.js experience needed...',
          requirements: '3+ years Node.js, Database design, API development',
          status: 'Active',
          datePosted: DateTime.now().subtract(const Duration(days: 4)),
          deadline: DateTime.now().add(const Duration(days: 28)),
          companyName: 'DataSystems',
          location: 'Chicago, IL',
        ),
      ];

      notifyListeners();
    } catch (error) {
      // Handle error
      print('Error fetching recommended jobs: $error');
    }

    _setLoading(false);
  }

  // Get user's job applications
  Future<void> getUserApplications() async {
    _setLoading(true);

    try {
      // In a real app, this would be an API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      _userApplications = [
        Application(
          id: 'app1',
          job: Job(
            id: 1,
            recruiterId: 101,
            jobType: 'Flutter Developer',
            description: 'We are looking for an experienced Flutter developer...',
            requirements: '3+ years Flutter experience, Dart proficiency, Mobile app development',
            status: 'Active',
            datePosted: DateTime.now().subtract(const Duration(days: 7)),
            deadline: DateTime.now().add(const Duration(days: 23)),
            companyName: 'Tech Solutions',
            location: 'New York, NY',
          ),
          status: 'Reviewing',
          appliedDate: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Application(
          id: 'app2',
          job: Job(
            id: 3,
            recruiterId: 103,
            jobType: 'UI/UX Designer',
            description: 'Looking for a talented UI/UX designer to join our team...',
            requirements: '3+ years UI/UX experience, Figma, User research',
            status: 'Active',
            datePosted: DateTime.now().subtract(const Duration(days: 10)),
            deadline: DateTime.now().add(const Duration(days: 20)),
            companyName: 'Creative Labs',
            location: 'San Francisco, CA',
          ),
          status: 'Pending',
          appliedDate: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Application(
          id: 'app3',
          job: Job(
            id: 4,
            recruiterId: 104,
            jobType: 'Product Manager',
            description: 'Experienced product manager needed to lead our mobile team...',
            requirements: '5+ years product management, Agile methodologies, Technical background',
            status: 'Active',
            datePosted: DateTime.now().subtract(const Duration(days: 15)),
            deadline: DateTime.now().add(const Duration(days: 15)),
            companyName: 'InnovateTech',
            location: 'Austin, TX',
          ),
          status: 'Rejected',
          appliedDate: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ];

      notifyListeners();
    } catch (error) {
      // Handle error
      print('Error fetching applications: $error');
    }

    _setLoading(false);
  }

  // Apply to a job
  Future<void> applyToJob(int jobId) async {  // Changed parameter type to int
    _setLoading(true);

    try {
      // In a real app, this would be an API call
      await Future.delayed(const Duration(seconds: 1));

      // Find the job by ID
      final job = _allJobs.firstWhere((job) => job.id == jobId);

      // Create a new application
      final newApplication = Application(
        id: 'app${_userApplications.length + 1}',
        job: job,
        status: 'Pending',
        appliedDate: DateTime.now(),
      );

      // Add to applications list
      _userApplications.add(newApplication);

      notifyListeners();
    } catch (error) {
      // Handle error
      print('Error applying to job: $error');
    }

    _setLoading(false);
  }

  // Helper method to set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
