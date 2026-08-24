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
  static const List<({String a, String b, String tone})>
  hotIt = <({String a, String b, String tone})>[
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
    (
      a: 'Ingoiare tutto',
      b: 'Sputare in faccia',
      tone: ContentTone.cattivo,
    ),
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
      a: 'Farti scoprire mentre ti tocchi',
      b: 'Scoprire i tuoi genitori mentre lo fanno',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Una cosa a tre con sconosciuti',
      b: 'Con due amici stretti di qui',
      tone: ContentTone.piccante,
    ),
    (
      a: 'Tradire senza mai essere scoperto',
      b: 'Essere tradito senza saperlo mai',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Una storia col partner di un amico',
      b: 'Il tuo partner col tuo migliore amico',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Che escano le tue foto peggiori',
      b: 'Che escano le tue chat peggiori',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Sentire cosa dice il gruppo di te',
      b: 'Che il gruppo senta cosa dici tu',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Confessare il tuo peggior segreto ora',
      b: 'Che lo sveli il tuo migliore amico',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Sesso con l\'ex del tuo migliore amico',
      b: 'Dirgli che ci hai già pensato',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Sapere tutto dei presenti',
      b: 'Che i presenti sappiano tutto di te',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Un ex che torna sempre',
      b: 'Mai più notizie di nessun ex',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Fare coppia fissa con uno del gruppo',
      b: 'Non poter più vedere il gruppo',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Scoprire un tradimento del passato',
      b: 'Confessarne uno tuo adesso',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Leggere il diario segreto del partner',
      b: 'Che lui legga tutte le tue chat',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Sapere chi del gruppo parla male di te',
      b: 'Sapere chi ti ha mentito di più',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Un ex che spunta al primo appuntamento',
      b: 'Un partner che nomina sempre l\'ex',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Tradire in un sogno e confessarlo',
      b: 'Sognare l\'ex ogni notte e tacere',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Sapere il vero body count del partner',
      b: 'Che lui scopra il tuo vero',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Baciare l\'ex del tuo migliore amico',
      b: 'Che lui baci il tuo ex',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Una notte col partner di un collega',
      b: 'Che tutti pensino che l\'hai fatto',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Scoprire che l\'ex ti tradiva sempre',
      b: 'Scoprire che ti ha sempre amato',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Vendicarti di un ex e pentirtene',
      b: 'Perdonarlo e pentirtene di più',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Il gruppo legge la tua ultima chat hot',
      b: 'Il gruppo vede le tue foto private',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Confessare a chi hai fatto ghosting',
      b: 'Chiamare ora chi ti ha ghostato',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Essere lasciato con un vocale',
      b: 'Lasciare qualcuno al suo compleanno',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Rubare il partner a qualcuno',
      b: 'Fartelo rubare e riprendertelo',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Sapere ogni bugia detta dal partner',
      b: 'Che il partner sappia ogni tua bugia',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Dire al gruppo il tuo peggior tradimento',
      b: 'Dire il segreto peggiore di un amico',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Flirtare col partner del tuo capo',
      b: 'Che il tuo capo flirti col tuo',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Un amico che ci prova col tuo partner',
      b: 'Un partner che ci prova col tuo amico',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Trovare un regalo dell\'ex a casa sua',
      b: 'Trovare chat con l\'ex nel suo telefono',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Cancellare per sempre un tuo segreto',
      b: 'Scoprire quello che ti nascondono',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Dire con chi del gruppo non usciresti',
      b: 'Sentire chi non uscirebbe mai con te',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Un ex a cui devi ancora dei soldi',
      b: 'Un ex che ti deve ancora delle scuse',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Ammettere di aver stalkerato l\'ex',
      b: 'Mostrare la cronologia dei suoi profili',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Sesso di nascosto a casa dei suoceri',
      b: 'Beccati da loro al momento peggiore',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Il tuo migliore amico ti odia',
      b: 'Il tuo amico ama il tuo partner',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Tradimento di una notte confessato',
      b: 'Storia parallela mai scoperta',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Rispondere nudo a tre domande',
      b: 'Rispondere vestito a trenta',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Sapere la data della fine della coppia',
      b: 'Sapere il motivo ma non la data',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Un rivale in amore più bello',
      b: 'Un rivale più simpatico',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Dire subito se il partner bacia male',
      b: 'Sposarlo senza dirglielo mai',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'L\'ex che ti scrive alle 3 di notte',
      b: 'Scrivergli tu e negare per sempre',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Partner ancora amico di tutti i suoi ex',
      b: 'Partner che ti vieta di vedere i tuoi',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Scoprire un profilo segreto del partner',
      b: 'Che lui trovi il tuo',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Amare due persone insieme',
      b: 'Essere l\'amante e non saperlo',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Dire chi dei presenti bacia peggio',
      b: 'Farti dare un voto da ogni presente',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Sabotare le nozze del tuo ex',
      b: 'Fare il testimone alle sue nozze',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Una lista pubblica dei tuoi flirt',
      b: 'Una lista di chi ti ha rifiutato',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Perdere l\'amico per dirgli la verità',
      b: 'Tenertelo mentendogli a vita',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Il tuo nemico sa il tuo segreto',
      b: 'Tua suocera sa tutto di te',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Scambiare il partner per una settimana',
      b: 'Vivere da single per un anno',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Il gruppo vota il tuo peggior difetto',
      b: 'Sentirli elencare tutti i tuoi flirt',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Tradire e confessarlo dopo dieci anni',
      b: 'Scoprirlo dopo dieci anni',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Un weekend con i tuoi suoceri',
      b: 'Un weekend con l\'ex del partner',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Sapere quanti ti hanno detto di no',
      b: 'Sapere chi si è pentito del sì',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Vuotare il sacco su un amore segreto',
      b: 'Che il gruppo indaghi per un\'ora',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Leggere ad alta voce l\'ultimo messaggio',
      b: 'Chiamare l\'ultimo numero in rubrica',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Rovinare una coppia dicendo la verità',
      b: 'Salvarla con una bugia enorme',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Il tuo ex parla di te in un podcast',
      b: 'Il gruppo racconta le tue notti peggiori',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Essere il piano B di qualcuno',
      b: 'Avere un piano B e farti beccare',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Il partner controlla il tuo telefono',
      b: 'Non poter mai guardare il suo',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Dire l\'ultima bugia detta a un presente',
      b: 'Ogni presente ne dice una su di te',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Uscire col gemello del tuo ex',
      b: 'Con qualcuno identico al tuo capo',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Sapere cosa dicono i tuoi ex di te',
      b: 'Riunirli tutti a una cena',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Tradire per vendetta e dirlo',
      b: 'Incassare e tramare in silenzio',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Baciare qualcuno per una scommessa',
      b: 'Scoprire di essere stato una scommessa',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Un matrimonio riparatore tra un mese',
      b: 'Dieci anni di fidanzamento senza nozze',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Spiare la serata dell\'ex dai social',
      b: 'Bloccarlo e morire di curiosità',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Confessare il flirt più squallido',
      b: 'Che lo racconti chi era presente',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Il gruppo sa chi ti piace qui dentro',
      b: 'Lo sa solo la persona sbagliata',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Scoprire una doppia vita del partner',
      b: 'Riuscire a nascondere la tua',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Rompere una coppia di amici parlando',
      b: 'Vederli infelici e stare zitto',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Il gruppo ti sceglie il partner',
      b: 'Il gruppo sceglie chi devi lasciare',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Dire il vero motivo del tuo ultimo addio',
      b: 'Sentire la versione del tuo ex',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Una notte con due ex insieme',
      b: 'Una notte con l\'ex e il suo nuovo amore',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Essere geloso e avere ragione',
      b: 'Fidarti ed essere tradito',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Ingoiare lo sperma ogni volta',
      b: 'Non ricevere mai più sesso orale',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Fare sesso anale ogni giorno',
      b: 'Non fare mai più sesso in vita tua',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Venire filmato mentre scopi',
      b: 'Farlo davanti a tutto il gruppo',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Che tutti sappiano quanto scopi male',
      b: 'Che sappiano qual è il tuo fetish più estremo',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Leccare l\'ano del tuo peggior nemico',
      b: 'Farti leccare l\'ano da un perfetto sconosciuto',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Venire in faccia a chi hai a destra',
      b: 'Farti venire in faccia da chi hai a sinistra',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Sesso a tre con due amici stretti',
      b: 'Sesso a tre con due perfetti sconosciuti',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Un anno di solo sesso anale',
      b: 'Un anno di solo sesso orale',
      tone: ContentTone.cattivo,
    ),
    (
      a: 'Che i tuoi vedano i tuoi messaggi hot',
      b: 'Che vedano un video mentre lo fai',
      tone: ContentTone.cattivo,
    ),
  ];

  static const List<({String a, String b})> it = <({String a, String b})>[
    (a: 'Sapere come morirai', b: 'Sapere quando'),
    (a: 'Una verità scomoda', b: 'Una bugia comoda'),
    (a: 'Più soldi', b: 'Più tempo libero'),
    (a: 'Essere famoso', b: 'Essere invisibile alla gente'),
    (a: 'Viaggiare nel passato', b: 'Viaggiare nel futuro'),
    (a: 'Saper volare', b: 'Essere invisibile'),
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
    (a: 'Vita senza musica', b: 'Vita senza cinema'),
    (a: 'Sapere sempre la verità', b: 'Vivere felice nell\'illusione'),
    (a: 'Un anno sabbatico', b: 'Andare in pensione un anno prima'),
    (a: 'Parlare tutte le lingue', b: 'Suonare tutti gli strumenti'),
    (a: 'Non provare mai imbarazzo', b: 'Non provare mai paura'),
    (a: 'Rivivere il tuo giorno migliore', b: 'Cancellare il peggiore'),
    (a: 'Convivere dopo un mese', b: 'Convivere dopo anni'),
    (a: 'Figli presto', b: 'Figli tardi'),
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
    (a: 'Singhiozzo a vita', b: 'Starnutire ogni due minuti'),
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
    (a: 'Palmi sempre sudati', b: 'Labbra sempre screpolate'),
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
    (a: 'Piedi al posto delle mani', b: 'Mani al posto dei piedi'),
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
    (a: 'Pioggia di tacos', b: 'Neve di gelato'),
    (a: 'Re del mondo per un giorno', b: 'Persona normale per sempre'),
    (
      a: 'Sapere tutto ma non provare emozioni',
      b: 'Provare tutto ma non capire niente',
    ),
    (a: 'Cancellare un rimpianto', b: 'Garantirti un successo futuro'),
    (a: 'Sempre affamato', b: 'Sempre assonnato'),
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
    (a: 'Mai più pizza', b: 'Mai più pasta'),
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
    (a: 'Starnutire coriandoli', b: 'Ruttare bolle di sapone'),
    (a: 'Avere quattro braccia', b: 'Avere quattro gambe'),
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
    (a: 'Camminare sui Lego ogni mattina', b: 'Doccia gelata ogni mattina'),
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
    (a: 'Rivivere lo stesso lunedì', b: 'Saltare tutti i venerdì'),
    (a: 'Parlare con le piante', b: 'Capire i neonati'),
    (a: 'Vincere sempre a carte', b: 'Trovare sempre parcheggio'),
    (a: 'Estate di 40 gradi senza mare', b: 'Inverno gelido senza neve'),
    (a: 'Solo film doppiati malissimo', b: 'Solo film coi sottotitoli sfasati'),
    (a: 'Caffè gratis a vita', b: 'Gelato gratis a vita'),
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
    (a: 'Nutella senza pane', b: 'Pane senza Nutella'),
    (a: 'Weekend infinito ma sempre pioggia', b: 'Solo lunedì ma sempre sole'),
    (
      a: 'Un solo piatto ma cucinato perfetto',
      b: 'Cucinare tutto in modo mediocre',
    ),
    (a: 'Viaggio su Marte senza ritorno', b: 'Mai più lasciare l\'Italia'),
    (a: 'Dormire ogni notte in tenda', b: 'Dormire ogni notte sul divano'),
    (a: 'Un maggiordomo robot', b: 'Un cuoco robot'),
    (a: 'Mai più ascensori', b: 'Mai più scale mobili'),
    (a: 'Sapere ogni gossip di Hollywood', b: 'Sapere ogni finale di serie tv'),
    (a: 'Solo cibo piccante per un anno', b: 'Mai più sale'),
    (a: 'Vivere senza musica', b: 'Vivere senza film'),
    (a: 'Sempre cinque minuti in ritardo', b: 'Sempre un\'ora in anticipo'),
    (
      a: 'Ballare benissimo una sola canzone',
      b: 'Ballare così così qualsiasi canzone',
    ),
    (a: 'Estate eterna', b: 'Inverno eterna'),
    (a: 'Mai più fritto', b: 'Mai più dolci'),
    (a: 'Leggere il pensiero dei cani', b: 'Parlare con i gatti'),
    (
      a: 'Azzeccare sempre la fila più veloce',
      b: 'Azzeccare sempre l\'ascensore giusto',
    ),
    (a: 'Casa in montagna', b: 'Casa al mare'),
    (
      a: 'Rivivere lo stesso giorno perfetto',
      b: 'Un giorno nuovo ma imprevedibile',
    ),
    (a: 'Wi-Fi lento per sempre', b: 'Batteria sempre al dieci per cento'),
    (
      a: 'Essere invisibile un\'ora al giorno',
      b: 'Volare dieci minuti al giorno',
    ),
    (a: 'Solo docce fredde', b: 'Solo treni regionali'),
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
