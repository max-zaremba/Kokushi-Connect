import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';
import 'dart:async';

abstract class Database {
  //user getters 
  Future<String> getFirstName(String userId);
  Future<String> getLastName(String userId);
  Future<String> getEmail(String userId);
  Future<DateTime> getDOB(String userId);
  Future<String> getRank(String userId);
  Future<String> getDojoIdByUserId(String userId);
  Future<String> getAccountType(String userId);

  //user setters
  Future<void> setFirstName(String firstName, String userId);
  Future<void> setLastName(String lastName, String userId);
  Future<void> setEmail(String email, String userId);
  Future<void> setDOB(DateTime dob, String userId);
  Future<void> setRank(String rank, String userId);
  Future<void> setDojoIdForUser(String dojoId, String userId);
  Future<void> setAccountType(String accountType, String userId);

  Future<void> createAccount(String firstName, String lastName, DateTime dob, String rank, String accountType, String userId); //creates a new account

  //dojo getters
  Future<String> getDojoName(String dojoId);
  Future<String> getDojoCode(String dojoId);
  Future<String> getDojoAddress(String dojoId);
  Future<String> getDojoIdByDojoName(String dojoName);
  
  //dojo setters
  Future<void> setDojoCode(String code, String dojoId);
  Future<void> setDojoName(String name, String dojoId);
  Future<void> setDojoAddress(String address, String dojoId);
}

class Db implements Database {
  final Firestore _firestore = Firestore.instance;

  //gets all user information
  Future<DocumentSnapshot> userInfo(String userId) async {
    return _firestore.collection('users').document(userId).get();
  }

  //getters for user
  Future<String> getFirstName(String userId) async {
    DocumentSnapshot document = await userInfo(userId);
    return document.data['firstName'];
  }

  Future<String> getLastName(String userId) async {
    DocumentSnapshot document = await userInfo(userId);
    return document.data['lastName'];
  }

  Future<String> getEmail(String userId) async {
    DocumentSnapshot document = await userInfo(userId);
    return document.data['email'];
  }
  
  Future<DateTime> getDOB(String userId) async {
    DocumentSnapshot document = await userInfo(userId);
    return document.data['dob'];
  }

  Future<String> getRank(String userId) async {
    DocumentSnapshot document = await userInfo(userId);
    return document.data['rank'];
  }

  Future<String> getDojoIdByUserId(String userId) async {
    DocumentSnapshot document = await userInfo(userId);
    return document.data['dojoId'];
  }

  Future<String> getAccountType(String userId) async {
    DocumentSnapshot document = await userInfo(userId);
    return document.data['accountType'];
  }

  //setters for users
  Future<void> setFirstName(String firstName, String userId) async {
    return _firestore.collection("users").document(userId).setData({ 'firstName': firstName});
  }

  Future<void> setLastName(String lastName, String userId) async {
    return _firestore.collection("users").document(userId).setData({ 'lastName': lastName});
  }

  Future<void> setEmail(String email, String userId) async {
    return _firestore.collection("users").document(userId).setData({ 'email': email});
  }

  Future<void> setDOB(DateTime dob, String userId) async{
    return _firestore.collection("users").document(userId).setData({ 'dob': dob});
  }

  Future<void> setRank(String rank, String userId) async {
    return _firestore.collection("users").document(userId).setData({ 'rank': rank});
  }

  Future<void> setDojoIdForUser(String dojoId, String userId) async {
    return _firestore.collection("users").document(userId).setData({ 'dojoId': dojoId});
  }

  Future<void> setAccountType(String accountType, String userId){
    return _firestore.collection("users").document(userId).setData({ 'accountType': accountType});
  }

  //account creation
  Future<void> createAccount(String firstName, String lastName, DateTime dob, String rank, String accountType, String userId) async {
    return _firestore.collection("users").document(userId).setData({ 'firstName': firstName, 'lastName': lastName, 'dob': dob, 'rank': rank, 'accountType': accountType });
  }

  //gets all dojo information
  Future<DocumentSnapshot> dojoInfo(String dojoId) async {
    return _firestore.collection('dojos').document(dojoId).get();
  }

  //getters for dojo
  Future<String> getDojoName([String dojoId]) async {
    DocumentSnapshot document = await userInfo(dojoId);
    return document.data['dojoName'];
  }

  Future<String> getDojoCode(String dojoId) async {
    DocumentSnapshot document = await userInfo(dojoId);
    return document.data['dojoCode'];
  }

  Future<String> getDojoAddress(String dojoId) async {
    DocumentSnapshot document = await userInfo(dojoId);
    return document.data['address'];
  }

  Future<String> getDojoIdByDojoName(String dojoName) async {
    //TODO
    return "NOT A KEY";
  }

  //setters for dojo
  Future<void> setDojoCode(String code, String dojoId) async {
    return _firestore.collection("dojos").document(dojoId).setData({ 'dojoCode': code});
  }
  Future<void> setDojoName(String name, String dojoId) async {
    return _firestore.collection("dojos").document(dojoId).setData({ 'dojoName': name});
  }
  Future<void> setDojoAddress(String address, String dojoId) async {
    return _firestore.collection("dojos").document(dojoId).setData({ 'address': address});
  }
}