import 'package:flutter/material.dart';

class WelcomeImages extends StatelessWidget {
  const WelcomeImages({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 655,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: const [
          Positioned(
            top: 0,
            left: 0,
            child: _DecorImage(
              key: Key('pixels1'),
              asset: 'assets/images/pixels1.png',
              width: 144,
              height: 142,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: _DecorImage(
              key: Key('pixels'),
              asset: 'assets/images/pixels.png',
              width: 144,
              height: 142,
            ),
          ),
          Positioned(
            bottom: 34,
            child: _DecorImage(
              key: Key('illustration1'),
              asset: 'assets/images/illustration1.png',
              width: 283,
              height: 228,
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorImage extends StatelessWidget {
  final String asset;
  final double width;
  final double height;

  const _DecorImage({
    super.key,
    required this.asset,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FittedBox(fit: BoxFit.contain, child: Image.asset(asset)),
    );
  }
}
