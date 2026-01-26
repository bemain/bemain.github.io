import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:portfolio/frontpage/projects_section.dart';
import 'package:portfolio/writing/article.dart';

/// A custom JsonSerializable annotation that supports decoding objects such
/// as Timestamps and DateTimes.
/// This variable can be reused between different models
const firestoreSerializable = JsonSerializable(
  converters: firestoreJsonConverters,
  // The following values could alternatively be set inside your `build.yaml`
  explicitToJson: true,
  createFieldMap: true,
);

/// Helper class for accessing data on the Firestore database.
class Firestore {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference<Article> articlesCollection =
      _firestore.collection("writing").withConverter<Article>(
            fromFirestore: (snapshot, options) =>
                Article.fromJson(snapshot.data()!),
            toFirestore: (value, options) => value.toJson(),
          );

  static List<Article>? _articles;

  static Future<List<Article>> get articles async {
    print("[DEBUG] Getting articles, currently ${_articles?.length}");
    _articles ??=
        (await articlesCollection.get()).docs.map((e) => e.data()).toList();
    return _articles!;
  }

  static final CollectionReference<Project> projectsCollection =
      _firestore.collection("projects").withConverter<Project>(
            fromFirestore: (snapshot, options) =>
                Project.fromJson(snapshot.data()!),
            toFirestore: (value, options) => value.toJson(),
          );
}
