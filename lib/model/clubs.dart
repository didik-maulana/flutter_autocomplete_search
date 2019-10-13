class DataMaster {
  List<Club> clubs;

  DataMaster({this.clubs});

  DataMaster.fromJson(Map<String, dynamic> json) {
    if (json['clubs'] != null) {
      clubs = new List<Club>();
      json['clubs'].forEach((value) {
        clubs.add(new Club.fromJson(value));
      });
    }
  }
}

class Club {
  int id;
  String name;
  String code;

  Club({this.id, this.name, this.code});

  Club.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
  }
}

List<Club> getClubSuggestions(String query, List<Club> clubs) {
  List<Club> matchedClubs = new List();

  matchedClubs.addAll(clubs);
  matchedClubs.retainWhere((club) => club.name.toLowerCase().contains(query.toLowerCase()));

  if (query == '') {
    return clubs;
  } else {
    return matchedClubs;
  }
}
