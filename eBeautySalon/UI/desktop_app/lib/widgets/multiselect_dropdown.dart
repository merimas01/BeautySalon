import 'package:flutter/material.dart';
import '../models/search_result.dart';
import '../models/usluga.dart';

class MultiSelect extends StatefulWidget {
  SearchResult<Usluga> usluge;
  MultiSelect({super.key, required this.usluge});

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final SearchResult<Usluga> _selectedItems = SearchResult();

  void _itemChange(Usluga itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.result.add(itemValue);
        print(itemValue.uslugaId);
      } else {
        _selectedItems.result.remove(itemValue);
      }
    });
  }

  void _cancel() {
    //print("selected items: ${_selectedItems.result}");
    Navigator.pop(context);
  }

  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Odaberite usluge"),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.usluge.result
              .map((Usluga item) => CheckboxListTile(
                  value: _selectedItems.result.contains(item),
                  title: Text(item.naziv!),
                  onChanged: (isChecked) {
                    _itemChange(item, isChecked!);
                  }))
              .toList(),
        ),
      ),
      actions: [
        TextButton(onPressed: _cancel, child: Text("Otkaži")),
        ElevatedButton(
          child: Text("Spasi"),
          onPressed: _submit,
        )
      ],
    );
  }
}
