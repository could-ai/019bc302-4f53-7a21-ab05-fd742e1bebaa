import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../services/mock_data_service.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final entry = FoodEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        calories: int.parse(_caloriesController.text),
        protein: int.tryParse(_proteinController.text) ?? 0,
        carbs: int.tryParse(_carbsController.text) ?? 0,
        fat: int.tryParse(_fatController.text) ?? 0,
        timestamp: DateTime.now(),
      );

      await MockDataService().addEntry(entry);

      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pop(context, true); // Return true to indicate refresh needed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADD ENTRY'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('FOOD DETAILS'),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Food Name',
                  hintText: 'e.g. Grilled Salmon',
                  prefixIcon: Icon(Icons.restaurant_menu),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Calories',
                  suffixText: 'kcal',
                  prefixIcon: Icon(Icons.local_fire_department),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('MACROS (Optional)'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _proteinController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Protein',
                        suffixText: 'g',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _carbsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Carbs',
                        suffixText: 'g',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _fatController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Fat',
                        suffixText: 'g',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveEntry,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.background,
                          ),
                        )
                      : const Text('LOG FOOD'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.primary,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }
}
