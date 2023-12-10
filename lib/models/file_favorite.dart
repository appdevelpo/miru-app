import 'package:isar/isar.dart';
import 'package:miru_app/models/extension.dart';

part 'file_favorite.g.dart';

@collection
class File_Favorite {
  Id id = Isar.autoIncrement;
  @Index(composite: [CompositeIndex('url')])
  late String package;
  late String url;
  late List<String> tags;
  late int? parentFolderId;
  late int? folderId;
  @Enumerated(EnumType.name)
  late ExtensionType type;
  late String title;
  String? cover;
  DateTime date = DateTime.now();
}
