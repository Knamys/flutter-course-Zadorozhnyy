import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/plant.dart';
import '../widgets/plant_card.dart';

const baseUrl = 'https://6ae9836d3d3dd3d37be50ab8.mockapi.io';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _nameController = TextEditingController();
  final Set<String> _likedIds = {};
  List<Plant> _plants = [];
  bool _onlyLiked = false;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await http.get(Uri.parse('$baseUrl/plants'));
      if (response.statusCode != 200) {
        throw Exception('Статус ${response.statusCode}');
      }
      final list = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      setState(() => _plants = list.map((e) => Plant.fromJson(e)).toList());
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _send() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    // id пустой: у нового элемента его нет, в toJson он не попадает
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
      final response = await http.post(
        Uri.parse('$baseUrl/plants'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(plant.toJson()),
      );
      if (response.statusCode != 201) {
        throw Exception('Статус ${response.statusCode}');
      }
      final created =
          Plant.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      setState(() => _plants.insert(0, created));
      _nameController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
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
          ElevatedButton(onPressed: _send, child: const Text('Отправить')),
        ],
      ),
    );
  }

  Widget _buildBody(List<Plant> visible) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ошибка: $_error'),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _load, child: const Text('Обновить')),
          ],
        ),
      );
    }
    return Column(
      children: [
        _buildForm(),
        Expanded(
          child: visible.isEmpty
              ? const Center(child: Text('Ничего не нашлось'))
              : ListView.builder(
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
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _onlyLiked
        ? _plants.where((p) => _likedIds.contains(p.id)).toList()
        : _plants;

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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(
              'В каталоге: ${_plants.length} · В избранном: ${_likedIds.length}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
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
      body: _buildBody(visible),
    );
  }
}