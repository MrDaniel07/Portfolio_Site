import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/project_model.dart';
import '../models/experience_model.dart';
import '../models/settings_model.dart';

class SupabaseService {
  final SupabaseClient _client = SupabaseConfig.client;

  // ==================== PROJECTS CRUD ====================

  /// Fetch all projects from Supabase
  Future<List<ProjectModel>> getProjects() async {
    try {
      final response = await _client
          .from('projects')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ProjectModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching projects: $e');
      return [];
    }
  }

  /// Add a new project to Supabase
  Future<bool> addProject(ProjectModel project) async {
    try {
      await _client.from('projects').insert(project.toJson());
      return true;
    } catch (e) {
      print('Error adding project: $e');
      return false;
    }
  }

  /// Update an existing project in Supabase
  Future<bool> updateProject(ProjectModel project) async {
    try {
      if (project.id == null) return false;
      await _client
          .from('projects')
          .update(project.toJson())
          .eq('id', project.id!);
      return true;
    } catch (e) {
      print('Error updating project: $e');
      return false;
    }
  }

  /// Delete a project from Supabase
  Future<bool> deleteProject(String id) async {
    try {
      await _client.from('projects').delete().eq('id', id);
      return true;
    } catch (e) {
      print('Error deleting project: $e');
      return false;
    }
  }

  // ==================== EXPERIENCES CRUD ====================

  /// Fetch all experiences from Supabase
  Future<List<ExperienceModel>> getExperiences() async {
    try {
      final response = await _client
          .from('experiences')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ExperienceModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching experiences: $e');
      return [];
    }
  }

  /// Add a new experience to Supabase
  Future<bool> addExperience(ExperienceModel experience) async {
    try {
      await _client.from('experiences').insert(experience.toJson());
      return true;
    } catch (e) {
      print('Error adding experience: $e');
      return false;
    }
  }

  /// Update an existing experience in Supabase
  Future<bool> updateExperience(ExperienceModel experience) async {
    try {
      if (experience.id == null) return false;
      await _client
          .from('experiences')
          .update(experience.toJson())
          .eq('id', experience.id!);
      return true;
    } catch (e) {
      print('Error updating experience: $e');
      return false;
    }
  }

  /// Delete an experience from Supabase
  Future<bool> deleteExperience(String id) async {
    try {
      await _client.from('experiences').delete().eq('id', id);
      return true;
    } catch (e) {
      print('Error deleting experience: $e');
      return false;
    }
  }

  // ==================== SETTINGS CRUD ====================

  /// Get settings from Supabase (always returns the first/only record)
  Future<SettingsModel?> getSettings() async {
    try {
      final response =
          await _client.from('settings').select().limit(1).maybeSingle();

      if (response == null) {
        // If no settings exist, create default settings
        final defaultSettings = SettingsModel(
          adminPassword: 'admin123',
          seoTitle: 'Anyahuru Oluebube Daniel - Portfolio',
          seoDescription:
              'Software Engineer and Cloud Security Engineer specializing in application development and cybersecurity',
          seoKeywords:
              'software engineer, cloud security, cybersecurity, flutter developer, AWS, portfolio',
          seoAuthor: 'Anyahuru Oluebube Daniel',
          seoOgImage: '',
        );
        await updateSettings(defaultSettings);
        return defaultSettings;
      }

      return SettingsModel.fromJson(response);
    } catch (e) {
      print('Error fetching settings: $e');
      return null;
    }
  }

  /// Update settings in Supabase
  Future<bool> updateSettings(SettingsModel settings) async {
    try {
      // Check if settings exist
      final existing =
          await _client.from('settings').select().limit(1).maybeSingle();

      if (existing == null) {
        // Insert new settings
        await _client.from('settings').insert(settings.toJson());
      } else {
        // Update existing settings
        await _client
            .from('settings')
            .update(settings.toJson())
            .eq('id', existing['id']);
      }
      return true;
    } catch (e) {
      print('Error updating settings: $e');
      return false;
    }
  }

  /// Verify admin password
  Future<bool> verifyAdminPassword(String password) async {
    try {
      final settings = await getSettings();
      return settings?.adminPassword == password;
    } catch (e) {
      print('Error verifying password: $e');
      return false;
    }
  }
}
