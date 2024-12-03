import 'dart:io';
import 'dart:ui';

import 'package:basic_editor/pages/editor/editor_models.dart';
import 'package:basic_editor/pages/editor/editor_template_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class EditorPage extends StatefulWidget {
  final dynamic data;
  const EditorPage({super.key, this.data});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final List<EditorOptionModel> options = [
    EditorOptionModel(
      selected: false,
      title: "Opacidade",
      icon: Icons.opacity,
    ),
    EditorOptionModel(
      selected: true,
      title: "Cor do texto",
      icon: Icons.color_lens_outlined,
    ),
    EditorOptionModel(
      selected: false,
      title: "Template",
      icon: Icons.grid_goldenratio_rounded,
    )
  ];

  final List<Color> colors = [
    Colors.white,
    Colors.black,
    Colors.orange,
    Colors.blue,
    Colors.grey
  ];

  final ImagePicker picker = ImagePicker();
  final GlobalKey globalKey = GlobalKey();

  var selectedOption = 1;
  var selectedTemplate = 0;
  var selectedOpacity = 0.6;
  var selectedColor = Colors.black;
  var selectedImage = "";

  Future<void> pickImage() async {
    var resultImage = await picker.pickImage(source: ImageSource.gallery);

    if (resultImage != null) setState(() => selectedImage = resultImage.path);
  }

  Future<void> captureFrame() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      var image = await boundary.toImage(pixelRatio: 3.0);

      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      if (byteData == null) return;

      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final now = DateTime.now().toIso8601String();
      final file = File('${tempDir.path}/iatrain_training_export-$now.png');
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([XFile(file.path)],
          text: 'Compartilhe ou salve sua imagem IATrain !');

      await file.delete();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compartilhe seu treino'),
        actions: selectedImage.isEmpty
            ? null
            : [
                IconButton(
                  onPressed: () => captureFrame(),
                  icon: const Icon(Icons.download),
                ),
              ],
      ),
      body: selectedImage.isEmpty ? buildImageSelector() : buildEditor(),
    );
  }

  Widget buildEditor() {
    var templateData = EditorTemplateModel(
      color: selectedColor,
      opacity: selectedOpacity,
      data: widget.data,
      imagePath: selectedImage,
    );

    return Column(
      children: [
        RepaintBoundary(
          key: globalKey,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(
                  File(selectedImage),
                ),
              ),
            ),
            child: selectedTemplate == 0
                ? EditorTemplateFirstWidget(
                    templateData: templateData, isMainContent: true)
                : selectedTemplate == 1
                    ? EditorTemplateSecondWidget(
                        templateData: templateData, isMainContent: true)
                    : EditorTemplateThirdWidget(
                        templateData: templateData, isMainContent: true),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            color: Theme.of(context).colorScheme.onInverseSurface,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: pickImage,
                  child: const Text('Selecionar outra imagem'),
                ),
                buildMainOptionContent(),
                buildMainOptions()
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildMainOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(options.length, (index) {
        var option = options[index];

        return GestureDetector(
          onTap: () {
            setState(() {
              for (var opt in options) {
                opt.selected = false;
              }
              option.selected = true;
              selectedOption = index;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: option.selected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
            ),
            child: Column(
              children: [
                Icon(
                  option.icon,
                  color: option.selected ? Colors.white : null,
                ),
                const SizedBox(width: 4),
                Text(
                  option.title,
                  style: TextStyle(
                    color: option.selected ? Colors.white : null,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildMainOptionContent() {
    return selectedOption == 0
        ? opacityContent()
        : selectedOption == 1
            ? colorContent()
            : templateContent();
  }

  Widget opacityContent() {
    return Column(
      children: [
        Text('Opacidade ${(selectedOpacity * 100).floor()} %'),
        Slider(
          min: 0.1,
          max: 1.0,
          label: '$selectedOpacity',
          value: selectedOpacity,
          onChanged: (value) => setState(() => selectedOpacity = value),
        )
      ],
    );
  }

  Widget colorContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(colors.length, (index) {
        var color = colors[index];

        return GestureDetector(
          onTap: () => setState(() {
            selectedColor = color;
          }),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              height: selectedColor == color ? 54 : 42,
              width: selectedColor == color ? 54 : 42,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(100),
                boxShadow: selectedColor == color
                    ? [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          spreadRadius: 1,
                          blurRadius: 15,
                          offset: const Offset(5, 5),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget templateContent() {
    var templateData = EditorTemplateModel(
      color: selectedColor,
      opacity: selectedOpacity,
      data: widget.data,
      imagePath: selectedImage,
    );

    List<Widget> templates = [
      EditorTemplateFirstWidget(
        templateData: templateData,
        isMainContent: false,
      ),
      EditorTemplateSecondWidget(
        templateData: templateData,
        isMainContent: false,
      ),
      EditorTemplateThirdWidget(
        templateData: templateData,
        isMainContent: false,
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        templates.length,
        (index) {
          return GestureDetector(
            onTap: () => setState(() => selectedTemplate = index),
            child: Container(
              height: index == selectedTemplate ? 124 : 100,
              width: index == selectedTemplate ? 124 : 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: selectedTemplate == index
                    ? [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          spreadRadius: 1,
                          blurRadius: 15,
                          offset: const Offset(5, 5),
                        ),
                      ]
                    : null,
              ),
              child: templates[index],
            ),
          );
        },
      ),
    );
  }

  Widget buildImageSelector() {
    return Center(
      child: FilledButton.icon(
        onPressed: pickImage,
        label: const Text('Selecione uma imagem'),
        icon: const Icon(Icons.image),
      ),
    );
  }
}
