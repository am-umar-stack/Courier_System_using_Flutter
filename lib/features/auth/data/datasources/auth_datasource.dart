import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../../../core/constants/app_constants.dart';
import '../models/user_model.dart';

class AuthDatasource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthDatasource({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  firebase_auth.User? get currentFirebaseUser {
    return _firebaseAuth.currentUser;
  }

  Stream<firebase_auth.User?> watchAuthState() {
    return _firebaseAuth.authStateChanges();
  }

  Future<firebase_auth.UserCredential> signInWithEmail(
    String email,
    String password,
  ) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<firebase_auth.UserCredential> signUpWithEmail(
    String email,
    String password,
  ) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  Future<UserModel?> getUserDocument(String userId) async {
    DocumentSnapshot snapshot = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .get();

    if (!snapshot.exists) {
      return null;
    }

    return UserModel.fromFirestore(snapshot);
  }

  Future<void> createUserDocument(UserModel user) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.id)
        .set(user.toFirestore());
  }

  Future<void> updateUserRole(String userId, String role) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .update({'role': role});
  }

  Stream<UserModel?> watchUserDocument(String userId) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      return UserModel.fromFirestore(snapshot);
    });
  }
}
