import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

/// Enum for Dialog Type
enum CustomDialogType { CONFIRMATION, ACCEPT, DELETE, UPDATE, ADD, RETRY, NOTIFICATION, LOCATION }

/// dialog primary color
Color getDialogPrimaryColor(
    BuildContext context,
    CustomDialogType dialogType,
    Color? primaryColor,
    ) {
  if (primaryColor != null) return primaryColor;
  Color color;

  switch (dialogType) {
    case CustomDialogType.DELETE:
      color = Colors.red;
      break;
    case CustomDialogType.UPDATE:
      color = Colors.amber;
      break;
    case CustomDialogType.CONFIRMATION:
    case CustomDialogType.ADD:
    case CustomDialogType.RETRY:
    case CustomDialogType.NOTIFICATION:
    case CustomDialogType.LOCATION:
      color = Colors.blue;
      break;
    case CustomDialogType.ACCEPT:
      color = Colors.green;
      break;
  }
  return color;
}

/// build positive text for dialog
String getPositiveText(CustomDialogType dialogType) {
  String positiveText = '';

  switch (dialogType) {
    case CustomDialogType.NOTIFICATION:
    case CustomDialogType.LOCATION:
    case CustomDialogType.CONFIRMATION:
      positiveText = 'Yes';
      break;
    case CustomDialogType.DELETE:
      positiveText = 'Delete';
      break;
    case CustomDialogType.UPDATE:
      positiveText = 'Update';
      break;
    case CustomDialogType.ADD:
      positiveText = 'Add';
      break;
    case CustomDialogType.ACCEPT:
      positiveText = 'Accept';
      break;
    case CustomDialogType.RETRY:
      positiveText = 'Retry';
      break;
  }
  return positiveText;
}

/// Build title
String getTitle(CustomDialogType dialogType) {
  String titleText = '';

  switch (dialogType) {
    case CustomDialogType.NOTIFICATION:
    case CustomDialogType.LOCATION:
    case CustomDialogType.CONFIRMATION:
      titleText = 'Are you sure want to perform this action?';
      break;
    case CustomDialogType.DELETE:
      titleText = 'Do you want to delete?';
      break;
    case CustomDialogType.UPDATE:
      titleText = 'Do you want to update?';
      break;
    case CustomDialogType.ADD:
      titleText = 'Do you want to add?';
      break;
    case CustomDialogType.ACCEPT:
      titleText = 'Do you want to accept?';
      break;
    case CustomDialogType.RETRY:
      titleText = 'Click to retry';
      break;
  }
  return titleText;
}

/// get icon for dialog
Widget getIcon(CustomDialogType dialogType, {double? size}) {
  Icon icon;

  switch (dialogType) {
    case CustomDialogType.CONFIRMATION:
    case CustomDialogType.RETRY:
    case CustomDialogType.ACCEPT:
    case CustomDialogType.NOTIFICATION:
    case CustomDialogType.LOCATION:
      icon = Icon(Icons.done, size: size ?? 20, color: Colors.white);
      break;
    case CustomDialogType.DELETE:
      icon = Icon(Icons.delete_forever_outlined,
          size: size ?? 20, color: Colors.white);
      break;
    case CustomDialogType.UPDATE:
      icon = Icon(Icons.edit, size: size ?? 20, color: Colors.white);
      break;
    case CustomDialogType.ADD:
      icon = Icon(Icons.add, size: size ?? 20, color: Colors.white);
      break;
  }
  return icon;
}

/// Build center image for dialog
Widget? getCenteredImage(
    BuildContext context,
    CustomDialogType dialogType,
    Color? primaryColor,
    ) {
  Widget? widget;

  switch (dialogType) {
    case CustomDialogType.CONFIRMATION:
      widget = Container(
        decoration: BoxDecoration(
          color: getDialogPrimaryColor(context, dialogType, primaryColor)
              .withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(16),
        child: Icon(
          Icons.warning_amber_rounded,
          color: getDialogPrimaryColor(context, dialogType, primaryColor),
          size: 40,
        ),
      );
      break;
    case CustomDialogType.DELETE:
      widget = Container(
        decoration: BoxDecoration(
          color: getDialogPrimaryColor(context, dialogType, primaryColor)
              .withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(16),
        child: Icon(
          Icons.close,
          color: getDialogPrimaryColor(context, dialogType, primaryColor),
          size: 40,
        ),
      );
      break;
    case CustomDialogType.UPDATE:
      widget = Container(
        decoration: BoxDecoration(
          color: getDialogPrimaryColor(context, dialogType, primaryColor)
              .withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(16),
        child: Icon(
          Icons.edit_outlined,
          color: getDialogPrimaryColor(context, dialogType, primaryColor),
          size: 40,
        ),
      );
      break;
    case CustomDialogType.ADD:
    case CustomDialogType.ACCEPT:
      widget = Container(
        decoration: BoxDecoration(
          color: getDialogPrimaryColor(context, dialogType, primaryColor)
              .withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(16),
        child: Icon(
          Icons.done_outline,
          color: getDialogPrimaryColor(context, dialogType, primaryColor),
          size: 40,
        ),
      );
      break;
    case CustomDialogType.RETRY:
      widget = Container(
        decoration: BoxDecoration(
          color: getDialogPrimaryColor(
            context,
            dialogType,
            primaryColor,
          ).withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(16),
        child: Icon(Icons.refresh_rounded,
            color: getDialogPrimaryColor(
              context,
              dialogType,
              primaryColor,
            ),
            size: 40),
      );
      break;

    case CustomDialogType.NOTIFICATION:
      widget = Container(
        decoration: BoxDecoration(
          color: getDialogPrimaryColor(context, dialogType, primaryColor)
              .withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(16),
        child: Icon(
          Icons.notifications_none,
          color: getDialogPrimaryColor(context, dialogType, primaryColor),
          size: 40,
        ),
      );
      break;
    case CustomDialogType.LOCATION:
      widget = Container(
        decoration: BoxDecoration(
          color: getDialogPrimaryColor(context, dialogType, primaryColor)
              .withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(16),
        child: Icon(
          Icons.location_on_outlined,
          color: getDialogPrimaryColor(context, dialogType, primaryColor),
          size: 40,
        ),
      );
      break;
  }
  return widget;
}

/// placeholder for dialog
Widget defaultPlaceHolder(
    BuildContext context,
    CustomDialogType dialogType,
    double? height,
    double? width,
    Color? primaryColor, {
      Widget? child,
      ShapeBorder? shape,
    }) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: getDialogPrimaryColor(context, dialogType, primaryColor)
          .withOpacity(0.2),
    ),
    alignment: Alignment.center,
    child: child ?? getCenteredImage(context, dialogType, primaryColor),
  );
}

/// title for dialog
Widget buildTitleWidget(
    BuildContext context,
    CustomDialogType dialogType,
    Color? primaryColor,
    Widget? customCenterWidget,
    double height,
    double width,
    String? centerImage,
    ShapeBorder? shape,
    ) {
  if (customCenterWidget != null) {
    return Container(
      child: customCenterWidget,
      constraints: BoxConstraints(maxHeight: height, maxWidth: width),
    );
  } else {
    if (centerImage != null) {
      return Image.network(
        centerImage,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (_, object, stack) {
          log(object.toString());
          return defaultPlaceHolder(
            context,
            dialogType,
            height,
            width,
            primaryColor,
            shape: shape,
          );
        },
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return defaultPlaceHolder(
            context,
            dialogType,
            height,
            width,
            primaryColor,
            shape: shape,
            child: Loader(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    } else {
      return defaultPlaceHolder(
        context,
        dialogType,
        height,
        width,
        primaryColor,
        shape: shape,
      );
    }
  }
}

/// show confirm dialog box
Future<bool?> ownShowConfirmDialogCustom(
    BuildContext context, {
      required Function(BuildContext) onAccept,
      String? title,
      String? subTitle,
      String? positiveText,
      String? negativeText,
      String? centerImage,
      Widget? customCenterWidget,
      Color? primaryColor,
      Color? positiveTextColor,
      Color? negativeTextColor,
      ShapeBorder? shape,
      Function(BuildContext)? onCancel,
      bool barrierDismissible = true,
      double? height,
      double? width,
      bool cancelable = true,
      Color? barrierColor,
      CustomDialogType dialogType = CustomDialogType.CONFIRMATION,
      DialogAnimation dialogAnimation = DialogAnimation.DEFAULT,
      Duration? transitionDuration,
      Curve curve = Curves.easeInBack,
    }) async {
  hideKeyboard(context);

  return await showGeneralDialog(
    context: context,
    barrierColor: barrierColor ?? Colors.black54,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Container();
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: '',
    transitionDuration: transitionDuration ?? 400.milliseconds,
    transitionBuilder: (_, animation, secondaryAnimation, child) {
      return dialogAnimatedWrapperWidget(
        animation: animation,
        dialogAnimation: dialogAnimation,
        curve: curve,
        child: AlertDialog(
          shape: shape ?? dialogShape(),
          titlePadding: EdgeInsets.zero,
          backgroundColor: _.cardColor,
          elevation: defaultElevation.toDouble(),
          title: buildTitleWidget(
            _,
            dialogType,
            primaryColor,
            customCenterWidget,
            height ?? customDialogHeight,
            width ?? customDialogWidth,
            centerImage,
            shape,
          ).cornerRadiusWithClipRRectOnly(
              topLeft: defaultRadius.toInt(), topRight: defaultRadius.toInt()),
          content: Container(
            width: width ?? customDialogWidth,
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? getTitle(dialogType),
                  style: boldTextStyle(size: 16),
                  textAlign: TextAlign.center,
                ),
                8.height.visible(subTitle.validate().isNotEmpty),
                Text(
                  subTitle.validate(),
                  style: secondaryTextStyle(size: 16),
                  textAlign: TextAlign.center,
                ).visible(subTitle.validate().isNotEmpty),
                16.height,
                Row(
                  children: [
                    AppButton(
                      elevation: 0,
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: radius(defaultAppButtonRadius),
                        side: const BorderSide(color: viewLineColor),
                      ),
                      color: _.cardColor,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.close,
                            color: textPrimaryColorGlobal,
                            size: 20,
                          ),
                          6.width,
                          Text(
                            negativeText ?? 'Cancel',
                            style: boldTextStyle(
                                color: negativeTextColor ??
                                    textPrimaryColorGlobal),
                          ),
                        ],
                      ).fit(),
                      onTap: () {
                        if (cancelable) finish(_, false);

                        onCancel?.call(_);
                      },
                    ).expand(),
                    16.width,
                    AppButton(
                      elevation: 0,
                      color: getDialogPrimaryColor(_, dialogType, primaryColor),
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: radius(defaultAppButtonRadius),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          getIcon(dialogType),
                          6.width,
                          Text(
                            positiveText ?? getPositiveText(dialogType),
                            style: boldTextStyle(
                                color: positiveTextColor ?? Colors.white),
                          ),
                        ],
                      ).fit(),
                      onTap: () {
                        onAccept.call(_);

                        if (cancelable) finish(_, true);
                      },
                    ).expand(),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
