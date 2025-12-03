import 'package:flutter/material.dart';
import 'package:formkit/src/core/engine/formkit_core_engine.dart';

typedef FormKitBuilder<TOutputVO> = Widget Function(
  BuildContext context,
  FormKitCoreEngine engine, 
);