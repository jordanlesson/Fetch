import 'package:meta/meta.dart';

List<Profile> demoProfiles = [
  Profile(
    id: "abcde12345",
    name: "Biscuit",
    dateOfBirth: DateTime.now(),
    breed: "Shih-Tzu",
    bio: "I like to play Fetch",
    gender: "male",
    hobby: "Eating Treats",
    owner: "12345abcde",
    photos: [
      "https://images.dog.ceo/breeds/husky/n02110185_248.jpg",
      "https://images.dog.ceo/breeds/papillon/n02086910_3866.jpg",
      "https://images.dog.ceo/breeds/malamute/n02110063_13625.jpg",
    ],
    treats: [],
    likes: [],
  ),
  Profile(
    id: "abcde12345",
    name: "Biscuit",
    dateOfBirth: DateTime.now(),
    breed: "Shih-Tzu",
    bio: "I like to play Fetch",
    gender: "male",
    hobby: "Eating Treats",
    owner: "12345abcde",
    photos: [
      "https://images.dog.ceo/breeds/husky/n02110185_248.jpg",
      "https://images.dog.ceo/breeds/papillon/n02086910_3866.jpg",
      "https://images.dog.ceo/breeds/malamute/n02110063_13625.jpg",
    ],
  ),
  Profile(
    id: "abcde12345",
    name: "Biscuit",
    dateOfBirth: DateTime.now(),
    breed: "Shih-Tzu",
    bio: "I like to play Fetch",
    gender: "male",
    hobby: "Eating Treats",
    owner: "12345abcde",
    photos: [
      "https://images.dog.ceo/breeds/husky/n02110185_248.jpg",
      "https://images.dog.ceo/breeds/papillon/n02086910_3866.jpg",
      "https://images.dog.ceo/breeds/malamute/n02110063_13625.jpg",
    ],
  ),
];

class Profile {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String breed;
  final String gender;
  final String owner;
  String bio;
  String hobby;
  List<dynamic> treats;
  List<dynamic> photos;
  List<dynamic> photoPaths;
  List<dynamic> likes;
  int treatCount;
  int likeCount;

  Profile(
      {this.id,
      this.photos,
      this.photoPaths,
      this.name,
      this.dateOfBirth,
      this.breed,
      this.gender,
      this.bio,
      this.owner,
      this.hobby,
      this.treats,
      this.likes,
      this.likeCount,
      this.treatCount,
      });

  String convertDate(DateTime date) {
    Duration timeDifference = date.difference(DateTime.now()).abs();
    int age = (timeDifference.inDays / 365).floor();
    return age.toString();
  }
}
