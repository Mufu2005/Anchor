// import 'package:flutter/material.dart';

class Task {
  final String id;
  final String userId;
  final String title;
  final String description;
  bool isCompleted;
  final String priority;
  final DateTime? time_stamp; 
     // "High", "Medium", or "Low"
 

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.time_stamp,
    required this.priority, 
    this.isCompleted = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'].toString(),
      userId: json['user_id']?.toString() ?? '', 
      title: json['title'] ?? 'Untitled',
      description: json['description'] ?? 'No Description',
      time_stamp: json['time_stamp'] != null
          ? DateTime.tryParse(json['time_stamp'].toString())
          : null,

      priority: json['priority'] ?? 'Medium',
      
      // Parse Booleans (Handle 1/0 from SQL or true/false from JSON)
      isCompleted: json['is_completed'] == 1 || json['is_completed'] == true,
      
    );
  }
}