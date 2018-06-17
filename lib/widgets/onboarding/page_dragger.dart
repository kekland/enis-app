import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'pager_indicator.dart';

class PageDragger extends StatefulWidget {
  final bool canDragLeftToRight;
  final bool canDragRightToLeft;
  final StreamController<SlideUpdate> slideUpdateStream;

  PageDragger({this.slideUpdateStream, this.canDragLeftToRight, this.canDragRightToLeft});
  @override
  _PageDraggerState createState() => new _PageDraggerState();
}

class _PageDraggerState extends State<PageDragger> {
  static const FULL_TRANSITION_PX = 300;

  Offset dragStart;
  SlideDirection slideDirection;
  double slidePercent;

  onDragStart(DragStartDetails details) {
    dragStart = details.globalPosition;
  }

  onDragUpdate(DragUpdateDetails details) {
    if (dragStart != null) {
      final newPosition = details.globalPosition;
      final dx = dragStart.dx - newPosition.dx;

      if (dx > 0.0 && widget.canDragRightToLeft) {
        slideDirection = SlideDirection.rightToLeft;
      } else if (dx < 0.0 && widget.canDragLeftToRight) {
        slideDirection = SlideDirection.leftToRight;
      } else {
        slideDirection = SlideDirection.none;
      }

      if (slideDirection != SlideDirection.none) {
        slidePercent = (dx / FULL_TRANSITION_PX).abs().clamp(0.0, 1.0);
      } else {
        slidePercent = 0.0;
      }
      widget.slideUpdateStream.add(new SlideUpdate(UpdateType.dragging, slideDirection, slidePercent, false));

      //print("Dragging $slideDirection at $slidePercent%");
    }
  }

  onDragEnd(DragEndDetails details) {
    widget.slideUpdateStream.add(new SlideUpdate(UpdateType.doneDragging, SlideDirection.none, 0.0, false));
    dragStart = null;
  }

  onTap() {
    if (widget.canDragRightToLeft) {
      widget.slideUpdateStream.add(new SlideUpdate(UpdateType.dragging, SlideDirection.rightToLeft, 0.0, false));

      widget.slideUpdateStream.add(new SlideUpdate(UpdateType.doneDragging, SlideDirection.none, 0.0, true));
    }
    dragStart = null;
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onHorizontalDragStart: onDragStart,
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
      onTap: onTap,
    );
  }
}

class AnimatedPageDragger {
  static const PERCENT_PER_MILLISECOND = 0.005;

  final slideDirection;
  final transitionGoal;

  AnimationController completionAnimationController;

  AnimatedPageDragger({
    this.slideDirection,
    this.transitionGoal,
    slidePercent,
    StreamController<SlideUpdate> slideUpdateStream,
    TickerProvider vsync,
  }) {
    final startSlidePercent = slidePercent;
    var endSlidePercent;
    var slideRemaining;
    var duration;

    if (transitionGoal == TransitionGoal.open) {
      endSlidePercent = 1.0;
      slideRemaining = 1.0 - slidePercent;
    } else {
      endSlidePercent = 0.0;
      slideRemaining = slidePercent;
    }

    duration = new Duration(
      milliseconds: (slideRemaining / PERCENT_PER_MILLISECOND).round(),
    );

    completionAnimationController = new AnimationController(
      vsync: vsync,
      duration: duration,
    )
      ..addListener(() {
        final slidePercent = lerpDouble(startSlidePercent, endSlidePercent, completionAnimationController.value);
        slideUpdateStream.add(new SlideUpdate(
          UpdateType.animating,
          slideDirection,
          slidePercent,
          false,
        ));
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          slideUpdateStream.add(new SlideUpdate(
            UpdateType.doneAnimating,
            slideDirection,
            endSlidePercent,
            false,
          ));
        }
      });
  }

  run() {
    completionAnimationController.forward(from: 0.0);
  }

  dispose() {
    completionAnimationController.dispose();
  }
}

enum TransitionGoal {
  open,
  close,
}

enum UpdateType {
  dragging,
  doneDragging,
  animating,
  doneAnimating,
}

class SlideUpdate {
  final slideDirection;
  final slidePercent;
  final updateType;
  final tapped;

  SlideUpdate(this.updateType, this.slideDirection, this.slidePercent, this.tapped);
}