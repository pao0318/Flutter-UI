import 'package:books_app/Constants/genres.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:books_app/Widgets/UserLocation.dart';

//------------Stack Overflow COde ----------------
class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog({Key key, this.items, this.initialSelectedValues})
      : super(key: key);

  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Genres'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}

//------------Stack Overflow Code ----------------
class LocationRange extends StatefulWidget {
  @override
  _LocationRangeState createState() => _LocationRangeState();
}

class _LocationRangeState extends State<LocationRange> {
  double _currentSlidervalue = 10;
  String s;
  @override
  Widget build(BuildContext context) {
    s = _currentSlidervalue.toStringAsFixed(2);
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Set Location Range',
            style: GoogleFonts.poppins(fontSize: 15),
          ),
        ),
        Slider(
          label: _currentSlidervalue.round().toString(),
          value: _currentSlidervalue,
          min: 0,
          max: 40,
          onChanged: (double value) {
            setState(() {
              _currentSlidervalue = value;
            });
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '$s km',
            style: GoogleFonts.poppins(),
          ),
        )
      ],
    );
  }
}

userPreferences(BuildContext context) {
//------------Stack Overflow CodeList ----------------
  void _showMultiSelect(BuildContext context) async {
    int i = 0;
    int j = i;
    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: genres.map<MultiSelectDialogItem<String>>((String val) {
            return MultiSelectDialogItem<String>(
                (i++).toString(), val.toString());
          }).toList(),
          initialSelectedValues: [1, j].toSet(),
        );
      },
    );

    print(selectedValues);
  }

//------------Stack Overflow CodeList ----------------

  showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      barrierLabel: 'Animation',
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context, animation1, animation2) {
        TextEditingController _author;
        TextEditingController _book;

        return AlertDialog(
          title: Center(
            child: Text(
              'User Preferences',
              style: GoogleFonts.muli(),
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Container(
            height: 300,
            width: 250,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  searchBar(),
                  SizedBox(
                    height: 20,
                  ),
                  LocationRange(),
                  TextFormField(
                    controller: _book,
                    keyboardType: TextInputType.name,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      hintText: 'Favourite Book',
                      hintStyle: GoogleFonts.muli(),
                    ),
                    onSaved: (val) {
                      val = _book.text;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _author,
                    keyboardType: TextInputType.name,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                        hintText: 'Favourite Author',
                        hintStyle: GoogleFonts.muli()),
                    onSaved: (val) {
                      val = _author.text;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ButtonTheme(
                    minWidth: 220,
                    height: 40,
                    child: RaisedButton(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11)),
                      onPressed: () {
                        _showMultiSelect(context);
                      },
                      child: Text(
                        'Select Book Genres',
                        style: GoogleFonts.muli(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                'Save',
                style: GoogleFonts.muli(fontWeight: FontWeight.bold),
              ),
            ),
            FlatButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: GoogleFonts.muli(fontWeight: FontWeight.bold),
              ),
            )
          ],
        );
      });
}
