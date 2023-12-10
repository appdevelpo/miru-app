// import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:miru_app/controllers/detail_controller.dart';
// import 'package:miru_app/utils/i18n.dart';
// import 'package:miru_app/views/widgets/platform_widget.dart';

class DetailFavoriteButtonDialog extends StatefulWidget {
  final bool isFavorite;

  const DetailFavoriteButtonDialog({
    required this.isFavorite,
  });

  @override
  _DetailFavoriteButtonDialogState createState() =>
      _DetailFavoriteButtonDialogState();
}

class _DetailFavoriteButtonDialogState
    extends State<DetailFavoriteButtonDialog> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
                _isFavorite ? 'Remove from favorites?' : 'Add to favorites?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                  Navigator.pop(context, true);
                },
                child: Text(_isFavorite ? 'Remove' : 'Add'),
              ),
            ],
          ),
        );
      },
    );
  }
}
