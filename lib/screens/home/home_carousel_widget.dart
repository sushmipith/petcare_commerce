import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeCarouselWidget extends StatelessWidget {
  static const List<String> _imgList = [
    "https://firebasestorage.googleapis.com/v0/b/petcarecommerce-b065e.appspot.com/o/banner%2FBANNER_01.jpg?alt=media&token=797dccf5-89d2-4cc5-b8cb-a9a2db36b761",
    "https://firebasestorage.googleapis.com/v0/b/petcarecommerce-b065e.appspot.com/o/banner%2Facc-banner-mobile-size.jpg?alt=media&token=414cae1a-e9fd-46ca-a7be-3914b87ab61e",
    "https://firebasestorage.googleapis.com/v0/b/petcarecommerce-b065e.appspot.com/o/banner%2Fakc-personalized-puppy-box.png?alt=media&token=da2d1029-8f88-41e4-a19d-45d505d36b3b",
    "https://firebasestorage.googleapis.com/v0/b/petcarecommerce-b065e.appspot.com/o/banner%2Fpettoy-big-banner2.jpg?alt=media&token=bba7e750-79ef-4add-8f03-b0c647d385f2"
  ];

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaConst = MediaQuery.of(context);
    double mHeight = mediaConst.size.height;
    return CarouselSlider(
      items: _imgList
          .map(
            (url) => Image.network(
              url,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          )
          .toList(),
      options: CarouselOptions(
        height: mHeight * 0.25,
        aspectRatio: 2,
        autoPlay: true,
        viewportFraction: 1,
        autoPlayAnimationDuration: const Duration(seconds: 2),
      ),
    );
  }
}
