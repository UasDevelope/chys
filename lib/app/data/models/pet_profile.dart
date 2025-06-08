class PetModel {
  final String? id;
  final String? user;
  final bool? isHavePet;
  final String? petType;
  final String? profilePic;
  final String? name;
  final String? breed;
  final String? sex;
  final DateTime? dateOfBirth;
  final String? bio;
  final List<String>? photos;
  final String? color;
  final String? size;
  final num? weight;
  final String? marks;
  final String? microchipNumber;
  final String? tagId;
  final bool? lostStatus;
  final bool? vaccinationStatus;
  final String? vetName;
  final String? vetContactNumber;
  final List<String>? personalityTraits;
  final List<String>? allergies;
  final String? specialNeeds;
  final String? feedingInstructions;
  final String? dailyRoutine;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  PetModel({
    this.id,
    this.user,
    this.isHavePet,
    this.petType,
    this.profilePic,
    this.name,
    this.breed,
    this.sex,
    this.dateOfBirth,
    this.bio,
    this.photos,
    this.color,
    this.size,
    this.weight,
    this.marks,
    this.microchipNumber,
    this.tagId,
    this.lostStatus,
    this.vaccinationStatus,
    this.vetName,
    this.vetContactNumber,
    this.personalityTraits,
    this.allergies,
    this.specialNeeds,
    this.feedingInstructions,
    this.dailyRoutine,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['_id'],
      user: json['user'],
      isHavePet: json['isHavePet'],
      petType: json['petType'],
      profilePic: json['profilePic'],
      name: json['name'],
      breed: json['breed'],
      sex: json['sex'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      bio: json['bio'],
      photos: (json['photos'] as List?)?.map((e) => e.toString()).toList(),
      color: json['color'],
      size: json['size'],
      weight: json['weight'],
      marks: json['marks'],
      microchipNumber: json['microchipNumber'],
      tagId: json['tagId'],
      lostStatus: json['lostStatus'],
      vaccinationStatus: json['vaccinationStatus'],
      vetName: json['vetName'],
      vetContactNumber: json['vetContactNumber'],
      personalityTraits: (json['personalityTraits'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      allergies:
          (json['allergies'] as List?)?.map((e) => e.toString()).toList(),
      specialNeeds: json['specialNeeds'],
      feedingInstructions: json['feedingInstructions'],
      dailyRoutine: json['dailyRoutine'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'isHavePet': isHavePet,
      'petType': petType,
      'profilePic': profilePic,
      'name': name,
      'breed': breed,
      'sex': sex,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'bio': bio,
      'photos': photos,
      'color': color,
      'size': size,
      'weight': weight,
      'marks': marks,
      'microchipNumber': microchipNumber,
      'tagId': tagId,
      'lostStatus': lostStatus,
      'vaccinationStatus': vaccinationStatus,
      'vetName': vetName,
      'vetContactNumber': vetContactNumber,
      'personalityTraits': personalityTraits,
      'allergies': allergies,
      'specialNeeds': specialNeeds,
      'feedingInstructions': feedingInstructions,
      'dailyRoutine': dailyRoutine,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}
