/// allow : true

class Allow {
  bool allow;

  static Allow fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    Allow allowBean = Allow();
    allowBean.allow = map['allow'];
    return allowBean;
  }

  Map toJson() => {
    "allow": allow,
  };
}