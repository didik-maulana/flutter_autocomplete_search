import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_autocomplete_search/model/clubs.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    title: 'Autocomplete Search',
    debugShowCheckedModeBanner: false,
    home: MainPage(),
  ));
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Club club = new Club();
  TextEditingController _textFieldController = new TextEditingController();

  Future<String> loadJson() async {
    return rootBundle.loadString('assets/clubs.json');
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Autocomplete Search'),
        centerTitle: true,
      ),
      body: FutureBuilder<String>(
        future: loadJson(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final dataMaster = DataMaster.fromJson(json.decode(snapshot.data));
            return _buildContainer(dataMaster.clubs);
          } else {
            return Center(
              child: Text('Error load data'),
            );
          }
        },
      ),
    );
  }

  Widget _buildContainer(List<Club> clubs) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          children: <Widget>[
            _buildTextField(clubs),
            SizedBox(height: 16.0),
            _buildOutput(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(List<Club> clubs) {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        autofocus: false,
        controller: _textFieldController,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 18.0,
        ),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: "Search Football Club",
          labelStyle: TextStyle(color: Colors.black38),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
        ),
      ),
      suggestionsCallback: (String query) {
        return getClubSuggestions(query, clubs);
      },
      onSuggestionSelected: (Club club) {
        setState(() {
          this.club = club;
        });
        _textFieldController.text = club.name;
      },
      noItemsFoundBuilder: (BuildContext context) {
        return ListTile(
          title: Text('Club not found..'),
        );
      },
      itemBuilder: (BuildContext context, Club club) {
        return ListTile(
          title: Text(club.name),
          subtitle: Text(
            'ID : ${club.id}, Code : ${club.code}',
            style: TextStyle(
              fontSize: 12.0,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      },
    );
  }

  Widget _buildOutput() {
    return Text("""
    Result for club selected :
    
    ID    : ${club.id ?? '-'}
    Name  : ${club.name ?? '-'}
    Code  : ${club.code ?? '-'}"""
    );
  }
}

