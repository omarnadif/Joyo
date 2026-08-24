import '../content_tone.dart';

/// Pool gratuito di "Non ho mai": 455 frasi, divise per tono
/// (155 soft, 150 piccante, 150 cattivo).
/// Ogni frase completa "Non ho mai…".
class NonHoMaiPool {
  const NonHoMaiPool._();

  static const List<({String text, String tone})>
  entries = <({String text, String tone})>[
    // ---------------------------------------------------------- soft
    (
      text: 'saltato il lavoro o la scuola fingendomi malato',
      tone: ContentTone.soft,
    ),
    (text: 'dormito fino a mezzogiorno passato', tone: ContentTone.soft),
    (text: 'mangiato qualcosa caduto per terra', tone: ContentTone.soft),
    (text: 'cantato sotto la doccia a squarciagola', tone: ContentTone.soft),
    (
      text: 'finto di conoscere una canzone per non fare brutta figura',
      tone: ContentTone.soft,
    ),
    (
      text: 'dimenticato il compleanno di un amico stretto',
      tone: ContentTone.soft,
    ),
    (text: 'perso un treno o un aereo', tone: ContentTone.soft),
    (text: 'viaggiato da solo', tone: ContentTone.soft),
    (text: 'rotto un osso', tone: ContentTone.soft),
    (text: 'fatto un tatuaggio', tone: ContentTone.soft),
    (text: 'tinto i capelli di un colore assurdo', tone: ContentTone.soft),
    (
      text: 'mandato un messaggio alla persona sbagliata',
      tone: ContentTone.soft,
    ),
    (
      text: 'finto di ridere a una battuta che non avevo capito',
      tone: ContentTone.soft,
    ),
    (text: 'parlato da solo ad alta voce', tone: ContentTone.soft),
    (text: 'pianto guardando un film', tone: ContentTone.soft),
    (text: 'guardato una stagione intera in un giorno', tone: ContentTone.soft),
    (text: 'mangiato la pizza con le posate', tone: ContentTone.soft),
    (text: 'messo l\'ananas sulla pizza', tone: ContentTone.soft),
    (text: 'cucinato qualcosa di immangiabile', tone: ContentTone.soft),
    (text: 'bruciato la cena', tone: ContentTone.soft),
    (text: 'dimenticato il fornello acceso', tone: ContentTone.soft),
    (text: 'chiuso le chiavi dentro casa', tone: ContentTone.soft),
    (text: 'dimenticato dove avevo parcheggiato', tone: ContentTone.soft),
    (text: 'preso una multa', tone: ContentTone.soft),
    (
      text: 'fatto finta di non vedere un conoscente per strada',
      tone: ContentTone.soft,
    ),
    (text: 'inventato una scusa per non uscire', tone: ContentTone.soft),
    (text: 'cancellato un piano all\'ultimo minuto', tone: ContentTone.soft),
    (
      text: 'detto "arrivo tra cinque minuti" mentre ero ancora a casa',
      tone: ContentTone.soft,
    ),
    (text: 'fatto la spesa affamato', tone: ContentTone.soft),
    (text: 'comprato qualcosa che non ho mai usato', tone: ContentTone.soft),
    (text: 'speso troppo per una cosa inutile', tone: ContentTone.soft),
    (text: 'vinto un premio', tone: ContentTone.soft),
    (text: 'cantato al karaoke', tone: ContentTone.soft),
    (text: 'ballato senza musica', tone: ContentTone.soft),
    (text: 'suonato uno strumento davanti a qualcuno', tone: ContentTone.soft),
    (text: 'dormito in aeroporto', tone: ContentTone.soft),
    (text: 'dormito in macchina', tone: ContentTone.soft),
    (text: 'dormito in tenda', tone: ContentTone.soft),
    (text: 'fatto il bagno di notte al mare', tone: ContentTone.soft),
    (text: 'avuto paura del buio da grande', tone: ContentTone.soft),
    (text: 'dormito con la luce accesa', tone: ContentTone.soft),
    (text: 'urlato per un incubo', tone: ContentTone.soft),
    (text: 'camminato nel sonno', tone: ContentTone.soft),
    (text: 'russato tanto da svegliare qualcuno', tone: ContentTone.soft),
    (text: 'mangiato a letto', tone: ContentTone.soft),
    (
      text: 'saltato la colazione per una settimana intera',
      tone: ContentTone.soft,
    ),
    (
      text: 'bevuto un caffè dimenticato e ormai freddo',
      tone: ContentTone.soft,
    ),
    (text: 'rovesciato qualcosa addosso a qualcuno', tone: ContentTone.soft),
    (text: 'rotto qualcosa di prezioso senza dirlo', tone: ContentTone.soft),
    (text: 'incolpato qualcun altro per una cosa mia', tone: ContentTone.soft),
    (text: 'copiato a un compito in classe', tone: ContentTone.soft),
    (text: 'finito un lavoro all\'ultima notte utile', tone: ContentTone.soft),
    (text: 'mandato una mail senza l\'allegato', tone: ContentTone.soft),
    (
      text: 'sbagliato il nome di una persona in faccia',
      tone: ContentTone.soft,
    ),
    (text: 'dimenticato una password importante', tone: ContentTone.soft),
    (text: 'cercato il mio nome su internet', tone: ContentTone.soft),
    (text: 'bloccato qualcuno sui social', tone: ContentTone.soft),
    (
      text: 'pubblicato qualcosa e cancellato dopo cinque minuti',
      tone: ContentTone.soft,
    ),
    (
      text: 'finto che il telefono fosse scarico per non rispondere',
      tone: ContentTone.soft,
    ),
    (
      text: 'risposto dopo giorni fingendo di non aver visto',
      tone: ContentTone.soft,
    ),
    (
      text: 'usato il Wi-Fi di qualcun altro senza chiedere',
      tone: ContentTone.soft,
    ),
    (
      text: 'cantato in macchina fissando gli altri automobilisti',
      tone: ContentTone.soft,
    ),
    (text: 'ballato da solo in ascensore', tone: ContentTone.soft),
    (
      text: 'parlato con un animale come se capisse tutto',
      tone: ContentTone.soft,
    ),
    (text: 'dato un nome alla mia macchina', tone: ContentTone.soft),
    (
      text: 'fatto una promessa che sapevo di non mantenere',
      tone: ContentTone.soft,
    ),
    (text: 'mentito sulla mia età', tone: ContentTone.soft),
    (
      text: 'esagerato quanto mi era piaciuto un regalo',
      tone: ContentTone.soft,
    ),
    (text: 'ridato a qualcun altro un regalo ricevuto', tone: ContentTone.soft),
    (text: 'tenuto per anni una cosa prestata', tone: ContentTone.soft),
    (text: 'prestato dei soldi senza rivederli', tone: ContentTone.soft),
    (text: 'chiesto un aumento', tone: ContentTone.soft),
    (text: 'cambiato lavoro di punto in bianco', tone: ContentTone.soft),
    (
      text: 'fatto un colloquio per un posto che non volevo',
      tone: ContentTone.soft,
    ),
    (
      text: 'mangiato al fast food due volte nello stesso giorno',
      tone: ContentTone.soft,
    ),
    (text: 'mangiato il gelato a colazione', tone: ContentTone.soft),
    (text: 'fatto ore di fila per qualcosa', tone: ContentTone.soft),
    (text: 'dimenticato un appuntamento importante', tone: ContentTone.soft),
    (text: 'litigato per il telecomando', tone: ContentTone.soft),
    (
      text: 'guardato lo stesso film più di cinque volte',
      tone: ContentTone.soft,
    ),
    (text: 'imparato a memoria una scena di un film', tone: ContentTone.soft),
    (text: 'perso una scommessa stupida', tone: ContentTone.soft),
    (text: 'vinto a carte barando', tone: ContentTone.soft),
    (text: 'rotto uno schermo del telefono', tone: ContentTone.soft),
    (text: 'lasciato il telefono in un locale', tone: ContentTone.soft),
    (
      text: 'sbattuto contro una porta a vetri pulitissima',
      tone: ContentTone.soft,
    ),
    (
      text: 'salutato qualcuno che in realtà salutava la persona dietro di me',
      tone: ContentTone.soft,
    ),
    (
      text: 'tirato una porta con scritto sopra "spingere"',
      tone: ContentTone.soft,
    ),
    (
      text: 'cercato il telefono nel panico mentre lo tenevo in mano',
      tone: ContentTone.soft,
    ),
    (
      text: 'chiamato "mamma" un insegnante davanti a tutti',
      tone: ContentTone.soft,
    ),
    (
      text: 'mandato un vocale di cinque minuti per una cosa da dieci secondi',
      tone: ContentTone.soft,
    ),
    (
      text: 'riascoltato la mia voce in un vocale e provato vergogna',
      tone: ContentTone.soft,
    ),
    (
      text: 'finto di essere al telefono per non parlare con qualcuno',
      tone: ContentTone.soft,
    ),
    (text: 'applaudito all\'atterraggio dell\'aereo', tone: ContentTone.soft),
    (text: 'riso nel momento più sbagliato possibile', tone: ContentTone.soft),
    (
      text:
          'inciampato in pubblico e continuato a camminare come se niente fosse',
      tone: ContentTone.soft,
    ),
    (text: 'messo dieci sveglie e ignorate tutte', tone: ContentTone.soft),
    (
      text: 'googlato i miei sintomi convincendomi di avere una malattia rara',
      tone: ContentTone.soft,
    ),
    (text: 'pianto per una pubblicità', tone: ContentTone.soft),
    (
      text: 'risposto "anche tu" al cameriere che mi augurava buon appetito',
      tone: ContentTone.soft,
    ),
    (
      text: 'dormito durante una videochiamata con la camera accesa',
      tone: ContentTone.soft,
    ),
    (
      text: 'indossato la stessa maglia per una settimana di fila',
      tone: ContentTone.soft,
    ),
    (
      text: 'annusato una maglia per decidere se era ancora mettibile',
      tone: ContentTone.soft,
    ),
    (
      text: 'mangiato direttamente dalla pentola in piedi in cucina',
      tone: ContentTone.soft,
    ),
    (
      text: 'detto "ultimo episodio e dormo" per poi vedere l\'alba',
      tone: ContentTone.soft,
    ),
    (
      text: 'dimenticato perché ero entrato in una stanza',
      tone: ContentTone.soft,
    ),
    (
      text: 'riso da solo ripensando a una figuraccia di anni fa',
      tone: ContentTone.soft,
    ),
    (
      text: 'mangiato la Nutella col cucchiaio direttamente dal barattolo',
      tone: ContentTone.soft,
    ),
    (text: 'pianto per la fame', tone: ContentTone.soft),
    (
      text: 'ordinato una pizza intera solo per me e finita tutta',
      tone: ContentTone.soft,
    ),
    (text: 'litigato ad alta voce con il navigatore', tone: ContentTone.soft),
    (
      text: 'riletto venti volte un messaggio prima di inviarlo',
      tone: ContentTone.soft,
    ),
    (
      text:
          'chiesto solo una spuntatina e uscito dal parrucchiere irriconoscibile',
      tone: ContentTone.soft,
    ),
    (text: 'perso ore a guardare video di animali', tone: ContentTone.soft),
    (
      text: 'convinto qualcuno di una cosa inventata per scherzo',
      tone: ContentTone.soft,
    ),
    (
      text: 'finto di lavorare all\'arrivo del capo',
      tone: ContentTone.soft,
    ),
    (
      text: 'mandato "ok" solo per chiudere una discussione',
      tone: ContentTone.soft,
    ),
    (text: 'messo il pigiama alle sei di sera', tone: ContentTone.soft),
    (text: 'saltato la palestra per andare a mangiare', tone: ContentTone.soft),
    (text: 'rimandato la dieta "a lunedì" per mesi', tone: ContentTone.soft),
    (text: 'usato la cyclette come appendiabiti', tone: ContentTone.soft),
    (
      text: 'detto "ci vediamo presto" sperando di non rivedere quella persona',
      tone: ContentTone.soft,
    ),
    (text: 'parlato con le piante di casa', tone: ContentTone.soft),
    (
      text: 'dato la colpa al cane per qualcosa che avevo fatto io',
      tone: ContentTone.soft,
    ),
    (
      text: 'mangiato i popcorn prima dell\'inizio del film',
      tone: ContentTone.soft,
    ),
    (
      text: 'nascosto i dolci per non doverli condividere',
      tone: ContentTone.soft,
    ),
    (
      text: 'aperto il frigo dieci volte sperando in cibo nuovo',
      tone: ContentTone.soft,
    ),
    (
      text: 'usato la scusa "domani mi sveglio presto" per lasciare una festa',
      tone: ContentTone.soft,
    ),
    (
      text: 'incartato un regalo cinque minuti prima di consegnarlo',
      tone: ContentTone.soft,
    ),
    (
      text: 'ordinato d\'asporto dopo aver dimenticato di scongelare la cena',
      tone: ContentTone.soft,
    ),
    (
      text: 'letto solo il titolo di un articolo e commentato da esperto',
      tone: ContentTone.soft,
    ),
    (
      text: 'tifato per una squadra solo perché stava vincendo',
      tone: ContentTone.soft,
    ),
    (
      text: 'preso la pioggia per non aver ascoltato le previsioni',
      tone: ContentTone.soft,
    ),
    (text: 'iniziato dieci libri senza finirne uno', tone: ContentTone.soft),
    (text: 'messo like a un post senza averlo letto', tone: ContentTone.soft),
    (
      text: 'scattato cento foto uguali per sceglierne una',
      tone: ContentTone.soft,
    ),
    (
      text: 'chiesto consiglio su una foto e poi ignorato la risposta',
      tone: ContentTone.soft,
    ),
    (text: 'usato un filtro in ogni foto pubblicata', tone: ContentTone.soft),
    (
      text: 'riguardato le mie storie più di chiunque altro',
      tone: ContentTone.soft,
    ),
    (text: 'ballato in camera come a un concerto', tone: ContentTone.soft),
    (
      text: 'provato un discorso importante davanti allo specchio',
      tone: ContentTone.soft,
    ),
    (
      text: 'vinto una discussione immaginaria sotto la doccia',
      tone: ContentTone.soft,
    ),
    (
      text: 'dato dieci soprannomi diversi al mio animale',
      tone: ContentTone.soft,
    ),
    (
      text: 'mangiato l\'ultima fetta senza chiedere a nessuno',
      tone: ContentTone.soft,
    ),
    (
      text: 'bevuto direttamente dal cartone davanti al frigo',
      tone: ContentTone.soft,
    ),
    (
      text: 'indossato calzini spaiati sperando che nessuno notasse',
      tone: ContentTone.soft,
    ),
    (text: 'dormito con un peluche da adulto', tone: ContentTone.soft),
    (
      text: 'controllato dietro le tende dopo un film horror',
      tone: ContentTone.soft,
    ),
    (
      text: 'corso su per le scale dopo aver spento la luce',
      tone: ContentTone.soft,
    ),
    (
      text: 'esultato per un parcheggio riuscito al primo colpo',
      tone: ContentTone.soft,
    ),
    (
      text: 'dichiarato guerra a una zanzara alle tre di notte',
      tone: ContentTone.soft,
    ),
    (
      text: 'acceso il condizionatore per dormire sotto il piumone',
      tone: ContentTone.soft,
    ),
    (
      text: 'scritto una lista di cose da fare e ignorata del tutto',
      tone: ContentTone.soft,
    ),
    (text: 'fatto finta di aver letto un libro famoso', tone: ContentTone.soft),
    (
      text: 'perso il filo del discorso mentre parlavo io',
      tone: ContentTone.soft,
    ),
    // ------------------------------------------------------ piccante
    (text: 'baciato qualcuno la prima sera', tone: ContentTone.piccante),
    (
      text: 'avuto una cotta per qualcuno di questo gruppo',
      tone: ContentTone.piccante,
    ),
    (
      text: 'avuto una cotta per il partner di un amico',
      tone: ContentTone.piccante,
    ),
    (text: 'scritto a un ex nel cuore della notte', tone: ContentTone.piccante),
    (
      text: 'risposto a un ex dopo mesi di silenzio',
      tone: ContentTone.piccante,
    ),
    (
      text: 'finto di dormire per evitare un momento di intimità',
      tone: ContentTone.piccante,
    ),
    (text: 'mentito a chi stavo frequentando', tone: ContentTone.piccante),
    (text: 'controllato il telefono di un partner', tone: ContentTone.piccante),
    (
      text: 'avuto due appuntamenti nello stesso giorno',
      tone: ContentTone.piccante,
    ),
    (
      text: 'baciato due persone nella stessa serata',
      tone: ContentTone.piccante,
    ),
    (text: 'detto "ti amo" senza pensarlo davvero', tone: ContentTone.piccante),
    (text: 'chiuso una storia con un messaggio', tone: ContentTone.piccante),
    (text: 'rimesso insieme i pezzi con un ex', tone: ContentTone.piccante),
    (text: 'tenuto nascosta una relazione', tone: ContentTone.piccante),
    (text: 'flirtato per ottenere qualcosa', tone: ContentTone.piccante),
    (text: 'usato un\'app di incontri', tone: ContentTone.piccante),
    (
      text: 'usato una foto profilo di dieci anni fa',
      tone: ContentTone.piccante,
    ),
    (
      text: 'incontrato dal vivo qualcuno conosciuto online',
      tone: ContentTone.piccante,
    ),
    (
      text: 'dedicato una canzone a qualcuno presente in questa stanza',
      tone: ContentTone.piccante,
    ),
    (
      text: 'dormito a casa di qualcuno appena conosciuto',
      tone: ContentTone.piccante,
    ),
    (text: 'perso il conto di quanto avevo bevuto', tone: ContentTone.piccante),
    (
      text: 'fatto qualcosa di imbarazzante da ubriaco',
      tone: ContentTone.piccante,
    ),
    (
      text: 'rimpianto la mattina dopo i messaggi della sera prima',
      tone: ContentTone.piccante,
    ),
    (
      text: 'dimenticato pezzi di una serata intera',
      tone: ContentTone.piccante,
    ),
    (
      text: 'cantato per strada alle quattro di notte',
      tone: ContentTone.piccante,
    ),
    (text: 'fatto il bagno senza costume', tone: ContentTone.piccante),
    (
      text: 'girato per casa senza vestiti con qualcuno in visita',
      tone: ContentTone.piccante,
    ),
    (
      text: 'dimenticato di chiudere la porta del bagno',
      tone: ContentTone.piccante,
    ),
    (
      text: 'detto una bugia enorme a un primo appuntamento',
      tone: ContentTone.piccante,
    ),
    (text: 'finto di essere single', tone: ContentTone.piccante),
    (
      text: 'spiato il profilo del nuovo partner del mio ex',
      tone: ContentTone.piccante,
    ),
    (text: 'litigato in pubblico con un partner', tone: ContentTone.piccante),
    (
      text: 'fatto pace con un bacio senza chiarire niente',
      tone: ContentTone.piccante,
    ),
    (text: 'baciato qualcuno per una scommessa', tone: ContentTone.piccante),
    (
      text: 'rimpianto una risposta data a Obbligo o Verità',
      tone: ContentTone.piccante,
    ),
    (
      text: 'sentito i vicini fare sesso attraverso il muro',
      tone: ContentTone.piccante,
    ),
    (text: 'avuto un flirt sul posto di lavoro', tone: ContentTone.piccante),
    (
      text: 'scritto al capo cose che non avrei dovuto',
      tone: ContentTone.piccante,
    ),
    (
      text: 'dato buca a un appuntamento senza avvisare',
      tone: ContentTone.piccante,
    ),
    (
      text: 'detto "sali a bere qualcosa?" sapendo benissimo cosa intendevo',
      tone: ContentTone.piccante,
    ),
    (
      text: 'baciato qualcuno nel bagno di un locale',
      tone: ContentTone.piccante,
    ),
    (
      text: 'passato un film intero al cinema senza guardarne una scena',
      tone: ContentTone.piccante,
    ),
    (
      text: 'conservato una foto imbarazzante di un amico',
      tone: ContentTone.piccante,
    ),
    (
      text: 'scrollato il profilo di qualcuno fino a tre anni fa',
      tone: ContentTone.piccante,
    ),
    (
      text: 'risposto a una storia solo per farmi notare',
      tone: ContentTone.piccante,
    ),
    (
      text: 'mentito su dove stavo passando la serata',
      tone: ContentTone.piccante,
    ),
    (
      text: 'detto di essere a casa mentre ero fuori',
      tone: ContentTone.piccante,
    ),
    (
      text: 'nascosto una relazione alla mia famiglia',
      tone: ContentTone.piccante,
    ),
    (
      text: 'baciato qualcuno di cui non ricordavo il nome',
      tone: ContentTone.piccante,
    ),
    (
      text: 'chiesto a un amico di chiamarmi per scappare da un appuntamento',
      tone: ContentTone.piccante,
    ),
    (
      text: 'lasciato un locale di nascosto per non salutare',
      tone: ContentTone.piccante,
    ),
    (
      text: 'finito la serata in un posto che non ricordo',
      tone: ContentTone.piccante,
    ),
    (
      text: 'dato il mio numero a una persona appena conosciuta in un locale',
      tone: ContentTone.piccante,
    ),
    (
      text: 'detto una bugia durante questa partita',
      tone: ContentTone.piccante,
    ),
    (text: 'ghostato qualcuno senza spiegazioni', tone: ContentTone.piccante),
    (
      text: 'riletto una vecchia chat per nostalgia',
      tone: ContentTone.piccante,
    ),
    (
      text:
          'messo un like a una foto di tre anni fa durante uno stalking notturno',
      tone: ContentTone.piccante,
    ),
    (
      text: 'inventato un partner immaginario per togliermi qualcuno di torno',
      tone: ContentTone.piccante,
    ),
    (
      text: 'provato frasi di rimorchio davanti allo specchio',
      tone: ContentTone.piccante,
    ),
    (text: 'baciato l\'ex di un amico', tone: ContentTone.piccante),
    (
      text: 'chiesto a un amico di indagare per scoprire se piacevo a qualcuno',
      tone: ContentTone.piccante,
    ),
    (
      text: 'vomitato in un posto assurdo durante una serata',
      tone: ContentTone.piccante,
    ),
    (text: 'avuto una storia di una notte', tone: ContentTone.piccante),
    (
      text: 'fatto la walk of shame con i vestiti della sera prima',
      tone: ContentTone.piccante,
    ),
    (
      text: 'mandato una foto che non manderei mai ai miei',
      tone: ContentTone.piccante,
    ),
    (
      text: 'avuto un sogno spinto su una persona presente in questa stanza',
      tone: ContentTone.piccante,
    ),
    (
      text: 'flirtato con qualcuno del personale per avere da bere gratis',
      tone: ContentTone.piccante,
    ),
    (
      text: 'passato la notte fuori mentendo su dove ero',
      tone: ContentTone.piccante,
    ),
    (
      text: 'salvato un contatto con un nome falso per non farmi beccare',
      tone: ContentTone.piccante,
    ),
    (
      text: 'baciato qualcuno solo perché era mezzanotte a Capodanno',
      tone: ContentTone.piccante,
    ),
    (text: 'fatto sexting fino a notte fonda', tone: ContentTone.piccante),
    (
      text: 'iniziato io una conversazione finita in sexting',
      tone: ContentTone.piccante,
    ),
    (
      text: 'baciato qualcuno molto più grande o più giovane di me',
      tone: ContentTone.piccante,
    ),
    (text: 'avuto una fantasia su un collega', tone: ContentTone.piccante),
    (
      text: 'fatto un massaggio finito in tutt\'altro',
      tone: ContentTone.piccante,
    ),
    (
      text: 'baciato qualcuno entro un\'ora dal primo incontro',
      tone: ContentTone.piccante,
    ),
    (
      text: 'comprato biancheria intima pensando a chi l\'avrebbe vista',
      tone: ContentTone.piccante,
    ),
    (
      text: 'flirtato in palestra invece di allenarmi',
      tone: ContentTone.piccante,
    ),
    (
      text: 'avuto un flirt estivo finito con la fine della vacanza',
      tone: ContentTone.piccante,
    ),
    (text: 'baciato qualcuno in ascensore', tone: ContentTone.piccante),
    (text: 'fatto la doccia con un\'altra persona', tone: ContentTone.piccante),
    (
      text:
          'diviso il letto con un amico chiedendomi se sarebbe successo qualcosa',
      tone: ContentTone.piccante,
    ),
    (
      text: 'baciato qualcuno durante un gioco come questo',
      tone: ContentTone.piccante,
    ),
    (
      text: 'mandato la posizione a un amico prima di un appuntamento al buio',
      tone: ContentTone.piccante,
    ),
    (
      text: 'provato a rimorchiare con una battuta trovata online',
      tone: ContentTone.piccante,
    ),
    (
      text: 'fatto un complimento audace a uno sconosciuto',
      tone: ContentTone.piccante,
    ),
    (
      text: 'ricevuto un due di picche davanti a tutti',
      tone: ContentTone.piccante,
    ),
    // ------------------------------------------------------- cattivo
    (
      text: 'parlato male di una persona presente in questa stanza',
      tone: ContentTone.cattivo,
    ),
    (text: 'rivelato il segreto di un amico', tone: ContentTone.cattivo),
    (
      text: 'condiviso lo screenshot di una chat privata',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'creato un profilo falso per spiare qualcuno',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          'gioito in segreto per il fallimento di qualcuno che mi sta antipatico',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'finto di essere felice per un amico mentre rosicavo dentro',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'pensato che il partner di un amico non lo meritasse per niente',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'sperato che la relazione di una coppia di amici finisse',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'detto "non lo dico a nessuno" e spifferato tutto entro un\'ora',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          'creato una chat di gruppo senza una persona solo per parlare di lei',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'flirtato con qualcuno solo per far ingelosire un\'altra persona',
      tone: ContentTone.cattivo,
    ),
    (text: 'dato un consiglio sbagliato apposta', tone: ContentTone.cattivo),
    (text: 'rovinato una sorpresa di proposito', tone: ContentTone.cattivo),
    (
      text: 'finto di aver dimenticato il portafoglio per non pagare',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'riferito un gossip aggiungendo dettagli inventati',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'usato le lacrime per ottenere quello che volevo',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'letto una chat sul telefono di un amico mentre era in bagno',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'finto di ascoltare i problemi di un amico pensando ai fatti miei',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'negato fino alla morte una cosa che avevo fatto davvero',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          'sparlato di qualcuno e negato tutto quando me l\'hanno chiesto in faccia',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'usato un segreto di qualcuno per vincere una discussione',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          'diviso il conto alla pari sapendo di aver ordinato il triplo degli altri',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'invitato una persona solo perché aveva la macchina',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenuto nascosto a un amico che il suo partner flirtava con altri',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'cancellato un messaggio dal telefono di qualcun altro',
      tone: ContentTone.cattivo,
    ),
    (text: 'fatto sesso in un luogo pubblico', tone: ContentTone.cattivo),
    (
      text: 'avuto un amico di letto tenendolo nascosto a tutti',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'mandato un messaggio spinto alla persona sbagliata',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'rivisto un ex solo per una notte giurando che era l\'ultima',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'dimenticato il nome di qualcuno con cui avevo passato la notte',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'pensato a un\'altra persona mentre baciavo il mio partner',
      tone: ContentTone.cattivo,
    ),
    (text: 'mentito sul numero delle mie conquiste', tone: ContentTone.cattivo),
    (
      text: 'fatto sesso a una festa mentre la casa era piena di gente',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'usato il fascino per farmi perdonare qualcosa di grave',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'passato la notte con qualcuno conosciuto quella sera su un\'app',
      tone: ContentTone.cattivo,
    ),
    (text: 'fatto o desiderato una cosa a tre', tone: ContentTone.cattivo),
    (text: 'tradito un partner', tone: ContentTone.cattivo),
    (
      text: 'baciato un\'altra persona mentre ero in coppia',
      tone: ContentTone.cattivo,
    ),
    (text: 'mandato una mia foto senza vestiti', tone: ContentTone.cattivo),
    (
      text: 'mostrato a un amico una foto hot ricevuta in privato',
      tone: ContentTone.cattivo,
    ),
    (text: 'passato la notte con l\'ex di un amico', tone: ContentTone.cattivo),
    (text: 'fatto sesso in macchina', tone: ContentTone.cattivo),
    (
      text: 'fatto sesso a casa dei genitori del mio partner',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'fatto sesso con due persone diverse nella stessa settimana',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'avuto una storia con una persona già impegnata',
      tone: ContentTone.cattivo,
    ),
    (text: 'finto di provare piacere a letto', tone: ContentTone.cattivo),
    (
      text: 'dato un voto alle prestazioni dei miei ex parlando con gli amici',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'usato il sesso per farmi perdonare dopo un litigio',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'scritto a qualcuno alle tre di notte con un solo scopo in mente',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'avuto una notte di passione con qualcuno di questo gruppo',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          'immaginato come sarebbe a letto una persona presente in questa stanza',
      tone: ContentTone.cattivo,
    ),
    (text: 'paragonato a letto un partner a un ex', tone: ContentTone.cattivo),
    (
      text: 'tenuto una chat segreta con un ex mentre ero impegnato',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          'accettato un invito a "vedere un film" sapendo come sarebbe finita',
      tone: ContentTone.cattivo,
    ),
    (text: 'flirtato con il partner di un amico', tone: ContentTone.cattivo),
    (
      text: 'mandato un messaggio hot mentre ero a cena con altre persone',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'fatto sexting mentre il mio partner era nella stanza accanto',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenuto pronto un piano B mentre ero in una relazione',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'baciato qualcuno solo per vendetta contro un ex',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'fatto sesso con una persona che mi stava antipatica',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'illuso qualcuno solo per portarlo a letto',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'ghostato qualcuno dopo averci passato la notte',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'conservato le foto hot di un ex dopo la rottura',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'raccontato in giro i dettagli intimi di un ex',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'finto sentimenti solo per non restare da solo',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'provato to rimorchiare la persona che piaceva a un amico',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'sparito subito dopo aver ottenuto quello che volevo',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'detto "ti amo" a letto solo per il momento',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'fatto sesso sapendo che dalla stanza accanto ci sentivano',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'risposto a un ex mentre ero a letto con un\'altra persona',
      tone: ContentTone.cattivo,
    ),
    // ------------------------------------------------ piccante (extra)
    (text: 'fatto sesso al primo appuntamento', tone: ContentTone.piccante),
    (text: 'finto un orgasmo', tone: ContentTone.piccante),
    (text: 'fatto sexting con qualcuno conosciuto da meno di ventiquattro ore', tone: ContentTone.piccante),
    (text: 'chiesto per primo una foto audace', tone: ContentTone.piccante),
    (text: 'ricevuto una foto hot non richiesta e risposto con un complimento', tone: ContentTone.piccante),
    (text: 'fatto sesso in un posto pubblico', tone: ContentTone.piccante),
    (text: 'appannato i vetri di una macchina, e non per il freddo', tone: ContentTone.piccante),
    (text: 'fatto sesso in casa di sconosciuti durante una festa', tone: ContentTone.piccante),
    (text: 'passato la notte con qualcuno di cui non ricordavo il nome', tone: ContentTone.piccante),
    (text: 'incrociato un conoscente durante la walk of shame e salutato come se niente fosse', tone: ContentTone.piccante),
    (text: 'baciato qualcuno solo perché la serata era quella giusta', tone: ContentTone.piccante),
    (text: 'baciato qualcuno nei primi dieci minuti del primo appuntamento', tone: ContentTone.piccante),
    (text: 'baciato una persona dello stesso sesso', tone: ContentTone.piccante),
    (text: 'desiderato qualcuno presente in questa stanza', tone: ContentTone.piccante),
    (text: 'avuto un sogno erotico su un amico', tone: ContentTone.piccante),
    (text: 'immaginato un futuro intero con qualcuno appena conosciuto', tone: ContentTone.piccante),
    (text: 'avuto una storia solo fisica durata più di sei mesi', tone: ContentTone.piccante),
    (text: 'detto "ti amo" solo per arrivare a fine serata', tone: ContentTone.piccante),
    (text: 'fatto pace a letto dopo un litigio iniziato apposta', tone: ContentTone.piccante),
    (text: 'flirtato con qualcuno per farmi offrire qualcosa', tone: ContentTone.piccante),
    (text: 'dato un numero falso a qualcuno che ci provava', tone: ContentTone.piccante),
    (text: 'usato una frase di rimorchio trovata su internet', tone: ContentTone.piccante),
    (text: 'rimorchiato in palestra', tone: ContentTone.piccante),
    (text: 'rimorchiato a un matrimonio', tone: ContentTone.piccante),
    (text: 'rimorchiato al supermercato', tone: ContentTone.piccante),
    (text: 'baciato il mio migliore amico o la mia migliore amica', tone: ContentTone.piccante),
    (text: 'provato attrazione per il partner di un amico', tone: ContentTone.piccante),
    (text: 'fatto sesso con un collega', tone: ContentTone.piccante),
    (text: 'avuto una storia con qualcuno molto più grande di me', tone: ContentTone.piccante),
    (text: 'mentito sul mio body count', tone: ContentTone.piccante),
    (text: 'dimenticato il nome di qualcuno mentre eravamo a letto', tone: ContentTone.piccante),
    (text: 'finto di dormire per evitare un momento intimo', tone: ContentTone.piccante),
    (text: 'fatto sesso con i calzini addosso', tone: ContentTone.piccante),
    (text: 'riso durante un momento intimo rovinando tutto', tone: ContentTone.piccante),
    (text: 'mandato un messaggio hot alla persona sbagliata', tone: ContentTone.piccante),
    (text: 'riletto il mio sexting e provato orgoglio', tone: ContentTone.piccante),
    (text: 'creato una playlist apposta per le notti in compagnia', tone: ContentTone.piccante),
    (text: 'controllato il telefono mentre l\'altra persona dormiva accanto a me', tone: ContentTone.piccante),
    (text: 'cercato su internet come migliorare a letto', tone: ContentTone.piccante),
    (text: 'chiesto a un amico un giudizio onesto sulle mie doti', tone: ContentTone.piccante),
    (text: 'guardato un film per adulti in compagnia', tone: ContentTone.piccante),
    (text: 'comprato biancheria apposta per una notte precisa', tone: ContentTone.piccante),
    (text: 'fatto sesso nella doccia', tone: ContentTone.piccante),
    (text: 'fatto sesso sul divano di qualcun altro', tone: ContentTone.piccante),
    (text: 'fatto rumore apposta perché sentissero', tone: ContentTone.piccante),
    (text: 'dovuto nascondermi in fretta all\'arrivo di qualcuno', tone: ContentTone.piccante),
    (text: 'rimesso i vestiti di corsa e sbagliato maglietta', tone: ContentTone.piccante),
    (text: 'lasciato segni visibili sul collo di qualcuno', tone: ContentTone.piccante),
    (text: 'coperto un segno sul collo con trucco o sciarpa', tone: ContentTone.piccante),
    (text: 'detto a un partner che era il migliore, mentendo', tone: ContentTone.piccante),
    (text: 'dato un voto a una notte parlandone con gli amici il giorno dopo', tone: ContentTone.piccante),
    (text: 'fatto classifiche dei miei ex con gli amici', tone: ContentTone.piccante),
    (text: 'rincontrato un one night stand sul posto di lavoro', tone: ContentTone.piccante),
    (text: 'flirtato con due persone contemporaneamente nella stessa serata', tone: ContentTone.piccante),
    (text: 'usato un\'app di incontri seduto accanto ai miei', tone: ContentTone.piccante),
    (text: 'avuto un match e non scritto mai per paura', tone: ContentTone.piccante),
    (text: 'fatto la prima mossa e incassato un no', tone: ContentTone.piccante),
    (text: 'baciato qualcuno sotto la pioggia sentendomi in un film', tone: ContentTone.piccante),
    (text: 'organizzato di incontrare "per caso" la mia crush', tone: ContentTone.piccante),
    (text: 'offerto un massaggio con secondi fini evidenti', tone: ContentTone.piccante),
    (text: 'accettato un massaggio sapendo benissimo dove sarebbe andato a finire', tone: ContentTone.piccante),
    (text: 'fatto colazione a letto con qualcuno conosciuto la sera prima', tone: ContentTone.piccante),
    (text: 'tenuto uno spazzolino di riserva per gli ospiti di una notte', tone: ContentTone.piccante),
    // ------------------------------------------------- cattivo (extra)
    (text: 'fatto sesso con qualcuno presente in questa stanza', tone: ContentTone.cattivo),
    (text: 'fatto sesso con più di una persona nelle stesse ventiquattro ore', tone: ContentTone.cattivo),
    (text: 'fatto una cosa a tre', tone: ContentTone.cattivo),
    (text: 'ricevuto una proposta per una cosa a tre e accettato', tone: ContentTone.cattivo),
    (text: 'fatto sesso con una persona impegnata sapendolo', tone: ContentTone.cattivo),
    (text: 'tradito senza mai confessarlo', tone: ContentTone.cattivo),
    (text: 'scoperto un tradimento e fatto finta di niente', tone: ContentTone.cattivo),
    (text: 'fatto sesso con l\'ex del mio migliore amico', tone: ContentTone.cattivo),
    (text: 'usato giocattoli, da solo o in compagnia', tone: ContentTone.cattivo),
    (text: 'comprato un giocattolo online controllando il pacco ogni ora', tone: ContentTone.cattivo),
    (text: 'girato un video mentre facevo sesso', tone: ContentTone.cattivo),
    (text: 'rivisto quel video', tone: ContentTone.cattivo),
    (text: 'tenuto foto hot nel telefono senza password', tone: ContentTone.cattivo),
    (text: 'mandato la stessa foto hot a più persone', tone: ContentTone.cattivo),
    (text: 'finto un orgasmo più di una volta con la stessa persona', tone: ContentTone.cattivo),
    (text: 'detto il nome sbagliato a letto', tone: ContentTone.cattivo),
    (text: 'sentito il nome sbagliato e fatto finta di niente', tone: ContentTone.cattivo),
    (text: 'fatto sesso in un bagno pubblico', tone: ContentTone.cattivo),
    (text: 'fatto sesso all\'aperto rischiando di essere visto', tone: ContentTone.cattivo),
    (text: 'preso in flagrante da qualcuno', tone: ContentTone.cattivo),
    (text: 'beccato qualcuno in flagrante', tone: ContentTone.cattivo),
    (text: 'fatto sesso mentre altri dormivano nella stessa stanza', tone: ContentTone.cattivo),
    (text: 'fatto sesso a casa dei miei con i miei in casa', tone: ContentTone.cattivo),
    (text: 'fatto sesso a casa dei suoi con i suoi in casa', tone: ContentTone.cattivo),
    (text: 'saltato il lavoro per restare a letto in compagnia', tone: ContentTone.cattivo),
    (text: 'fatto sesso durante l\'orario di lavoro', tone: ContentTone.cattivo),
    (text: 'usato l\'ufficio in modo non professionale', tone: ContentTone.cattivo),
    (text: 'avuto un debole serio per un superiore', tone: ContentTone.cattivo),
    (text: 'fatto sesso con un amico e mai più parlato dell\'argomento', tone: ContentTone.cattivo),
    (text: 'rovinato un\'amicizia per una notte', tone: ContentTone.cattivo),
    (text: 'avuto due storie parallele senza che si sapessero', tone: ContentTone.cattivo),
    (text: 'sentito entrambi nella stessa sera senza farmi scoprire', tone: ContentTone.cattivo),
    (text: 'usato la casa di un amico per un incontro segreto', tone: ContentTone.cattivo),
    (text: 'fatto entrare qualcuno di nascosto e uscire all\'alba', tone: ContentTone.cattivo),
    (text: 'nascosto una persona nell\'armadio o sul balcone, letteralmente', tone: ContentTone.cattivo),
    (text: 'cancellato messaggi per non farli trovare', tone: ContentTone.cattivo),
    (text: 'salvato una persona in rubrica con un nome falso', tone: ContentTone.cattivo),
    (text: 'pensato a qualcuno di questa stanza mentre ero con un\'altra persona', tone: ContentTone.cattivo),
    (text: 'iniziato qualcosa in un locale e finito nel parcheggio', tone: ContentTone.cattivo),
    (text: 'fatto sesso senza sapere il cognome dell\'altra persona', tone: ContentTone.cattivo),
    (text: 'superato il confine con un amico di letto e finto che nulla fosse cambiato', tone: ContentTone.cattivo),
    (text: 'tenuto un amico di letto segreto per più di un anno', tone: ContentTone.cattivo),
    (text: 'accettato un "vieni a vedere un film" sapendo che non avremmo visto nulla', tone: ContentTone.cattivo),
    (text: 'mandato "sei sveglio?" alle tre di notte e ottenuto risposta', tone: ContentTone.cattivo),
    (text: 'risposto a un "sei sveglio?" alle tre di notte ed essere uscito di casa', tone: ContentTone.cattivo),
    (text: 'fatto sesso con qualcuno che detestavo', tone: ContentTone.cattivo),
    (text: 'usato il sesso per farmi perdonare', tone: ContentTone.cattivo),
    (text: 'usato il sesso per ottenere qualcosa', tone: ContentTone.cattivo),
    (text: 'detto no a inizio serata e cambiato idea a metà', tone: ContentTone.cattivo),
    (text: 'detto "non succederà mai più" quando era già successo tre volte', tone: ContentTone.cattivo),
    (text: 'contato il mio body count e dovuto ricominciare da capo', tone: ContentTone.cattivo),
    (text: 'detto al partner un body count più basso del vero', tone: ContentTone.cattivo),
    (text: 'tenuto un elenco scritto delle persone con cui sono stato', tone: ContentTone.cattivo),
    (text: 'dato un nome in codice a un\'avventura per parlarne liberamente', tone: ContentTone.cattivo),
    (text: 'raccontato i dettagli di una notte a un intero gruppo', tone: ContentTone.cattivo),
    (text: 'riconosciuto su un\'app di incontri una persona impegnata che conosco', tone: ContentTone.cattivo),
    (text: 'trovato un profilo che non doveva esserci e fatto uno screenshot', tone: ContentTone.cattivo),
    (text: 'usato un profilo falso per controllare qualcuno', tone: ContentTone.cattivo),
    (text: 'guardato il telefono del partner mentre dormiva', tone: ContentTone.cattivo),
    (text: 'trovato qualcosa che avrei preferito non trovare', tone: ContentTone.cattivo),
    (text: 'fatto finta di niente dopo aver trovato tutto', tone: ContentTone.cattivo),
    (text: 'provato un fetish e scoperto che mi piaceva', tone: ContentTone.cattivo),
    (text: 'confessato un fetish e visto la faccia dell\'altra persona cambiare', tone: ContentTone.cattivo),
    (text: 'legato qualcuno o farmi legare per gioco', tone: ContentTone.cattivo),
    (text: 'usato ghiaccio o cibo a letto', tone: ContentTone.cattivo),
    (text: 'bendato qualcuno o essere stato bendato', tone: ContentTone.cattivo),
    (text: 'messo la musica alta per coprire i rumori', tone: ContentTone.cattivo),
    (text: 'ricevuto lamentele dai vicini', tone: ContentTone.cattivo),
    (text: 'rotto qualcosa in casa durante il sesso', tone: ContentTone.cattivo),
    (text: 'spiegato un livido o un graffio con una scusa inventata', tone: ContentTone.cattivo),
    (text: 'usato il tavolo della cucina per qualcosa che non era una cena', tone: ContentTone.cattivo),
    (text: 'fatto sesso in ascensore o su una rampa di scale', tone: ContentTone.cattivo),
    (text: 'fatto sesso in spiaggia e trovato sabbia ovunque per giorni', tone: ContentTone.cattivo),
    (text: 'fatto sesso in piscina o in mare', tone: ContentTone.cattivo),
    (text: 'fatto sesso in tenda con altri nel campeggio', tone: ContentTone.cattivo),
    (text: 'fatto sesso su un treno o in aereo', tone: ContentTone.cattivo),
    (text: 'pagato una stanza solo per qualche ora', tone: ContentTone.cattivo),
    (text: 'usato la pausa pranzo in modo molto creativo', tone: ContentTone.cattivo),
    (text: 'avuto un risveglio di cui non parlerò mai nel dettaglio', tone: ContentTone.cattivo),
    (text: 'fatto qualcosa a letto che questo gruppo non crederebbe mai di me', tone: ContentTone.cattivo),
    (text: 'assaggiato il mio stesso piacere', tone: ContentTone.cattivo),
    (text: 'fatto sesso anale', tone: ContentTone.cattivo),
    (text: 'ricevuto uno schiaffo o una sculacciata e chiesto il bis', tone: ContentTone.cattivo),
    (text: 'scambiato messaggi hot con qualcuno in questa stanza mentre eravamo a cena insieme', tone: ContentTone.cattivo),
    (text: 'sperimentato con il dolore a letto', tone: ContentTone.cattivo),
    (text: 'avuto fantasie su un membro della famiglia (non stretto)', tone: ContentTone.cattivo),
    (text: 'fatto sesso nel letto dei miei genitori', tone: ContentTone.cattivo),
    (text: 'ingoiato tutto dopo un rapporto', tone: ContentTone.cattivo),
    (text: 'fatto sesso mentre qualcun altro guardava', tone: ContentTone.cattivo),
    (text: 'partecipato a un\'orgia', tone: ContentTone.cattivo),
    (text: 'ingoiato lo sperma del partner', tone: ContentTone.cattivo),
    (text: 'leccato l\'ano a qualcuno', tone: ContentTone.cattivo),
    (text: 'fatto sesso anale senza protezione', tone: ContentTone.cattivo),
    (text: 'usato un vibratore o dildo durante un rapporto', tone: ContentTone.cattivo),
    (text: 'fatto un video mentre facevo sesso e poi l\'ho tenuto', tone: ContentTone.cattivo),
    (text: 'venuta/o in faccia a qualcuno', tone: ContentTone.cattivo),
    (text: 'fatto sesso con una persona di cui non sapevo il nome', tone: ContentTone.cattivo),
    (text: 'avuto un rapporto in un luogo pubblico molto affollato', tone: ContentTone.cattivo),
    (text: 'assaggiato il mio stesso sperma o eiaculazione', tone: ContentTone.cattivo),
    (text: 'fatto sesso con due persone diverse nella stessa notte', tone: ContentTone.cattivo),
    (text: 'subito o fatto bondage pesante', tone: ContentTone.cattivo),
    (text: 'fatto sesso orale in un luogo pubblico', tone: ContentTone.cattivo),
    (text: 'usato oggetti domestici come sex toys', tone: ContentTone.cattivo),
    (text: 'ricevuto sesso orale mentre guidavo', tone: ContentTone.cattivo),
    (text: 'fatto sesso durante il ciclo', tone: ContentTone.cattivo),
    (text: 'avuto un orgasmo multiplo nello stesso rapporto', tone: ContentTone.cattivo),
    (text: 'fatto sesso con qualcuno conosciuto da meno di un\'ora', tone: ContentTone.cattivo),
    (text: 'pagato o ricevuto soldi per sesso', tone: ContentTone.cattivo),
  ];
}
