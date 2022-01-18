import 'package:flutter/material.dart';

class ImageBackgroundWidget extends StatelessWidget {
  final String path;
  final BoxFit fitMode;
  final Widget? child;

  ImageBackgroundWidget({
    required this.path,
    required this.fitMode,
    this.child
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: fitMode,
          image: AssetImage(path),
        )
      ),
      child: child,
    );
  }
}

class UrlImageBackgroundWidget extends StatelessWidget {
  final String url;
  final BoxFit fitMode;
  final Widget? child;

  UrlImageBackgroundWidget({
    required this.url,
    required this.fitMode,
    this.child
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
            fit: fitMode,
            image: NetworkImage(url),
          )
      ),
      child: child,
    );
  }
}

class ImageBackgroundOpacityWidget extends StatelessWidget {
  final String path;
  final double opacity; //0->1
  final BoxFit fitMode;
  final Widget? child;

  ImageBackgroundOpacityWidget({
    required this.path,
    required this.opacity,
    required this.fitMode,
    this.child
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: fitMode,
              image: AssetImage(path),
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(opacity),
                  BlendMode.dstATop
              )
          )
      ),
      child: child,
    );
  }
}