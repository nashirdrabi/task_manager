
import 'package:flutter/material.dart';

import '../di/service_locator.dart';
import 'base_web_api.dart';



abstract class BaseRepo<W extends BaseWebApi> {

  final W _webapi = serviceLocator<W>();
  @protected
  W get webApi => _webapi;






}
