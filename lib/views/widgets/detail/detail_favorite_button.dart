import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miru_app/controllers/detail_controller.dart';
import 'package:miru_app/utils/i18n.dart';
import 'package:miru_app/views/widgets/folder_item_card.dart';
import 'package:miru_app/views/widgets/platform_widget.dart';
import 'package:miru_app/views/widgets/detail/detail_favorite_button_filedialog.dart';
import 'package:miru_app/views/widgets/detail/detail_favorite_button_dialog.dart';

class DetailFavoriteButton extends StatefulWidget {
  const DetailFavoriteButton({
    Key? key,
    this.tag,
    this.folderDepth,
    this.parentFolder,
  }) : super(key: key);
  final String? tag;
  final int? folderDepth;
  final int? parentFolder;
  @override
  fluent.State<DetailFavoriteButton> createState() =>
      _DetailFavoriteButtonState();
}

class _DetailFavoriteButtonState extends State<DetailFavoriteButton> {
  late DetailPageController c = Get.find<DetailPageController>(tag: widget.tag);
  bool showFavoriteDialog = false;
  // bool textFieldPop = false;
  final textFieldPop = false.obs;
  String textField_content = '';
  Widget _buildAndroid(BuildContext context) {
    return Obx(
      () {
        final isFavorite = c.isFavorite.value;
        return OutlinedButton.icon(
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          label: Text(
            isFavorite ? 'detail.favorited'.i18n : 'detail.favorite'.i18n,
          ),
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(
              const Size(double.infinity, 50),
            ),
            backgroundColor: isFavorite
                ? MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary)
                : null,
            foregroundColor: isFavorite
                ? MaterialStateProperty.all(
                    Theme.of(context).colorScheme.onPrimary)
                : null,
          ),
          onPressed: () async {
            showDialog(
                context: context,
                builder: (context) => DetailFavoriteDialog(
                      tag: widget.tag,
                    ));
            // AlertDialog(
            //   title: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(showFavoriteDialog
            //             ? 'Remove from favorites?'
            //             : 'Add to favorites?'),
            //         ButtonBar(children: [
            //           IconButton(
            //               onPressed: () {
            //                 textFieldPop.value = true;
            //                 debugPrint("press");
            //               },
            //               icon: const Icon(Icons.create_new_folder_rounded))
            //         ]),
            //         Visibility(
            //             child: TextField(), visible: textFieldPop.value),
            //       ]),
            //   content: SizedBox(
            //     width: MediaQuery.of(context).size.width * 0.8,
            //     child: FutureBuilder(
            //       future: DatabaseService.getFavoritesByType(),
            //       builder: ((context, snapshot) {
            //         if (snapshot.hasError) {
            //           return Center(
            //             child: Text("${snapshot.error}"),
            //           );
            //         }

            //         if (!snapshot.hasData) {
            //           return const SizedBox(
            //             height: 300,
            //             child: Center(
            //               child: ProgressRing(),
            //             ),
            //           );
            //         }
            //         final data = snapshot.data;

            //         if (data != null && data.isEmpty) {
            //           return Center(
            //             child: Text("common.no-result".i18n),
            //           );
            //         }
            //         return LayoutBuilder(
            //           builder: (context, constraints) => GridView.builder(
            //             padding: const EdgeInsets.symmetric(horizontal: 16),
            //             gridDelegate:
            //                 SliverGridDelegateWithFixedCrossAxisCount(
            //               crossAxisCount: constraints.maxWidth ~/ 120,
            //               childAspectRatio: 0.7,
            //               crossAxisSpacing: 16,
            //               mainAxisSpacing: 16,
            //             ),
            //             itemCount: data!.length,
            //             itemBuilder: (context, index) {
            //               final item = data[index];
            //               return ExtensionItemCard(
            //                 title: item.title,
            //                 url: item.url,
            //                 package: item.package,
            //                 cover: item.cover,
            //               );
            //             },
            //           ),
            //         );
            //       }),
            //     ),
            //   ),
            //   actions: [
            //     TextButton(
            //       onPressed: () => Navigator.pop(context, false),
            //       child: Text('Cancel'),
            //     ),
            //     TextButton(
            //       onPressed: () async {
            //         setState(() {
            //           showFavoriteDialog = !showFavoriteDialog;
            //         });
            //         // await c.toggleFavorite();
            //         Navigator.pop(context, true);
            //       },
            //       child: Text(showFavoriteDialog ? 'Remove' : 'Add'),
            //     ),
            //   ],
            // ),
            // );
          },
          onLongPress: () {
            showDialog(
                context: context,
                builder: (context) => const DetailFavoriteFileDialog());
          },
        );
      },
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Obx(() {
      final isFavorite = c.isFavorite.value;
      return fluent.FilledButton(
        onPressed: () async {
          await c.toggleFavorite();
        },
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: isFavorite
                ? [
                    Text('detail.favorited'.i18n),
                    const SizedBox(width: 8),
                    const Icon(fluent.FluentIcons.favorite_star_fill)
                  ]
                : [
                    Text('detail.favorite'.i18n),
                    const SizedBox(width: 8),
                    const Icon(fluent.FluentIcons.favorite_star)
                  ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformBuildWidget(
      androidBuilder: _buildAndroid,
      desktopBuilder: _buildDesktop,
    );
  }
}
