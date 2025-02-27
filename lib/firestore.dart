import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio/writing/article.dart';

/// Helper class for accessing data on the Firestore database.
class Firestore {
  static final CollectionReference<Article> articles =
      FirebaseFirestore.instance.collection("writing").withConverter<Article>(
            fromFirestore: (snapshot, options) =>
                Article.fromJson(snapshot.data()!),
            toFirestore: (value, options) => value.toJson(),
          );
}
