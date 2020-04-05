import 'package:cached_network_image/cached_network_image.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  String img;
  ImageView({this.img});
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image(
          fit: BoxFit.cover,
//          height:200.0,
//          width: 500.0,
          alignment: Alignment.center,
          image: CachedNetworkImageProvider(
             img
          ),),
      ),
    );
  }
}
