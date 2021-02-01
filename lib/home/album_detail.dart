import 'dart:ui';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ceo_events/configs/events_exception.dart';
import 'package:ceo_events/home/album_image_detail.dart';
import 'package:ceo_events/home/book_screen.dart';
import 'package:ceo_events/models/company.dart';
import 'package:ceo_events/models/event.dart';
import 'package:ceo_events/models/photogallery.dart';
import 'package:ceo_events/service/app_service.dart';
import 'package:ceo_events/utils/adapt.dart';
import 'package:ceo_events/utils/utils_importer.dart';
import 'package:ceo_events/widgets/BorderIcon.dart';
import 'package:ceo_events/widgets/customicon.dart';
import 'package:ceo_events/widgets/fade_route.dart';
import 'package:ceo_events/widgets/hotel_theme.dart';
import 'package:ceo_events/widgets/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rect_getter/rect_getter.dart';

import 'package:sliver_fab/sliver_fab.dart';
import 'package:flashy_tab_bar/flashy_tab_bar.dart';
import 'package:ceo_events/widgets/OptionButton.dart';
import 'package:ceo_events/utils/widget_functions.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:carousel_slider/carousel_slider.dart';


var photos;
var eventID;
var albumID;

final albumsFutureProvider =
    FutureProvider.autoDispose<List<Photogallery>>((ref) async {
  ref.maintainState = true;

  final albumService = ref.read(eventServiceProvider);
  final albums = await albumService.getPhotoGallery(eventID);

  
  final albums1 = albums.where((i) => i.album == albumID).toList();
  

  for (int i = 0; i < albums1.length; i++) {
    photos = albums1[i].photos[i].toString();
  }

  return albums1;
});

class AlbumDetailPage extends StatefulWidget {

   final Photogallery albums;

  AlbumDetailPage({Key key, this.albums}) : super(key: key);
  

  @override
  _SliverWithTabBarState createState() => _SliverWithTabBarState(albums: albums);
}

class _SliverWithTabBarState extends State<AlbumDetailPage> with TickerProviderStateMixin {

 final Photogallery albums;

  final double bottomSheetCornerRadius = 50; 

  final Duration animationDuration = Duration(milliseconds: 600);
  final Duration delay = Duration(milliseconds: 300);
  GlobalKey rectGetterKey = RectGetter.createGlobalKey();
  Rect rect;

  TabController controller;

  _SliverWithTabBarState({this.albums});

  static double bookButtonBottomOffset = -60;
  double bookButtonBottom = bookButtonBottomOffset;
  AnimationController _bottomSheetController;
  //RefreshIndicator refreshIndicator;

   void _onTap() {
    setState(() => rect = RectGetter.getRectFromKey(rectGetterKey));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() =>
          rect = rect.inflate(1.3 * MediaQuery.of(context).size.longestSide));
      Future.delayed(animationDuration + delay, _goToNextPage);
    });
  }

  void _goToNextPage() {
    Navigator.of(context)
        .push(FadeRouteBuilder(page: BookScreen()))
        .then((_) => setState(() => rect = null));
  }


  @override
  void initState() {
    super.initState();
    // eventID = widget.event.projectID;

    // context.refresh(companiesFutureProvider);
    context.refresh(albumsFutureProvider);

    controller = TabController(length: 5, vsync: this);
    _bottomSheetController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    Future.delayed(Duration(milliseconds: 700)).then((v) {
      setState(() {
        bookButtonBottom = 0;
      });
    });
  }



  
  @override
  Widget build(BuildContext context) {



    photos = widget.albums.photos;
    albumID = widget.albums.album;

    final phts = photos.map((item) => item).toList();
    final phts1 = phts.map((item) => item).toList();

    var phts2;
    


    for (var i = 0; i < phts1.length; i++) {

    print(phts1[i].toString());

phts2 = phts1[i].toString();

    }


    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    final double padding = 25;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                backgroundColor: Colors.blue,
                shadowColor: Colors.pink,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(widget.albums.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontFamily: "SF-Pro-Display-Bold"),),
                  background: ClipPath(
                  child: Container(
                    height: 370.0,
                    // decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    //   BoxShadow(
                    //       color: Colors.black12,
                    //       offset: Offset(0.0, 10.0),
                    //       blurRadius: 10.0)
                    // ]),
   
                    child: Stack(
                      children: <Widget>[
                        Hero(
                          tag: widget.albums.cover,
                          child: Container(
                          height: double.infinity,
                          width: double.infinity,
                            child: ClipRRect(
                              child: Image.network(
                                widget.albums.cover,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                const Color(0x00000000),
                                const Color(0xDD000000)
                              ],
                                  stops: [
                                0.0,
                                0.9
                              ],
                              begin: FractionalOffset(0.0, 0.0),
                              end: FractionalOffset(0.0, 1.0))),
                        )
                      ],
                    ),
                  ),
                ),





                ),
              ),
          ];
        },
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [


                Padding(
                padding: EdgeInsets.all(10),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                  ),
                itemCount: photos.length,
                itemBuilder: (BuildContext context, int index) {
                  final movie = photos[index];

                  return PortfolioGalleryImageWidget(
                    imagePath: photos[index], 
                    onImageTap: () => Navigator.push(
                      context, 
                      _createGalleryDetailRoute(photos, index),
                    ),
                  );
                //   return GestureDetector(
                //     // onTap: () {
                //     //   Navigator.push(context, MaterialPageRoute(builder: (context) => SingleMovie(movie)));
                //     // },

                //      onTap: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => const PortfolioGalleryImageWidget(
                //               imagePath: imagePath, 
                //               onImageTap: () => Navigator.push(
                //                 context, 
                //                 _createGalleryDetailRoute(imagePath, index),
                //               ),
                //         ),
                //       ),
                //       );
                //     },

                //   child: Card(
                //     elevation: 10,
                //     child: Image.network(movie, fit: BoxFit.cover,),
                    
                //   ),
                // );
              },

            ),

            ),

            

          ],
        ),
      ),
    ),
  );
}

MaterialPageRoute _createGalleryDetailRoute(
  List<String> imagePath, int index) {
    return MaterialPageRoute(
      builder: (context) => PortfolioGalleryDetailPage(imagePaths: imagePath, currentIndex: index),
      );
  }



  //   List<Widget> loadQuestions(Photogallery photos) {
  //   List<Widget> questionCell = [];
  //   for (int i = 0; i < photos.photos.length; i++) {
  //     questionCell.add(Card(
  //       color: Colors.white,
  //       child: InkWell(
  //         child: Image(
  //             image: NetworkImage(photos.photos[i].toString())),
  //       ),
  //     ));
  //   }
  //   return questionCell;
  // }



}





class PortfolioGalleryImageWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onImageTap;

  const PortfolioGalleryImageWidget(
      {Key key, @required this.imagePath, @required this.onImageTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(2, 2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: NetworkImage(imagePath),
            fit: BoxFit.cover,
            child: InkWell(onTap: onImageTap),
          ),
        ),
      ),
    );
  }
}



class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    Key key,
    @required this.message,
  })  : assert(message != null, 'A non-null String must be provided'),
        super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          ElevatedButton(
            onPressed: () => context.refresh(albumsFutureProvider),
            child: Text("Try again"),
          ),
        ],
      ),
    );
  }
}




