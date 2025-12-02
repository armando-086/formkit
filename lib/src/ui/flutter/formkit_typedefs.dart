import 'package:flutter/material.dart';
import 'package:formkit/src/core/engine/formkit_core_engine.dart';
//. =============================================================
//. Tipo de función que construye la UI, exponiendo el motor de FormKit.
//. =============================================================
typedef FormKitBuilder<TOutputVO> = Widget Function(
  BuildContext context,
  FormKitCoreEngine engine, 
);