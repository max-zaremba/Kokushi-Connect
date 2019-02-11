import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';

abstract class Database {
  Future<String> getFirstName([String userId]);
  Future<String> getLastName([String userId]);
  Future<String> getEmail([String userId]);
  Future<String> getDOB([String userId]);
  Future<String> getRank([String userId]);
  Future<void> setRank(String rank, [String userId]);
  Future<String> getDojoId();
  Future<String> getDojoName([String dojoId]);
  Future<void> setDojo(String name);
  Future<bool> getAccountType();
  Future<void> createAccount(String firstName, String lastName, DateTime dob, String rank, bool coach);
  // first name
  // last name
  // email
  // userID
  // DOB
  // Rank
  // DojoID
  // Account Type
}

class Db implements Database {
  final Firestore _firestore = Firestore.instance;
  
  Db({this.auth});
  final BaseAuth auth;

  Future<void> createAccount(String firstName, String lastName, DateTime dob, String rank, bool coach) async {
    return _firestore.collection("users").document().setData({ 'firstName': firstName, 'lastName': lastName, 'dob': dob, 'rank': rank, 'coach': coach });
  }

  Future<String> getDOB([String userId]) {
    // TODO: implement getDOB
    return null;
  }

  Future<String> getDojoId() {
    // TODO: implement getDojoId
    return null;
  }

  Future<String> getDojoName([String dojoId]) {
    // TODO: implement getDojoName
    return null;
  }

  Future<String> getEmail([String userId]) {
    // TODO: implement getEmail
    return null;
  }

  Future<String> getFirstName([String userId]) {
    // TODO: implement getFirstName
    return null;
  }

  Future<String> getLastName([String userId]) {
    // TODO: implement getLastName
    return null;
  }

  Future<String> getRank([String userId]) {
    // TODO: implement getRank
    return null;
  }

  Future<String> setDojo(String name) {
    // TODO: implement setDojo
    return null;
  }

  Future<String> setRank(String rank, [String userId]) {
    // TODO: implement setRank
    return null;
  }

  Future<bool> getAccountType() {

  }

}