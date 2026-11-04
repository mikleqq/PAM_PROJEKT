// lib/data/models.dart
// Domain Models for Home Services App with JSON Serialization (L5)

class ServiceCategory {
  final String id;
  final String name;
  final String iconName;
  final int masterCount;
  final double startingPrice;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.iconName,
    required this.masterCount,
    required this.startingPrice,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> j) => ServiceCategory(
        id: j['id'] as String? ?? '',
        name: j['name'] as String? ?? '',
        iconName: j['iconName'] as String? ?? '',
        masterCount: j['masterCount'] as int? ?? 0,
        startingPrice: (j['startingPrice'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'iconName': iconName,
        'masterCount': masterCount,
        'startingPrice': startingPrice,
      };
}

class Master {
  final String id;
  final String name;
  final String specialty;
  final String categoryId;
  final double rating;
  final int reviewsCount;
  final double hourlyRate; // in MDL
  final int experienceYears;
  final String bio;
  final String phone;
  final bool isAvailable;
  final bool isVerified;
  final List<String> skills;
  final bool isFavorite;

  const Master({
    required this.id,
    required this.name,
    required this.specialty,
    required this.categoryId,
    required this.rating,
    required this.reviewsCount,
    required this.hourlyRate,
    required this.experienceYears,
    required this.bio,
    required this.phone,
    required this.isAvailable,
    required this.isVerified,
    required this.skills,
    this.isFavorite = false,
  });

  factory Master.fromJson(Map<String, dynamic> j) => Master(
        id: j['id'] as String? ?? '',
        name: j['name'] as String? ?? '',
        specialty: j['specialty'] as String? ?? '',
        categoryId: j['categoryId'] as String? ?? '',
        rating: (j['rating'] as num?)?.toDouble() ?? 0.0,
        reviewsCount: j['reviewsCount'] as int? ?? 0,
        hourlyRate: (j['hourlyRate'] as num?)?.toDouble() ?? 0.0,
        experienceYears: j['experienceYears'] as int? ?? 0,
        bio: j['bio'] as String? ?? '',
        phone: j['phone'] as String? ?? '',
        isAvailable: j['isAvailable'] as bool? ?? true,
        isVerified: j['isVerified'] as bool? ?? false,
        skills: (j['skills'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        isFavorite: j['isFavorite'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'specialty': specialty,
        'categoryId': categoryId,
        'rating': rating,
        'reviewsCount': reviewsCount,
        'hourlyRate': hourlyRate,
        'experienceYears': experienceYears,
        'bio': bio,
        'phone': phone,
        'isAvailable': isAvailable,
        'isVerified': isVerified,
        'skills': skills,
        'isFavorite': isFavorite,
      };

  Master copyWith({
    String? id,
    String? name,
    String? specialty,
    String? categoryId,
    double? rating,
    int? reviewsCount,
    double? hourlyRate,
    int? experienceYears,
    String? bio,
    String? phone,
    bool? isAvailable,
    bool? isVerified,
    List<String>? skills,
    bool? isFavorite,
  }) {
    return Master(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      categoryId: categoryId ?? this.categoryId,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      experienceYears: experienceYears ?? this.experienceYears,
      bio: bio ?? this.bio,
      phone: phone ?? this.phone,
      isAvailable: isAvailable ?? this.isAvailable,
      isVerified: isVerified ?? this.isVerified,
      skills: skills ?? this.skills,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class ServiceOrder {
  final String id;
  final String serviceName;
  final String description;
  final String masterName;
  final String masterSpecialty;
  final String masterPhone;
  final String date;
  final String time;
  final String address;
  final double price; // in MDL
  final String status; // "Завершён", "В процессе", "Ожидает", "Отменён"
  final String paymentMethod;

  const ServiceOrder({
    required this.id,
    required this.serviceName,
    required this.description,
    required this.masterName,
    required this.masterSpecialty,
    required this.masterPhone,
    required this.date,
    required this.time,
    required this.address,
    required this.price,
    required this.status,
    required this.paymentMethod,
  });

  factory ServiceOrder.fromJson(Map<String, dynamic> j) => ServiceOrder(
        id: j['id'] as String? ?? '',
        serviceName: j['serviceName'] as String? ?? '',
        description: j['description'] as String? ?? '',
        masterName: j['masterName'] as String? ?? '',
        masterSpecialty: j['masterSpecialty'] as String? ?? '',
        masterPhone: j['masterPhone'] as String? ?? '',
        date: j['date'] as String? ?? '',
        time: j['time'] as String? ?? '',
        address: j['address'] as String? ?? '',
        price: (j['price'] as num?)?.toDouble() ?? 0.0,
        status: j['status'] as String? ?? 'Ожидает',
        paymentMethod: j['paymentMethod'] as String? ?? 'Наличными',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'serviceName': serviceName,
        'description': description,
        'masterName': masterName,
        'masterSpecialty': masterSpecialty,
        'masterPhone': masterPhone,
        'date': date,
        'time': time,
        'address': address,
        'price': price,
        'status': status,
        'paymentMethod': paymentMethod,
      };

  ServiceOrder copyWith({
    String? id,
    String? serviceName,
    String? description,
    String? masterName,
    String? masterSpecialty,
    String? masterPhone,
    String? date,
    String? time,
    String? address,
    double? price,
    String? status,
    String? paymentMethod,
  }) {
    return ServiceOrder(
      id: id ?? this.id,
      serviceName: serviceName ?? this.serviceName,
      description: description ?? this.description,
      masterName: masterName ?? this.masterName,
      masterSpecialty: masterSpecialty ?? this.masterSpecialty,
      masterPhone: masterPhone ?? this.masterPhone,
      date: date ?? this.date,
      time: time ?? this.time,
      address: address ?? this.address,
      price: price ?? this.price,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}

class Review {
  final String id;
  final String userName;
  final double rating;
  final String date;
  final String comment;

  const Review({
    required this.id,
    required this.userName,
    required this.rating,
    required this.date,
    required this.comment,
  });
}

const mockReviews = [
  Review(
    id: 'r1',
    userName: 'Елена П.',
    rating: 5.0,
    date: '10 Октября 2026',
    comment: 'Прекрасный мастер! Приехал точно в указанное время, всё сделал аккуратно и быстро. Рекомендую!',
  ),
  Review(
    id: 'r2',
    userName: 'Виктор Т.',
    rating: 5.0,
    date: '02 Октября 2026',
    comment: 'Качественная работа, помог с покупкой недостающих деталей. Цены адекватные.',
  ),
  Review(
    id: 'r3',
    userName: 'Ольга М.',
    rating: 4.5,
    date: '20 Сентября 2026',
    comment: 'Все отлично, немного затянулся процесс из-за сложных труб, но результат суппер!',
  ),
];
