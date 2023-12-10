import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miru_app/controllers/detail_controller.dart';
import 'package:miru_app/models/favorite.dart';
import 'package:miru_app/utils/i18n.dart';
import 'package:miru_app/views/widgets/folder_item_card.dart';
import 'package:miru_app/views/widgets/platform_widget.dart';
import 'package:miru_app/views/widgets/detail_favorite_button_dialog.dart';
import 'package:miru_app/views/widgets/extension_item_card.dart';
import 'package:miru_app/data/services/database_service.dart';
import 'package:miru_app/views/widgets/progress.dart';
import 'package:miru_app/views/widgets/grid_item_tile.dart';

class DetailFavoriteFileDialog extends StatefulWidget {
  const DetailFavoriteFileDialog({
    Key? key,
  }) : super(key: key);
  @override
  fluent.State<DetailFavoriteFileDialog> createState() =>
      _DetailFavoriteFileDialogState();
}

class _DetailFavoriteFileDialogState extends State<DetailFavoriteFileDialog> {
  String textField_content = '';
  int folderDepth = 0;
  int? parentFolderId;
  Widget _buildAndroid(BuildContext context) {
    return AlertDialog(
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Create new folder?"),
        Row(children: [
          Expanded(
              child: TextField(
            onChanged: (String value) {
              textField_content = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter your information...',
            ),
          )),
          IconButton(
              onPressed: () {
                debugPrint("press");
                DatabaseService.addFavoriteFolder(
                  folderName: textField_content,
                  parentFolderId: parentFolderId,
                  folderDepth: folderDepth,
                );
                // setState(() {
                //   parentFolderId = parentFolderId;
                // });
              },
              icon: const Icon(Icons.create_new_folder_rounded))
        ]),
      ]),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: FutureBuilder(
          future: DatabaseService.getFavoritesFolder(parentFolderId),
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            }
            if (!snapshot.hasData) {
              return const SizedBox(
                height: 300,
                child: Center(
                  child: ProgressRing(),
                ),
              );
            }
            final data = snapshot.data;
            if (folderDepth > 0) {
              // debugPrint()
              data!.insert(
                  0,
                  Favorite()
                    ..cover = ''
                    ..url = ""
                    ..title = "back"
                    ..id = 0
                    ..folderId = parentFolderId);
            }
            if (data != null && data.isEmpty) {
              return Center(
                child: Text("common.no-result".i18n),
              );
            }
            return LayoutBuilder(
              builder: (context, constraints) => GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth ~/ 120,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: data!.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  if (item.id == 0) {
                    return Hero(
                      tag: "",
                      child: GridItemTile(
                        title: "back",
                        // cover: item.cove,
                        usingIcon: const Icon(
                          Icons.more_horiz_rounded,
                          size: 80,
                        ),
                        onTap: () async {
                          // debugPrint("${item.folderId}");
                          final parentId =
                              await DatabaseService.getFavoritesParentFolder(
                                  parentFolderId);
                          folderDepth--;
                          setState(() {
                            parentFolderId = parentId;
                          });
                        },
                      ),
                    );
                  }
                  // debugPrint("${item.folderId}");
                  return Hero(
                    tag: item.url,
                    child: GridItemTile(
                      title: item.title,
                      cover: item.cover,
                      usingIcon: const Icon(
                        Icons.folder_rounded,
                        size: 80,
                      ),
                      onTap: () {
                        // debugPrint("${item.folderId}");
                        folderDepth++;
                        setState(() {
                          parentFolderId = item.folderId;
                        });
                      },
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            // await c.toggleFavorite();
            Navigator.pop(context, true);
          },
          child: Text('Finish'),
        ),
      ],
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return _buildAndroid(context);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformBuildWidget(
      androidBuilder: _buildAndroid,
      desktopBuilder: _buildDesktop,
    );
  }
}
