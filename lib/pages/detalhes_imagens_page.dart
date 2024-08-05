import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io';

class DetalhesImagemPage extends StatefulWidget {
  final List<String> imgList;
  final int currentImageIndex;

  const DetalhesImagemPage(
      {Key? key, required this.imgList, required this.currentImageIndex})
      : super(key: key);

  @override
  State<DetalhesImagemPage> createState() => _DetalhesImagemPageState();
}

class _DetalhesImagemPageState extends State<DetalhesImagemPage> {
  int _currentImageIndex = 0;
  CarouselController buttonCarouselController = CarouselController();

  double largura = 0;
  double fracaoImagem = 1;
  double altura = 500;

  @override
  void initState() {
    _currentImageIndex = widget.currentImageIndex;
    super.initState();
  }

  bool _isLocalFile(String path) {
    return Uri.tryParse(path)?.scheme == 'file' || path.startsWith('/');
  }

  @override
  Widget build(BuildContext context) {
    double tamanhoTela = MediaQuery.of(context).size.width;
    if (tamanhoTela < 700) {
      largura = tamanhoTela;
      altura = tamanhoTela - 150;
    } else if (tamanhoTela < 1000) {
      largura = tamanhoTela;
      altura = tamanhoTela - 500;
      fracaoImagem = 0.7;
    } else if (tamanhoTela < 1300) {
      largura = tamanhoTela - 75;
      altura = tamanhoTela - 750;
      fracaoImagem = 0.6;
    } else if (tamanhoTela < 1600) {
      largura = tamanhoTela - 120;
      altura = tamanhoTela - 1100;
      fracaoImagem = 0.6;
    } else {
      largura = tamanhoTela - 150;
      altura = tamanhoTela - 1450;
      fracaoImagem = 0.5;
    }

    return SingleChildScrollView(
      child: Dialog(
        surfaceTintColor: Colors.white,
        insetPadding: EdgeInsets.zero,
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  SizedBox(
                    width: largura,
                    height: altura,
                    child: CarouselSlider(
                      items: widget.imgList.map((String item) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                              ),
                              child: _isLocalFile(item)
                                  ? Image.file(
                                      File(item),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 50,
                                        );
                                      },
                                    )
                                  : Image.network(
                                      item,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 50,
                                        );
                                      },
                                    ),
                            );
                          },
                        );
                      }).toList(),
                      carouselController: buttonCarouselController,
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        initialPage: widget.currentImageIndex,
                        onPageChanged: (index, reason) {
                          setState(
                            () {
                              _currentImageIndex = index;
                            },
                          );
                        },
                        viewportFraction: fracaoImagem,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 14.0,
                    child: Text(
                      '${_currentImageIndex + 1}/${widget.imgList.length}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (kIsWeb)
                    Positioned(
                      left: 16.0,
                      top: 0.0,
                      bottom: 0.0,
                      child: IconButton(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          buttonCarouselController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linear,
                          );
                        },
                      ),
                    ),
                  if (kIsWeb)
                    Positioned(
                      right: 16.0,
                      top: 0.0,
                      bottom: 0.0,
                      child: IconButton(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          buttonCarouselController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linear,
                          );
                        },
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
