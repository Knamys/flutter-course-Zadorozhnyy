import 'package:flutter/material.dart';
import '../../domain/entities/plant.dart';

class PlantFormSheet extends StatefulWidget {
  const PlantFormSheet({super.key, required this.onSave, this.plant});

  final void Function(Plant plant) onSave;
  final Plant? plant;

  @override
  State<PlantFormSheet> createState() => _PlantFormSheetState();
}

class _PlantFormSheetState extends State<PlantFormSheet> {
  late final _name = TextEditingController(text: widget.plant?.name);
  late final _latin = TextEditingController(text: widget.plant?.latinName);
  late final _feature = TextEditingController(text: widget.plant?.feature);
  late final _description =
      TextEditingController(text: widget.plant?.description);
  bool _nameError = false;

  @override
  void dispose() {
    _name.dispose();
    _latin.dispose();
    _feature.dispose();
    _description.dispose();
    super.dispose();
  }

  void _save() {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = true);
      return;
    }
    final old = widget.plant;
    widget.onSave(Plant(
      id: old?.id ?? '',
      name: name,
      latinName: _latin.text.trim(),
      category: old?.category ?? PlantCategory.swamp,
      feature: _feature.text.trim(),
      image: old?.image ?? 'assets/placeholder.png',
      description: _description.text.trim(),
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, 16 + MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.plant == null ? 'Новое растение' : 'Редактирование',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _name,
              decoration: InputDecoration(
                labelText: 'Название',
                errorText: _nameError ? 'Введите название' : null,
              ),
            ),
            TextField(
              controller: _latin,
              decoration: const InputDecoration(labelText: 'Латинское название'),
            ),
            TextField(
              controller: _feature,
              decoration: const InputDecoration(labelText: 'Тег'),
            ),
            TextField(
              controller: _description,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Описание'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _save, child: const Text('Сохранить')),
          ],
        ),
      ),
    );
  }
}