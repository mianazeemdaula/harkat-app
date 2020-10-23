class Validator {}

String validate(String value, String rule, String field) {
  field = field.toLowerCase();
  List<String> _rules = rule.split("|");
  if (_rules.contains("required") && value.isEmpty) {
    return "Please enter $field";
  }
  if (_rules.indexWhere((element) => element.contains('min')) >= 0) {
    String _min = _rules.firstWhere((element) => element.contains('min'));
    assert(_min != null);
    List<String> _get = _min.split(":");
    if (value.length < int.parse(_get[1])) {
      return "$field requires at least ${_get[1]} charaters";
    }
  }
  if (_rules.indexWhere((element) => element.contains('max')) >= 0) {
    print("max contains");
    String _max = _rules.firstWhere((element) => element.contains('max'));
    assert(_max != null);
    List<String> _getMax = _max.split(":");
    if (value.length > int.parse(_getMax[1])) {
      return "$field requires max ${_getMax[1]} charaters";
    }
  }
  if (_rules.contains("email")) {
    // r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) return "Please enter valid email";
  }
  if (_rules.contains("name")) {
    RegExp nameRegExp = new RegExp('[a-zA-Z]');
    if (!nameRegExp.hasMatch(value)) return "Please enter only character";
  }
  if (_rules.contains("numeric")) {
    RegExp numberRegExp = new RegExp(r'\d');
    if (!numberRegExp.hasMatch(value)) return "Please enter only number";
  }
  return null;
}
