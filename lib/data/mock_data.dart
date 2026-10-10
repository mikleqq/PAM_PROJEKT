// lib/data/mock_data.dart
// Domain Models and Mock Data for Home Services App

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
  });
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

// Mock Data
const mockCategories = [
  ServiceCategory(
    id: 'cat_plumbing',
    name: 'Сантехника',
    iconName: 'water_drop',
    masterCount: 14,
    startingPrice: 250,
  ),
  ServiceCategory(
    id: 'cat_electric',
    name: 'Электрика',
    iconName: 'bolt',
    masterCount: 18,
    startingPrice: 300,
  ),
  ServiceCategory(
    id: 'cat_cleaning',
    name: 'Уборка и клининг',
    iconName: 'cleaning_services',
    masterCount: 22,
    startingPrice: 200,
  ),
  ServiceCategory(
    id: 'cat_appliance',
    name: 'Бытовая техника',
    iconName: 'home_repair_service',
    masterCount: 11,
    startingPrice: 350,
  ),
  ServiceCategory(
    id: 'cat_furniture',
    name: 'Сборка мебели',
    iconName: 'chair',
    masterCount: 9,
    startingPrice: 220,
  ),
  ServiceCategory(
    id: 'cat_locks',
    name: 'Замки и двери',
    iconName: 'lock',
    masterCount: 8,
    startingPrice: 280,
  ),
  ServiceCategory(
    id: 'cat_repair',
    name: 'Косметический ремонт',
    iconName: 'format_paint',
    masterCount: 15,
    startingPrice: 400,
  ),
  ServiceCategory(
    id: 'cat_handyman',
    name: 'Мастер на час',
    iconName: 'build',
    masterCount: 25,
    startingPrice: 180,
  ),
];

const mockMasters = [
  Master(
    id: 'm1',
    name: 'Алексей Иванов',
    specialty: 'Сантехник высшей категории',
    categoryId: 'cat_plumbing',
    rating: 4.9,
    reviewsCount: 48,
    hourlyRate: 350,
    experienceYears: 8,
    bio: 'Опытный сантехник. Устранение протечек, монтаж труб, установка смесителей, унитазов и душкабин. Гарантия на работы 12 месяцев.',
    phone: '+373 69 123 456',
    isAvailable: true,
    isVerified: true,
    skills: ['Монтаж труб', 'Установка сантехники', 'Устранение засоров', 'Аварийный выезд'],
  ),
  Master(
    id: 'm2',
    name: 'Иван Петров',
    specialty: 'Электрик-монтажник',
    categoryId: 'cat_electric',
    rating: 4.8,
    reviewsCount: 36,
    hourlyRate: 380,
    experienceYears: 10,
    bio: 'Дипломированный электрик 4 группы допуска. Проводка под ключ, замена автоматов, установка розеток, люстр и электрощитов.',
    phone: '+373 68 234 567',
    isAvailable: true,
    isVerified: true,
    skills: ['Замена проводки', 'Монтаж щитков', 'Установка люстр', 'Диагностика коротких замыканий'],
  ),
  Master(
    id: 'm3',
    name: 'Сергей Смирнов',
    specialty: 'Универсальный мастер на час',
    categoryId: 'cat_handyman',
    rating: 4.7,
    reviewsCount: 52,
    hourlyRate: 250,
    experienceYears: 6,
    bio: 'Быстро и качественно выполню любые мелкие бытовые работы: навешивание карнизов, полок, телевизоров, мелкий ремонт мебели.',
    phone: '+373 79 345 678',
    isAvailable: false,
    isVerified: true,
    skills: ['Крепление к стенам', 'Мелкий ремонт', 'Замена замков', 'Навеска ТВ'],
  ),
  Master(
    id: 'm4',
    name: 'Мария Ковалева',
    specialty: 'Специалист по клинингу',
    categoryId: 'cat_cleaning',
    rating: 5.0,
    reviewsCount: 64,
    hourlyRate: 220,
    experienceYears: 5,
    bio: 'Генеральная уборка квартир и офисов, уборка после ремонта, мойка окон. Использую гипоаллергенную профессиональную химию.',
    phone: '+373 60 456 789',
    isAvailable: true,
    isVerified: true,
    skills: ['Генеральная уборка', 'Мойка окон', 'Уборка после ремонта', 'Химчистка диванов'],
  ),
  Master(
    id: 'm5',
    name: 'Павел Сидоров',
    specialty: 'Мастер по ремонту бытовой техники',
    categoryId: 'cat_appliance',
    rating: 4.8,
    reviewsCount: 29,
    hourlyRate: 400,
    experienceYears: 12,
    bio: 'Ремонт стиральных и посудомоечных машин, холодильников, духовки. Выезд на дом с оригинальными запчастями.',
    phone: '+373 68 567 890',
    isAvailable: true,
    isVerified: true,
    skills: ['Стиральные машины', 'Холодильники', 'Посудомойки', 'Замена ТЭНа'],
  ),
  Master(
    id: 'm6',
    name: 'Дмитрий Чеботарь',
    specialty: 'Мастер по сборке корпусной мебели',
    categoryId: 'cat_furniture',
    rating: 4.9,
    reviewsCount: 41,
    hourlyRate: 280,
    experienceYears: 7,
    bio: 'Сборка кухонь, шкафов-купе, кроватей любых брендов (IKEA, Jysk и др.). Собственный профессиональный инструмент.',
    phone: '+373 78 678 901',
    isAvailable: true,
    isVerified: true,
    skills: ['Сборка кухонь', 'Шкафы-купе', 'Врезка моек', 'Регулировка фасадов'],
  ),
  Master(
    id: 'm7',
    name: 'Михаил Федоров',
    specialty: 'Специалист по дверям и замкам',
    categoryId: 'cat_locks',
    rating: 4.6,
    reviewsCount: 22,
    hourlyRate: 320,
    experienceYears: 9,
    bio: 'Аварийное вскрытие без повреждений, замена личинок, установка дверных замков и доводчиков.',
    phone: '+373 69 789 012',
    isAvailable: false,
    isVerified: false,
    skills: ['Вскрытие замков', 'Замена личинок', 'Установка доводчиков', 'Ремонт дверей'],
  ),
  Master(
    id: 'm8',
    name: 'Евгений Лупу',
    specialty: 'Маляр-штукатур',
    categoryId: 'cat_repair',
    rating: 4.9,
    reviewsCount: 38,
    hourlyRate: 450,
    experienceYears: 11,
    bio: 'Шпатлевка стеновых поверхностей, покраска, поклейка обоев, монтаж гипсокартона. Чистота после проведения работ.',
    phone: '+373 60 890 123',
    isAvailable: true,
    isVerified: true,
    skills: ['Поклейка обоев', 'Покраска стен', 'Шпатлевка', 'Гипсокартон'],
  ),
];

const mockOrders = [
  ServiceOrder(
    id: 'ORD-2026-001',
    serviceName: 'Замена смесителя на кухне',
    description: 'Демонтаж старого смесителя, установка нового двухвентильного кухонного смесителя с подводом гибкой подводки и герметизацией.',
    masterName: 'Алексей Иванов',
    masterSpecialty: 'Сантехник',
    masterPhone: '+373 69 123 456',
    date: '12 Октября 2026',
    time: '14:00 - 15:30',
    address: 'г. Кишинев, ул. Штефан чел Маре 132, кв. 45',
    price: 450,
    status: 'Завершён',
    paymentMethod: 'Наличными',
  ),
  ServiceOrder(
    id: 'ORD-2026-002',
    serviceName: 'Установка 4 розеток и люстры',
    description: 'Штробление стены, подведение кабеля, установка 4 подрозетников и монтаж светодиодной люстры в гостиной.',
    masterName: 'Иван Петров',
    masterSpecialty: 'Электрик',
    masterPhone: '+373 68 234 567',
    date: '18 Октября 2026',
    time: '10:00 - 12:00',
    address: 'г. Кишинев, Московский проспект 8, кв. 12',
    price: 600,
    status: 'В процессе',
    paymentMethod: 'Картой мастеру',
  ),
  ServiceOrder(
    id: 'ORD-2026-003',
    serviceName: 'Генеральная уборка 2-комн. квартиры',
    description: 'Комплексная влажная уборка комнат, протирка всех поверхностей, обеспыливание стен, мойка санузла и кухни.',
    masterName: 'Мария Ковалева',
    masterSpecialty: 'Клининг',
    masterPhone: '+373 60 456 789',
    date: '22 Октября 2026',
    time: '09:00 - 14:00',
    address: 'г. Кишинев, ул. Дачия 24, кв. 89',
    price: 1100,
    status: 'Ожидает',
    paymentMethod: 'Наличными мастеру',
  ),
  ServiceOrder(
    id: 'ORD-2026-004',
    serviceName: 'Ремонт нагревательного элемента стиральной машины',
    description: 'Диагностика ошибки нагрева воды, замена перегоревшего ТЭНа на оригинальный элемент Bosch.',
    masterName: 'Павел Сидоров',
    masterSpecialty: 'Бытовая техника',
    masterPhone: '+373 68 567 890',
    date: '05 Октября 2026',
    time: '16:00 - 17:30',
    address: 'г. Кишинев, ул. Алба-Юлия 184, кв. 3',
    price: 850,
    status: 'Завершён',
    paymentMethod: 'Наличными',
  ),
  ServiceOrder(
    id: 'ORD-2026-005',
    serviceName: 'Сборка трехдверного шкафа-купе',
    description: 'Сборка каркаса шкафа, установка раздвижной системы дверей, крепление внутренних полок и штанг.',
    masterName: 'Дмитрий Чеботарь',
    masterSpecialty: 'Сборка мебели',
    masterPhone: '+373 78 678 901',
    date: '28 Сентября 2026',
    time: '11:00 - 15:00',
    address: 'г. Кишинев, ул. Мирча чел Бэтрын 15, кв. 102',
    price: 900,
    status: 'Завершён',
    paymentMethod: 'Картой мастеру',
  ),
  ServiceOrder(
    id: 'ORD-2026-006',
    serviceName: 'Замена дверного замка сейфового типа',
    description: 'Демонтаж заклинившего замка, подгонка посадочного гнезда в стальной двери и монтаж нового замка Kale.',
    masterName: 'Михаил Федоров',
    masterSpecialty: 'Замки и двери',
    masterPhone: '+373 69 789 012',
    date: '15 Сентября 2026',
    time: '18:00 - 19:00',
    address: 'г. Кишинев, ул. Каля Ешилор 5, кв. 67',
    price: 500,
    status: 'Отменён',
    paymentMethod: 'Наличными',
  ),
];

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
