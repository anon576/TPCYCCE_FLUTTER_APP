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
    setState(() {
      isLoading = true;
    });
  }

  void hideLoadingIndicator() {
    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveSkill() async {
    if (selectedSkill != null && selectedLevel != null) {
      showLoadingIndicator();
      final response = await SkillAPI.createSkill(selectedSkill!, selectedLevel!);
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Update Skill',
                      style: TextStyle(color: TextColor, fontSize: 18.0),
                    ),
                    SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Skill',
                        labelStyle: TextStyle(color: HintColor),
                        filled: true,
                        fillColor: BackgroundColor,
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
                          style: ElevatedButton.styleFrom(backgroundColor: TextColor),
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
      InputComponent.showWarningSnackBar(context, response['message'] ?? 'Failed to delete skill');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.screenAppbar("Campus", context),
      backgroundColor: BackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Skill',
                      labelStyle: TextStyle(color: HintColor),
                      filled: true,
                      fillColor: CardColor,
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
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: saveSkill,
                    child: Text('Submit', style: TextStyle(color: BackgroundColor)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TextColor,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: savedSkills.length,
                    itemBuilder: (context, index) {
                      final skill = savedSkills[index];
                      return Card(
                        color: CardColor,
                        child: ListTile(
                          title: Text(skill['Skill'], style: TextStyle(color: TextColor)),
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
