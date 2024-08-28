import 'package:flutter/material.dart';
import 'package:yccetpc/components/app_properties.dart';
import 'package:yccetpc/components/custom_appbar.dart';
import '../../api/skills_api.dart';
import '../../components/error_snackbar.dart';

class Skills extends StatefulWidget {
  const Skills({super.key});

  @override
  State<Skills> createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
  final List<int> levels = List.generate(10, (index) => index + 1);
  String? selectedSkill;
  int? selectedLevel;
  List<Map<String, dynamic>> savedSkills = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchSkills();
  }

 Future<void> fetchSkills() async {
  showLoadingIndicator();
  final response = await SkillAPI.readSkills();
  if (!mounted) return; // Check if the widget is still mounted
  hideLoadingIndicator();
  if (response['success']) {
    setState(() {
      savedSkills = List<Map<String, dynamic>>.from(response['skills']);
    });
  } else {
    InputComponent.showWarningSnackBar(context, response['message'] ?? 'Failed to load skills');
  }
}

void showLoadingIndicator() {
  if (!mounted) return; // Check if the widget is still mounted
  setState(() {
    isLoading = true;
  });
}

void hideLoadingIndicator() {
  if (!mounted) return; // Check if the widget is still mounted
  setState(() {
    isLoading = false;
  });
}

Future<void> saveSkill() async {
  if (selectedSkill != null && selectedLevel != null) {
    showLoadingIndicator();
    final response = await SkillAPI.createSkill(selectedSkill!, selectedLevel!);
    if (!mounted) return; // Check if the widget is still mounted
    hideLoadingIndicator();
    if (response['success']) {
      fetchSkills(); // Refresh the list after adding a skill
      InputComponent.showErrorDialogBox(context, 'Skill added successfully', response['message']);
    } else {
      InputComponent.showWarningSnackBar(context, response['message'] ?? 'Failed to add skill');
    }
  } else {
    InputComponent.showWarningSnackBar(context, 'Please select a skill and level');
  }
}


  Future<void> updateSkill(int index) async {
    showDialog(
      context: context,
      builder: (context) {
        String? newSkill = savedSkills[index]['Skill'];
        int? newLevel = savedSkills[index]['Level'];

        return Dialog(
          backgroundColor: CardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Update Skill',
                      style: TextStyle(color: TextColor, fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Skill',
                        labelStyle: TextStyle(color: HintColor),
                        filled: true,
                        fillColor: BackgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      value: newSkill,
                      items: skills.map((String skill) {
                        return DropdownMenuItem<String>(
                          value: skill,
                          child: Text(skill, style: TextStyle(color: TextColor)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          newSkill = newValue;
                        });
                      },
                      dropdownColor: CardColor,
                    ),
                    SizedBox(height: 16.0),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: 'Level',
                        labelStyle: TextStyle(color: HintColor),
                        filled: true,
                        fillColor: BackgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      value: newLevel,
                      items: levels.map((int level) {
                        return DropdownMenuItem<int>(
                          value: level,
                          child: Text(level.toString(), style: TextStyle(color: TextColor)),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          newLevel = newValue;
                        });
                      },
                      dropdownColor: CardColor,
                    ),
                    SizedBox(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (newSkill != null && newLevel != null) {
                              showLoadingIndicator();
                              final response = await SkillAPI.updateSkill(savedSkills[index]['SkillID'], newSkill!, newLevel!);
                              hideLoadingIndicator();
                              if (response['success']) {
                                fetchSkills(); // Refresh the list after updating a skill
                                Navigator.of(context).pop();
                                InputComponent.showErrorDialogBox(context, 'Skill updated successfully', response['message']);
                              } else {
                                InputComponent.showWarningSnackBar(context, response['message'] ?? 'Failed to update skill');
                              }
                            }
                          },
                          child: Text('Update', style: TextStyle(color: BackgroundColor)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TextColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel', style: TextStyle(color: HintColor)),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteSkill(int index) async {
    showLoadingIndicator();
    final response = await SkillAPI.deleteSkill(savedSkills[index]['SkillID']);
    hideLoadingIndicator();
    if (response['success']) {
      fetchSkills(); // Refresh the list after deleting a skill
      InputComponent.showErrorDialogBox(context, 'Skill deleted successfully', response['message']);
    } else {
      InputComponent.showWarningSnackBar(context, 'Failed to delete skill');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.screenAppbar("Skills", context),
      backgroundColor: BackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Add a New Skill',
                    style: TextStyle(
                      color: TextColor,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Skill',
                      labelStyle: TextStyle(color: HintColor),
                      filled: true,
                      fillColor: CardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    value: selectedSkill,
                    items: skills.map((String skill) {
                      return DropdownMenuItem<String>(
                        value: skill,
                        child: Text(skill, style: TextStyle(color: TextColor)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSkill = newValue;
                      });
                    },
                    dropdownColor: CardColor,
                  ),
                  SizedBox(height: 16.0),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Level',
                      labelStyle: TextStyle(color: HintColor),
                      filled: true,
                      fillColor: CardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    value: selectedLevel,
                    items: levels.map((int level) {
                      return DropdownMenuItem<int>(
                        value: level,
                        child: Text(level.toString(), style: TextStyle(color: TextColor)),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedLevel = newValue;
                      });
                    },
                    dropdownColor: CardColor,
                  ),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: saveSkill,
                    child: Text('Submit', style: TextStyle(color: BackgroundColor)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Divider(color: HintColor),
                  SizedBox(height: 24.0),
                  Text(
                    'Saved Skills',
                    style: TextStyle(
                      color: TextColor,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: savedSkills.length,
                    itemBuilder: (context, index) {
                      final skill = savedSkills[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        color: CardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          title: Text(skill['Skill'], style: TextStyle(color: TextColor, fontWeight: FontWeight.bold)),
                          subtitle: Text('Level: ${skill['Level']}', style: TextStyle(color: HintColor)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: TextColor),
                                onPressed: () => updateSkill(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: TextColor),
                                onPressed: () => deleteSkill(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                color: TextColor,
              ),
            ),
        ],
      ),
    );
  }
}
