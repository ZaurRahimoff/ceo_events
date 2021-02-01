import 'package:ceo_events/models/company.dart';
import 'package:ceo_events/models/event.dart';
import 'package:ceo_events/service/app_service.dart';
import 'package:ceo_events/widgets/hotel_theme.dart';
import 'package:ceo_events/widgets/icons.dart';
import 'package:ceo_events/widgets/parallax_page_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BottomSheetContent extends StatelessWidget {
  final AnimationController controller;

  final Event event;
  final Company company;

  BottomSheetContent({this.controller, this.event, this.company});

  @override
  Widget build(BuildContext context) {
    final themeData = HotelConceptThemeProvider.get();
    final double topPaddingMax = 44;
    final double topPaddingMin = MediaQuery.of(context).padding.top;
    double topMarginAnimatedValue = (1 - controller.value) * topPaddingMax * 2;
    double topMarginUpdatedValue = topMarginAnimatedValue <= topPaddingMin
        ? topPaddingMin
        : topMarginAnimatedValue;
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      child: Padding(
        padding: EdgeInsets.only(top: topMarginUpdatedValue),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ScrollConfiguration(
              behavior: OverScrollBehavior(),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                      maxWidth: constraints.maxWidth),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Hero(
                                          tag: event.logo,
                                          child: Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.all(10),
                                            height: 80,
                                            width: 80,
                                            padding: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(
                                                      0.5), //color of shadow
                                                  spreadRadius:
                                                      5, //spread radius
                                                  blurRadius: 7, // blur radius
                                                  offset: Offset(0,
                                                      2), // changes position of shadow
                                                  //first paramerter of offset is left-right
                                                  //second parameter is top to down
                                                ),
                                                //you can set more BoxShadow() here
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16)),
                                              child: Image.network(
                                                event.logo,
                                                height: 70,
                                                width: 70,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  event.title.replaceAll('<br/>', ''),
                                  softWrap: true,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: themeData.primaryColorLight,
                                      fontSize: 22),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: <Widget>[
                              Icon(
                                HotelBookingConcept.ic_location,
                                size: 20,
                                color: themeData.textTheme.display3.color,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                event.location,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Text(
                            "DETAILS",
                            style: TextStyle(
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            event.description.replaceAll("\\r\\n", "\n"),
                            style: TextStyle(height: 1.4),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "FACILITIES",
                            style: TextStyle(letterSpacing: 1),
                          ),
                          const SizedBox(height: 8),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: eventServiceProvider,
                          // ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Start in",
                                    style: TextStyle(letterSpacing: 1),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    event.beginTime,
                                    style: themeData.textTheme.display1,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "End in",
                                    style: TextStyle(letterSpacing: 1),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    event.endTime,
                                    style: themeData.textTheme.display1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 68),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
