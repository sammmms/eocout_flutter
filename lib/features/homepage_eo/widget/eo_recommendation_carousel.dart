import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';

class EoRecommendationCarousel extends StatelessWidget {
  const EoRecommendationCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [
        _buildCarouselItems('assets/images/festive_culture.png'),
        _buildCarouselItems('assets/images/public_event.png'),
        _buildCarouselItems('assets/images/wedding.png'),
      ],
      options: CarouselOptions(
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          aspectRatio: 2.0,
          viewportFraction: 1),
    );
  }

  Widget _buildCarouselItems(String path) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Image.asset(path, fit: BoxFit.cover, width: double.infinity),
    );
  }
}
