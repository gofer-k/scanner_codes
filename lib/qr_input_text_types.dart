import 'package:flutter/cupertino.dart';

enum QRInputTextType {
  singleLineText,
  multiLineText,
  nUmber,
  phone,
  dateTime,
  address,
  email,
  web,
  password;

  (String, TextInputType) get textInputType {
    switch (this) {
      case QRInputTextType.singleLineText:
        return ('singleLineText', TextInputType.text);
      case QRInputTextType.multiLineText:
        return ("multilineText", TextInputType.multiline);
      case QRInputTextType.nUmber:
        return ("number", TextInputType.number);
      case QRInputTextType.phone:
        return ("phone", TextInputType.phone);
      case QRInputTextType.dateTime:
        return ("dateTime", TextInputType.datetime);
      case QRInputTextType.address:
        return ("address", TextInputType.streetAddress);
      case QRInputTextType.email:
        return ("email", TextInputType.emailAddress);
      case QRInputTextType.web:
        return ("web", TextInputType.url);
      case QRInputTextType.password:
        return ("password", TextInputType.visiblePassword);
    }
  }

  String get typeName => textInputType.$1;
  TextInputType get typeValue => textInputType.$2;
}

