import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user => _auth.authStateChanges();

  Future<User?> signInWithEmail(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  Future<User?> registerWithEmail(String email, String password, String name) async {
    try {
      print("Tentando cadastrar usuário: $email");
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        print("Usuário criado com sucesso: ${user.uid}");
        
        await user.updateDisplayName(name);

        await DatabaseService(uid: user.uid).updateUserData(email: email, name: name);
        
        await user.sendEmailVerification();
        print("Email de verificação enviado para ${user.email}");
      }
      return user;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException Detalhado: Code=${e.code}, Message=${e.message}, TenantId=${e.tenantId}");
      rethrow; 
    } catch (e) {
       print("Erro Inesperado: $e");
       rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> sendEmailVerification(User user) async {
    try {
      await user.sendEmailVerification();
    } catch (e) {
      print("Error sending email verification: $e");
    }
  }
  
  Future<void> reloadUser(User user) async {
    await user.reload();
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential result = await _auth.signInWithCredential(credential);
    User? user = result.user;

    if (user != null) {
      await DatabaseService(uid: user.uid).updateUserData(
        email: user.email,
        name: user.displayName,
      );
    }

    return user;
  }

  Future<void> deleteAccount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await DatabaseService(uid: user.uid).deleteUserData();
      
      try {
        await user.delete();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          print('O usuário precisa fazer login novamente para excluir a conta.');
          rethrow;
        }
      }
    }
  }

  Future<void> changePassword(String newPassword) async {
    User? user = _auth.currentUser;
    if (user != null) {
        await user.updatePassword(newPassword);
    }
  }

  Future<void> changeEmail(String newEmail) async {
    User? user = _auth.currentUser;
    if (user != null) {
        await user.verifyBeforeUpdateEmail(newEmail);
    }
  }

  Future<void> changeName(String newName) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(newName);
      
      await DatabaseService(uid: user.uid).updateUserData(name: newName);
      
      await user.reload();
    }
  }

  Future<void> syncUserEmail() async {
    User? user = _auth.currentUser;
    if (user != null && user.email != null) {
      var snapshot = await DatabaseService(uid: user.uid).userData.first;
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        String? dbEmail = data?['email'];
        
        if (dbEmail != user.email) {
          print("Syncing email: DB($dbEmail) -> Auth(${user.email})");
          await DatabaseService(uid: user.uid).updateUserData(email: user.email);
        }
      }
    }
  }
}
