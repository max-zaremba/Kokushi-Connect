import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';
import 'dart:async';

abstract class Database {
  Future<String> getFirstName(String userId);
  Future<String> getLastName(String userId);
  Future<String> getEmail(String userId);
  Future<DateTime> getDOB(String userId);
  Future<String> getRank(String userId);
  Future<void> setRank(String rank, String userId);
  Future<String> getDojoId();
  Future<String> getDojoName(String dojoId);
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

  Future<DocumentSnapshot> userInfo(String userId) async {
    return _firestore.collection('users').document(userId).get();
  }

  Future<void> createAccount(String firstName, String lastName, DateTime dob, String rank, bool coach) async {
    return _firestore.collection("users").document().setData({ 'firstName': firstName, 'lastName': lastName, 'dob': dob, 'rank': rank, 'coach': coach });
  }

  Future<DateTime> getDOB(String userId) async {
    DocumentSnapshot document = await userInfo(userId);
    return document.data['dob'];
  }

  Future<String> getDojoId() async {
    // TODO: implement getDojoId
    return null;
  }

  Future<String> getDojoName([String dojoId]) async {
    // TODO: implement getDojoName
    return null;
  }

  Future<String> getEmail(String userId) async {
    // TODO: implement getEmail
    return null;
  }

  Future<String> getFirstName(String userId) async {
    DocumentSnapshot document = await userInfo(userId);
    return document.data['firstName'];
  }

  Future<String> getLastName(String userId) async {
    // TODO: implement getLastName
    return null;
  }

  Future<String> getRank(String userId) async {
    // TODO: implement getRank
    return null;
  }

  Future<String> setDojo(String name) async {
    // TODO: implement setDojo
    return null;
  }

  Future<String> setRank(String rank, String userId) async {
    // TODO: implement setRank
    return null;
  }

  Future<bool> getAccountType() async {
    return null;
  }
}