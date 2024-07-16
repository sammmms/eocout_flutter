import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';

List<String> title = [
  'Kelas EO Festival',
  'Kelas EO Publik',
  'Kelola Pernikahan',
];

List<String> subtitle = [
  'Pelajari cara mengelola festival dengan baik',
  'Pelajari cara mengelola event publik dengan baik',
  'Pelajari cara mengelola pernikahan dengan baik',
];

class EoRecommendationCarousel extends StatelessWidget {
  const EoRecommendationCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [
        _buildCarouselItems('assets/images/festive_culture.png', 0),
        _buildCarouselItems('assets/images/public_event.png', 1),
        _buildCarouselItems('assets/images/wedding.png', 2),
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

  Widget _buildCarouselItems(String path, int idx) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.asset(path, fit: BoxFit.cover, width: double.infinity),
              Container(
                color: Colors.black.withOpacity(0.4),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title[idx],
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      subtitle[idx],
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.end,
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
