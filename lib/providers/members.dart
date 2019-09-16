import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

enum BuyOption {
  Empty,
  NotYet,
  Already,
}

enum PayOption {
  Empty,
  NotYet,
  Already,
}

enum ReceiveOption {
  Empty,
  NotYet,
  Already,
}

class Members with ChangeNotifier {
  List<dynamic> _members;
  String _token;
  // We need the token to send the request;

  set token(String t) {
    _token = t;
  }

  String get token {
    return token;
  }

  // Members(this._token);

  List<Map<String, dynamic>> get members {
    if (_members == null) {
      return null;
    }

    return [..._members];
  }

  List<dynamic> get allProducts {
    print('allProducts called');
    var allProducts = [];

    if (_members == null) {
      return null;
    }

    _members.forEach((m) {
      var products = m["products"];
      products.forEach((p) {
        allProducts.add({
          ...p,
          "uid": m["_id"],
          "uname": m["name"],
        });
      });
    });

    return allProducts;
  }

  List<dynamic> getShowingResultBySearchingCon(
      Map<String, dynamic> searchingCon) {
    if (searchingCon == null) {
      return allProducts;
    }
    List<dynamic> showingProduct = [];

    if (searchingCon["uid"] != null) {
      var buyer = findBuyerById(searchingCon["uid"]);
      if (buyer != null) {
        List<dynamic> products = buyer["products"];
        products?.forEach((p) {
          showingProduct.add({
            ...p,
            "uid": buyer["_id"],
            "uname": buyer["name"],
          });
        });
      }
    } else {
      showingProduct = allProducts;
    }

    if (searchingCon["orderNum"] != null &&
        !searchingCon["orderNum"].toString().trim().isEmpty) {
      showingProduct = showingProduct
          .where((p) =>
              p["orderNum"].toString() == searchingCon["orderNum"].toString())
          .toList();
    }

    if (searchingCon["name"] != null &&
        !searchingCon["name"].toString().trim().isEmpty) {
      showingProduct = showingProduct
          .where(
            (p) => p["name"].toString().contains(
                  searchingCon["name"].toString(),
                ),
          )
          .toList();
    }

    if (searchingCon["uname"] != null &&
        !searchingCon["uname"].toString().trim().isEmpty) {
      showingProduct = showingProduct
          .where(
            (p) => p["uname"].toString().contains(
                  searchingCon["uname"].toString(),
                ),
          )
          .toList();
    }

    if (!(searchingCon["bought"] == null ||
        searchingCon["bought"] == BuyOption.Empty)) {
      showingProduct = showingProduct
          .where((p) =>
              p["bought"] ==
              (searchingCon["bought"] == BuyOption.Already ? true : false))
          .toList();
    }

    if (!(searchingCon["paid"] == null ||
        searchingCon["paid"] == PayOption.Empty)) {
      showingProduct = showingProduct
          .where((p) =>
              p["paid"] ==
              (searchingCon["paid"] == PayOption.Already ? true : false))
          .toList();
    }

    if (!(searchingCon["received"] == null ||
        searchingCon["received"] == ReceiveOption.Empty)) {
      showingProduct = showingProduct
          .where((p) =>
              p["received"] ==
              (searchingCon["received"] == ReceiveOption.Already
                  ? true
                  : false))
          .toList();
    }

    showingProduct?.sort((a, b) {
      // return int.parse(b['orderNum']) - int.parse(a['orderNum']);
      var r = int.parse(b['orderNum']).compareTo(int.parse(a['orderNum']));
      if (r != 0) return r;
      return DateTime.parse(b['createdAt'])
          .compareTo(DateTime.parse(a['createdAt']));
    });

    return showingProduct;
  }

  List<dynamic> get allMembersNameAndId {
    if (_members == null) {
      return null;
    }

    return _members.map((m) {
      return {
        "_id": m["_id"],
        "name": m["name"],
      };
    }).toList();
  }

  Future<void> fetchAndSetMembers() async {
    final url = "https://shop4you-au.appspot.com/member/";
    final res = await http.get(url, headers: {"Authorization": _token});

    if (res.body.isEmpty || res.body == null) {
      return;
    }

    final extractedData = json.decode(res.body);

    _members = extractedData["members"];

    notifyListeners();
  }

  dynamic findBuyerById(String uid) {
    return _members?.firstWhere((m) => m["_id"] == uid);
  }

  Future<void> addNewMember(String name) async {
    if (name.isEmpty) {
      return;
    }

    final url = "https://shop4you-au.appspot.com/member/";
    final res = await http.post(
      url,
      headers: {
        "Authorization": _token,
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      },
      body: "name=$name",
    );

    final resData = json.decode(res.body);

    _members.add({
      "name": resData["insertMember"]["name"],
      "products": [],
      "remark": "",
      "_id": resData["insertID"],
    });

    notifyListeners();
  }

  dynamic getCertainUser(String uid) {
    if (uid == null) {
      return null;
    }

    return _members.firstWhere((m) => m["_id"] == uid);
  }

  List<dynamic> findMembersFromName(String input) {
    if (input == null || input.trim().isEmpty) {
      return _members;
    }
    return _members.where((m) => m["name"].toString().contains(input)).toList();
  }

  Future<bool> deleteMember(String uid) async {
    Map<String, dynamic> origM;

    int idx = _members.indexWhere((m) => m["_id"] == uid);
    origM = Map.from(_members[idx]);
    _members.removeAt(idx);

    notifyListeners();
    final url = "https://shop4you-au.appspot.com/member/$uid";
    final res = await http.delete(
      url,
      headers: {
        "Authorization": _token,
      },
    );

    if (res.statusCode >= 400) {
      _members.add(origM);
      notifyListeners();
      return false;
    }

    return true;
  }

  Future<void> updateMember(
      String uid, Map<String, dynamic> updateFields) async {
    final idx = _members.indexWhere((m) => m["_id"] == uid);
    var origiField = {};
    updateFields.forEach((k, v) {
      origiField[k] = _members[idx][k];
      _members[idx][k] = v;
    });
    notifyListeners();

    final url = "https://shop4you-au.appspot.com/member/$uid";
    final res = await http.put(
      url,
      headers: {
        "Authorization": _token,
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      },
      body: "member=${json.encode(updateFields)}",
    );

    if (res.statusCode >= 400) {
      origiField.forEach((k, v) => _members[idx][k] = v);
      notifyListeners();
    }
  }

  // Product

  Future<void> addProductToMember(
      String uid, Map<String, dynamic> product) async {
    final url = "https://shop4you-au.appspot.com/member/$uid/product/";
    final res = await http.post(
      url,
      headers: {
        "Authorization": _token,
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      },
      body: "product=${json.encode(product)}",
    );

    final resData = json.decode(res.body);

    final idx = _members.indexWhere((m) => m["_id"] == uid);
    // Adding id
    _members[idx]["products"].add(resData["addedProduct"]);
    notifyListeners();
  }

  Future<void> updateProductToMember(
      String uid, String pid, Map<String, dynamic> product) async {
    var orignalField = {};

    final uidx = _members.indexWhere((m) => m["_id"] == uid);
    final pidx = _members[uidx]["products"].indexWhere((p) => p["_id"] == pid);

    product.forEach((k, v) {
      orignalField[k] = _members[uidx]["products"][pidx][k];
      _members[uidx]["products"][pidx][k] = v;
    });
    notifyListeners();

    final url = "https://shop4you-au.appspot.com/member/$uid/product/$pid";
    final res = await http.put(
      url,
      headers: {
        "Authorization": _token,
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      },
      body: "uid=$uid&pid=$pid&product=${json.encode(product)}",
    );

    if (res.statusCode >= 400) {
      orignalField.forEach((k, v) {
        _members[uidx]["products"][pidx][k] = v;
      });
      notifyListeners();
    }
  }

  Future<void> deleteProductForMember(String uid, String pid) async {
    Map<String, dynamic> origP;
    final uidx = _members.indexWhere((m) => m["_id"] == uid);
    _members[uidx]["products"].removeWhere((p) {
      if (p["_id"] == pid) {
        origP = Map.from(p);
        return true;
      }
      return false;
    });
    notifyListeners();

    final url = "https://shop4you-au.appspot.com/member/$uid/product/$pid";
    final res = await http.delete(
      url,
      headers: {
        "Authorization": _token,
      },
    );

    if (res.statusCode >= 400) {
      _members[uidx]["products"].add(origP);
      notifyListeners();
    }
  }
}
