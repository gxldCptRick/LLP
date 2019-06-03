import 'dart:math';

import 'package:light_link_mobile/data_layer/models/computer.dart';
import 'package:light_link_mobile/data_layer/models/profile.dart';
import 'package:light_link_mobile/data_layer/models/user.dart';
import 'package:light_link_mobile/data_layer/services/user_service.dart';

class RandomUserService extends UserService {
  Map<String, User> cache;
  List<String> profileNames;
  List<Computer> puters;
  Random rnJesus;
  User currentlyLoggedIn;

  RandomUserService() {
    rnJesus = Random();
    cache = Map<String, User>();
    profileNames = [
      "Milo is here",
      "Always put something in the list.",
      "What do you want ok",
      "Rude",
      "This is More For The Pool",
      "I need something more to add to it.",
      "Windows or Mac",
      "Flammability Requirments",
      "Kinky",
      "Discontinous",
      "Balls in Holes ;)",
      "Burger King Footlettuce.",
      "Factor The King",
      "Disapointed",
      "Foil this out mane",
      "Frijoles",
      "This is a really really really long thing in order to make this thing cool looking."
    ];
    puters = [
      Computer.init("Mc Bitchin", ["keyboard", "mouse", "mousepad"], null)
    ];
  }

  factory RandomUserService.withSeededCache() {
    var service = RandomUserService();
    service.getUserById("gxldcptrick");
    service.getUserById("alexTheGoat");
    return service;
  }

  @override
  Iterable<Profile> getProfilesForUser(String username) {
    return cache[username].profiles;
  }

  String generateColor() {
    int red = rnJesus.nextInt(256);
    int blue = rnJesus.nextInt(256);
    int green = rnJesus.nextInt(256);
    return "ff" +
        red.toRadixString(16) +
        blue.toRadixString(16) +
        green.toRadixString(16);
  }

  Iterable<Profile> createProfiles() sync* {
    while (true) {
      var color = generateColor();
      var profile = Profile.init(
        profileNames[rnJesus.nextInt(profileNames.length)],
        {
          "keyboard": color,
        },
        false,
        DateTime.now().subtract(
          Duration(
            days: rnJesus.nextInt(100),
          ),
        ),
      );
      yield profile;
    }
  }

  @override
  User getUserById(String username) {
    if (!cache.containsKey(username)) {
      cache[username] =
          new User.init(username, "", createProfiles().take(10).toList());
      cache[username].profiles[0].isActive = true;
    }
    currentlyLoggedIn = cache[username];
    return currentlyLoggedIn;
  }

  @override
  void removeProfileFromUser(String username, String profilename) {
    getUserById(username).profiles.removeWhere((p) => p.name == profilename);
  }

  @override
  void addProfileToUser(String username, Profile profile) {
    getUserById(username).profiles.add(profile);
  }

  @override
  void updateProfileForUser(String uname, String ogName, Profile profile) {
    var user = getUserById(uname).profiles;
    user.removeWhere((p) => p.name == ogName);
    user.add(profile);
  }

  @override
  Profile getActiveProfile(String username) {
    var user = getUserById(username);
    if (user.profiles.any((c) => c.isActive))
      return user.profiles.firstWhere((c) => c.isActive);
    else
      return user.profiles.first;
  }

  @override
  void updateActiveProfile(String username, Profile profile) {
    var user = getUserById(username);
    user.profiles.forEach((c) => c.isActive = false);
    profile.isActive = true;
    updateProfileForUser(username, profile.name, profile);
  }

  @override
  void updateProfileConfigsWithComputer(String username) {
    var setOfDevices = Set<String>();
    puters.forEach((c) => c.connectedDevices.forEach(setOfDevices.add));
    Profile.currentConfigs = setOfDevices;
    this.cache[username].profiles.forEach((p) => p.applyLatestConfigs());
  }

  @override
  void linkComputerToUser(String username, String computerName) {
    puters
        .where((c) => c.name == computerName)
        .forEach((c) => c.userName = username);
  }
}
