import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:rate_my_app/src/core.dart';
import 'package:rate_my_app/src/style.dart';

/// A simple dialog button click listener.
typedef RateMyAppDialogButtonClickListener = bool Function(
    RateMyAppDialogButton button);

/// Validates a state when called in a function.
typedef Validator = bool Function();

/// Allows to change the default dialog content.
typedef DialogContentBuilder = Widget Function(
    BuildContext context, Widget defaultContent);

/// Allows to dynamically build actions.
typedef DialogActionsBuilder = List<Widget> Function(BuildContext context);

/// Allows to dynamically build actions according to the specified rating.
typedef StarDialogActionsBuilder = List<Widget> Function(
    BuildContext context, double? stars);

/// The Android Rate my app dialog.
class RateMyAppDialog extends StatelessWidget {
  /// The Rate my app instance.
  final RateMyApp rateMyApp;

  /// The dialog's title.
  final String title;

  /// The dialog's message.
  final String message;

  /// The content builder.
  final DialogContentBuilder contentBuilder;

  /// The actions builder.
  final DialogActionsBuilder? actionsBuilder;

  /// The dialog's rate button.
  final String rateButton;

  /// The dialog's no button.
  final String noButton;

  /// The dialog's later button.
  final String laterButton;

  /// The buttons listener.
  final RateMyAppDialogButtonClickListener? listener;

  /// The dialog's style.
  final DialogStyle dialogStyle;

  /// Creates a new Rate my app dialog.
  const RateMyAppDialog(
    this.rateMyApp, {
    required this.title,
    required this.message,
    required this.contentBuilder,
    this.actionsBuilder,
    required this.rateButton,
    required this.noButton,
    required this.laterButton,
    this.listener,
    required this.dialogStyle,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = SingleChildScrollView(
      child: Padding(
        padding: dialogStyle.messagePadding,
        child: Text(
          message,
          style: dialogStyle.messageStyle,
          textAlign: dialogStyle.messageAlign,
        ),
      ),
    );

    return AlertDialog(
      title: Padding(
        padding: dialogStyle.titlePadding,
        child: Text(
          title,
          style: dialogStyle.titleStyle,
          textAlign: dialogStyle.titleAlign,
        ),
      ),
      content: contentBuilder(context, content),
      contentPadding: dialogStyle.contentPadding,
      shape: dialogStyle.dialogShape,
      actions: (actionsBuilder ?? _defaultActionsBuilder)(context),
    );
  }

  List<Widget> _defaultActionsBuilder(BuildContext context) => [
        RateMyAppNoButton(
          rateMyApp,
          text: noButton,
          validator: () =>
              listener == null || listener!(RateMyAppDialogButton.no),
        ),
        RateMyAppLaterButton(
          rateMyApp,
          text: laterButton,
          validator: () =>
              listener == null || listener!(RateMyAppDialogButton.later),
        ),
        RateMyAppRateButton(
          rateMyApp,
          text: rateButton,
          validator: () =>
              listener == null || listener!(RateMyAppDialogButton.rate),
        ),
      ];
}

/// The Rate my app star dialog.
class RateMyAppStarDialog extends StatefulWidget {
  /// The Rate my app instance.
  final RateMyApp rateMyApp;

  /// The dialog's title.
  final String title;

  /// The dialog's message.
  final String message;

  /// The content builder.
  final DialogContentBuilder contentBuilder;

  /// The rating changed callback.
  final StarDialogActionsBuilder? actionsBuilder;

  /// The dialog's style.
  final DialogStyle dialogStyle;

  /// The smooth star rating style.
  final StarRatingOptions starRatingOptions;

  /// Creates a new Rate my app star dialog.
  const RateMyAppStarDialog(
    this.rateMyApp, {
    required this.title,
    required this.message,
    required this.contentBuilder,
    this.actionsBuilder,
    required this.dialogStyle,
    required this.starRatingOptions,
  });

  @override
  State<StatefulWidget> createState() => _RateMyAppStarDialogState();

  /// Used when there is no onRatingChanged callback.
  List<Widget> _defaultOnRatingChanged(BuildContext context, double? rating) =>
      [
        RateMyAppRateButton(
          rateMyApp,
          text: 'RATE',
        ),
        RateMyAppLaterButton(
          rateMyApp,
          text: 'MAYBE LATER',
        ),
        RateMyAppNoButton(
          rateMyApp,
          text: 'NO',
        ),
      ];
}

/// The Rate my app star dialog state.
class _RateMyAppStarDialogState extends State<RateMyAppStarDialog> {
  /// The current rating.
  late double currentRating;

  @override
  void initState() {
    super.initState();
    currentRating = widget.starRatingOptions.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: widget.dialogStyle.messagePadding,
            child: Text(
              widget.message,
              style: widget.dialogStyle.messageStyle,
              textAlign: widget.dialogStyle.messageAlign,
            ),
          ),
          createRatingBar(),
        ],
      ),
    );

    return AlertDialog(
      title: Padding(
        padding: widget.dialogStyle.titlePadding,
        child: Text(
          widget.title,
          style: widget.dialogStyle.titleStyle,
          textAlign: widget.dialogStyle.titleAlign,
        ),
      ),
      content: widget.contentBuilder(context, content),
      contentPadding: widget.dialogStyle.contentPadding,
      shape: widget.dialogStyle.dialogShape,
      actions: (widget.actionsBuilder ?? widget._defaultOnRatingChanged)(
          context, currentRating),
    );
  }

  /// Creates the rating bar.
  RatingBar createRatingBar() {
    if (widget.starRatingOptions.itemBuilder == null) {
      return RatingBar(
        onRatingUpdate: (rating) {
          setState(() => currentRating = rating);
        },
        ratingWidget: widget.starRatingOptions.ratingWidget ??
            createDefaultRatingWidget(),
        initialRating: widget.starRatingOptions.initialRating,
        minRating: widget.starRatingOptions.minRating,
        allowHalfRating: widget.starRatingOptions.allowHalfRating,
        itemPadding: widget.starRatingOptions.itemPadding,
        itemSize: widget.starRatingOptions.itemSize,
        itemCount: widget.starRatingOptions.itemCount,
        glow: widget.starRatingOptions.glow,
        glowRadius: widget.starRatingOptions.glowRadius,
        tapOnlyMode: widget.starRatingOptions.tapOnlyMode,
        wrapAlignment: widget.starRatingOptions.wrapAlignment,
      );
    }
    return RatingBar.builder(
      onRatingUpdate: (rating) {
        setState(() => currentRating = rating);
      },
      itemBuilder: widget.starRatingOptions.itemBuilder!,
      initialRating: widget.starRatingOptions.initialRating,
      minRating: widget.starRatingOptions.minRating,
      allowHalfRating: widget.starRatingOptions.allowHalfRating,
      itemPadding: widget.starRatingOptions.itemPadding,
      itemSize: widget.starRatingOptions.itemSize,
      itemCount: widget.starRatingOptions.itemCount,
      glow: widget.starRatingOptions.glow,
      glowRadius: widget.starRatingOptions.glowRadius,
      tapOnlyMode: widget.starRatingOptions.tapOnlyMode,
      wrapAlignment: widget.starRatingOptions.wrapAlignment,
    );
  }

  /// Creates the default rating widget.
  RatingWidget createDefaultRatingWidget() => RatingWidget(
        full: Icon(
          Icons.star,
          color: Colors.orangeAccent,
          size: widget.starRatingOptions.itemSize,
        ),
        half: Icon(
          Icons.star_half,
          color: Colors.orangeAccent,
          size: widget.starRatingOptions.itemSize,
        ),
        empty: Icon(
          Icons.star_border,
          color: Colors.orangeAccent,
          size: widget.starRatingOptions.itemSize,
        ),
      );
}

/// A Rate my app dialog button with a text, a validator and a callback.
abstract class _RateMyAppDialogButton extends StatelessWidget {
  /// The Rate my app instance.
  final RateMyApp rateMyApp;

  /// The button text.
  final String text;

  /// The state validator (whether this button should have an effect).
  final Validator? validator;

  /// Called when the action has been executed.
  final VoidCallback? callback;

  /// Creates a new Rate my app button widget instance.
  const _RateMyAppDialogButton(
    this.rateMyApp, {
    required this.text,
    this.validator = _validatorTrue,
    this.callback,
  });

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: () async {
          if (validator != null && !validator!()) {
            return;
          }

          await onButtonClicked(context);
          if (callback != null) {
            callback!();
          }
        },
        child: Text(text),
      );

  /// Triggered when a button has been clicked.
  Future<void> onButtonClicked(BuildContext context);

  /// A validator that always return true.
  static bool _validatorTrue() => true;
}

/// The Rate my app "rate" button widget.
class RateMyAppRateButton extends _RateMyAppDialogButton {
  /// Creates a new Rate my app "rate" button widget instance.
  const RateMyAppRateButton(
    RateMyApp rateMyApp, {
    required String text,
    Validator? validator,
    VoidCallback? callback,
  }) : super(
          rateMyApp,
          text: text,
          validator: validator,
          callback: callback,
        );

  @override
  Future<void> onButtonClicked(BuildContext context) async {
    await rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
    Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.rate);
    await rateMyApp.launchStore();
  }
}

/// The Rate my app "later" button widget.
class RateMyAppLaterButton extends _RateMyAppDialogButton {
  /// Creates a new Rate my app "later" button widget instance.
  const RateMyAppLaterButton(
    RateMyApp rateMyApp, {
    required String text,
    Validator? validator,
    VoidCallback? callback,
  }) : super(
          rateMyApp,
          text: text,
          validator: validator,
          callback: callback,
        );

  @override
  Future<void> onButtonClicked(BuildContext context) async {
    await rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed);
    Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.later);
  }
}

/// The Rate my app "no" button widget.
class RateMyAppNoButton extends _RateMyAppDialogButton {
  /// Creates a new Rate my app "no" button widget instance.
  const RateMyAppNoButton(
    RateMyApp rateMyApp, {
    required String text,
    Validator? validator,
    VoidCallback? callback,
  }) : super(
          rateMyApp,
          text: text,
          validator: validator,
          callback: callback,
        );

  @override
  Future<void> onButtonClicked(BuildContext context) async {
    await rateMyApp.callEvent(RateMyAppEventType.noButtonPressed);
    Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.no);
  }
}

/// Represents a Rate my app dialog button.
enum RateMyAppDialogButton {
  /// The "rate" button.
  rate,

  /// The "later" button.
  later,

  /// The "no" button.
  no,
}
