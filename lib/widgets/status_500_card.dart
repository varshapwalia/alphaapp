import 'package:flutter/material.dart';

class Status500Card extends StatelessWidget {
  final Function onpressedRetry;
  final bool hideImage;
  const Status500Card(
      {Key? key, required this.onpressedRetry, this.hideImage = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          padding: hideImage
              ? const EdgeInsets.symmetric(vertical: 10, horizontal: 40)
              : const EdgeInsets.all(48),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              hideImage
                  ? Container(
                height: 0,
              )
                  : Image.asset('images/status_500.png', fit: BoxFit.contain),
              const SizedBox(height: 16),
              const Text('Something Went wrong',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
              const SizedBox(height: 8),
              const Text(
                  'server took too long to respond,\ntrying again might resolve the issue',
                  style: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w400,
                      fontSize: 14)),
              const SizedBox(height: 16),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 53),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      primary: Theme.of(context).backgroundColor),
                  onPressed: onpressedRetry as void Function()?,
                  child: const Text('Retry',
                      style: TextStyle(
                          color: Color(0xFF3766FE),
                          fontWeight: FontWeight.w600,
                          fontSize: 16)))
            ],
          ),
        ));
  }
}
