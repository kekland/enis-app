import 'dart:async';

import 'package:enis_new/api/imko/imko_data.dart';
import 'package:enis_new/api/jko/jko_data.dart';
import 'package:enis_new/classes/assessment.dart';
import 'package:enis_new/widgets/imko/imko_subject_widget.dart';
import 'package:enis_new/widgets/jko/jko_subject_widget.dart';
import 'package:enis_new/widgets/onboarding/page.dart';
import 'package:enis_new/widgets/onboarding/page_dragger.dart';
import 'package:enis_new/widgets/onboarding/pager_indicator.dart';
import 'package:enis_new/widgets/page_reveal_widget.dart';
import 'package:flutter/material.dart';

final pages = [
  new PageViewModel(
    color: Colors.teal,
    hero: new Stack(
      children: <Widget>[
        new Transform(
          transform: new Matrix4.translationValues(0.0, -80.0, 0.0),
          child: new ScaleTransition(
            scale: AlwaysStoppedAnimation(0.5),
            child: JKOSubjectWidget(
              tappable: false,
              destroy: false,
              viewModel: JKOSubjectViewModel(
                subject: new JKOSubject.createNew(
                  id: '0',
                  diaryId: '0',
                  name: 'Kazakhstan in Modern World',
                  quarter: 1,
                  grade: 'A',
                  points: 0.8542,
                  evaluations: null,
                ),
              ),
            ),
          ),
        ),
        IMKOSubjectWidget(
          tappable: false,
          destroy: false,
          viewModel: IMKOSubjectViewModel(
            subject: new IMKOSubject.createNew(
              id: 0,
              name: 'English',
              formative: Assessment(current: 13, maximum: 14),
              summative: Assessment(current: 34, maximum: 40),
              quarter: 1,
              grade: 'A',
            ),
          ),
        ),
      ],
    ),
    title: 'View your marks!',
    body: 'Now without bugs :P',
    pagerIcon: Icons.cloud,
  ),
  new PageViewModel(
    color: Colors.lightBlue,
    hero: IMKOSubjectWidget(
      viewModel: IMKOSubjectViewModel(
        subject: new IMKOSubject.createNew(
          id: 0,
          name: 'English',
          formative: Assessment(current: 13, maximum: 14),
          summative: Assessment(current: 34, maximum: 40),
          quarter: 1,
          grade: 'A',
        ),
      ),
    ),
    title: 'Images',
    body: 'You can also attach images into your pastas!',
    pagerIcon: Icons.image,
  ),
  new PageViewModel(
    color: Colors.lime,
    hero: IMKOSubjectWidget(
      viewModel: IMKOSubjectViewModel(
        subject: new IMKOSubject.createNew(
          id: 0,
          name: 'English',
          formative: Assessment(current: 13, maximum: 14),
          summative: Assessment(current: 34, maximum: 40),
          quarter: 1,
          grade: 'A',
        ),
      ),
    ),
    title: 'Sharing',
    body: 'You can share your pastas with your friends, coworker, or even with your cat!',
    pagerIcon: Icons.share,
  ),
];

class OnboardingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new OnboardingPageState();
  }
}

class OnboardingPageState extends State<OnboardingPage> with TickerProviderStateMixin {
  StreamController<SlideUpdate> slideUpdateStream;
  AnimatedPageDragger dragger;

  int activeIndex = 0;
  int nextPageIndex = 1;
  SlideDirection slideDirection = SlideDirection.none;
  double slidePercent = 0.0;
  OnboardingPageState() {
    slideUpdateStream = new StreamController<SlideUpdate>();

    slideUpdateStream.stream.listen((SlideUpdate event) {
      setState(() {
        if (event.updateType == UpdateType.dragging) {
          slideDirection = event.slideDirection;
          slidePercent = event.slidePercent;

          if (slideDirection == SlideDirection.leftToRight) {
            nextPageIndex = activeIndex - 1;
          } else if (slideDirection == SlideDirection.rightToLeft) {
            nextPageIndex = activeIndex + 1;
          } else {
            nextPageIndex = activeIndex;
          }
          nextPageIndex.clamp(0, pages.length - 1);
        } else if (event.updateType == UpdateType.doneDragging) {
          if (slidePercent > 0.5 || event.tapped) {
            dragger = new AnimatedPageDragger(
              slideDirection: slideDirection,
              slidePercent: slidePercent,
              transitionGoal: TransitionGoal.open,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );
          } else {
            dragger = new AnimatedPageDragger(
              slideDirection: slideDirection,
              slidePercent: slidePercent,
              transitionGoal: TransitionGoal.close,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );

            nextPageIndex = activeIndex;
          }
          dragger.run();
        } else if (event.updateType == UpdateType.animating) {
          slideDirection = event.slideDirection;
          slidePercent = event.slidePercent;
        } else if (event.updateType == UpdateType.doneAnimating) {
          activeIndex = nextPageIndex;
          slideDirection = SlideDirection.none;
          slidePercent = 0.0;
          dragger.dispose();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          new Page(
            viewModel: pages[activeIndex],
            percentVisible: 1.0 - slidePercent,
          ),
          new PageRevealWidget(
            clickPosition: null,
            revealPercent: slidePercent,
            child: new Page(
              viewModel: pages[nextPageIndex],
              percentVisible: slidePercent,
            ),
          ),
          new PagerIndicator(
            viewModel: PagerIndicatorViewModel(
              pages: pages,
              activeIndex: activeIndex,
              slideDirection: slideDirection,
              slidePercent: slidePercent,
            ),
          ),
          new PageDragger(
            slideUpdateStream: slideUpdateStream,
            canDragLeftToRight: activeIndex > 0,
            canDragRightToLeft: activeIndex < pages.length - 1,
          ),
        ],
      ),
    );
  }
}
