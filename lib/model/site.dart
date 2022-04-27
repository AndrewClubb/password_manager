class Site {
  final String url;
  final String username;
  final String password;
  final String id;
  bool isSelected;

  Site({this.url = '', this.username = '', this.password = '', required this.id})
      : isSelected = false;
}
