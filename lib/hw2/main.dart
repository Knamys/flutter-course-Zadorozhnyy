import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFE8EEE7),
        appBar: AppBar(
          backgroundColor: const Color(0xFFE8EEE7),
          toolbarHeight: 80,
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Каталог растений-хищников', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Sans Liberation'),
                ),
                Text('6 растений в каталоге', style: TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'Sans Liberation',
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: const Color(0xFF080A08),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [Image.asset('assets/ВенеринаМухоловка.jpg', width: 280, height: 200, fit: BoxFit.cover),
                            positioned(),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Венерина мухоловка', overflow: TextOverflow.ellipsis, maxLines: 1,
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFFF0F0E7), fontFamily: 'Sans Liberation'),
                                ),
                                const SizedBox(height: 4),
                                const Text('Dionaea muscipula',
                                  style: TextStyle(fontSize: 16, color: Color(0xFF999E99), fontStyle: FontStyle.italic, fontFamily: 'Sans Liberation'),
                                ),
                                const SizedBox(height: 20),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    myTag('Хищное'),
                                    myTag('Болота'),
                                    myTag('Солнцелюбивое')
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: const Color(0xFF080A08),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [Image.asset('assets/Непентес.jpg', width: 280, height: 200, fit: BoxFit.cover),
                            positioned(),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Непентес', overflow: TextOverflow.ellipsis, maxLines: 1,
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFFF0F0E7), fontFamily: 'Sans Liberation'),
                                ),
                                const SizedBox(height: 4),
                                const Text('Nepenthes',
                                  style: TextStyle(fontSize: 16, color: Color(0xFF999E99), fontStyle: FontStyle.italic, fontFamily: 'Sans Liberation'),
                                ),
                                const SizedBox(height: 20),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    myTag('Хищное'),
                                    myTag('Тропики'),
                                    myTag('Лиана')
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(12),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: const Color(0xFF080A08),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [Image.asset('assets/Росянка.jpg', width: 280, height: 200, fit: BoxFit.cover),
                            positioned(),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Росянка', overflow: TextOverflow.ellipsis, maxLines: 1,
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFFF0F0E7), fontFamily: 'Sans Liberation'),
                                ),
                                const SizedBox(height: 4),
                                const Text('Drosera rotundifolia',
                                  style: TextStyle(fontSize: 16, color: Color(0xFF999E99), fontStyle: FontStyle.italic, fontFamily: 'Sans Liberation'),
                                ),
                                const SizedBox(height: 20),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    myTag('Хищное'),
                                    myTag('Болота'),
                                    myTag('Липкие ловушки')
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(12),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: const Color(0xFF080A08),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [Image.asset('assets/Саррацения.jpg', width: 280, height: 200, fit: BoxFit.cover),
                            positioned(),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Саррацения', overflow: TextOverflow.ellipsis, maxLines: 1,
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFFF0F0E7), fontFamily: 'Sans Liberation'),
                                ),
                                const SizedBox(height: 4),
                                const Text('Sarracenia',
                                  style: TextStyle(fontSize: 16, color: Color(0xFF999E99), fontStyle: FontStyle.italic, fontFamily: 'Sans Liberation'),
                                ),
                                const SizedBox(height: 20),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    myTag('Хищное'),
                                    myTag('Северная Америка'),
                                    myTag('Кувшинчатые ловушки')
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container myTag(String name) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFF4B6C50),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF193126)),
      ),
    );
  }
}

Positioned positioned() {
  return Positioned(
    top: 12,
    left: 12,
    child: Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.favorite, color: Color(0xFFE84D59), size: 24),
        onPressed: () {},
      ),
    ),
  );
}
