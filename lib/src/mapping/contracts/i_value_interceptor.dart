//. =============================================================
//. Contrato para interceptar y transformar valores (P -> V).
//. P: Tipo de valor primitivo (String, int, etc.) recibido del input.
//. V: Tipo de valor final procesado (ValueObject, DTO, etc.).
//. =============================================================
abstract interface class IValueInterceptor<P, V> {
  V intercept(P value);
}