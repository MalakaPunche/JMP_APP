class SkillVisualization {
  final List<SkillCategory> categories;
  final List<SkillTrend> trends;
  final List<SkillCombination> combinations;

  SkillVisualization({
    required this.categories,
    required this.trends,
    required this.combinations,
  });

  factory SkillVisualization.fromJson(Map<String, dynamic> json) {
    return SkillVisualization(
      categories: (json['categories'] as List)
          .map((e) => SkillCategory.fromJson(e))
          .toList(),
      trends: (json['trends'] as List)
          .map((e) => SkillTrend.fromJson(e))
          .toList(),
      combinations: (json['combinations'] as List)
          .map((e) => SkillCombination.fromJson(e))
          .toList(),
    );
  }
}

class SkillCategory {
  final String name;
  final int count;

  SkillCategory({required this.name, required this.count});

  factory SkillCategory.fromJson(Map<String, dynamic> json) {
    return SkillCategory(
      name: json['name'] as String,
      count: json['count'] as int,
    );
  }
}

class SkillTrend {
  final String month;
  final Map<String, double> skillPercentages;

  SkillTrend({required this.month, required this.skillPercentages});

  factory SkillTrend.fromJson(Map<String, dynamic> json) {
    return SkillTrend(
      month: json['month'] as String,
      skillPercentages: Map<String, double>.from(json['skillPercentages']),
    );
  }
}

class SkillCombination {
  final String combination;
  final int count;

  SkillCombination({required this.combination, required this.count});

  factory SkillCombination.fromJson(Map<String, dynamic> json) {
    return SkillCombination(
      combination: json['combination'] as String,
      count: json['count'] as int,
    );
  }
} 