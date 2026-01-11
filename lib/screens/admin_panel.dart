import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../models/experience_model.dart';
import '../models/settings_model.dart';
import '../services/supabase_service.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final SupabaseService _service = SupabaseService();
  bool _isAuthenticated = false;
  final TextEditingController _passwordController = TextEditingController();

  int _selectedTab = 0; // 0 = Projects, 1 = Experiences, 2 = Settings

  Future<void> _login() async {
    final isValid =
        await _service.verifyAdminPassword(_passwordController.text);
    if (isValid) {
      setState(() => _isAuthenticated = true);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin Login')),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Admin Panel',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE0CC9F),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              setState(() => _isAuthenticated = false);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedTab = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedTab == 0
                                ? const Color(0xFFE0CC9F)
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Projects',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedTab = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedTab == 1
                                ? const Color(0xFFE0CC9F)
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Experiences',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedTab = 2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedTab == 2
                                ? const Color(0xFFE0CC9F)
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _selectedTab == 0
                ? ProjectsManagement(service: _service)
                : _selectedTab == 1
                    ? ExperiencesManagement(service: _service)
                    : SettingsManagement(service: _service),
          ),
        ],
      ),
    );
  }
}

// ==================== PROJECTS MANAGEMENT ====================

class ProjectsManagement extends StatefulWidget {
  final SupabaseService service;
  const ProjectsManagement({super.key, required this.service});

  @override
  State<ProjectsManagement> createState() => _ProjectsManagementState();
}

class _ProjectsManagementState extends State<ProjectsManagement> {
  List<ProjectModel> _projects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() => _isLoading = true);
    final projects = await widget.service.getProjects();
    setState(() {
      _projects = projects;
      _isLoading = false;
    });
  }

  void _showProjectForm({ProjectModel? project}) {
    showDialog(
      context: context,
      builder: (context) => ProjectFormDialog(
        project: project,
        onSave: (updatedProject) async {
          final success = project == null
              ? await widget.service.addProject(updatedProject)
              : await widget.service.updateProject(updatedProject);
          if (success) {
            _loadProjects();
            if (context.mounted) Navigator.pop(context);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () => _showProjectForm(),
            icon: const Icon(Icons.add),
            label: const Text('Add Project'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE0CC9F),
              foregroundColor: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: _projects.isEmpty
              ? const Center(child: Text('No projects yet'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _projects.length,
                  itemBuilder: (context, index) {
                    final project = _projects[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: project.imagePath.isNotEmpty
                            ? Image.asset(
                                project.imagePath,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported),
                              )
                            : const Icon(Icons.image),
                        title: Text(project.title),
                        subtitle: Text(
                          project.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  _showProjectForm(project: project),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Project'),
                                    content: const Text(
                                        'Are you sure you want to delete this project?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true && project.id != null) {
                                  await widget.service
                                      .deleteProject(project.id!);
                                  _loadProjects();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class ProjectFormDialog extends StatefulWidget {
  final ProjectModel? project;
  final Function(ProjectModel) onSave;

  const ProjectFormDialog({super.key, this.project, required this.onSave});

  @override
  State<ProjectFormDialog> createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends State<ProjectFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _imagePathController;
  late TextEditingController _linkController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.project?.description ?? '');
    _imagePathController =
        TextEditingController(text: widget.project?.imagePath ?? '');
    _linkController = TextEditingController(text: widget.project?.link ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.project == null ? 'Add Project' : 'Edit Project'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imagePathController,
                decoration: const InputDecoration(
                  labelText: 'Image Path',
                  hintText: 'assets/images/project.png',
                ),
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _linkController,
                decoration: const InputDecoration(
                  labelText: 'Project Link (optional)',
                  hintText: 'https://...',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final project = ProjectModel(
                id: widget.project?.id,
                title: _titleController.text,
                description: _descriptionController.text,
                imagePath: _imagePathController.text,
                link:
                    _linkController.text.isEmpty ? null : _linkController.text,
                createdAt: widget.project?.createdAt,
              );
              widget.onSave(project);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE0CC9F),
            foregroundColor: Colors.black,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

// ==================== EXPERIENCES MANAGEMENT ====================

class ExperiencesManagement extends StatefulWidget {
  final SupabaseService service;
  const ExperiencesManagement({super.key, required this.service});

  @override
  State<ExperiencesManagement> createState() => _ExperiencesManagementState();
}

class _ExperiencesManagementState extends State<ExperiencesManagement> {
  List<ExperienceModel> _experiences = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExperiences();
  }

  Future<void> _loadExperiences() async {
    setState(() => _isLoading = true);
    final experiences = await widget.service.getExperiences();
    setState(() {
      _experiences = experiences;
      _isLoading = false;
    });
  }

  void _showExperienceForm({ExperienceModel? experience}) {
    showDialog(
      context: context,
      builder: (context) => ExperienceFormDialog(
        experience: experience,
        onSave: (updatedExperience) async {
          final success = experience == null
              ? await widget.service.addExperience(updatedExperience)
              : await widget.service.updateExperience(updatedExperience);
          if (success) {
            _loadExperiences();
            if (context.mounted) Navigator.pop(context);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () => _showExperienceForm(),
            icon: const Icon(Icons.add),
            label: const Text('Add Experience'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE0CC9F),
              foregroundColor: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: _experiences.isEmpty
              ? const Center(child: Text('No experiences yet'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _experiences.length,
                  itemBuilder: (context, index) {
                    final experience = _experiences[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(experience.title),
                        subtitle: Text(
                            '${experience.company} • ${experience.period}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  _showExperienceForm(experience: experience),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Experience'),
                                    content: const Text(
                                        'Are you sure you want to delete this experience?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true && experience.id != null) {
                                  await widget.service
                                      .deleteExperience(experience.id!);
                                  _loadExperiences();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class ExperienceFormDialog extends StatefulWidget {
  final ExperienceModel? experience;
  final Function(ExperienceModel) onSave;

  const ExperienceFormDialog(
      {super.key, this.experience, required this.onSave});

  @override
  State<ExperienceFormDialog> createState() => _ExperienceFormDialogState();
}

class _ExperienceFormDialogState extends State<ExperienceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _companyController;
  late TextEditingController _periodController;
  late TextEditingController _imagePathController;
  late List<TextEditingController> _responsibilityControllers;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.experience?.title ?? '');
    _companyController =
        TextEditingController(text: widget.experience?.company ?? '');
    _periodController =
        TextEditingController(text: widget.experience?.period ?? '');
    _imagePathController = TextEditingController(
        text: widget.experience?.imagePath ?? 'assets/images/');
    _responsibilityControllers = widget.experience?.responsibilities
            .map((r) => TextEditingController(text: r))
            .toList() ??
        [TextEditingController()];
  }

  void _addResponsibility() {
    setState(() {
      _responsibilityControllers.add(TextEditingController());
    });
  }

  void _removeResponsibility(int index) {
    setState(() {
      _responsibilityControllers[index].dispose();
      _responsibilityControllers.removeAt(index);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _periodController.dispose();
    _imagePathController.dispose();
    for (var controller in _responsibilityControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.experience == null ? 'Add Experience' : 'Edit Experience'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: 'Company'),
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _periodController,
                decoration: const InputDecoration(
                  labelText: 'Period',
                  hintText: '2020 - 2023',
                ),
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imagePathController,
                decoration: const InputDecoration(
                  labelText: 'Image Path or URL',
                  hintText:
                      'assets/images/company.png or https://example.com/logo.png',
                ),
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              const Text('Responsibilities:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._responsibilityControllers.asMap().entries.map((entry) {
                final index = entry.key;
                final controller = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            labelText: 'Responsibility ${index + 1}',
                          ),
                          validator: (v) =>
                              v?.isEmpty == true ? 'Required' : null,
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: _responsibilityControllers.length > 1
                            ? () => _removeResponsibility(index)
                            : null,
                      ),
                    ],
                  ),
                );
              }),
              TextButton.icon(
                onPressed: _addResponsibility,
                icon: const Icon(Icons.add),
                label: const Text('Add Responsibility'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final experience = ExperienceModel(
                id: widget.experience?.id,
                title: _titleController.text,
                company: _companyController.text,
                period: _periodController.text,
                responsibilities: _responsibilityControllers
                    .map((c) => c.text)
                    .where((t) => t.isNotEmpty)
                    .toList(),
                imagePath: _imagePathController.text,
                createdAt: widget.experience?.createdAt,
              );
              widget.onSave(experience);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE0CC9F),
            foregroundColor: Colors.black,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

// ==================== SETTINGS MANAGEMENT ====================

class SettingsManagement extends StatefulWidget {
  final SupabaseService service;
  const SettingsManagement({super.key, required this.service});

  @override
  State<SettingsManagement> createState() => _SettingsManagementState();
}

class _SettingsManagementState extends State<SettingsManagement> {
  SettingsModel? _settings;
  bool _isLoading = true;
  int _selectedSubTab = 0;

  final _passwordFormKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _seoFormKey = GlobalKey<FormState>();
  late TextEditingController _seoTitleController;
  late TextEditingController _seoDescriptionController;
  late TextEditingController _seoKeywordsController;
  late TextEditingController _seoAuthorController;
  late TextEditingController _seoOgImageController;

  @override
  void initState() {
    super.initState();
    _seoTitleController = TextEditingController();
    _seoDescriptionController = TextEditingController();
    _seoKeywordsController = TextEditingController();
    _seoAuthorController = TextEditingController();
    _seoOgImageController = TextEditingController();
    _loadSettings();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _seoTitleController.dispose();
    _seoDescriptionController.dispose();
    _seoKeywordsController.dispose();
    _seoAuthorController.dispose();
    _seoOgImageController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    final settings = await widget.service.getSettings();
    setState(() {
      _settings = settings;
      if (settings != null) {
        _seoTitleController.text = settings.seoTitle;
        _seoDescriptionController.text = settings.seoDescription;
        _seoKeywordsController.text = settings.seoKeywords;
        _seoAuthorController.text = settings.seoAuthor;
        _seoOgImageController.text = settings.seoOgImage;
      }
      _isLoading = false;
    });
  }

  Future<void> _changePassword() async {
    if (_passwordFormKey.currentState!.validate()) {
      if (_currentPasswordController.text != _settings?.adminPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Current password is incorrect')),
        );
        return;
      }

      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      final updatedSettings = _settings!.copyWith(
        adminPassword: _newPasswordController.text,
      );

      final success = await widget.service.updateSettings(updatedSettings);
      if (success) {
        setState(() => _settings = updatedSettings);
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password changed successfully!')),
          );
        }
      }
    }
  }

  Future<void> _updateSEO() async {
    if (_seoFormKey.currentState!.validate()) {
      final updatedSettings = _settings!.copyWith(
        seoTitle: _seoTitleController.text,
        seoDescription: _seoDescriptionController.text,
        seoKeywords: _seoKeywordsController.text,
        seoAuthor: _seoAuthorController.text,
        seoOgImage: _seoOgImageController.text,
      );

      final success = await widget.service.updateSettings(updatedSettings);
      if (success) {
        setState(() => _settings = updatedSettings);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('SEO settings updated!')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Container(
          color: Colors.grey[100],
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedSubTab = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _selectedSubTab == 0
                              ? const Color(0xFFE0CC9F)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: const Text('Change Password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedSubTab = 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _selectedSubTab == 1
                              ? const Color(0xFFE0CC9F)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: const Text('SEO Settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _selectedSubTab == 0
                ? _buildPasswordChangeForm()
                : _buildSEOForm(),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordChangeForm() {
    return Form(
      key: _passwordFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Change Admin Password',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          TextFormField(
            controller: _currentPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Current Password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock_outline),
            ),
            validator: (v) => v?.isEmpty == true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _newPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'New Password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            validator: (v) {
              if (v?.isEmpty == true) return 'Required';
              if (v!.length < 6)
                return 'Password must be at least 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirm New Password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            validator: (v) => v?.isEmpty == true ? 'Required' : null,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _changePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE0CC9F),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Change Password'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSEOForm() {
    return Form(
      key: _seoFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SEO Optimization',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Configure meta tags for better search engine visibility',
              style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 24),
          TextFormField(
            controller: _seoTitleController,
            decoration: const InputDecoration(
              labelText: 'Page Title',
              border: OutlineInputBorder(),
              helperText: 'Recommended: 50-60 characters',
              prefixIcon: Icon(Icons.title),
            ),
            maxLength: 60,
            validator: (v) => v?.isEmpty == true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _seoDescriptionController,
            decoration: const InputDecoration(
              labelText: 'Meta Description',
              border: OutlineInputBorder(),
              helperText: 'Recommended: 150-160 characters',
              prefixIcon: Icon(Icons.description),
            ),
            maxLines: 3,
            maxLength: 160,
            validator: (v) => v?.isEmpty == true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _seoKeywordsController,
            decoration: const InputDecoration(
              labelText: 'Keywords (comma-separated)',
              border: OutlineInputBorder(),
              helperText: 'Example: software engineer, cloud security',
              prefixIcon: Icon(Icons.tag),
            ),
            maxLines: 2,
            validator: (v) => v?.isEmpty == true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _seoAuthorController,
            decoration: const InputDecoration(
              labelText: 'Author Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (v) => v?.isEmpty == true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _seoOgImageController,
            decoration: const InputDecoration(
              labelText: 'Open Graph Image URL',
              border: OutlineInputBorder(),
              helperText: 'Image shown on social media',
              prefixIcon: Icon(Icons.image),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _updateSEO,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE0CC9F),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Update SEO Settings'),
            ),
          ),
        ],
      ),
    );
  }
}
