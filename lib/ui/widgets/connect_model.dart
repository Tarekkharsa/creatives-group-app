
import 'package:flutter/material.dart';

Widget SnackBarConnection(scaffoldKey){
  final snackbar = SnackBar(
    content: Row(
      children: <Widget>[
        Icon(Icons.error_outline),
        SizedBox(
          width: 10.0,
        ),
        Text('No Internet Connection !!',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins-Bold',
              fontSize: 14.0,
            )),
      ],
    ),
  );
  scaffoldKey.currentState.showSnackBar(snackbar);

}