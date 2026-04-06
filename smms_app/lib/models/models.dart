class UserModel {
  final String id;
  final String name;
  final String rollNo;
  final String email;
  final String photoUrl;
  final String role; // 'student' or 'admin'
  final List<String> dietPreferences;
  final List<String> allergies;
  final int rewardPoints;
  final int totalMeals;
  final double wasteSavedKg;
  final double rebateBalance;

  const UserModel({
    required this.id,
    required this.name,
    required this.rollNo,
    required this.email,
    this.photoUrl = '',
    this.role = 'student',
    this.dietPreferences = const ['Vegetarian'],
    this.allergies = const [],
    this.rewardPoints = 0,
    this.totalMeals = 0,
    this.wasteSavedKg = 0,
    this.rebateBalance = 0,
  });
}

class MenuItemModel {
  final String id;
  final String name;
  final String category; // 'breakfast', 'lunch', 'snacks', 'dinner'
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final List<String> allergens;
  final String imageEmoji;
  final double averageRating;
  final int totalRatings;

  const MenuItemModel({
    required this.id,
    required this.name,
    required this.category,
    this.calories = 0,
    this.proteinG = 0,
    this.carbsG = 0,
    this.fatG = 0,
    this.allergens = const [],
    this.imageEmoji = '🍽️',
    this.averageRating = 0,
    this.totalRatings = 0,
  });
}

class MealModel {
  final String id;
  final DateTime date;
  final String mealType; // 'Breakfast', 'Lunch', 'Snacks', 'Dinner'
  final List<MenuItemModel> items;
  final bool isActive;

  const MealModel({
    required this.id,
    required this.date,
    required this.mealType,
    required this.items,
    this.isActive = true,
  });
}

class FeedbackModel {
  final String id;
  final String userId;
  final String itemId;
  final String itemName;
  final int rating;
  final String comment;
  final DateTime timestamp;

  const FeedbackModel({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.itemName,
    required this.rating,
    this.comment = '',
    required this.timestamp,
  });
}

class InventoryModel {
  final String id;
  final String ingredient;
  final double currentStockKg;
  final double requiredKg;
  final String unit;
  final String status; // 'sufficient', 'low', 'critical'

  const InventoryModel({
    required this.id,
    required this.ingredient,
    required this.currentStockKg,
    required this.requiredKg,
    this.unit = 'kg',
    required this.status,
  });
}

class AttendanceModel {
  final String id;
  final String userId;
  final String userName;
  final String rollNo;
  final String mealType;
  final DateTime scanTime;
  final bool isValid;
  final String status;

  const AttendanceModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.rollNo,
    required this.mealType,
    required this.scanTime,
    this.isValid = true,
    this.status = 'valid',
  });
}

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type; // 'menu', 'crowd', 'reward', 'system'
  final DateTime timestamp;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });
}

class LeaveModel {
  final String id;
  final String userId;
  final DateTime date;
  final String mealType;
  final String reason;

  const LeaveModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.mealType,
    this.reason = '',
  });
}

class ABTestModel {
  final String id;
  final MenuItemModel dishA;
  final MenuItemModel dishB;
  final int votesA;
  final int votesB;
  final DateTime deadline;
  final String mealType;

  const ABTestModel({
    required this.id,
    required this.dishA,
    required this.dishB,
    this.votesA = 0,
    this.votesB = 0,
    required this.deadline,
    required this.mealType,
  });
}

class WeatherData {
  final double temperature;
  final String condition; // 'sunny', 'cloudy', 'rainy', 'cold'
  final String icon;
  final String suggestion;

  const WeatherData({
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.suggestion,
  });
}
