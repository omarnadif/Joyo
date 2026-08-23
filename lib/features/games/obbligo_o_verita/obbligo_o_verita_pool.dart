import '../content_tone.dart';
import 'pool_cattivo.dart';
import 'pool_piccante.dart';
import 'pool_soft.dart';

/// Obbligo o Verità: un centinaio di obblighi e di verità per ciascun tono.
///
/// I toni non si sommano come negli altri giochi: qui una stanza "cattivo"
/// vuole domande cattive, non un misto in cui esce di nuovo "canta una
/// canzone". Ogni tono ha il suo mazzo.
class ObbligoOVeritaPool {
  const ObbligoOVeritaPool._();

  static List<String> obblighi(String tone) => switch (tone) {
    ContentTone.cattivo => ObbligoOVeritaCattivo.obblighi,
    ContentTone.piccante => ObbligoOVeritaPiccante.obblighi,
    _ => ObbligoOVeritaSoft.obblighi,
  };

  static List<String> verita(String tone) => switch (tone) {
    ContentTone.cattivo => ObbligoOVeritaCattivo.verita,
    ContentTone.piccante => ObbligoOVeritaPiccante.verita,
    _ => ObbligoOVeritaSoft.verita,
  };
}
