import 'dart:io';
import 'package:basic_editor/pages/editor/editor_models.dart';
import 'package:flutter/material.dart';

abstract class EditorTemplateBaseWidget extends StatelessWidget {
  final EditorTemplateModel templateData;
  final bool isMainContent;

  const EditorTemplateBaseWidget({
    super.key,
    required this.templateData,
    required this.isMainContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: templateData.imagePath != null
          ? BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(
                  File(templateData.imagePath!),
                ),
              ),
            )
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(templateData.opacity),
        ),
        child: Padding(
          padding: EdgeInsets.all(isMainContent ? 16.0 : 4),
          child: buildTemplateContent(context),
        ),
      ),
    );
  }

  Widget buildTemplateContent(BuildContext context);
}

class EditorTemplateFirstWidget extends EditorTemplateBaseWidget {
  const EditorTemplateFirstWidget({
    super.key,
    required super.templateData,
    required super.isMainContent,
  });

  @override
  Widget buildTemplateContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeader(),
        buildContent(),
        buildFooter(),
      ],
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          templateData.data['user'],
          style: TextStyle(
              color: templateData.color,
              fontSize: super.isMainContent ? 18 : 4),
        ),
        Image.asset(
            templateData.opacity > 0.5
                ? 'assets/iatrain_logo_light.png'
                : 'assets/iatrain_logo_dark.png',
            scale: super.isMainContent ? 32 : 100),
      ],
    );
  }

  Widget buildContent() {
    var titleStyle = TextStyle(
        color: templateData.color, fontSize: super.isMainContent ? 12 : 4);
    var subtitleStyle = TextStyle(
        color: templateData.color, fontSize: super.isMainContent ? 18 : 4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        (templateData.data["titles"] as List).length,
        (index) {
          var title = templateData.data["titles"][index];
          var subtitle = templateData.data["data"][index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: titleStyle),
                Text(subtitle, style: subtitleStyle),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Divider(),
        Text(
          templateData.data["datetime"],
          style: TextStyle(
              color: templateData.color,
              fontSize: super.isMainContent ? 18 : 4),
        ),
      ],
    );
  }
}

class EditorTemplateSecondWidget extends EditorTemplateBaseWidget {
  const EditorTemplateSecondWidget({
    super.key,
    required super.templateData,
    required super.isMainContent,
  });

  @override
  Widget buildTemplateContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeader(),
        buildContent(),
      ],
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              templateData.data['user'],
              style: TextStyle(
                  color: templateData.color,
                  fontSize: super.isMainContent ? 18 : 4),
            ),
            Text(
              templateData.data['datetime'],
              style: TextStyle(
                  color: templateData.color,
                  fontSize: super.isMainContent ? 14 : 3),
            ),
          ],
        ),
        Image.asset(
            templateData.opacity > 0.5
                ? 'assets/iatrain_logo_light.png'
                : 'assets/iatrain_logo_dark.png',
            scale: super.isMainContent ? 32 : 100),
      ],
    );
  }

  Widget buildContent() {
    var titleStyle = TextStyle(
        color: templateData.color, fontSize: super.isMainContent ? 12 : 4);
    var subtitleStyle = TextStyle(
        color: templateData.color, fontSize: super.isMainContent ? 16 : 4);

    return Column(
      children: [
        const Divider(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            (templateData.data["titles"] as List).length,
            (index) {
              var title = templateData.data["titles"][index];
              var subtitle = templateData.data["data"][index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(title, style: titleStyle),
                    Text(subtitle, style: subtitleStyle),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class EditorTemplateThirdWidget extends EditorTemplateBaseWidget {
  const EditorTemplateThirdWidget(
      {super.key, required super.templateData, required super.isMainContent});

  @override
  Widget buildTemplateContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        buildHeader(),
        buildContent(),
        buildFooter(),
      ],
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          templateData.data['user'],
          style: TextStyle(
              color: templateData.color,
              fontSize: super.isMainContent ? 18 : 4),
        ),
        Image.asset(
            templateData.opacity > 0.5
                ? 'assets/iatrain_logo_light.png'
                : 'assets/iatrain_logo_dark.png',
            scale: super.isMainContent ? 32 : 100),
      ],
    );
  }

  Widget buildContent() {
    var titleStyle = TextStyle(
        color: templateData.color, fontSize: super.isMainContent ? 12 : 4);
    var subtitleStyle = TextStyle(
        color: templateData.color, fontSize: super.isMainContent ? 18 : 4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(
        (templateData.data["titles"] as List).length,
        (index) {
          var title = templateData.data["titles"][index];
          var subtitle = templateData.data["data"][index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title, style: titleStyle),
                Text(subtitle, style: subtitleStyle),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Divider(),
        Text(
          templateData.data["datetime"],
          style: TextStyle(
              color: templateData.color,
              fontSize: super.isMainContent ? 18 : 4),
        ),
      ],
    );
  }
}
