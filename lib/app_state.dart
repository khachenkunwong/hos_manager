import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/lat_lng.dart';

class FFAppState {
  static final FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal() {
    initializePersistedState();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _chcknull = prefs.getString('ff_chcknull') ?? _chcknull;
    _tokenStore = prefs.getString('ff_tokenStore') ?? _tokenStore;
    _namegroup = prefs.getString('ff_namegroup') ?? _namegroup;
    _itemsduty = prefs.getString('ff_itemsduty') ?? _itemsduty;
    _itemsdutyupdata =
        prefs.getStringList('ff_itemsdutyupdata') ?? _itemsdutyupdata;
    _myemail = prefs.getString('ff_myemail') ?? _myemail;
    firstname = prefs.getString('ff_firstname') ?? firstname;
    lastname = prefs.getString('ff_lastname') ?? lastname;
    actor = prefs.getString('ff_actor') ?? actor;
    id = prefs.getString('ff_id') ?? id;
  }

  late SharedPreferences prefs;

  String _chcknull = 'ว่าง';
  String get chcknull => _chcknull;
  set chcknull(String _value) {
    _chcknull = _value;
    prefs.setString('ff_chcknull', _value);
  }

  String _tokenStore = '';
  String get tokenStore => _tokenStore;
  set tokenStore(String _value) {
    _tokenStore = _value;
    prefs.setString('ff_tokenStore', _value);
  }

  String _namegroup = '';
  String get namegroup => _namegroup;
  set namegroup(String _value) {
    _namegroup = _value;
    prefs.setString('ff_namegroup', _value);
  }

  String _firstname = '';
  String get firstname => _firstname;
  set firstname(String _value) {
    _firstname = _value;
    prefs.setString('ff_firstname', _value);
  }
  String _lastname = '';
  String get lastname => _lastname;
  set lastname(String _value) {
    _lastname = _value;
    prefs.setString('ff_lastname', _value);
  }
  String _actor = '';
  String get actor => _actor;
  set actor(String _value) {
    _actor = _value;
    prefs.setString('ff_actor', _value);
  }
  String _id = '';
  String get id => _id;
  set id(String _value) {
    _id = _value;
    prefs.setString('ff_id', _value);
  }

  String _itemsduty = '';
  String get itemsduty => _itemsduty;
  set itemsduty(String _value) {
    _itemsduty = _value;
    prefs.setString('ff_itemsduty', _value);
  }

  

  String _myemail = '';
  String get myemail => _myemail;
  set myemail(String _value) {
    _myemail = _value;
    prefs.setString('ff_myemail', _value);
  }

  List<String> _itemsdutyupdata = [];
  List<String> get itemsdutyupdata => _itemsdutyupdata;
  set itemsdutyupdata(List<String> _value) {
    _itemsdutyupdata = _value;
    prefs.setStringList('ff_itemsdutyupdata', _value);
  }

  void addToItemsduty(String _value) {
    _itemsdutyupdata.add(_value);
    prefs.setStringList('ff_itemsdutyupdata', _itemsdutyupdata);
  }

  void insertToItemsduty(String _value, int index) {
    _itemsdutyupdata.insert(index, _value);
    prefs.setStringList('ff_itemsdutyupdata', _itemsdutyupdata);
  }

  void removeFromItemsduty(String _value) {
    _itemsdutyupdata.remove(_value);
    prefs.setStringList('ff_itemsdutyupdata', _itemsdutyupdata);
  }
}

LatLng? _latLngFromString(String? val) {
  if (val == null) {
    return null;
  }
  final split = val.split(',');
  final lat = double.parse(split.first);
  final lng = double.parse(split.last);
  return LatLng(lat, lng);
}
