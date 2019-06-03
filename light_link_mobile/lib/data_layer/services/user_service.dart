import '../models/user.dart';
import '../models/profile.dart';

abstract class UserService {
  User getUserById(String username);
  Iterable<Profile> getProfilesForUser(String username);
  void removeProfileFromUser(String username, String profilename);
  void addProfileToUser(String username, Profile profile);
  Profile getActiveProfile(String username);
  void updateProfileForUser(String uname, String ogName, Profile profile);
  void updateActiveProfile(String username, Profile profile);
  void updateProfileConfigsWithComputer(String username);
  void linkComputerToUser(String username, String computerName);
}
