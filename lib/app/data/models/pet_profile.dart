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
  final UserModel? userModel;
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
    this.userModel,
    this.v,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    final dynamic userField = json['user'];

    return PetModel(
      id: json['_id'] as String?,
      user: userField is String ? userField : null,
      userModel: userField is Map<String, dynamic>
          ? UserModel.fromJson(userField)
          : null,
      isHavePet: json['isHavePet'] as bool?,
      petType: json['petType'] as String?,
      profilePic: json['profilePic'] as String?,
      name: json['name'] as String?,
      breed: json['breed'] as String?,
      sex: json['sex'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      bio: json['bio'] as String?,
      photos: (json['photos'] as List?)?.map((e) => e.toString()).toList(),
      color: json['color'] as String?,
      size: json['size'] as String?,
      weight: json['weight'] as num?,
      marks: json['marks'] as String?,
      microchipNumber: json['microchipNumber'] as String?,
      tagId: json['tagId'] as String?,
      lostStatus: json['lostStatus'] as bool?,
      vaccinationStatus: json['vaccinationStatus'] as bool?,
      vetName: json['vetName'] as String?,
      vetContactNumber: json['vetContactNumber'] as String?,
      personalityTraits: (json['personalityTraits'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      allergies:
          (json['allergies'] as List?)?.map((e) => e.toString()).toList(),
      specialNeeds: json['specialNeeds'] as String?,
      feedingInstructions: json['feedingInstructions'] as String?,
      dailyRoutine: json['dailyRoutine'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      v: json['__v'] as int?,
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
      'userModel': userModel?.toJson(),
    };
  }
}

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final Location? location;

  UserModel({this.id, this.name, this.email, this.location});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      location: json['location'] is Map<String, dynamic>
          ? Location.fromJson(json['location'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'location': location?.toJson(),
    };
  }
}

class Location {
  final String? type;
  final List<double>? coordinates;

  Location({this.type, this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] as String?,
      coordinates: (json['coordinates'] as List?)
          ?.map((e) => (e as num?)?.toDouble() ?? 0.0)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}
