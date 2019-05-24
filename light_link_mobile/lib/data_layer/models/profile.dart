import 'package:flutter/material.dart';

class Profile {
  String name;
  Map<String, dynamic> configurations;
  Profile() : this.init("", new Map());
  Profile.init(this.name, this.configurations);
  Profile.fromJSON(Map<String, dynamic> json)
      : name = json["name"] as String,
        configurations = json["configurations"] as Map<String, dynamic>;
  Map<String, dynamic> toJson() =>
      {'name': name, 'configurations': configurations};

  Color getColor() {
    if (configurations.values.length > 0)
      return createColorMap(configurations.values.first);
    else
      return Colors.black;
  }

  Color createColorMap(String first) {
    return Color(int.tryParse(first, radix: 16));
  }
}
