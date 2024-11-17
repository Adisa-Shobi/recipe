class Recipe {
  final bool vegetarian;
  final bool vegan;
  final bool glutenFree;
  final bool dairyFree;
  final bool veryHealthy;
  final bool cheap;
  final bool veryPopular;
  final bool sustainable;
  final bool lowFodmap;
  final int weightWatcherSmartPoints;
  final String gaps;
  final int? preparationMinutes;
  final int? cookingMinutes;
  final int aggregateLikes;
  final int healthScore;
  final String creditsText;
  final String sourceName;
  final double pricePerServing;
  final List<Ingredient> extendedIngredients;
  final int id;
  final String title;
  final int readyInMinutes;
  final int servings;
  final String sourceUrl;
  final String image;
  final String imageType;
  final String summary;
  final List<String> cuisines;
  final List<String> dishTypes;
  final List<String> diets;
  final List<String> occasions;
  final String instructions;
  final List<RecipeStep> analyzedInstructions;
  final double spoonacularScore;
  final String spoonacularSourceUrl;

  Recipe({
    required this.vegetarian,
    required this.vegan,
    required this.glutenFree,
    required this.dairyFree,
    required this.veryHealthy,
    required this.cheap,
    required this.veryPopular,
    required this.sustainable,
    required this.lowFodmap,
    required this.weightWatcherSmartPoints,
    required this.gaps,
    this.preparationMinutes,
    this.cookingMinutes,
    required this.aggregateLikes,
    required this.healthScore,
    required this.creditsText,
    required this.sourceName,
    required this.pricePerServing,
    required this.extendedIngredients,
    required this.id,
    required this.title,
    required this.readyInMinutes,
    required this.servings,
    required this.sourceUrl,
    required this.image,
    required this.imageType,
    required this.summary,
    required this.cuisines,
    required this.dishTypes,
    required this.diets,
    required this.occasions,
    required this.instructions,
    required this.analyzedInstructions,
    required this.spoonacularScore,
    required this.spoonacularSourceUrl,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      vegetarian: json['vegetarian'] ?? false,
      vegan: json['vegan'] ?? false,
      glutenFree: json['glutenFree'] ?? false,
      dairyFree: json['dairyFree'] ?? false,
      veryHealthy: json['veryHealthy'] ?? false,
      cheap: json['cheap'] ?? false,
      veryPopular: json['veryPopular'] ?? false,
      sustainable: json['sustainable'] ?? false,
      lowFodmap: json['lowFodmap'] ?? false,
      weightWatcherSmartPoints: json['weightWatcherSmartPoints'] ?? 0,
      gaps: json['gaps'] ?? '',
      preparationMinutes: json['preparationMinutes'],
      cookingMinutes: json['cookingMinutes'],
      aggregateLikes: json['aggregateLikes'] ?? 0,
      healthScore: json['healthScore'] ?? 0,
      creditsText: json['creditsText'] ?? '',
      sourceName: json['sourceName'] ?? '',
      pricePerServing: (json['pricePerServing'] ?? 0).toDouble(),
      extendedIngredients: (json['extendedIngredients'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e))
          .toList(),
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      readyInMinutes: json['readyInMinutes'] ?? 0,
      servings: json['servings'] ?? 0,
      sourceUrl: json['sourceUrl'] ?? '',
      image: json['image'] ?? '',
      imageType: json['imageType'] ?? '',
      summary: json['summary'] ?? '',
      cuisines: List<String>.from(json['cuisines'] ?? []),
      dishTypes: List<String>.from(json['dishTypes'] ?? []),
      diets: List<String>.from(json['diets'] ?? []),
      occasions: List<String>.from(json['occasions'] ?? []),
      instructions: json['instructions'] ?? '',
      analyzedInstructions: (json['analyzedInstructions'] as List<dynamic>)
          .expand((instruction) => (instruction['steps'] as List<dynamic>)
              .map((step) => RecipeStep.fromJson(step)))
          .toList(),
      spoonacularScore: (json['spoonacularScore'] ?? 0).toDouble(),
      spoonacularSourceUrl: json['spoonacularSourceUrl'] ?? '',
    );
  }

  static Function(Map<String, dynamic>) getListParser<T>(String key) {
    return (Map<String, dynamic> json) =>
        List<Recipe>.from(json[key].map((e) => Recipe.fromJson(e)));
  }

  Map<String, dynamic> toJson() {
    return {
      'vegetarian': vegetarian,
      'vegan': vegan,
      'glutenFree': glutenFree,
      'dairyFree': dairyFree,
      'veryHealthy': veryHealthy,
      'cheap': cheap,
      'veryPopular': veryPopular,
      'sustainable': sustainable,
      'lowFodmap': lowFodmap,
      'weightWatcherSmartPoints': weightWatcherSmartPoints,
      'gaps': gaps,
      'preparationMinutes': preparationMinutes,
      'cookingMinutes': cookingMinutes,
      'aggregateLikes': aggregateLikes,
      'healthScore': healthScore,
      'creditsText': creditsText,
      'sourceName': sourceName,
      'pricePerServing': pricePerServing,
      'extendedIngredients':
          extendedIngredients.map((e) => e.toJson()).toList(),
      'id': id,
      'title': title,
      'readyInMinutes': readyInMinutes,
      'servings': servings,
      'sourceUrl': sourceUrl,
      'image': image,
      'imageType': imageType,
      'summary': summary,
      'cuisines': cuisines,
      'dishTypes': dishTypes,
      'diets': diets,
      'occasions': occasions,
      'instructions': instructions,
      'analyzedInstructions': [
        {'steps': analyzedInstructions.map((e) => e.toJson()).toList()}
      ],
      'spoonacularScore': spoonacularScore,
      'spoonacularSourceUrl': spoonacularSourceUrl,
    };
  }
}

class Ingredient {
  final int id;
  final String aisle;
  final String image;
  final String consistency;
  final String name;
  final String nameClean;
  final String original;
  final String originalName;
  final double amount;
  final String unit;
  final List<String> meta;
  final Measures measures;

  Ingredient({
    required this.id,
    required this.aisle,
    required this.image,
    required this.consistency,
    required this.name,
    required this.nameClean,
    required this.original,
    required this.originalName,
    required this.amount,
    required this.unit,
    required this.meta,
    required this.measures,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'] ?? 0,
      aisle: json['aisle'] ?? '',
      image: json['image'] ?? '',
      consistency: json['consistency'] ?? '',
      name: json['name'] ?? '',
      nameClean: json['nameClean'] ?? '',
      original: json['original'] ?? '',
      originalName: json['originalName'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      meta: List<String>.from(json['meta'] ?? []),
      measures: Measures.fromJson(json['measures'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aisle': aisle,
      'image': image,
      'consistency': consistency,
      'name': name,
      'nameClean': nameClean,
      'original': original,
      'originalName': originalName,
      'amount': amount,
      'unit': unit,
      'meta': meta,
      'measures': measures.toJson(),
    };
  }
}

class Measures {
  final Measure us;
  final Measure metric;

  Measures({
    required this.us,
    required this.metric,
  });

  factory Measures.fromJson(Map<String, dynamic> json) {
    return Measures(
      us: Measure.fromJson(json['us'] ?? {}),
      metric: Measure.fromJson(json['metric'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'us': us.toJson(),
      'metric': metric.toJson(),
    };
  }
}

class Measure {
  final double amount;
  final String unitShort;
  final String unitLong;

  Measure({
    required this.amount,
    required this.unitShort,
    required this.unitLong,
  });

  factory Measure.fromJson(Map<String, dynamic> json) {
    return Measure(
      amount: (json['amount'] ?? 0).toDouble(),
      unitShort: json['unitShort'] ?? '',
      unitLong: json['unitLong'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'unitShort': unitShort,
      'unitLong': unitLong,
    };
  }
}

class RecipeStep {
  final int number;
  final String step;
  final List<Ingredient> ingredients;
  final List<Equipment> equipment;
  final Length? length;

  RecipeStep({
    required this.number,
    required this.step,
    required this.ingredients,
    required this.equipment,
    this.length,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      number: json['number'] ?? 0,
      step: json['step'] ?? '',
      ingredients: (json['ingredients'] as List<dynamic>? ?? [])
          .map((e) => Ingredient.fromJson(e))
          .toList(),
      equipment: (json['equipment'] as List<dynamic>? ?? [])
          .map((e) => Equipment.fromJson(e))
          .toList(),
      length: json['length'] != null ? Length.fromJson(json['length']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'step': step,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'equipment': equipment.map((e) => e.toJson()).toList(),
      'length': length?.toJson(),
    };
  }
}

class Equipment {
  final int id;
  final String name;
  final String localizedName;
  final String image;

  Equipment({
    required this.id,
    required this.name,
    required this.localizedName,
    required this.image,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      localizedName: json['localizedName'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'localizedName': localizedName,
      'image': image,
    };
  }
}

class Length {
  final int number;
  final String unit;

  Length({
    required this.number,
    required this.unit,
  });

  factory Length.fromJson(Map<String, dynamic> json) {
    return Length(
      number: json['number'] ?? 0,
      unit: json['unit'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'unit': unit,
    };
  }
}
