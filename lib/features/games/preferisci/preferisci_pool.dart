import '../../../core/i18n/app_locale.dart';
import '../content_tone.dart';
import 'preferisci_pool_de.dart';
import 'preferisci_pool_en.dart';
import 'preferisci_pool_es.dart';
import 'preferisci_pool_fr.dart';

/// Pool gratuito di "Preferisci", una lista per lingua.
///
/// L'indice della coppia finisce dentro `rounds.content['i']`, così l'host sa
/// quali sono già uscite e non le ripesca nella stessa partita.
class PreferisciPool {
  const PreferisciPool._();

  /// Coppie nella lingua scelta dal gruppo.
  static List<({String a, String b})> pairs(AppLocale locale) =>
      switch (locale) {
        AppLocale.it => it,
        AppLocale.en => PreferisciPoolEn.pairs,
        AppLocale.es => PreferisciPoolEs.pairs,
        AppLocale.fr => PreferisciPoolFr.pairs,
        AppLocale.de => PreferisciPoolDe.pairs,
      };

  /// Coppie audaci (piccante/cattivo) nella lingua del gruppo.
  static List<({String a, String b, String tone})> _hot(AppLocale locale) =>
      switch (locale) {
        AppLocale.it => hotIt,
        AppLocale.en => PreferisciPoolEn.hot,
        AppLocale.es => PreferisciPoolEs.hot,
        AppLocale.fr => PreferisciPoolFr.hot,
        AppLocale.de => PreferisciPoolDe.hot,
      };

  /// Coppie con il tono, per il filtro della modalità.
  ///
  /// Il mazzo base è tutto soft; in Mix e Hot entrano anche le coppie audaci
  /// di [hotIt] o dell'equivalente nella lingua del gruppo.
  static List<({String a, String b, String tone})> entries(AppLocale locale) =>
      [
        for (final p in pairs(locale)) (a: p.a, b: p.b, tone: ContentTone.soft),
        ..._hot(locale),
      ];

  /// Dilemmi da modalità Hot: diretti su sesso, ex e segreti del gruppo.
  static const List<({String a, String b, String tone})> hotIt =
      <({String a, String b, String tone})>[
        (
          a: 'Uscire nudo in giro per un minuto',
          b: 'Baciare una persona di questo gruppo',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Passare la notte con uno del gruppo',
          b: 'Una notte con un tuo vecchio prof',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Mostrare la galleria al gruppo',
          b: 'Far leggere le tue chat ad alta voce',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Un anno senza sesso',
          b: 'Un anno senza uscire la sera',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Dire il tuo body count al gruppo',
          b: 'Mostrare l\'ultima ricerca fatta',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Amore senza sesso',
          b: 'Sesso senza amore',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Partner bello ma pessimo a letto',
          b: 'Partner normale ma fenomenale',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Una notte col tuo ex',
          b: 'Una notte con uno sconosciuto',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Beccare i tuoi genitori',
          b: 'Farti beccare dai tuoi',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Dire a tutti chi ti piace adesso',
          b: 'Non parlare mai più con chi ti piace',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Baciare a occhi chiusi uno del gruppo',
          b: 'Baciare il tuo ex davanti a tutti',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Non poter più baciare',
          b: 'Non poter più abbracciare',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Sapere con chi ti tradirebbe il partner',
          b: 'Non saperlo mai',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Solo appuntamenti al buio per un anno',
          b: 'Solo uscite scelte da tua madre',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Rivedere in video il tuo primo bacio',
          b: 'Che lo riveda tutto il gruppo',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Gemere ogni volta che ti siedi',
          b: 'Urlare il nome del tuo ex ogni brindisi',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Mandare un nude all\'ex per sbaglio',
          b: 'Mandarlo nel gruppo famiglia',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Sexting col capo per errore',
          b: 'Chiamare il partner col nome dell\'ex',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Una notte con una celebrità',
          b: 'Un mese di sesso col tuo ex',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Fare sesso solo al buio totale',
          b: 'Solo con la luce sempre accesa',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Dire la tua fantasia più strana',
          b: 'Sentire quella di chi hai a destra',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Amici di letto col tuo migliore amico',
          b: 'Mai più sesso per un anno',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Un ex che bacia da dio',
          b: 'Uno nuovo tutto da istruire',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Farti spogliare con gli occhi al bar',
          b: 'Non essere mai più notato',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Raccontare il tuo peggior appuntamento',
          b: 'Rivivere la tua figuraccia più hot',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Fare sempre tu la prima mossa',
          b: 'Aspettare sempre che parta l\'altro',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Una cosa a tre con sconosciuti',
          b: 'Una cosa a tre con amici',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Beccare il coinquilino in azione',
          b: 'Farti beccare dal coinquilino',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Dire quante volte ci pensi al giorno',
          b: 'Dire quando l\'hai fatto l\'ultima volta',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Partner super geloso ma bollente',
          b: 'Partner tranquillo ma pigro a letto',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Baciare il primo che entra dalla porta',
          b: 'Baciare l\'ultimo che ti ha scritto',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Notte di passione senza baci',
          b: 'Baci infiniti ma niente altro',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Dimenticare la tua prima volta',
          b: 'Ricordarla ogni singolo giorno',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Dire il posto più assurdo dove l\'hai fatto',
          b: 'Dire il posto dove vorresti farlo',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Un flirt col tuo personal trainer',
          b: 'Un flirt col tuo medico',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Solo one night stand per un anno',
          b: 'Solo relazioni serie a vita',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Rifarti con l\'ex ogni tanto',
          b: 'Chiudere per sempre ma con rimpianto',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Un limone con chi hai a sinistra',
          b: 'Un lento sensuale con chi hai a destra',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Dormire nudo con un amico',
          b: 'Fare la doccia in costume con l\'ex',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Ricevere un nude non richiesto dal capo',
          b: 'Mandarne uno al capo per sbaglio',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Sesso da urlo una volta al mese',
          b: 'Sesso mediocre ogni giorno',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Sapere cosa pensa l\'altro a letto',
          b: 'Che senta ogni tuo pensiero a letto',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Un weekend con la tua cotta segreta',
          b: 'Un mese col tuo primo amore',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Colazione a letto dopo la prima notte',
          b: 'Sparire prima dell\'alba',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Dire il tuo punto debole a letto',
          b: 'Mimarlo davanti al gruppo',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Tatuarti il nome dell\'ex',
          b: 'Urlare il suo nome al momento sbagliato',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Match col tuo ex su un\'app',
          b: 'Match col tuo capo su un\'app',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Il partner sa ogni tua fantasia',
          b: 'Tu sai ogni sua fantasia',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Spogliarello improvvisato ora',
          b: 'Racconto piccante della tua estate',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Baciare uno del gruppo a scelta tua',
          b: 'Baciarne uno scelto dal gruppo',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Storia segreta super passionale',
          b: 'Storia ufficiale ma tiepida',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Fare sesso solo d\'estate',
          b: 'Fare sesso solo d\'inverno',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Scordare ogni tua notte brava',
          b: 'Ricordare pure quelle da dimenticare',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Audio hot mandato alla persona sbagliata',
          b: 'Riceverne uno dal tuo capo',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Far leggere i messaggi con l\'ex',
          b: 'Far vedere le foto con l\'ex',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Amore a prima vista stasera',
          b: 'Avventura di una notte stasera',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Dire il nome della tua cotta al gruppo',
          b: 'Farla indovinare al gruppo',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Ballare un lento col tuo ex stasera',
          b: 'Karaoke romantico con uno del gruppo',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Provarci con uno sconosciuto ora',
          b: 'Dare il numero al primo che lo chiede',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Un massaggio da uno del gruppo',
          b: 'Farlo tu a uno del gruppo',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Vietato flirtare per un anno',
          b: 'Obbligo di flirtare con chiunque',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Una notte col tuo idolo musicale',
          b: 'Un weekend col tuo attore preferito',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Confessare un sogno hot su un presente',
          b: 'Che un presente lo confessi su di te',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Silenzio totale a letto',
          b: 'Telecronaca completa a letto',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Un lato B da urlo',
          b: 'Un décolleté da applausi',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Il tuo ex diventa famosissimo',
          b: 'Il tuo ex diventa il tuo capo',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Dire cosa ti eccita di più',
          b: 'Dire cosa ti spegne subito',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Una tresca estiva mai confessata',
          b: 'Un amore a distanza infinito',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Due presenti ti fanno il filo',
          b: 'Fare il filo a due presenti insieme',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Vedere l\'ex con uno più bello di te',
          b: 'Che ti veda con uno peggio di lui',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Baci col morso',
          b: 'Baci a stampo per sempre',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Dormire abbracciati senza sesso',
          b: 'Sesso senza mai dormire insieme',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Fare sesso con la musica a palla',
          b: 'Col telegiornale in sottofondo',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Rivelare il tuo numero di ex',
          b: 'Rivelare chi era il migliore',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Provarci col cameriere stasera',
          b: 'Lasciargli il numero sullo scontrino',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Prima volta imbarazzante ma dolce',
          b: 'Perfetta ma con la persona sbagliata',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Un tatuaggio dove decide il gruppo',
          b: 'Un piercing dove decide il gruppo',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Un bacio di 30 secondi con un presente',
          b: 'Dieci baci veloci con dieci sconosciuti',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Sapere chi del gruppo ti sogna di notte',
          b: 'Sapere chi non ti bacerebbe mai',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Sesso in tenda in campeggio pieno',
          b: 'In hotel con pareti di carta',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Una vacanza solo per single',
          b: 'Una vacanza solo per coppie',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Sesso anale ogni volta',
          b: 'Mai più sesso per un anno',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Essere dominato',
          b: 'Essere dominante',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Fare sesso con due persone contemporaneamente',
          b: 'Farne a meno per sei mesi',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Farti filmare mentre lo fai',
          b: 'Non farlo mai più',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Leccare ovunque',
          b: 'Essere leccato ovunque',
          tone: ContentTone.piccante,
        ),
        (a: 'Ingoiare', b: 'Sputare', tone: ContentTone.cattivo),
        (
          a: 'Farti bendare e legare',
          b: 'Essere tu a bendare e legare',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Sesso selvaggio con uno sconosciuto',
          b: 'Sesso mediocre col partner ideale',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Farlo ingoiare a lui',
          b: 'Farglielo sputare addosso',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Una cosa a tre con sconosciuti',
          b: 'Con due amici stretti di qui',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Solo sesso orale per un anno',
          b: 'Mai più sesso orale',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Ricevere sempre l\'orale',
          b: 'Farlo sempre tu',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un orale finito in bocca',
          b: 'Un orale finito sul viso',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Leccare fino all\'orgasmo',
          b: 'Essere leccata fino all\'orgasmo',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un pompino di 30 minuti',
          b: 'Venire in 30 secondi',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso a tre con due sconosciuti',
          b: 'Guardare il partner con un altro',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso a tre con due uomini',
          b: 'Sesso a tre con due donne',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un\'orgia da otto persone',
          b: 'Sesso da soli per un anno',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Guardare il partner scopare un altro',
          b: 'Farti guardare mentre scopi',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Uno sconosciuto ti guarda venire',
          b: 'Guardi uno sconosciuto venire',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farti legare e bendare',
          b: 'Legare e bendare tu',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Essere frustata dolcemente',
          b: 'Frustare tu il partner',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sottomessa per una notte',
          b: 'Dominatrice per una notte',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Collare e guinzaglio addosso a te',
          b: 'Metterli tu al partner',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sculacciata fino a lasciare il segno',
          b: 'Sculacciare tu fino al segno',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Legata al letto tutta la notte',
          b: 'Legare tu il partner al letto',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Bendata e in balia del partner',
          b: 'Bendare tu e comandare',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un vibratore per un\'ora senza fermarsi',
          b: 'Nessun orgasmo per un mese',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Orgasmo negato per giorni',
          b: 'Orgasmi forzati a ripetizione',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un plug indossato tutto il giorno',
          b: 'Un vibratore in pubblico',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Provare tutti i sex toy del negozio',
          b: 'Solo mani per sempre',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un dildo enorme',
          b: 'Un vibratore piccolo ma costante',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Manette vere ai polsi',
          b: 'Corde di seta sul corpo',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso nel bagno di un locale',
          b: 'Sesso in un vicolo al buio',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farlo in spiaggia di notte',
          b: 'Farlo in ascensore',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso in auto in un parcheggio',
          b: 'Sesso su un tetto di notte',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Rischiare di essere scoperti in ufficio',
          b: 'Farlo in un camerino',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso in treno in corsa',
          b: 'Sesso sotto un tavolo affollato',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un video hot che gira',
          b: 'Le tue chat hot che girano',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Le tue foto nude sul telefono di lui',
          b: 'Un tuo video intimo salvato',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Registrare mentre lo fate',
          b: 'Fotografarti nuda per lui',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un nudo inviato per sbaglio al capo',
          b: 'Un nudo visto dai tuoi amici',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Fare sesso davanti a una webcam',
          b: 'Fare sesso con la luce accesa sempre',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso ruvido e senza pieta',
          b: 'Sesso lento tutta la notte',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Venire cinque volte di fila',
          b: 'Un solo orgasmo lunghissimo',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Fingere sempre l\'orgasmo',
          b: 'Non venire mai più',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un orgasmo ogni ora per un giorno',
          b: 'Nessun orgasmo per un anno',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Squirtare davanti a lui',
          b: 'Vederlo venire sul tuo corpo',
          tone: ContentTone.cattivo,
        ),
        (a: 'Sesso anale', b: 'Doppia penetrazione', tone: ContentTone.cattivo),
        (
          a: 'Provare l\'anale la prima volta',
          b: 'Non provarlo mai',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Rimorchiare uno sconosciuto stasera',
          b: 'Un ex per un\'ultima notte',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Una notte con il tuo mito del cinema',
          b: 'Una notte con il tuo ex migliore',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso con il migliore amico di lui',
          b: 'Sesso con la migliore amica di lei',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Scambio di coppia con amici',
          b: 'Scambio con perfetti sconosciuti',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Baciare tutti a un\'orgia',
          b: 'Scegliere solo una persona',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un massaggio che finisce a letto',
          b: 'Un lap dance privato',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Spogliarello davanti al gruppo',
          b: 'Ballare nuda su un palo',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Leccare la panna dal suo corpo',
          b: 'Fargli leccare il cioccolato da te',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso coperti di olio',
          b: 'Sesso sotto la doccia bollente',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un feticcio dei piedi soddisfatto',
          b: 'Un feticcio del sedere soddisfatto',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farti succhiare le dita dei piedi',
          b: 'Succhiare tu le sue',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Indossare solo lingerie a cena fuori',
          b: 'Niente intimo a cena fuori',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un corsetto stretto tutta la sera',
          b: 'Tacchi a spillo e nient\'altro',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso con la maschera sul viso',
          b: 'Sesso al buio totale',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Dire ad alta voce le tue fantasie',
          b: 'Realizzarne una a caso',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un gioco di ruolo prof e studente',
          b: 'Un gioco di ruolo capo e segretaria',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Fingervi due sconosciuti in un bar',
          b: 'Fingervi ex che si ritrovano',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso mentre gli altri dormono vicino',
          b: 'Sesso urlando senza freni',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farti dire cose sporche all\'orecchio',
          b: 'Dirle tu a lui',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sexting per tutto il giorno di lavoro',
          b: 'Foto hot ogni ora',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un pompino mentre guida',
          b: 'Un ditalino al cinema',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sedurlo con lo sguardo per un\'ora',
          b: 'Saltargli addosso subito',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Cavalcarlo fino a sfinirlo',
          b: 'Lasciarti prendere da dietro',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso in tre posizioni di fila',
          b: 'Un\'ora nella stessa posizione',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farlo venire solo con le mani',
          b: 'Solo con la bocca',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un pompino bendato',
          b: 'Un rapporto bendato',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Ghiaccio sulla pelle nuda',
          b: 'Cera calda sul corpo',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Mordere fino a lasciare i segni',
          b: 'Graffiare la schiena a fondo',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Succhiotti visibili sul collo',
          b: 'Segni di morsi sull\'interno coscia',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso con un solo partner per sempre',
          b: 'Un partner diverso ogni mese',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Vedere il partner nudo con un altro',
          b: 'Non sapere mai cosa fa',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un trio programmato nei dettagli',
          b: 'Un trio totalmente improvvisato',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farti spogliare lentamente da lui',
          b: 'Spogliarlo tu con i denti',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso con lui in uniforme',
          b: 'Sesso con te in uniforme',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un lungo preliminare senza penetrazione',
          b: 'Penetrazione subito senza preliminari',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Edging per un\'ora',
          b: 'Orgasmo immediato e via',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farti toccare in un locale affollato',
          b: 'Toccarlo tu sotto il tavolo',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un dito extra durante il rapporto',
          b: 'Una lingua extra durante il rapporto',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso davanti allo specchio',
          b: 'Sesso ripreso col telefono',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Indossare un plug a cena dai suoceri',
          b: 'Un vibratore comandato da lui',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Vibratore telecomandato in metro',
          b: 'Vibratore telecomandato al ristorante',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Una spanking session lunga',
          b: 'Una session di bondage lunga',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sospesa con corde giapponesi',
          b: 'Immobilizzata con nastro adesivo',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un massaggio integrale da uno del gruppo',
          b: 'Una doccia insieme a uno del gruppo',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Baciare il collega che ti piace da mesi',
          b: 'Sentirti dire che ricambia ma è fidanzato',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Sesso lento tutta la notte',
          b: 'Sesso veloce e travolgente in un minuto',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Dire ad alta voce la tua parola d\'ordine',
          b: 'Mimare la tua posizione preferita',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Flirt bollente col migliore amico del tuo ex',
          b: 'Un flirt bollente col vicino di casa',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Fare sesso solo in luoghi pubblici',
          b: 'Fare sesso solo con la porta aperta',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Un weekend di puro sesso senza parlare',
          b: 'Un weekend di sole coccole senza sesso',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Ricevere un lap dance da chi hai a destra',
          b: 'Farne uno a chi hai a sinistra',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Confessare a quale presente faresti la corte',
          b: 'Farti scegliere un pretendente dal gruppo',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Provare tutto in una notte con lo sconosciuto',
          b: 'Restare casto per un anno con l\'amore vero',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Un bacio alla francese col tuo primo amore',
          b: 'Un abbraccio infinito con la tua ultima cotta',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Baciare tutti i presenti a turno',
          b: 'Baciarne uno solo per dieci minuti',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Dire quanto duri di media a letto',
          b: 'Dire il tuo record personale',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Un incontro proibito con l\'insegnante di ballo',
          b: 'Un incontro proibito con il barista sotto casa',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Sedurre uno sconosciuto in dieci minuti',
          b: 'Farti sedurre senza dire una parola',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Solo lingerie provocante per un mese',
          b: 'Solo pigiami sformati per un anno',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Fare sesso con lo stesso partner per sempre',
          b: 'Un partner diverso ogni settimana senza amore',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Farti spogliare lentamente da chi hai davanti',
          b: 'Spogliare tu chi ti sta accanto',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Dire la fantasia che non hai mai realizzato',
          b: 'Realizzarla stasera con un presente',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Un bacio appassionato sotto la pioggia',
          b: 'Una notte di fuoco davanti al camino',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Sesso con la persona più bella mai vista',
          b: 'Sesso indimenticabile con chi ami davvero',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Farti mordere il collo da chi hai a destra',
          b: 'Mordere tu il collo a chi hai a sinistra',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Quante volte hai pensato a un presente',
          b: 'Un presente confessi quante volte pensa a te',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Un anno di sole avventure senza domani',
          b: 'Un anno di sola attesa per la persona giusta',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Baciare uno bendato e indovinare chi è',
          b: 'Farti baciare e far indovinare a tutti',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Sesso sfrenato ma senza mai rivedersi',
          b: 'Attesa infinita ma poi per sempre',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Un ballo provocante davanti a tutto il gruppo',
          b: 'Un bacio a sorpresa scelto dal gruppo',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Fare la doccia insieme al tuo ex',
          b: 'Fare il bagno insieme alla tua cotta',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Dire chi del gruppo baceresti al buio',
          b: 'Dire chi del gruppo non baceresti mai',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Massaggio ai piedi da uno sconosciuto sexy',
          b: 'Un massaggio alla schiena dal tuo ex',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Fare sesso solo con il buio e le candele',
          b: 'Fare sesso solo davanti allo specchio',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Flirt segreto col tuo istruttore di nuoto',
          b: 'Un flirt segreto con il tuo tatuatore',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Rivelare l\'oggetto più osé che possiedi',
          b: 'Mostrarlo al gruppo',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Passare la notte con la tua cotta del liceo',
          b: 'Passare la notte con la tua cotta di ora',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Solo baci lenti per un mese',
          b: 'Solo notti di passione ma niente baci',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Farti sussurrare cose bollenti all\'orecchio',
          b: 'Sussurrarle tu a chi hai accanto',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Dire il soprannome hot che dai al partner',
          b: 'Dire quello che il partner dà a te',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Una notte con chi ti ha rifiutato anni fa',
          b: 'Una notte con chi ti desidera da sempre',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Fare sesso al primo appuntamento sempre',
          b: 'Aspettare tre mesi ogni volta',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Baciare chi hai davanti per venti secondi',
          b: 'Abbracciare chi hai dietro per due minuti',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Il luogo più rischioso dove ci hai provato',
          b: 'L\'ora più assurda in cui l\'hai fatto',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Un weekend alle terme solo con uno del gruppo',
          b: 'Una crociera romantica con uno sconosciuto',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Farti leggere nel pensiero durante un bacio',
          b: 'Leggere tu i pensieri di chi baci',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Solo appuntamenti bollenti ma mai un secondo',
          b: 'Solo appuntamenti dolci ma senza scintilla',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Rivelare quanti presenti troveresti attraenti',
          b: 'Farti dire da ognuno se ti trova attraente',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Fare sesso ascoltando la tua canzone preferita',
          b: 'Farlo nel silenzio più totale',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Una notte con un modello ma senza parole',
          b: 'Una notte con uno spiritoso ma niente sesso',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Un limone appassionato con chi hai a destra',
          b: 'Un massaggio sensuale da chi hai a sinistra',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Quale parte del corpo ti fa perdere la testa',
          b: 'Farla indovinare al gruppo',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Sedurre chi ti piace scrivendo solo emoji',
          b: 'Sedurlo con un unico vocale imbarazzante',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Fare sesso solo la mattina presto',
          b: 'Fare sesso solo a notte fonda',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Un bacio rubato al tuo capo per scommessa',
          b: 'Un bacio rubato al miglior amico del partner',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Confessare la tua fantasia con un vip',
          b: 'Sentire quella di chi hai davanti',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Solo relazioni a distanza ma passionali',
          b: 'Solo relazioni vicine ma tiepide',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Farti fare un succhiotto ben visibile',
          b: 'Farne uno tu a chi hai accanto',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Dire quante volte hai fatto la prima mossa',
          b: 'Dire quante volte ti sei tirato indietro',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Una notte di passione ma la dimentichi',
          b: 'Nessuna notte ma il ricordo di un bacio',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Baciare la persona più timida del gruppo',
          b: 'Baciare la più sfacciata del gruppo',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Fare uno strip poker con i presenti',
          b: 'Fare un obbligo o verità solo piccante',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Sedurre qualcuno solo con lo sguardo',
          b: 'Sedurlo solo con una frase',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Un appuntamento hot deciso dal tuo ex',
          b: 'Un appuntamento hot deciso da tua madre',
          tone: ContentTone.piccante,
        ),
        (
          a: 'Un morso sul capezzolo',
          b: 'Pinze sui capezzoli',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un blindfold e sorprese a sorpresa',
          b: 'Sapere tutto in anticipo',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farti umiliare a parole a letto',
          b: 'Umiliare tu lui a parole',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un padrone per una notte',
          b: 'Una schiava per una notte',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Obbedire a ogni ordine per un\'ora',
          b: 'Dare tu gli ordini per un\'ora',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso con una parola di sicurezza',
          b: 'Sesso senza limiti concordati',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un piano a tre con una escort',
          b: 'Un piano a tre con un amico',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farsi filmare da un terzo presente',
          b: 'Farsi solo guardare da un terzo',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso su un balcone a vista',
          b: 'Sesso in giardino di notte',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un quickie in cucina',
          b: 'Un maratona in camera',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farlo sul tavolo della sala',
          b: 'Farlo contro il muro dell\'ingresso',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso appena svegli ogni mattina',
          b: 'Sesso solo a mezzanotte ogni notte',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Provare il wax play',
          b: 'Provare il temperature play',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un vibratore mentre lui ti guarda',
          b: 'Le sue mani mentre tu ti guardi',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Masturbarti davanti a lui',
          b: 'Guardarlo masturbarsi per te',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un orgasmo solo con le parole',
          b: 'Un orgasmo solo con un giocattolo',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso con lo sperma sul viso',
          b: 'Sesso con lo sperma sul corpo',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farti finire dentro',
          b: 'Farti finire fuori',
          tone: ContentTone.cattivo,
        ),
        (a: 'Un creampie', b: 'Un facial', tone: ContentTone.cattivo),
        (
          a: 'Leccarlo dopo che è venuto',
          b: 'Farti leccare dopo che sei venuta',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un rapporto in piena luce del giorno',
          b: 'Un rapporto solo a lume di candela',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso con musica a tutto volume',
          b: 'Sesso in totale silenzio',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farsi legare i polsi con la cravatta',
          b: 'Legare le caviglie con le calze',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Una benda e cuffie insonorizzate',
          b: 'Solo la benda sugli occhi',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Dominare completamente per un giorno',
          b: 'Sottometterti completamente per un giorno',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso in tenda in campeggio',
          b: 'Sesso in piscina di notte',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un rapporto sul sedile posteriore',
          b: 'Un rapporto sul cofano',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Provare il pegging',
          b: 'Provare il rimming',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un dildo indossabile per lei',
          b: 'Un anello vibrante per lui',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farti prendere in bocca fino in fondo',
          b: 'Prenderlo tu fino in fondo',
          tone: ContentTone.cattivo,
        ),
        (a: 'Deep throat', b: 'Face sitting', tone: ContentTone.cattivo),
        (
          a: 'Sederti sul suo viso',
          b: 'Farlo sedere sul tuo',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un sixty-nine infinito',
          b: 'Alternarsi a turno',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso con un lubrificante riscaldante',
          b: 'Sesso con un gel effetto freddo',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farti bendare e indovinare i giocattoli',
          b: 'Indovinare le sue mani bendata',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un role play infermiera e paziente',
          b: 'Un role play poliziotta e arrestato',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Fingersi estranei in hotel',
          b: 'Fingersi vicini di casa curiosi',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso con lingerie strappata addosso',
          b: 'Sesso restando quasi vestiti',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farti strappare le mutandine',
          b: 'Strappargli i boxer coi denti',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un orgasmo in meno di un minuto',
          b: 'Resistere per venti minuti',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Contare gli orgasmi ad alta voce',
          b: 'Restare in assoluto silenzio',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un threesome con la tua cotta',
          b: 'Un threesome con la sua cotta',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Guardare porno insieme e imitarlo',
          b: 'Inventare tutto senza riferimenti',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Ricreare una scena porno famosa',
          b: 'Girare un vostro video amatoriale',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso con i tacchi ancora addosso',
          b: 'Sesso completamente nudi',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farti tenere un ovetto tutto il giorno',
          b: 'Un plug tutto il pomeriggio',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un massaggio erotico completo',
          b: 'Un bagno erotico a due',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso con olio profumato ovunque',
          b: 'Sesso ricoperti di schiuma',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farlo sedurre da un\'altra davanti a te',
          b: 'Sedurre tu un altro davanti a lui',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Uno strip poker che finisce a letto',
          b: 'Un obbligo o verita hot fino in fondo',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Baciare una donna davanti a lui',
          b: 'Guardarlo baciare un uomo',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un primo bacio saffico',
          b: 'Un primo bacio gay',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso con due mani su di te',
          b: 'Sesso con due bocche su di te',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farti stringere il collo dolcemente',
          b: 'Stringere tu i suoi polsi',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un choking leggero concordato',
          b: 'Un hair pulling deciso',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso con i capelli tirati',
          b: 'Sesso con le unghie sulla schiena',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farti prendere da dietro allo specchio',
          b: 'Prenderlo tu cavalcandolo allo specchio',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un orgasmo negato per tre giorni',
          b: 'Tre orgasmi in un\'ora',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farsi guardare mentre ti spogli in webcam',
          b: 'Guardare lui spogliarsi in webcam',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un vibratore condiviso a turno',
          b: 'Due giocattoli contemporaneamente',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Sesso su una sedia legata',
          b: 'Sesso in piedi contro la finestra',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farti mordere il labbro fino a farlo',
          b: 'Mordergli il collo con foga',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Un rapporto interrotto e ripreso più volte',
          b: 'Un rapporto unico senza pause',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Provare il sensory deprivation',
          b: 'Provare il sensory overload',
          tone: ContentTone.cattivo,
        ),
        (
          a: 'Farti solleticare bendata',
          b: 'Solleticare tu lui immobilizzato',
          tone: ContentTone.cattivo,
        ),
      ];

  static const List<({String a, String b})> it = <({String a, String b})>[
    (a: 'Sapere come morirai', b: 'Sapere quando'),
    (a: 'Una verità scomoda', b: 'Una bugia comoda'),
    (a: 'Più soldi', b: 'Più tempo libero'),
    (a: 'Essere famoso', b: 'Essere invisibile alla gente'),
    (a: 'Viaggiare nel passato', b: 'Viaggiare nel futuro'),
    (a: 'Leggere nel pensiero', b: 'Prevedere il futuro'),
    (a: 'Mai più social', b: 'Mai più film'),
    (a: 'Perdere il telefono', b: 'Perdere le chiavi di casa'),
    (a: 'Sempre 5 minuti in anticipo', b: 'Sempre 10 minuti in ritardo'),
    (a: 'Capo simpatico ma incapace', b: 'Capo antipatico ma bravo'),
    (
      a: 'Stipendio alto e lavoro noioso',
      b: 'Stipendio basso e lavoro che ami',
    ),
    (a: 'Matrimonio con 200 invitati', b: 'Matrimonio in due'),
    (a: 'Una settimana senza uscire', b: 'Uscire tutte le sere'),
    (a: 'Dormire 10 ore', b: 'Dormire 5 ore e stare benissimo'),
    (a: 'Rifare la vacanza perfetta', b: 'Provare un posto nuovo'),
    (a: 'Controllare il conto ogni giorno', b: 'Non guardarlo mai'),
    (a: 'Superpotere inutile ma divertente', b: 'Superpotere utile ma noioso'),
    (a: 'Rileggere sempre lo stesso libro', b: 'Non finirne mai uno'),
    (a: 'Sapere sempre la verità', b: 'Vivere felice nell\'illusione'),
    (a: 'Un anno sabbatico', b: 'Andare in pensione un anno prima'),
    (a: 'Parlare tutte le lingue', b: 'Suonare tutti gli strumenti'),
    (a: 'Non provare mai imbarazzo', b: 'Non provare mai paura'),
    (a: 'Rivivere il tuo giorno migliore', b: 'Cancellare il peggiore'),
    (a: 'Convivere dopo un mese', b: 'Convivere dopo anni'),
    (a: 'Vacanza organizzata nei minimi dettagli', b: 'Partire all\'avventura'),
    (a: 'Una stagione tutta in una notte', b: 'Un episodio a settimana'),
    (a: 'Batteria sempre all\'1%', b: 'Internet lentissimo'),
    (
      a: 'Vestiti sempre un po\' bagnati',
      b: 'Sassolino nella scarpa per sempre',
    ),
    (a: 'Dire sempre ciò che pensi', b: 'Non poter più parlare'),
    (
      a: 'Niente riscaldamento d\'inverno',
      b: 'Niente aria condizionata d\'estate',
    ),
    (a: 'Piatto preferito a ogni pasto', b: 'Mai più il tuo piatto preferito'),
    (a: 'Mai più bisogno di dormire', b: 'Mai più bisogno di mangiare'),
    (a: 'Ricco ma senza amici', b: 'Squattrinato ma amatissimo'),
    (a: 'Niente più affitto a vita', b: 'Stipendio raddoppiato'),
    (a: 'Il più simpatico della stanza', b: 'Il più intelligente della stanza'),
    (a: 'Memoria fotografica', b: 'Dimenticare ogni figuraccia'),
    (a: 'Mai più code', b: 'Mai più traffico'),
    (a: 'Sopracciglia rasate per un anno', b: 'Capelli verde fluo per un anno'),
    (a: 'Perdere l\'olfatto', b: 'Perdere il gusto'),
    (a: 'Voce da cartone animato', b: 'Risata che imbarazza tutti'),
    (a: 'Cronologia visibile ai genitori', b: 'Chat lette dal tuo capo'),
    (a: 'Ruttare alla fine di ogni frase', b: 'Ridere come una capra'),
    (
      a: 'Usare lo spazzolino di uno sconosciuto',
      b: 'Bere dal suo bicchiere già usato',
    ),
    (a: 'Uscire con il tuo ex', b: 'Con l\'ex del tuo migliore amico'),
    (a: 'Puzzette rumorose ma inodori', b: 'Silenziose ma micidiali'),
    (a: 'Dimenticare chi sei', b: 'Essere dimenticato da tutti'),
    (a: 'Perdere tutti i soldi', b: 'Perdere tutti i ricordi'),
    (a: 'Partner ricco ma noioso', b: 'Partner squattrinato ma esilarante'),
    (a: 'Un\'ora in ascensore col tuo ex', b: 'Un\'ora in ascensore col capo'),
    (a: 'Compleanno dimenticato da tutti', b: 'Festa a sorpresa imbarazzante'),
    (a: 'Il tuo segreto svelato a tutti', b: 'Sapere i segreti di tutti'),
    (a: 'Famoso ma odiato', b: 'Sconosciuto ma amato'),
    (a: 'Non ridere mai più', b: 'Non piangere mai più'),
    (
      a: 'Tornare alle superiori per un anno',
      b: 'Rifare l\'esame di maturità ogni anno',
    ),
    (a: 'Vivere in un film horror', b: 'Vivere in un musical'),
    (
      a: 'Sfidare un\'anatra grande come un cavallo',
      b: 'Cento cavalli grandi come anatre',
    ),
    (a: 'Vivere sott\'acqua', b: 'Vivere nello spazio'),
    (
      a: 'Inseguito a vita da una lumaca killer',
      b: 'Un clown che ti fissa ogni notte',
    ),
    (a: 'Parlare con gli animali', b: 'Controllare il meteo'),
    (a: 'Ballare appena parte la musica', b: 'Piangere quando qualcuno ride'),
    (
      a: 'Ogni mattina in un paese diverso',
      b: 'Mai più uscire dalla tua città',
    ),
    (a: 'Vivere in un videogioco', b: 'Vivere in un cartone animato'),
    (a: 'Tasto "pausa" per la vita', b: 'Tasto "riavvolgi" per la vita'),
    (a: 'Teletrasporto ma perdi sempre le scarpe', b: 'Volare a passo d\'uomo'),
    (a: 'Vivere 1000 anni', b: 'Dieci vite da 100 anni'),
    (a: 'Re del mondo per un giorno', b: 'Persona normale per sempre'),
    (
      a: 'Sapere tutto ma non provare emozioni',
      b: 'Provare tutto ma non capire niente',
    ),
    (a: 'Cancellare un rimpianto', b: 'Garantirti un successo futuro'),
    (
      a: 'Coda che scodinzola quando sei felice',
      b: 'Orecchie che si abbassano se sei triste',
    ),
    (a: 'Rinunciare al caffè per sempre', b: 'Rinunciare al cioccolato'),
    (
      a: 'Naso che cresce quando menti',
      b: 'Capelli che cambiano colore con l\'umore',
    ),
    (a: 'Trovare l\'amore della vita', b: 'Trovare il lavoro dei sogni'),
    (a: 'Ricchissimo ma sempre triste', b: 'Al verde ma sempre felice'),
    (a: 'Un milione subito', b: '3.000 euro al mese a vita'),
    (a: 'Salvare il tuo cane', b: 'Salvare uno sconosciuto'),
    (a: 'Non poter mai mentire', b: 'Credere a ogni bugia'),
    (a: 'Avere sempre ragione ma da solo', b: 'Sbagliare ma in compagnia'),
    (a: 'Genio incompreso', b: 'Sempliciotto felice'),
    (a: 'Stesso outfit ogni giorno', b: 'Mai ripetere un outfit'),
    (a: 'Cantare tutto ciò che dici', b: 'Camminare solo all\'indietro'),
    (a: 'Wi-Fi gratis ovunque a vita', b: 'Voli gratis a vita'),
    (a: 'Mangiare solo cibo bollente', b: 'Solo cibo ghiacciato'),
    (a: 'Mai più aperitivi', b: 'Mai più cibo a domicilio'),
    (a: 'Vita lunga piena di rimpianti', b: 'Vita breve senza rimpianti'),
    (a: 'Amare senza essere ricambiato', b: 'Essere amato da chi non ami'),
    (a: 'Il partner legge i tuoi pensieri', b: 'Tu leggi i suoi'),
    (a: 'Partner scelto dai tuoi amici', b: 'Partner scelto da un algoritmo'),
    (a: 'Capire sempre chi ti mente', b: 'Non farti mai beccare quando menti'),
    (a: 'Rivivere per sempre i tuoi 18 anni', b: 'Saltare direttamente ai 40'),
    (a: 'Dormire sempre a casa di altri', b: 'Avere sempre ospiti a casa tua'),
    (
      a: 'Concerto della tua band preferita da solo',
      b: 'Festival con amici ma musica che odi',
    ),
    (
      a: 'Fare karaoke stonando davanti a tutti',
      b: 'Ballare da solo in pista per un\'ora',
    ),
    (a: 'Perdere tutte le foto del telefono', b: 'Perdere tutte le chat'),
    (a: 'Essere alto 2 metri e 20', b: 'Essere alto un metro e 20'),
    (a: 'Vivere senza estate', b: 'Vivere senza inverno'),
    (a: 'Salvare cinque sconosciuti', b: 'Salvare il tuo migliore amico'),
    (a: 'Un milione ma mai più smartphone', b: 'Zero soldi ma col telefono'),
    (a: 'Lavoro dei sogni all\'estero', b: 'Lavoro noioso vicino agli amici'),
    (a: 'Avere 25 anni per sempre', b: 'Invecchiare con i tuoi amici'),
    (a: 'Casa dei sogni in mezzo al nulla', b: 'Monolocale in pieno centro'),
    (
      a: 'Sapere cosa dicono di te alle spalle',
      b: 'Vivere sereno senza saperlo',
    ),
    (a: 'Ogni pasto cucinato da uno chef', b: 'Autista personale a vita'),
    (
      a: 'Commentare ad alta voce tutto ciò che fai',
      b: 'Sentire la voce narrante della tua vita',
    ),
    (a: 'Zanzara in camera ogni notte', b: 'Mosca sul piatto a ogni pasto'),
    (a: 'Autocorrettore impazzito a vita', b: 'Mai più emoji'),
    (a: 'Chiamate solo in vivavoce', b: 'Schermo sempre visibile a tutti'),
    (
      a: 'Il tuo cane parla ma ti critica',
      b: 'Il tuo specchio ti fa complimenti falsi',
    ),
    (a: 'Un milione solo per te', b: 'Centomila a testa per il gruppo'),
    (a: 'Essere sempre sottovalutato', b: 'Essere sempre sopravvalutato'),
    (
      a: 'Riscoprire da zero la tua serie preferita',
      b: 'Vedere in anteprima ogni finale',
    ),
    (a: 'Parlare solo urlando', b: 'Parlare solo sussurrando'),
    (a: 'Ridere sempre nei momenti seri', b: 'Piangere a ogni film comico'),
    (a: 'Mangiare sempre con le mani', b: 'Mangiare tutto col cucchiaino'),
    (
      a: 'I tuoi sogni proiettati agli amici',
      b: 'Gli amici leggono il tuo diario',
    ),
    (a: 'Unico single del gruppo per sempre', b: 'Primo del gruppo a sposarti'),
    (a: 'Rinascere negli anni \'80', b: 'Nascere nel 2050'),
    (
      a: 'Ristoranti gratis ma sempre da solo',
      b: 'Pagare sempre ma in compagnia',
    ),
    (a: 'Virale per una figuraccia epica', b: 'Mai più di 10 like'),
    (a: 'Bere solo acqua per sempre', b: 'Mai più acqua, solo bibite'),
    (a: 'Un solo genere musicale a vita', b: 'Una sola app sul telefono'),
    (a: 'In smoking in spiaggia', b: 'In costume a un matrimonio'),
    (a: 'Cucinare da chef stellato', b: 'Casa che si pulisce da sola'),
    (
      a: 'Volo lungo accanto a un chiacchierone',
      b: 'Volo lungo accanto a un neonato',
    ),
    (a: 'Colazione salata per sempre', b: 'Cena dolce per sempre'),
    (a: 'Vivere senza specchi', b: 'Vivere senza orologi'),
    (a: 'Parlare con le piante', b: 'Capire i neonati'),
    (a: 'Vincere sempre a carte', b: 'Trovare sempre parcheggio'),
    (a: 'Estate di 40 gradi senza mare', b: 'Inverno gelido senza neve'),
    (a: 'Solo film doppiati malissimo', b: 'Solo film coi sottotitoli sfasati'),
    (a: 'Trasloco ogni anno', b: 'Stessa casa per sempre'),
    (
      a: 'Suoneria imbarazzante per sempre',
      b: 'Sfondo imbarazzante per sempre',
    ),
    (a: 'Essere un meme famoso', b: 'Avere un sosia famoso'),
    (
      a: 'Ballare la macarena a ogni saluto',
      b: 'Salutare tutti con l\'inchino',
    ),
    (a: 'Weekend infinito ma sempre pioggia', b: 'Solo lunedì ma sempre sole'),
    (
      a: 'Un solo piatto ma cucinato perfetto',
      b: 'Cucinare tutto in modo mediocre',
    ),
    (a: 'Viaggio su Marte senza ritorno', b: 'Mai più lasciare l\'Italia'),
    (a: 'Dormire ogni notte in tenda', b: 'Dormire ogni notte sul divano'),
    (a: 'Un maggiordomo robot', b: 'Un cuoco robot'),
    (a: 'Sapere ogni gossip di Hollywood', b: 'Sapere ogni finale di serie tv'),
    (a: 'Solo cibo piccante per un anno', b: 'Mai più sale'),
    (
      a: 'Ballare benissimo una sola canzone',
      b: 'Ballare così così qualsiasi canzone',
    ),
    (a: 'Leggere il pensiero dei cani', b: 'Parlare con i gatti'),
    (
      a: 'Azzeccare sempre la fila più veloce',
      b: 'Azzeccare sempre l\'ascensore giusto',
    ),
    (
      a: 'Rivivere lo stesso giorno perfetto',
      b: 'Un giorno nuovo ma imprevedibile',
    ),
    (
      a: 'Essere invisibile un\'ora al giorno',
      b: 'Volare dieci minuti al giorno',
    ),
    (
      a: 'Cucinare per dieci ogni sera',
      b: 'Lavare i piatti di dieci ogni sera',
    ),
    (
      a: 'Zaino pesante ma con tutto il necessario',
      b: 'Zaino leggero ma mai la cosa giusta',
    ),
    (
      a: 'Foto sempre venute male ma ricordi perfetti',
      b: 'Foto perfette ma ricordi confusi',
    ),
    (
      a: 'Un karaoke obbligatorio a settimana',
      b: 'Un discorso in pubblico al mese',
    ),
    (
      a: 'Un maggiordomo umano imbarazzante',
      b: 'Un robot che ti giudica in silenzio',
    ),
  ];
}
