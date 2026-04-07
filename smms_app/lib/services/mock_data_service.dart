import 'dart:math';
import '../models/models.dart';

class MockDataService {
  static final _random = Random(42);

  // ─── Current User ───
  static const currentUser = UserModel(
    id: 'STU001',
    name: 'Varun Kumar',
    rollNo: '21BCS4590',
    email: 'varun.k@university.edu',
    role: 'student',
    dietPreferences: ['Vegetarian'],
    allergies: ['Peanuts'],
    rewardPoints: 340,
    totalMeals: 156,
    wasteSavedKg: 12.5,
    rebateBalance: 250.0,
  );

  static const adminUser = UserModel(
    id: 'ADM001',
    name: 'Dr. Sharma',
    rollNo: 'ADMIN',
    email: 'admin@university.edu',
    role: 'admin',
    rewardPoints: 0,
    totalMeals: 0,
    wasteSavedKg: 0,
    rebateBalance: 0,
  );

  // ─── Crowd Data ───
  static double get currentOccupancy => 45 + _random.nextDouble() * 40;
  static int get liveHeadcount => 120 + _random.nextInt(200);
  static int get totalCapacity => 450;

  // ─── Weather ───
  static const currentWeather = WeatherData(
    temperature: 18.0,
    condition: 'cold',
    icon: '🌧️',
    suggestion: 'Cold weather detected! Consider adding hot soups and chai to today\'s menu.',
  );

  // ─── Today's Menu ───
  static List<MealModel> get todaysMeals => [
    MealModel(
      id: 'M001',
      date: DateTime.now(),
      mealType: 'Breakfast',
      items: const [
        MenuItemModel(id: 'I001', name: 'Aloo Paratha', category: 'breakfast', calories: 320, proteinG: 8, carbsG: 42, fatG: 14, imageEmoji: '🫓', averageRating: 4.2, totalRatings: 89),
        MenuItemModel(id: 'I002', name: 'Curd', category: 'breakfast', calories: 80, proteinG: 5, carbsG: 6, fatG: 3, imageEmoji: '🥛', averageRating: 3.8, totalRatings: 65),
        MenuItemModel(id: 'I003', name: 'Chai', category: 'breakfast', calories: 90, proteinG: 2, carbsG: 12, fatG: 3, imageEmoji: '☕', averageRating: 4.5, totalRatings: 120),
        MenuItemModel(id: 'I004', name: 'Fruit Bowl', category: 'breakfast', calories: 110, proteinG: 1, carbsG: 28, fatG: 0, imageEmoji: '🍎', averageRating: 4.0, totalRatings: 45),
      ],
    ),
    MealModel(
      id: 'M002',
      date: DateTime.now(),
      mealType: 'Lunch',
      items: const [
        MenuItemModel(id: 'I005', name: 'Paneer Butter Masala', category: 'lunch', calories: 380, proteinG: 18, carbsG: 20, fatG: 24, allergens: ['Dairy'], imageEmoji: '🧀', averageRating: 4.6, totalRatings: 210),
        MenuItemModel(id: 'I006', name: 'Dal Tadka', category: 'lunch', calories: 220, proteinG: 12, carbsG: 30, fatG: 8, imageEmoji: '🍲', averageRating: 3.5, totalRatings: 180),
        MenuItemModel(id: 'I007', name: 'Jeera Rice', category: 'lunch', calories: 280, proteinG: 5, carbsG: 52, fatG: 6, imageEmoji: '🍚', averageRating: 3.9, totalRatings: 150),
        MenuItemModel(id: 'I008', name: 'Roti', category: 'lunch', calories: 120, proteinG: 3, carbsG: 22, fatG: 2, imageEmoji: '🫓', averageRating: 4.1, totalRatings: 200),
        MenuItemModel(id: 'I009', name: 'Mixed Raita', category: 'lunch', calories: 90, proteinG: 4, carbsG: 8, fatG: 4, allergens: ['Dairy'], imageEmoji: '🥗', averageRating: 3.7, totalRatings: 95),
      ],
    ),
    MealModel(
      id: 'M003',
      date: DateTime.now(),
      mealType: 'Snacks',
      items: const [
        MenuItemModel(id: 'I010', name: 'Samosa', category: 'snacks', calories: 260, proteinG: 5, carbsG: 32, fatG: 12, imageEmoji: '🥟', averageRating: 4.4, totalRatings: 175),
        MenuItemModel(id: 'I011', name: 'Masala Tea', category: 'snacks', calories: 95, proteinG: 2, carbsG: 14, fatG: 3, imageEmoji: '🍵', averageRating: 4.3, totalRatings: 190),
      ],
    ),
    MealModel(
      id: 'M004',
      date: DateTime.now(),
      mealType: 'Dinner',
      items: const [
        MenuItemModel(id: 'I012', name: 'Chole Bhature', category: 'dinner', calories: 450, proteinG: 14, carbsG: 55, fatG: 18, imageEmoji: '🍛', averageRating: 4.7, totalRatings: 230),
        MenuItemModel(id: 'I013', name: 'Green Salad', category: 'dinner', calories: 60, proteinG: 2, carbsG: 10, fatG: 1, imageEmoji: '🥗', averageRating: 3.2, totalRatings: 70),
        MenuItemModel(id: 'I014', name: 'Gulab Jamun', category: 'dinner', calories: 180, proteinG: 3, carbsG: 30, fatG: 6, allergens: ['Dairy'], imageEmoji: '🍩', averageRating: 4.8, totalRatings: 250),
        MenuItemModel(id: 'I015', name: 'Chapati', category: 'dinner', calories: 110, proteinG: 3, carbsG: 20, fatG: 2, imageEmoji: '🫓', averageRating: 4.0, totalRatings: 160),
      ],
    ),
  ];

  // ─── Notifications ───
  static List<NotificationModel> get notifications => [
    NotificationModel(id: 'N001', title: '🍛 Special Dinner Tonight!', body: 'Chole Bhature with Gulab Jamun served tonight. Don\'t miss it!', type: 'menu', timestamp: DateTime.now().subtract(const Duration(minutes: 30))),
    NotificationModel(id: 'N002', title: '⚠️ High Crowd Alert', body: 'Mess is at 85% capacity. Consider visiting after 1:45 PM.', type: 'crowd', timestamp: DateTime.now().subtract(const Duration(hours: 1))),
    NotificationModel(id: 'N003', title: '🎉 Reward Earned!', body: 'You earned 50 points for reviewing 5 meals this week!', type: 'reward', timestamp: DateTime.now().subtract(const Duration(hours: 3))),
    NotificationModel(id: 'N004', title: '🌧️ Weather Advisory', body: 'Cold weather ahead. Hot soup added to tomorrow\'s lunch menu.', type: 'system', timestamp: DateTime.now().subtract(const Duration(hours: 5))),
    NotificationModel(id: 'N005', title: '🎯 Happy Hour!', body: 'Visit mess between 2:00-2:30 PM for bonus reward points!', type: 'reward', timestamp: DateTime.now().subtract(const Duration(hours: 8))),
  ];

  // ─── Inventory ───
  static const List<InventoryModel> inventory = [
    InventoryModel(id: 'INV001', ingredient: 'Rice', currentStockKg: 120, requiredKg: 80, status: 'sufficient'),
    InventoryModel(id: 'INV002', ingredient: 'Wheat Flour', currentStockKg: 45, requiredKg: 60, status: 'low'),
    InventoryModel(id: 'INV003', ingredient: 'Paneer', currentStockKg: 8, requiredKg: 25, unit: 'kg', status: 'critical'),
    InventoryModel(id: 'INV004', ingredient: 'Cooking Oil', currentStockKg: 30, requiredKg: 20, unit: 'L', status: 'sufficient'),
    InventoryModel(id: 'INV005', ingredient: 'Onions', currentStockKg: 50, requiredKg: 40, status: 'sufficient'),
    InventoryModel(id: 'INV006', ingredient: 'Tomatoes', currentStockKg: 15, requiredKg: 35, status: 'critical'),
    InventoryModel(id: 'INV007', ingredient: 'Potatoes', currentStockKg: 60, requiredKg: 45, status: 'sufficient'),
    InventoryModel(id: 'INV008', ingredient: 'Sugar', currentStockKg: 20, requiredKg: 15, status: 'sufficient'),
    InventoryModel(id: 'INV009', ingredient: 'Milk', currentStockKg: 25, requiredKg: 40, unit: 'L', status: 'low'),
    InventoryModel(id: 'INV010', ingredient: 'Chickpeas', currentStockKg: 18, requiredKg: 15, status: 'sufficient'),
  ];

  // ─── AB Tests ───
  static List<ABTestModel> get abTests => [
    ABTestModel(
      id: 'AB001',
      dishA: const MenuItemModel(id: 'AB_A1', name: 'Veg Biryani', category: 'lunch', calories: 350, proteinG: 10, carbsG: 55, fatG: 10, imageEmoji: '🍛'),
      dishB: const MenuItemModel(id: 'AB_B1', name: 'Pulao', category: 'lunch', calories: 300, proteinG: 8, carbsG: 50, fatG: 8, imageEmoji: '🍚'),
      votesA: 142,
      votesB: 98,
      deadline: DateTime.now().add(const Duration(days: 2)),
      mealType: 'Lunch',
    ),
    ABTestModel(
      id: 'AB002',
      dishA: const MenuItemModel(id: 'AB_A2', name: 'Masala Dosa', category: 'breakfast', calories: 280, proteinG: 6, carbsG: 38, fatG: 12, imageEmoji: '🥞'),
      dishB: const MenuItemModel(id: 'AB_B2', name: 'Poha', category: 'breakfast', calories: 200, proteinG: 5, carbsG: 35, fatG: 5, imageEmoji: '🥣'),
      votesA: 87,
      votesB: 113,
      deadline: DateTime.now().add(const Duration(days: 3)),
      mealType: 'Breakfast',
    ),
  ];

  // ─── Attendance Records (Admin) ───
  static List<AttendanceModel> get recentScans => [
    AttendanceModel(id: 'A001', userId: 'STU001', userName: 'Varun Kumar', rollNo: '21BCS4590', mealType: 'Lunch', scanTime: DateTime.now().subtract(const Duration(minutes: 5)), isValid: true),
    AttendanceModel(id: 'A002', userId: 'STU002', userName: 'Priya Singh', rollNo: '21BCS4230', mealType: 'Lunch', scanTime: DateTime.now().subtract(const Duration(minutes: 8)), isValid: true),
    AttendanceModel(id: 'A003', userId: 'STU003', userName: 'Rahul Verma', rollNo: '21BCS4120', mealType: 'Lunch', scanTime: DateTime.now().subtract(const Duration(minutes: 12)), isValid: false),
    AttendanceModel(id: 'A004', userId: 'STU004', userName: 'Ananya Patel', rollNo: '21BCS4780', mealType: 'Lunch', scanTime: DateTime.now().subtract(const Duration(minutes: 15)), isValid: true),
    AttendanceModel(id: 'A005', userId: 'STU005', userName: 'Arjun Reddy', rollNo: '21BCS4340', mealType: 'Lunch', scanTime: DateTime.now().subtract(const Duration(minutes: 20)), isValid: true),
  ];

  // ─── Hourly Footfall Data ───
  static List<Map<String, dynamic>> get hourlyFootfall => [
    {'hour': '7 AM', 'count': 45},
    {'hour': '8 AM', 'count': 120},
    {'hour': '9 AM', 'count': 80},
    {'hour': '12 PM', 'count': 280},
    {'hour': '1 PM', 'count': 350},
    {'hour': '2 PM', 'count': 180},
    {'hour': '4 PM', 'count': 90},
    {'hour': '5 PM', 'count': 65},
    {'hour': '7 PM', 'count': 310},
    {'hour': '8 PM', 'count': 240},
    {'hour': '9 PM', 'count': 110},
  ];

  // ─── Weekly Waste Data ───
  static const List<Map<String, dynamic>> weeklyWaste = [
    {'day': 'Mon', 'wasteKg': 35, 'savedKg': 15},
    {'day': 'Tue', 'wasteKg': 28, 'savedKg': 22},
    {'day': 'Wed', 'wasteKg': 42, 'savedKg': 8},
    {'day': 'Thu', 'wasteKg': 20, 'savedKg': 30},
    {'day': 'Fri', 'wasteKg': 55, 'savedKg': 5},
    {'day': 'Sat', 'wasteKg': 18, 'savedKg': 32},
    {'day': 'Sun', 'wasteKg': 25, 'savedKg': 25},
  ];

  // ─── Simulation Data ───
  static Map<String, dynamic> simulateWeek(double modifier) {
    final baseMeals = 2800;
    final baseCost = 42000.0;
    final baseWaste = 220.0;
    return {
      'totalMeals': (baseMeals * modifier).round(),
      'estimatedCost': (baseCost * modifier).round(),
      'predictedWaste': (baseWaste * (2.0 - modifier)).round(),
      'savings': ((baseWaste - baseWaste * (2.0 - modifier)) * 15).round(),
      'notEatingToggles': (142 * modifier).round(),
    };
  }

  // ─── Recipe Bank (for Kanban) ───
  static const List<MenuItemModel> recipeBank = [
    MenuItemModel(id: 'R001', name: 'Idli Sambhar', category: 'breakfast', calories: 240, proteinG: 8, carbsG: 40, fatG: 4, imageEmoji: '🥘'),
    MenuItemModel(id: 'R002', name: 'Upma', category: 'breakfast', calories: 200, proteinG: 5, carbsG: 32, fatG: 6, imageEmoji: '🍲'),
    MenuItemModel(id: 'R003', name: 'Rajma Chawal', category: 'lunch', calories: 380, proteinG: 15, carbsG: 58, fatG: 8, imageEmoji: '🫘'),
    MenuItemModel(id: 'R004', name: 'Kadhi Pakora', category: 'lunch', calories: 300, proteinG: 10, carbsG: 28, fatG: 16, allergens: ['Dairy'], imageEmoji: '🍛'),
    MenuItemModel(id: 'R005', name: 'Aloo Gobi', category: 'dinner', calories: 200, proteinG: 5, carbsG: 25, fatG: 8, imageEmoji: '🥔'),
    MenuItemModel(id: 'R006', name: 'Mushroom Masala', category: 'dinner', calories: 180, proteinG: 8, carbsG: 15, fatG: 10, imageEmoji: '🍄'),
    MenuItemModel(id: 'R007', name: 'Veg Fried Rice', category: 'dinner', calories: 310, proteinG: 7, carbsG: 48, fatG: 10, imageEmoji: '🍚'),
    MenuItemModel(id: 'R008', name: 'Tomato Soup', category: 'snacks', calories: 120, proteinG: 3, carbsG: 15, fatG: 5, imageEmoji: '🥣'),
    MenuItemModel(id: 'R009', name: 'Bread Pakora', category: 'snacks', calories: 280, proteinG: 6, carbsG: 30, fatG: 14, imageEmoji: '🍞'),
    MenuItemModel(id: 'R010', name: 'Kheer', category: 'dinner', calories: 250, proteinG: 6, carbsG: 40, fatG: 8, allergens: ['Dairy'], imageEmoji: '🍮'),
  ];

  // ─── Academic Calendar Events ───
  static List<Map<String, dynamic>> get academicEvents => [
    {'date': DateTime.now().add(const Duration(days: 2)), 'event': 'Mid-Semester Exams Begin', 'modifier': 0.75, 'icon': '📝'},
    {'date': DateTime.now().add(const Duration(days: 7)), 'event': 'Cultural Fest', 'modifier': 1.3, 'icon': '🎭'},
    {'date': DateTime.now().add(const Duration(days: 14)), 'event': 'Holi Break', 'modifier': 0.3, 'icon': '🎨'},
    {'date': DateTime.now().add(const Duration(days: 21)), 'event': 'Regular Classes Resume', 'modifier': 1.0, 'icon': '📚'},
  ];

  // ─── Heatmap Zones ───
  static const List<Map<String, dynamic>> heatmapZones = [
    {'zone': 'Main Entrance', 'congestion': 0.9, 'x': 0.5, 'y': 0.95},
    {'zone': 'Counter A', 'congestion': 0.85, 'x': 0.2, 'y': 0.5},
    {'zone': 'Counter B', 'congestion': 0.6, 'x': 0.5, 'y': 0.5},
    {'zone': 'Counter C', 'congestion': 0.3, 'x': 0.8, 'y': 0.5},
    {'zone': 'Salad Bar', 'congestion': 0.95, 'x': 0.15, 'y': 0.25},
    {'zone': 'Beverage Station', 'congestion': 0.7, 'x': 0.85, 'y': 0.25},
    {'zone': 'Seating Area 1', 'congestion': 0.5, 'x': 0.3, 'y': 0.15},
    {'zone': 'Seating Area 2', 'congestion': 0.4, 'x': 0.7, 'y': 0.15},
    {'zone': 'Wash Area', 'congestion': 0.65, 'x': 0.5, 'y': 0.05},
  ];

  // ─── Surge/Happy Hour Data ───
  static const List<Map<String, dynamic>> surgeSlots = [
    {'time': '12:00 - 12:30', 'predicted': 'Very High', 'color': 'red', 'incentive': null},
    {'time': '12:30 - 1:00', 'predicted': 'High', 'color': 'orange', 'incentive': null},
    {'time': '1:00 - 1:30', 'predicted': 'Peak', 'color': 'red', 'incentive': null},
    {'time': '1:30 - 2:00', 'predicted': 'Medium', 'color': 'yellow', 'incentive': '+5 Points'},
    {'time': '2:00 - 2:30', 'predicted': 'Low', 'color': 'green', 'incentive': '+15 Points! 🎉'},
    {'time': '2:30 - 3:00', 'predicted': 'Very Low', 'color': 'green', 'incentive': '+10 Points'},
  ];

  // ─── Kitchen Display Data ───
  static List<Map<String, dynamic>> get kitchenDisplayItems => [
    {'item': 'Roti', 'remaining': 45, 'refillIn': 8, 'status': 'serving', 'emoji': '🫓'},
    {'item': 'Rice', 'remaining': 120, 'refillIn': 25, 'status': 'serving', 'emoji': '🍚'},
    {'item': 'Paneer Masala', 'remaining': 12, 'refillIn': 3, 'status': 'urgent', 'emoji': '🧀'},
    {'item': 'Dal Tadka', 'remaining': 80, 'refillIn': 18, 'status': 'serving', 'emoji': '🍲'},
    {'item': 'Salad', 'remaining': 30, 'refillIn': 10, 'status': 'serving', 'emoji': '🥗'},
    {'item': 'Curd', 'remaining': 5, 'refillIn': 1, 'status': 'critical', 'emoji': '🥛'},
  ];

  // ─── Ingredient Fatigue Data ───
  static const List<Map<String, dynamic>> ingredientFatigue = [
    {'ingredient': 'Paneer', 'usedInDays': 5, 'outOf': 7, 'suggestion': 'Switch to Mushroom or Soya Chunks'},
    {'ingredient': 'Potato', 'usedInDays': 4, 'outOf': 7, 'suggestion': 'Consider Sweet Potato or Cauliflower'},
    {'ingredient': 'Rice', 'usedInDays': 7, 'outOf': 7, 'suggestion': 'Rotate with Quinoa or Millet'},
  ];

  // ─── Leftover Routing ───
  static const List<Map<String, dynamic>> leftoverData = [
    {'item': 'Rice', 'surplusKg': 20, 'suggestion': 'Convert to Lemon Rice for dinner', 'ngoOption': true},
    {'item': 'Dal', 'surplusKg': 8, 'suggestion': 'Convert to Dal Paratha for breakfast', 'ngoOption': false},
    {'item': 'Chapati', 'surplusKg': 5, 'suggestion': 'Distribute via local shelter partner', 'ngoOption': true},
  ];

  // weekly menu for menu management
  static Map<String, List<MenuItemModel>> get weeklyMenu => {
    'Monday': const [
      MenuItemModel(id: 'W01', name: 'Poha', category: 'breakfast', imageEmoji: '🥣'),
      MenuItemModel(id: 'W02', name: 'Rajma Chawal', category: 'lunch', imageEmoji: '🫘'),
      MenuItemModel(id: 'W03', name: 'Samosa', category: 'snacks', imageEmoji: '🥟'),
      MenuItemModel(id: 'W04', name: 'Aloo Gobi + Roti', category: 'dinner', imageEmoji: '🥔'),
    ],
    'Tuesday': const [
      MenuItemModel(id: 'W05', name: 'Idli Sambhar', category: 'breakfast', imageEmoji: '🥘'),
      MenuItemModel(id: 'W06', name: 'Paneer + Rice', category: 'lunch', imageEmoji: '🧀'),
      MenuItemModel(id: 'W07', name: 'Tea + Biscuit', category: 'snacks', imageEmoji: '🍵'),
      MenuItemModel(id: 'W08', name: 'Chole Bhature', category: 'dinner', imageEmoji: '🍛'),
    ],
    'Wednesday': const [
      MenuItemModel(id: 'W09', name: 'Aloo Paratha', category: 'breakfast', imageEmoji: '🫓'),
      MenuItemModel(id: 'W10', name: 'Dal + Rice', category: 'lunch', imageEmoji: '🍲'),
      MenuItemModel(id: 'W11', name: 'Bread Pakora', category: 'snacks', imageEmoji: '🍞'),
      MenuItemModel(id: 'W12', name: 'Mushroom + Roti', category: 'dinner', imageEmoji: '🍄'),
    ],
    'Thursday': const [
      MenuItemModel(id: 'W13', name: 'Upma', category: 'breakfast', imageEmoji: '🍲'),
      MenuItemModel(id: 'W14', name: 'Kadhi Pakora', category: 'lunch', imageEmoji: '🍛'),
      MenuItemModel(id: 'W15', name: 'Samosa', category: 'snacks', imageEmoji: '🥟'),
      MenuItemModel(id: 'W16', name: 'Veg Biryani', category: 'dinner', imageEmoji: '🍛'),
    ],
    'Friday': const [
      MenuItemModel(id: 'W17', name: 'Masala Dosa', category: 'breakfast', imageEmoji: '🥞'),
      MenuItemModel(id: 'W18', name: 'Mix Veg + Roti', category: 'lunch', imageEmoji: '🥗'),
      MenuItemModel(id: 'W19', name: 'Sandwich', category: 'snacks', imageEmoji: '🥪'),
      MenuItemModel(id: 'W20', name: 'Dal Makhani + Naan', category: 'dinner', imageEmoji: '🫘'),
    ],
  };
}
