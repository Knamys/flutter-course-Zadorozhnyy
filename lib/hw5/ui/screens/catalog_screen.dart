import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/plant.dart';
import '..//widgets/plant_card.dart';
import 'login_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _plantsStream =
      FirebaseFirestore.instance.collection('plants').snapshots();
  final _nameController = TextEditingController();
  final Set<String> _likedIds = {};
  bool _onlyLiked = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final plant = Plant(
      id: '',
      name: name,
      latinName: '',
      category: PlantCategory.swamp,
      feature: 'Новое',
      image: 'assets/placeholder.png',
      description: '',
    );

    try {
      await FirebaseFirestore.instance.collection('plants').add(plant.toJson());
      _nameController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _toggleLike(String id) {
    setState(() {
      if (_likedIds.contains(id)) {
        _likedIds.remove(id);
      } else {
        _likedIds.add(id);
      }
    });
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Название',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(onPressed: _add, child: const Text('Отправить')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _plantsStream,
      builder: (context, snapshot) {
        final plants = snapshot.hasData
            ? snapshot.data!.docs.map(Plant.fromFirestore).toList()
            : <Plant>[];
        final visible = _onlyLiked
            ? plants.where((p) => _likedIds.contains(p.id)).toList()
            : plants;

        Widget content;
        if (snapshot.hasError) {
          content = Center(child: Text('Ошибка: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          content = const Center(child: CircularProgressIndicator());
        } else if (visible.isEmpty) {
          content = const Center(child: Text('Ничего не нашлось'));
        } else {
          content = ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: visible.length,
            itemBuilder: (context, index) {
              final plant = visible[index];
              return PlantCard(
                plant: plant,
                isLiked: _likedIds.contains(plant.id),
                onLikeTap: () => _toggleLike(plant.id),
              );
            },
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFE8EEE7),
          appBar: AppBar(
            backgroundColor: const Color(0xFFE8EEE7),
            scrolledUnderElevation: 0,
            toolbarHeight: 80,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Каталог растений-хищников',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(
                  'В каталоге: ${plants.length} · В избранном: ${_likedIds.length}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              IconButton(icon: const Icon(Icons.logout), onPressed: _signOut),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: FilterChip(
                    avatar: Icon(
                      _onlyLiked ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: _onlyLiked ? const Color(0xFFE84D59) : null,
                    ),
                    label: const Text('Только избранные'),
                    selected: _onlyLiked,
                    showCheckmark: false,
                    selectedColor: const Color(0xFFCFE3D2),
                    onSelected: (value) => setState(() => _onlyLiked = value),
                  ),
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              _buildForm(),
              Expanded(child: content),
            ],
          ),
        );
      },
    );
  }
}