import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../APIs/animal-related-apis.dart';
import '../APIs/food-programme-apis.dart';
import '../APIs/food-related-apis.dart';
import '../models/animal.dart';
import '../models/food.dart';
import '../models/food_programme.dart';
import '../models/location.dart';
import '../models/user.dart';
import '../APIs/location-related-apis.dart';
import '../widgets/food_programme_create.dart';

class AddAnimalScreen extends StatefulWidget {
  final User user;
  final Animal? animal;

  const AddAnimalScreen({
    super.key,
    required this.user,
    this.animal,
  });

  @override
  State<AddAnimalScreen> createState() => _AddAnimalScreenState();
}

class _AddAnimalScreenState extends State<AddAnimalScreen> {
  final _formKey = GlobalKey<FormState>();
  late List<FoodProgramme> _foodProgrammes = [];
  late Future<List<Food>> _foodsFuture;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _healthProfileController = TextEditingController();
  DateTime? _selectedDate;
  Location? _selectedLocation;
  late Future<List<Location>> _locationsFuture;
  Uint8List? _selectedImage;
  bool isEditMode = false;


  @override
  void initState() {
    super.initState();
    isEditMode = widget.animal != null;
    _locationsFuture = getAllLocationsOfUserAPI(widget.user).then((locations) {
      if (isEditMode) {
        // Find the matching location by ID from the fetched locations
        _selectedLocation = locations.firstWhere(
              (loc) => loc.id == widget.animal!.location.id,
          orElse: () => widget.animal!.location,
        );
      }
      return locations;
    });
    _foodsFuture = getAllFoodsForUserAPI(widget.user);

    if (isEditMode) {
      // Populate fields with existing animal data
      _nameController.text = widget.animal!.name;
      _descriptionController.text = widget.animal!.description;
      _healthProfileController.text = widget.animal!.healthProfile;
      _selectedDate = widget.animal!.age;
      _selectedImage = widget.animal!.imageData;

      // Load food programmes for the animal
      getFoodProgrammeForAnimalAPI(widget.animal!).then((programmes) {
        setState(() {
          _foodProgrammes = programmes;
        });
      });
    }
  }

  Future<void> _addFoodProgramme() async {
    final foods = await _foodsFuture;
    if (mounted) {
      final FoodProgramme? newProgramme = await showDialog<FoodProgramme>(
        context: context,
        builder: (context) => AddFoodProgrammeDialog(availableFoods: foods),
      );

      if (newProgramme != null) {
        setState(() {
          _foodProgrammes.add(newProgramme);
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _healthProfileController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveAnimal() async {
    if (_formKey.currentState!.validate() && _selectedLocation != null && _selectedDate != null) {
      try {
        final animal = Animal(
          isEditMode ? widget.animal!.id : '', // Use existing ID if editing
          _nameController.text,
          _descriptionController.text,
          _selectedDate!,
          _selectedImage,
          _healthProfileController.text,
          _selectedLocation!,
        );

        final savedAnimal = isEditMode
            ? await updateAnimalAPI(animal)
            : await saveAnimalAPI(widget.user, animal);

        final programmesToSave = _foodProgrammes.map((fp) {
          fp.animal = savedAnimal;
          return fp;
        }).toList();

        // Save food programmes if there are any
        if (programmesToSave.isNotEmpty) {
          await saveFoodProgrammesAPI(programmesToSave);
        }

        if (mounted) {
          // Show success message and pop back to previous screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Animal saved successfully')),
          );
          Navigator.of(context).pop(savedAnimal);
        }
      } catch (e) {
        if (mounted) {
          // Show error message if save fails
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save animal: $e')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
    }
  }

  Future<void> _editFoodProgramme(int index) async {
    final foods = await _foodsFuture;
    if (mounted) {
      final FoodProgramme? updatedProgramme = await showDialog<FoodProgramme>(
        context: context,
        builder: (context) => AddFoodProgrammeDialog(
          availableFoods: foods,
          existingProgramme: _foodProgrammes[index],
        ),
      );

      if (updatedProgramme != null) {
        setState(() {
          _foodProgrammes[index] = updatedProgramme;
        });
      }
    }
  }


  Widget _buildFoodProgrammesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Food Programme',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              if (_foodProgrammes.isEmpty)
                SizedBox(
                  height: 80,
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: _addFoodProgramme,
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _foodProgrammes.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _foodProgrammes.length) {
                      return ListTile(
                        leading: const Icon(Icons.add_circle_outline),
                        title: const Text('Add another programme'),
                        onTap: _addFoodProgramme,
                      );
                    }

                    final programme = _foodProgrammes[index];
                    final endTimeStr = programme.endHour != null
                        ? ' - ${programme.endHour!.format(context)}'
                        : '';

                    return ListTile(
                      title: Text(programme.food.name),
                      subtitle: Text(
                        '${programme.startHour.format(context)}$endTimeStr',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editFoodProgramme(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              setState(() {
                                _foodProgrammes.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA7D77C),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(isEditMode ? 'Edit Animal' : 'Add Animal'),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 40,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Animal Image and Change Picture Button
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          // Add image change functionality later
                        },
                        child: const Text(
                          'Change picture',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    filled: true,
                    fillColor: Colors.white,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Location Dropdown
                FutureBuilder<List<Location>>(
                  future: _locationsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    final locations = snapshot.data ?? [];

                    return DropdownButtonFormField<Location>(
                      value: _selectedLocation,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        filled: true,
                        fillColor: Colors.white,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      items: locations.map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location.name ?? 'Location ${location.id}'),
                        );
                      }).toList(),
                      onChanged: (Location? value) {
                        setState(() {
                          _selectedLocation = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a location';
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Food Programme Section
                _buildFoodProgrammesList(),

                const SizedBox(height: 16),

                // Calendar for Birth Date
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Birth Date',
                        filled: true,
                        fillColor: Colors.white,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedDate == null
                                ? 'Select date'
                                : '${_selectedDate!.year}/${_selectedDate!.month}/${_selectedDate!.day}',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(Icons.calendar_today, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    filled: true,
                    fillColor: Colors.white,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Health Profile Field
                TextFormField(
                  controller: _healthProfileController,
                  decoration: InputDecoration(
                    labelText: 'Health Profile',
                    filled: true,
                    fillColor: Colors.white,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter health profile information';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Save Button
                Center(
                  child: ElevatedButton(
                    onPressed: _saveAnimal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF31511E),
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Save animal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}