import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fuodz/services/toast.service.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/custom_grid_view.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class MultiImageSelectorView extends StatefulWidget {
  const MultiImageSelectorView({
    this.links,
    this.onImagesSelected,
    Key key,
  }) : super(key: key);

  final List<String> links;
  final Function(List<File>) onImagesSelected;

  @override
  _MultiImageSelectorViewState createState() => _MultiImageSelectorViewState();
}

class _MultiImageSelectorViewState extends State<MultiImageSelectorView> {
  //
  List<File> selectedFiles = [];
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        Visibility(
          visible: showImageUrl() && !showSelectedImage(),
          child: CustomGridView(
            dataSet: widget.links,
            itemBuilder: (ctx, index) {
              return CustomImage(
                imageUrl: widget.links[index] ?? "",
              ).h20(context).wFull(context);
            },
          ),
        ),
        //
        Visibility(
          visible: showSelectedImage(),
          child: CustomGridView(
            dataSet: selectedFiles,
            itemBuilder: (ctx, index) {
              return Image.file(
                selectedFiles[index] ?? "",
                fit: BoxFit.cover,
              ).h20(context).wFull(context);
            },
          ),
        ),

        //
        Visibility(
          // visible: !showImageUrl() && !showSelectedImage(),
          visible: true,
          child: CustomButton(
            title: "Select photo(s)".tr(),
            onPressed: pickNewPhoto,
          ).centered(),
        ),
      ],
    )
        .wFull(context)
        .box
        .clip(Clip.antiAlias)
        .border(color: context.accentColor)
        .roundedSM
        .outerShadow
        .make()
        .onTap(pickNewPhoto);
  }

  bool showImageUrl() {
    return widget.links != null && widget.links.isNotEmpty;
  }

  bool showSelectedImage() {
    return selectedFiles != null && selectedFiles.isNotEmpty;
  }

  //
  pickNewPhoto() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      selectedFiles = [];

      for (var selectedFile in pickedFiles) {
        selectedFiles.add(File(selectedFile.path));
      }
      //
      widget.onImagesSelected(selectedFiles);
      setState(() {
        selectedFiles = selectedFiles;
      });
    } else {
      ToastService.toastError("No Image/Photo selected".tr());
    }
  }
}
