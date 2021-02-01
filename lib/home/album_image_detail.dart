import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ceo_events/home/album_detail.dart';
import 'package:ceo_events/models/event.dart';
import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share/share.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';



class PortfolioGalleryDetailPage extends StatefulWidget {
  final List<String> imagePaths;
  final int currentIndex;
  Event event; 

  PortfolioGalleryDetailPage(
      {Key key, @required this.imagePaths, @required this.currentIndex, this.event})
      : super(key: key);

  @override
  _PortfolioGalleryDetailPageState createState() =>
      _PortfolioGalleryDetailPageState();
}

class _PortfolioGalleryDetailPageState
    extends State<PortfolioGalleryDetailPage> {
  int _currentIndex;
  PageController _pageController;
  Event event; 
  
  static GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _requestPermission();

    _currentIndex = widget.currentIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }


  @override
  Widget build(BuildContext context) {


// var dio = Dio();
// var httpClient = new HttpClient();
// Future<Null> _launched;

// Future<File> _downloadFile(String url, String filename) async {
//   var request = await httpClient.getUrl(Uri.parse(url));
//   var response = await request.close();
//   var bytes = await consolidateHttpClientResponseBytes(response);
//   String dir = (await getTemporaryDirectory()).path;
//   File file = new File('$dir/$filename');
//   await file.writeAsBytes(bytes);
//   return file;
// }


                  
// Future<File> createFile(String url, String savePath) async {
//     try {
//       /// setting filename 
//       final filename = "temp.jpg";

//       /// getting application doc directory's path in dir variable
//       String dir = (await getApplicationDocumentsDirectory()).path;

//       /// if `filename` File exists in local system then return that file.
//       /// This is the fastest among all.
//       if (await File('$dir/$filename').exists()) return File('$dir/$filename');

//       ///if file not present in local system then fetch it from server

//       //String url = widget.imagePaths[_currentIndex];

//       /// requesting http to get url
//       var request = await HttpClient().getUrl(Uri.parse(url));

//       /// closing request and getting response
//       var response = await request.close();

//       /// getting response data in bytes
//       var bytes = await consolidateHttpClientResponseBytes(response);

//       /// generating a local system file with name as 'filename' and path as '$dir/$filename'
//       File file = new File('$dir/$filename');

//       /// writing bytes data of response in the file.
//       await file.writeAsBytes(bytes);

//       /// returning file.
//       return file;
//     }

//     /// on catching Exception return null
//     catch (err) {
//       print(err);
//       return null;
//     }
//   }


//  Future download2(Dio dio, String url, String savePath) async {
//     try {
//       Response response = await dio.get(
//         url, 
//         // onReceiveProgress: showDownloadProgress,
//         //Received data with List<int>
//         options: Options(
//             responseType: ResponseType.bytes,
//             followRedirects: false,
//             validateStatus: (status) { return status < 500; },
//             ),
//       );
//       print(response.headers);
//       File file = File(savePath);
//       var raf = file.openSync(mode: FileMode.write);
//       // response.data is List<int> type
//       raf.writeFromSync(response.data);
//       await raf.close();
//     } catch (e) {
//       print(e);
//     }
//   }


  Future<Null> urlFileShare(String url) async {

    final RenderBox box = context.findRenderObject();
    if (Platform.isAndroid) {
      //var url = 'https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg';
      var response = await get(url);
      final documentDirectory = (await getExternalStorageDirectory()).path;
      File imgFile = new File('$documentDirectory/flutter.png');
      imgFile.writeAsBytesSync(response.bodyBytes);
      print(documentDirectory);

      Share.shareFile(File('$documentDirectory/flutter.png'),
          subject: 'URL File Share',
          text: 'Hello, check your share files!',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      Share.share('Hello, check your share files!',
          subject: 'URL File Share',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }

  }

    return RepaintBoundary(
      key: _globalKey,
      child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 20),
            icon: FaIcon(FontAwesomeIcons.download),
            onPressed: () async {
                  // var tempDir = await getTemporaryDirectory();
                  // String fullPath = "boo2.jpg'";
                  // print('full path ${fullPath}');

                  // _downloadFile(widget.imagePaths[_currentIndex], fullPath);
                  // print(widget.imagePaths[_currentIndex]);
                  // print(tempDir);
                  
          
                var response = await Dio().get(widget.imagePaths[_currentIndex],
                    options: Options(responseType: ResponseType.bytes));
                final result = await ImageGallerySaver.saveImage(
                    Uint8List.fromList(response.data),
                    quality: 60,
                    name: 'IMG' + '_' + DateFormat.Hms().format(DateTime.now()).toString().replaceAll(':', ''));
                print(result);
                _toastInfo("$result");


               
                },
          ),
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 20),
            icon: FaIcon(FontAwesomeIcons.shareAlt),
            onPressed: () async {                  
               urlFileShare(widget.imagePaths[_currentIndex]);
                },
          ),
        ],
      ),
      body: _buildContent(),
    ),
    );
  }



    _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
    _toastInfo(info);
  }

 _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }

  Widget _buildContent() {
    return Stack(
      children: <Widget>[
        _buildPhotoViewGallery(),
        _buildIndicator(),
      ],
    );
  }

  Widget _buildIndicator() {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      // child: _buildDottedIndicator(),
      child: _buildImageCarouselSlider(),
    );
  }

  Widget _buildImageCarouselSlider() {
    return CarouselSlider.builder(
     
      itemCount: widget.imagePaths.length,
      itemBuilder: (BuildContext context, int index) {
        return PortfolioGalleryImageWidget(
          imagePath: widget.imagePaths[index],
          onImageTap: () => _pageController.jumpToPage(index),
        );
      },
      options: CarouselOptions(
        height: 100,
        viewportFraction: 0.21,
        enlargeCenterPage: true,
        initialPage: _currentIndex,
        pageSnapping: true,
        // autoPlay: false,
        // enlargeCenterPage: false,
        // viewportFraction: 0.7,
        // aspectRatio: 3.0,
        // initialPage: 0,
      ),
      // height: 100,
      // viewportFraction: 0.21,
      // enlargeCenterPage: true,
      // initialPage: _currentIndex,
    );
  }

  Row _buildDottedIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.imagePaths
          .map<Widget>((String imagePath) => _buildDot(imagePath))
          .toList(),
    );
  }

  Container _buildDot(String imagePath) {
    return Container(
      width: 8,
      height: 8,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentIndex == widget.imagePaths.indexOf(imagePath)
            ? Colors.white
            : Colors.grey.shade700,
      ),
    );
  }

  PhotoViewGallery _buildPhotoViewGallery() {
    return PhotoViewGallery.builder(
      itemCount: widget.imagePaths.length,
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(widget.imagePaths[index]),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 1.8,
        );
      },
      enableRotation: true,
      scrollPhysics: const BouncingScrollPhysics(),
      pageController: _pageController,
      loadingBuilder: (BuildContext context, ImageChunkEvent event) {
        return Center(child: CircularProgressIndicator());
      },
      onPageChanged: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}