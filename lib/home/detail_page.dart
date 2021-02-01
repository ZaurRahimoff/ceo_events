import 'dart:async';
import 'dart:ui';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ceo_events/configs/events_exception.dart';
import 'package:ceo_events/home/album_detail.dart';
import 'package:ceo_events/home/book_screen.dart';
import 'package:ceo_events/models/company.dart';
import 'package:ceo_events/models/event.dart';
import 'package:ceo_events/models/photogallery.dart';
import 'package:ceo_events/models/response_status.dart';
import 'package:ceo_events/models/visitor.dart';
import 'package:ceo_events/service/app_service.dart';
import 'package:ceo_events/utils/adapt.dart';
import 'package:ceo_events/utils/utils_importer.dart';
import 'package:ceo_events/widgets/BorderIcon.dart';
import 'package:ceo_events/widgets/customicon.dart';
import 'package:ceo_events/widgets/fade_route.dart';
import 'package:ceo_events/widgets/hotel_theme.dart';
import 'package:ceo_events/widgets/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rect_getter/rect_getter.dart';

import 'package:sliver_fab/sliver_fab.dart';
import 'package:flashy_tab_bar/flashy_tab_bar.dart';
import 'package:ceo_events/widgets/OptionButton.dart';
import 'package:ceo_events/utils/widget_functions.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';


var eventID;
var eventName;
String qrCode = '';



final companiesFutureProvider =
    FutureProvider.autoDispose<List<Company>>((ref) async {
  ref.maintainState = true;

  final companyService = ref.read(eventServiceProvider);
  final companies1 = await companyService.getCompanies(eventID);

  final companies = companies1.where((i) => i.projectId == eventID).toList();

  return companies;
});


final visitorsFutureProvider =
    FutureProvider.autoDispose<List<Visitor>>((ref) async {
  ref.maintainState = true;

  final visitorService = ref.read(eventServiceProvider);
  final visitors = await visitorService.getVisitors(eventID, eventName);

  // final visitors = visitors1.where((i) => i.projectId == eventID).toList();

  return visitors;
});


final sendPromoFutureProvider =
    FutureProvider.autoDispose<List<ResponseStatus>>((ref) async {
  ref.maintainState = true;

  final sendPromoService = ref.read(eventServiceProvider);
  final sendPromos = await sendPromoService.sendPromo(eventID, eventName, qrCode);

  //final companies = companies1.where((i) => i.projectId == eventID).toList();

  return sendPromos;
});


final albumsFutureProvider =
    FutureProvider.autoDispose<List<Photogallery>>((ref) async {
  ref.maintainState = true;

  final albumService = ref.read(eventServiceProvider);
  final albums = await albumService.getPhotoGallery(eventID);

  return albums;
});

class DetailPage extends StatefulWidget {

  
   final Event event;
   final Company company;
   final Visitor visitor;
   final Photogallery photo;

  DetailPage({Key key, @required this.event, this.company, this.visitor, this.photo}) : super(key: key);
  

  @override
  _SliverWithTabBarState createState() => _SliverWithTabBarState(event: event, company: company, visitor: visitor);
}

class _SliverWithTabBarState extends State<DetailPage> with TickerProviderStateMixin {
  

  final Event event;
  final Company company;
  final Visitor visitor;
  final Photogallery photo;

  final double bottomSheetCornerRadius = 50; 

  final Duration animationDuration = Duration(milliseconds: 600);
  final Duration delay = Duration(milliseconds: 300);
  GlobalKey rectGetterKey = RectGetter.createGlobalKey();
  Rect rect;

  TabController controller;

  Completer<GoogleMapController> _controller = Completer();

 void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }


  _SliverWithTabBarState({@required this.event, this.company, this.visitor, this.photo});

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
     _requestPermission();

    eventID = widget.event.projectID;
    eventName = widget.event.project;

    context.refresh(companiesFutureProvider);
    context.refresh(visitorsFutureProvider);
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


  // String _qrCounter, _qrValue = "";

  
  // Future _qrScan() async {
  //   _qrCounter= await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true, ScanMode.QR);

  //   setState(() {
  //     _qrValue=_qrCounter;
  //   });
  // }

      final client = Dio();

  Future<ResponseStatus> getData() async {
    final url = 'https://profile.iteca.az/sendpromo.json';

    try {
      final response = await client.post(url, data: {
        "apiKey": "4b4277bd1523915d0655ecc44992f2db",
                "projectID": 188,
                "project": "bakutel",
                "QRCode": "https://bakutel.az/company-VXg=.html",
        "ExhibitorID": 28,
        "ToID": 25748,
        "ToEmail": "zaur@ceo.az",
        "ToFullName": "Eldar Mustafayev"
      });

      if (response.statusCode == 200) {
        return ResponseStatus.fromJson(response.data);
      } else {
        print('${response.statusCode} : ${response.data.toString()}');
        throw response.statusCode;
      }
    } catch (error) {
      print(error);
    }
  }


  Future<void> _scanQR() async {
    
    String barcodeScanRes;


    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
     

      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    if(barcodeScanRes != null && barcodeScanRes != "-1") {
      DialogBuilder(context).showLoadingIndicator('Calculating');
      await getData();
      DialogBuilder(context).hideOpenDialog();
    }
     

    setState(() {
      qrCode = barcodeScanRes;
    });
  }







    _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();

    final info = statuses[Permission.location].toString();
    print(info);
  }


  @override
  Widget build(BuildContext context) {


    final Set<Marker> _markers = {};

    _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId((37.42796133580664 -122.085749655962).toString()),
        position: LatLng(double.parse(widget.event.latitude), double.parse(widget.event.longitude)),
        infoWindow: InfoWindow(
          title: widget.event.short_title,
          snippet: widget.event.location,
        ),
        icon: BitmapDescriptor.defaultMarker,
   ));


  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(double.parse(widget.event.latitude), double.parse(widget.event.longitude)),
    zoom: 14.4746,
  );

  final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(double.parse(widget.event.latitude), double.parse(widget.event.longitude)),
      tilt: 59.440717697143555,
      zoom: 15.151926040649414);

    final themeData = HotelConceptThemeProvider.get();
    final coverImageHeightCalc =
    MediaQuery.of(context).size.height / 2 + bottomSheetCornerRadius;

       Future<void> _goToTheLake() async {
   if(_requestPermission()!= null) {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
   }
  }
    
    return WillPopScope(
      onWillPop: () async {
        if (_bottomSheetController.value <= 0.5) {
          setState(() {
            bookButtonBottom = bookButtonBottomOffset;
          });
        }
        return true;
      },
      child: Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              collapsedHeight: 60,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 200.0,
                      width: double.infinity,
                      color: Colors.grey,
                      child: Image.network(widget.event.image_profile, fit: BoxFit.cover),
                    ),

                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: 
                        Expanded (
                        child: Row (children: [
                          Expanded (
                          flex: 1,
                           child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(5),
                            height: 75,
                            width: 75,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5), //border corner radius
                              boxShadow:[ 
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.5), //color of shadow
                                    spreadRadius: 5, //spread radius
                                    blurRadius: 7, // blur radius
                                    offset: Offset(0, 2), // changes position of shadow
                                    //first paramerter of offset is left-right
                                    //second parameter is top to down
                                ),
                                //you can set more BoxShadow() here
                                ],
                            ),
                          child: Column(
                              
                              children: [
                              Hero(
                                  tag: widget.event.logo,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(16)),
                                    child: FadeInImage.assetNetwork(
                                      width: 65,
                                      height: 65,
                                      fit: BoxFit.fitWidth,
                                      placeholder: ' ',
                                      image: widget.event.logo.toString() != 'null'
                                        ? widget.event.logo.toString()
                                        : ' ',
                                    ),
                                  )
                                ),

                              ],
                            ),
                           ), 

                           ),
                          ),

                          Expanded (
                            flex: 3,

                            child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  widget.event.title.replaceAll('<br/>', ''),
                                  style: TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.left,
                                ),
                              ),

                            ],
                          ),

                          ),

                        ],)   

                        
                        ),                     



                      ),


                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 2.0, left: 10.0, right: 10.0),
                      child: Text(
                         'Start date: ' + DateFormat.yMMMd().format(
                                            widget.event.beginDate),
                        style: TextStyle(fontSize: 15.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 2.0, left: 10.0, right: 10.0),
                      child: Text(
                         'End date: ' + DateFormat.yMMMd().format(
                                            widget.event.endDate),
                        style: TextStyle(fontSize: 15.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(Icons.share),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Icon(Icons.favorite),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              expandedHeight: 480.0,
              bottom: TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                isScrollable: true,
                tabs: [
                  Tab(text: 'Info'),
                  Tab(text: 'Exhibitors'),
                  Tab(text: 'Visitors'),
                  Tab(text: 'Photos'),
                  Tab(text: 'Services'),
                ],
                controller: controller,
              ),
            )
          ];
        },
        body: TabBarView(
          controller: controller,
          dragStartBehavior: DragStartBehavior.down,
            children: <Widget>[

              Container(
                height: 200,
                child: Expanded(
                  child:  Scaffold(
                            body: GoogleMap(
                              mapType: MapType.hybrid,
                              markers: _markers,
                              initialCameraPosition: _kGooglePlex,
                              onMapCreated: _onMapCreated,
                            ),
                            floatingActionButton: FloatingActionButton.extended(
                              onPressed: _goToTheLake,
                              label: Text('To the exhibition!'),
                              icon: Icon(Icons.arrow_right),
                            ),
                          ),
                ),
              ),



              Consumer(
                builder: (context, watch, child) => watch(companiesFutureProvider).when(
                  error: (e, s) {
                    if (e is EventsException) {
                      return _ErrorBodyCompany(message: e.message);
                    }
                    return _ErrorBodyCompany(
                        message: "Oops, something unexpected happened(None any Company)");
                  },
                  loading: () => Center(child: CircularProgressIndicator()),
                  data: (companies) {
                    return RefreshIndicator(
                      onRefresh: () {
                        return context.refresh(companiesFutureProvider);
                      },
                      child: Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.all(0.0),
                          itemCount: companies.length,
                          itemBuilder: (BuildContext context, int index) {
                            
                            print(companies.length);

                            return Card(  
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            elevation: 8,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(right: 16, left: 16, top: 5, bottom: 5),
                                    color: kBlueColor,
                                    child: Expanded(
                                    child: Column(
                                      children: <Widget>[


                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                          Expanded (child: 
                                              Text(companies[index].name.toString() != 'null'
                                                  ? companies[index].name.toString()
                                                  : ' ',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),


                                      ],
                                    ),
                                    ),
                                  ),

                                ExpansionTile (
                                  tilePadding: EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
                                  title: Expanded (                                  
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                     Text( companies[index].standN.toString() != 'null'
                                      ? 'Stand № ' + companies[index].standN.toString()
                                      : ' ',
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    Text( companies[index].site.toString() != 'null'
                                      ? companies[index].site.toString()
                                      : ' ',
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    ],
                                  ),
                                  ),
                                  leading: Hero(
                                    tag: 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(16)),
                                      child: FadeInImage.assetNetwork(
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.fitWidth,
                                        placeholder: 'assets/businessman2.png',
                                        image: companies[index].logoLink.toString() != 'null'
                                          ? companies[index].logoLink.toString()
                                          : ' ',
                                      ),
                                    )
                                  ),
                                  children: [ Container(
                                    padding: EdgeInsets.only(right: 16, left: 16, top: 0, bottom: 16),
                                    color: Colors.white,
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                                  child: FlatButton(onPressed: (){

                                                    showGeneralDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    barrierColor: Colors.black54, // space around dialog
                                                    transitionDuration: Duration(milliseconds: 800),
                                                    transitionBuilder: (context, a1, a2, child) {
                                                      return ScaleTransition(
                                                        scale: CurvedAnimation(
                                                            parent: a1,
                                                            curve: Curves.elasticOut,
                                                            reverseCurve: Curves.easeOutCubic),
                                                          child: CustomDialog( // our custom dialog
                                                          title: "Görüş sorğusu göndər",
                                                          content:
                                                              "Here goes the content of dialog. Here goes the content of dialog. Here goes the content of dialog.",
                                                          positiveBtnText: "Göndər",
                                                          negativeBtnText: "Bağla",
                                                          positiveBtnPressed: () {
                                                            // Do something here
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    pageBuilder: (BuildContext context, Animation animation,
                                                        Animation secondaryAnimation) {
                                                      return null;
                                                    },
                                                  );
                                                 }, 
                                                  child: Text(
                                                    "Görüş sorğusu göndər", 
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                    textColor: Colors.white,
                                                    color: kBlueColor,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                                  ),
                                                ),
                                              ),

                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                                  child: FlatButton(onPressed: (){}, 
                                                  child: Text(
                                                    "Mesaj sorğusu göndər",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                    textColor: Colors.white,
                                                    color: kBlueColor,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                                  ),
                                                ),
                                              ),

                                              

                                          ],
                                        ),

                                        Row(
                                          children: <Widget>[
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                                  child: FlatButton(onPressed: (){}, 
                                                  child: Text(
                                                    "Promo sorğusu göndər", 
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                    textColor: Colors.white,
                                                    color: kBlueColor,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                                  ),
                                                ),
                                              ),

                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                                  child: FlatButton(onPressed: (){}, 
                                                  child: Text(
                                                    "Məlumat",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                    textColor: Colors.white,
                                                    color: kBlueColor,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                                  ),
                                                ),
                                              ),

                                              

                                          ],
                                        ),



                                      ],
                                    ),
                                  ), 

                                  ],
                                  ),

                                ],
                              ),
                            ),
                          );



                          },
                        ),
                      ),
                    );
                  }),
              ),



              Consumer(
                builder: (context, watch, child) => watch(visitorsFutureProvider).when(
                  error: (e, s) {
                    if (e is EventsException) {
                      return _ErrorBodyVisitor(message: e.message);
                    }
                    return _ErrorBodyVisitor(
                        message: "Oops, something unexpected happened(None any Visitors)");
                  },
                  loading: () => Center(child: CircularProgressIndicator()),
                  data: (visitors) {
                    return RefreshIndicator(
                      onRefresh: () {
                        return context.refresh(visitorsFutureProvider);
                      },
                      child: Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.all(10.0),
                          itemCount: visitors.length,
                          itemBuilder: (BuildContext context, int index) {
                            print(visitors.length);
                            return Card(
                              elevation: 10,
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          child: Card(
                                            elevation: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                // CircleAvatar(
                                                //   child: Image.network(
                                                //       visitors[index]
                                                //                   .logoLink
                                                //                   .toString() !=
                                                //               'null'
                                                //           ? visitors[index]
                                                //               .logoLink
                                                //               .toString()
                                                //           : '',
                                                //       alignment:
                                                //           Alignment.topLeft),
                                                //   backgroundColor: Colors.white,
                                                //   maxRadius: 40,
                                                // ),
                                                SizedBox(
                                                  height: 15.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 250,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.0, right: 0),
                                            child: Flexible(
                                              child: Card(
                                                elevation: 0,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      visitors[index]
                                                          .name,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      visitors[index].position.toString() != 'null' && visitors[index].position.toString() !=  '-'
                                          ? visitors[index].position.toString()
                                          : ' ',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
              ),


              Consumer(
                builder: (context, watch, child) => watch(albumsFutureProvider).when(
                  error: (e, s) {
                    if (e is EventsException) {
                      return _ErrorBodyAlbum(message: e.message);
                    }
                    return _ErrorBodyAlbum(
                        message: "Oops, something unexpected happened(None any Album)");
                  },
                  loading: () => Center(child: CircularProgressIndicator()),
                  data: (albums) {
                    return RefreshIndicator(
                      onRefresh: () {
                        return context.refresh(albumsFutureProvider);
                      },
                   
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 2.0,
                          mainAxisSpacing: 2.0,
                        ),
                        itemCount: albums.length,
                        itemBuilder: (BuildContext context, int index) {
                          // Destination destination = destinations[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AlbumDetailPage(
                                  albums: albums[index],
                                ),
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(10.0),
                              width: 210.0,
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: <Widget>[
                                  // Positioned(
                                  //   bottom: 15.0,
                                  //   child: Container(
                                  //     height: 120.0,
                                  //     width: 200.0,
                                  //     decoration: BoxDecoration(
                                  //       color: Colors.white,
                                  //       borderRadius: BorderRadius.circular(10.0),
                                  //     ),
                                  //     child: Padding(
                                  //       padding: EdgeInsets.all(10.0),
                                  //       child: Column(
                                  //         mainAxisAlignment: MainAxisAlignment.end,
                                  //         crossAxisAlignment: CrossAxisAlignment.start,
                                  //         children: <Widget>[
                                  //           Text(
                                  //             albums[index].title,
                                  //             style: TextStyle(
                                  //               fontSize: 12.0,
                                  //               fontWeight: FontWeight.w600,
                                  //               letterSpacing: 1.2,
                                  //             ),
                                  //           ),
                                  //           Text(
                                  //             albums[index].photos.length.toString(),
                                  //             style: TextStyle(
                                  //               color: Colors.grey,
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        Hero(
                                          tag: albums[index].cover,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20.0),
                                            child: Image(
                                              height: 180.0,
                                              width: 180.0,
                                              image: NetworkImage(albums[index].cover),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(16)),
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
                                                                ),
                                        Positioned(
                                          left: 5.0,
                                          right: 5.0,
                                          bottom: 10.0,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              // Text(
                                              //   albums[index].title,
                                              //   style: TextStyle(
                                              //     color: Colors.white,
                                              //     fontSize: 14.0,
                                              //     fontWeight: FontWeight.w600,
                                              //     letterSpacing: 1.2,
                                              //   ),
                                              // ),
                                              Container(
                                                constraints: new BoxConstraints(
                                                maxWidth: MediaQuery.of(context).size.width - 84),
                                                child: Text(
                                                  albums[index].title,
                                                  style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.2,
                                                ),),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  // Icon(
                                                  //   FontAwesomeIcons.facebook,
                                                  //   size: 10.0,
                                                  //   color: Colors.white,
                                                  // ),
                                                  SizedBox(width: 5.0),
                                                  Text(
                                                    albums[index].photos.length.toString() + ' photos',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    
                    );
                  }),
              ),


              Center(
                child: Container(
                padding: const EdgeInsets.all(0.0),
                child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    RaisedButton(
                        onPressed: () async {
                          _scanQR();
                        },
                        child: const Text('QR Scan', style: TextStyle(fontSize: 20)),
                        color: Colors.blue,
                        textColor: Colors.white,
                        elevation: 5,
                      ),
                    Text('Scan result : $qrCode\n',
                      style: TextStyle(fontSize: 20))
                  ],
                ),
                ),
               ),
              ),


            ],
          ),
        
      ),
      
    ),
    );
  }
}



class CustomDialog extends StatelessWidget {
  final String title, content, positiveBtnText, negativeBtnText;
  final GestureTapCallback positiveBtnPressed;

  CustomDialog({
    @required this.title,
    @required this.content,
    @required this.positiveBtnText,
    @required this.negativeBtnText,
    @required this.positiveBtnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }


  
Widget _buildDialogContent(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  var error_message;

  return Stack(
    alignment: Alignment.topCenter,
    children: <Widget>[
      Container(  // Bottom rectangular box
        margin: EdgeInsets.only(top: 40), // to push the box half way below circle
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.only(top: 60, left: 20, right: 20), // spacing inside the box
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 16,
            ),

            Form(
            key: _formKey,
            child:
              TextFormField(
                initialValue: '',
                decoration: InputDecoration(
                  labelText: 'Sorğu',
                  errorText: error_message,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    error_message = 'Zəhmət olmasa sorğunuzu daxil edin';
                    return error_message;
                  }
                  return null;
                },
              ),
            ),



            ButtonBar(
              buttonMinWidth: 100,
              alignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Text(negativeBtnText),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                  child: Text(positiveBtnText),
                  onPressed: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
                    positiveBtnText;
                  }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      CircleAvatar( // Top Circle with icon
        maxRadius: 40.0,
        child: Icon(Icons.message),
      ),
    ],
  );
}

}




class DialogBuilder {
  DialogBuilder(this.context);

  final BuildContext context;

  void showLoadingIndicator([String text]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))
              ),
              backgroundColor: Colors.black87,
              content: LoadingIndicator(
                  text: text
              ),
            )
        );
      },
    );
  }

  void hideOpenDialog() {
    Navigator.of(context).pop();
  }
}


class LoadingIndicator extends StatelessWidget{
  LoadingIndicator({this.text = ''});

  final String text;

  @override
  Widget build(BuildContext context) {
    var displayedText = text;

    return Container(
        padding: EdgeInsets.all(16),
        color: Colors.black87,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _getLoadingIndicator(),
              _getHeading(context),
              _getText(displayedText)
            ]
        )
    );
  }

}



  Padding _getLoadingIndicator() {
    return Padding(
        child: Container(
            child: CircularProgressIndicator(
                strokeWidth: 3
            ),
            width: 32,
            height: 32
        ),
        padding: EdgeInsets.only(bottom: 16)
    );
  }

  Widget _getHeading(context) {
    return
      Padding(
          child: Text(
            'Please wait …',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16
            ),
            textAlign: TextAlign.center,
          ),
          padding: EdgeInsets.only(bottom: 4)
      );
  }

  Text _getText(String displayedText) {
    return Text(
      displayedText,
      style: TextStyle(
          color: Colors.white,
          fontSize: 14
      ),
      textAlign: TextAlign.center,
    );
  }






class _ErrorBodyAlbum extends StatelessWidget {
  const _ErrorBodyAlbum({
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


class _ErrorBodyVisitor extends StatelessWidget {
  const _ErrorBodyVisitor({
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
            onPressed: () => context.refresh(visitorsFutureProvider),
            child: Text("Try again"),
          ),
        ],
      ),
    );
  }
}


class _ErrorBodyCompany extends StatelessWidget {
  const _ErrorBodyCompany({
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
            onPressed: () => context.refresh(companiesFutureProvider),
            child: Text("Try again"),
          ),
        ],
      ),
    );
  }
}


class Mclipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 50.0);

    var controlpoint = Offset(10.0, size.height);
    var endpoint = Offset(size.width / 2, size.height);

    path.quadraticBezierTo(
        controlpoint.dx, controlpoint.dy, endpoint.dx, endpoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}




