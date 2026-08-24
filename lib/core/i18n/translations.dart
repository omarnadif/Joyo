/// Tutte le stringhe dell'interfaccia, una riga per concetto e cinque lingue
/// affiancate: così una traduzione mancante si vede a colpo d'occhio invece di
/// nascondersi in un file diverso.
///
/// I segnaposto sono nella forma {nome}.
const Map<String, Map<String, String>> kTranslations = {
  // ---------------------------------------------------------------- generale
  'app.tagline': {
    'it': 'Il party game per chi ha\nun telefono a testa.',
    'en': 'The party game for groups\nwith a phone each.',
    'es': 'El juego de fiesta para grupos\ncon un móvil cada uno.',
    'fr': 'Le jeu de soirée pour ceux\nqui ont chacun un téléphone.',
    'de': 'Das Partyspiel für Gruppen,\nbei denen jeder ein Handy hat.',
  },
  'common.retry': {
    'it': 'Riprova',
    'en': 'Try again',
    'es': 'Reintentar',
    'fr': 'Réessayer',
    'de': 'Erneut versuchen',
  },
  'common.cancel': {
    'it': 'Annulla',
    'en': 'Cancel',
    'es': 'Cancelar',
    'fr': 'Annuler',
    'de': 'Abbrechen',
  },
  'common.continue': {
    'it': 'CONTINUA',
    'en': 'CONTINUE',
    'es': 'CONTINUAR',
    'fr': 'CONTINUER',
    'de': 'WEITER',
  },
  'common.back_home': {
    'it': 'TORNA ALLA HOME',
    'en': 'BACK TO HOME',
    'es': 'VOLVER AL INICIO',
    'fr': "RETOUR À L'ACCUEIL",
    'de': 'ZURÜCK ZUM START',
  },
  'common.loading': {
    'it': 'Un attimo…',
    'en': 'One moment…',
    'es': 'Un momento…',
    'fr': 'Un instant…',
    'de': 'Einen Moment…',
  },
  'common.you': {'it': 'tu', 'en': 'you', 'es': 'tú', 'fr': 'toi', 'de': 'du'},

  // -------------------------------------------------------------- onboarding
  'onboarding.slide1.title': {
    'it': 'La serata prende\nuna piega inaspettata',
    'en': 'The night takes\nan unexpected turn',
    'es': 'La noche toma\nun giro inesperado',
    'fr': 'La soirée prend\nun tour inattendu',
    'de': 'Der Abend nimmt\neine unerwartete Wendung',
  },
  'onboarding.slide1.body': {
    'it':
        'Ognuno col suo telefono, tutti nella stessa stanza. Joyo collega gli schermi, voi create il caos.',
    'en':
        'One phone each, one room for all. Joyo connects the screens, you create the chaos.',
    'es':
        'Un móvil por persona, todos en la misma sala. Joyo conecta las pantallas, vosotros creáis el caos.',
    'fr':
        'Un téléphone chacun, tous dans la même pièce. Joyo relie les écrans, vous créez le chaos.',
    'de':
        'Jeder ein Handy, alle in einem Raum. Joyo verbindet die Displays, ihr sorgt für das Chaos.',
  },
  'onboarding.slide2.title': {
    'it': 'Codice alla mano,\nsi entra nel vivo',
    'en': 'Code in hand,\nget into the action',
    'es': 'Código en mano,\nempieza la acción',
    'fr': 'Code en main,\nplace à l\'action',
    'de': 'Code bereit,\nab in die Action',
  },
  'onboarding.slide2.body': {
    'it':
        'Apri la stanza, urla il codice e guarda gli amici fiondarsi dentro in pochi secondi.',
    'en':
        'Open the room, shout the code and watch your friends jump in within seconds.',
    'es':
        'Abre la sala, grita el código y mira cómo tus amigos entran en cuestión de segundos.',
    'fr':
        'Ouvre le salon, hurle le code et regarde tes amis débouler en quelques secondes.',
    'de':
        'Raum öffnen, Code rufen und zusehen, wie deine Freunde in Sekunden beitreten.',
  },
  'onboarding.slide3.title': {
    'it': 'Sei giochi per\nnon annoiarsi mai',
    'en': 'Six games to\nnever be bored',
    'es': 'Seis juegos para\nno aburrirse nunca',
    'fr': 'Six jeux pour\nne jamais s\'ennuyer',
    'de': 'Sechs Spiele,\ndamit es nie langweilig wird',
  },
  'onboarding.slide3.body': {
    'it':
        'Vota i tuoi amici, inventa balle colossali o sfida la sorte con la bottiglia. Velocità massima.',
    'en':
        'Vote for your friends, craft massive lies or tempt fate with the bottle. Maximum speed.',
    'es':
        'Vota a tus amigos, inventa mentiras colosales o desafía al destino con la botella. Máxima velocidad.',
    'fr':
        'Vote pour tes amis, invente des mensonges énormes ou défie le sort avec la bouteille. Vitesse maximale.',
    'de':
        'Stimme für Freunde ab, erfinde krasse Lügen oder fordere das Schicksal mit der Flasche heraus. Volles Tempo.',
  },
  'onboarding.slide4.title': {
    'it': 'Decidi tu\nquanto osare',
    'en': 'You decide\nhow far to go',
    'es': 'Tú decides\nhasta dónde llegar',
    'fr': 'C\'est toi qui décides\njusqu\'où oser',
    'de': 'Du entscheidest,\nwie weit ihr geht',
  },
  'onboarding.slide4.body': {
    'it':
        'Modalità Soft per scaldarsi, Mix per movimentare la serata, Hot per quando cadono le maschere.',
    'en':
        'Soft mode to warm up, Mix to shake things up, Hot for when the masks come off.',
    'es':
        'Modo Soft para calentar, Mix para animar la noche, Hot para cuando caen las máscaras.',
    'fr':
        'Mode Soft pour s\'échauffer, Mix pour bouger la soirée, Hot pour quand les masques tombent.',
    'de':
        'Soft-Modus zum Aufwärmen, Mix für Schwung, Hot für wenn die Masken fallen.',
  },
  'onboarding.language': {
    'it': 'In che lingua giocate?',
    'en': 'What language are you playing in?',
    'es': '¿En qué idioma jugáis?',
    'fr': 'Dans quelle langue jouez-vous ?',
    'de': 'In welcher Sprache spielt ihr?',
  },
  'onboarding.start': {
    'it': 'INIZIA',
    'en': 'START',
    'es': 'EMPEZAR',
    'fr': 'COMMENCER',
    'de': 'LOSLEGEN',
  },
  'onboarding.skip': {
    'it': 'Salta',
    'en': 'Skip',
    'es': 'Saltar',
    'fr': 'Passer',
    'de': 'Überspringen',
  },

  // -------------------------------------------------------------------- home
  'home.create': {
    'it': 'CREA STANZA',
    'en': 'CREATE ROOM',
    'es': 'CREAR SALA',
    'fr': 'CRÉER UN SALON',
    'de': 'RAUM ERSTELLEN',
  },
  'home.join': {
    'it': 'UNISCITI CON UN CODICE',
    'en': 'JOIN WITH A CODE',
    'es': 'UNIRSE CON UN CÓDIGO',
    'fr': 'REJOINDRE AVEC UN CODE',
    'de': 'MIT CODE BEITRETEN',
  },
  'home.games': {
    'it': 'I giochi',
    'en': 'The games',
    'es': 'Los juegos',
    'fr': 'Les jeux',
    'de': 'Die Spiele',
  },
  'home.connection_failed': {
    'it': 'Connessione a Joyo non riuscita.',
    'en': "Couldn't connect to Joyo.",
    'es': 'No se ha podido conectar con Joyo.',
    'fr': 'Connexion à Joyo impossible.',
    'de': 'Verbindung zu Joyo fehlgeschlagen.',
  },
  'home.language': {
    'it': 'Lingua',
    'en': 'Language',
    'es': 'Idioma',
    'fr': 'Langue',
    'de': 'Sprache',
  },

  // ------------------------------------------------------------ join / crea
  'join.title_create': {
    'it': 'Crea stanza',
    'en': 'Create room',
    'es': 'Crear sala',
    'fr': 'Créer un salon',
    'de': 'Raum erstellen',
  },
  'join.title_join': {
    'it': 'Unisciti',
    'en': 'Join',
    'es': 'Unirse',
    'fr': 'Rejoindre',
    'de': 'Beitreten',
  },
  'join.name_question': {
    'it': 'Come ti chiami?',
    'en': "What's your name?",
    'es': '¿Cómo te llamas?',
    'fr': 'Comment tu t\'appelles ?',
    'de': 'Wie heißt du?',
  },
  'join.name_hint': {
    'it': 'Il tuo nome',
    'en': 'Your name',
    'es': 'Tu nombre',
    'fr': 'Ton prénom',
    'de': 'Dein Name',
  },
  'join.color': {
    'it': 'Il tuo colore',
    'en': 'Your colour',
    'es': 'Tu color',
    'fr': 'Ta couleur',
    'de': 'Deine Farbe',
  },
  'join.code': {
    'it': 'Codice della stanza',
    'en': 'Room code',
    'es': 'Código de la sala',
    'fr': 'Code du salon',
    'de': 'Raumcode',
  },
  'join.cta_create': {
    'it': 'CREA LA STANZA',
    'en': 'CREATE THE ROOM',
    'es': 'CREAR LA SALA',
    'fr': 'CRÉER LE SALON',
    'de': 'RAUM ERSTELLEN',
  },
  'join.cta_join': {
    'it': 'ENTRA',
    'en': 'JOIN',
    'es': 'ENTRAR',
    'fr': 'ENTRER',
    'de': 'BEITRETEN',
  },
  'join.error_name': {
    'it': 'Scrivi il tuo nome.',
    'en': 'Type your name.',
    'es': 'Escribe tu nombre.',
    'fr': 'Écris ton prénom.',
    'de': 'Gib deinen Namen ein.',
  },
  'join.error_code': {
    'it': 'Il codice è di 6 caratteri.',
    'en': 'The code has 6 characters.',
    'es': 'El código tiene 6 caracteres.',
    'fr': 'Le code fait 6 caractères.',
    'de': 'Der Code hat 6 Zeichen.',
  },
  'error.room_not_found': {
    'it': 'Nessuna stanza con questo codice.',
    'en': 'No room with this code.',
    'es': 'No hay ninguna sala con este código.',
    'fr': 'Aucun salon avec ce code.',
    'de': 'Kein Raum mit diesem Code.',
  },
  'error.room_full': {
    'it': 'La stanza è piena: massimo 10 giocatori.',
    'en': 'The room is full: 10 players max.',
    'es': 'La sala está llena: máximo 10 jugadores.',
    'fr': 'Le salon est plein : 10 joueurs maximum.',
    'de': 'Der Raum ist voll: maximal 10 Spieler.',
  },
  'error.room_finished': {
    'it': 'Questa partita è già finita.',
    'en': 'This game is already over.',
    'es': 'Esta partita ya ha terminado.',
    'fr': 'Cette partie est déjà terminée.',
    'de': 'Diese Partie ist schon vorbei.',
  },
  'error.connection': {
    'it': 'Connessione persa. Riapri l\'app e riprova.',
    'en': 'Connection lost. Reopen the app and try again.',
    'es': 'Conexión perdida. Reabre la app e inténtalo de nuevo.',
    'fr': 'Connexion perdue. Rouvre l\'app et réessaie.',
    'de': 'Verbindung verloren. App neu öffnen und erneut versuchen.',
  },

  // ------------------------------------------------------------------- lobby
  'lobby.title': {
    'it': 'Lobby',
    'en': 'Lobby',
    'es': 'Sala',
    'fr': 'Salon',
    'de': 'Lobby',
  },
  'lobby.code_label': {
    'it': 'CODICE STANZA',
    'en': 'ROOM CODE',
    'es': 'CÓDIGO DE SALA',
    'fr': 'CODE DU SALON',
    'de': 'RAUMCODE',
  },
  'lobby.code_hint': {
    'it': 'Dillo ad alta voce · tocca per copiare',
    'en': 'Say it out loud · tap to copy',
    'es': 'Dilo en voz alta · toca para copiar',
    'fr': 'Dis-le à voix haute · touche pour copier',
    'de': 'Laut vorlesen · zum Kopieren tippen',
  },
  'lobby.code_copied': {
    'it': 'Codice copiato',
    'en': 'Code copied',
    'es': 'Código copiado',
    'fr': 'Code copié',
    'de': 'Code kopiert',
  },
  'lobby.players': {
    'it': 'Giocatori',
    'en': 'Players',
    'es': 'Jugadores',
    'fr': 'Joueurs',
    'de': 'Spieler',
  },
  'lobby.you': {'it': 'tu', 'en': 'you', 'es': 'tú', 'fr': 'toi', 'de': 'du'},
  'lobby.host_badge': {
    'it': 'HOST',
    'en': 'HOST',
    'es': 'ANFITRIÓN',
    'fr': 'HÔTE',
    'de': 'HOST',
  },
  'lobby.pick_game': {
    'it': 'SCEGLI IL GIOCO',
    'en': 'PICK A GAME',
    'es': 'ELIGE EL JUEGO',
    'fr': 'CHOISIR LE JEU',
    'de': 'SPIEL WÄHLEN',
  },
  'lobby.waiting_host': {
    'it': 'L\'host sta scegliendo il gioco…',
    'en': 'The host is picking a game…',
    'es': 'El anfitrión está eligiendo el juego…',
    'fr': "L'hôte choisit le jeu…",
    'de': 'Der Host wählt gerade ein Spiel…',
  },
  'lobby.which_game': {
    'it': 'A cosa giochiamo?',
    'en': 'What are we playing?',
    'es': '¿A qué jugamos?',
    'fr': 'On joue à quoi ?',
    'de': 'Was spielen wir?',
  },
  'lobby.remove_player': {
    'it': 'Rimuovere {name}?',
    'en': 'Remove {name}?',
    'es': '¿Quitar a {name}?',
    'fr': 'Retirer {name} ?',
    'de': '{name} entfernen?',
  },
  'lobby.remove_player_body': {
    'it':
        'Usalo se qualcuno ha chiuso l\'app senza uscire. Potrà sempre rientrare con il codice.',
    'en':
        'Use this if someone closed the app without leaving. They can always rejoin with the code.',
    'es':
        'Úsalo si alguien cerró la app sin salir. Siempre podrá volver a entrar con el código.',
    'fr':
        "À utilizzare si quelqu'un a fermé l'app sans quitter. Il pourra revenir avec le code.",
    'de':
        'Nutze das, wenn jemand die App geschlossen hat, ohne zu gehen. Er kann jederzeit mit dem Code zurückkommen.',
  },
  'lobby.remove': {
    'it': 'Rimuovi',
    'en': 'Remove',
    'es': 'Quitar',
    'fr': 'Retirer',
    'de': 'Entfernen',
  },
  'lobby.exit_host_title': {
    'it': 'Chiudere la stanza?',
    'en': 'Close the room?',
    'es': '¿Cerrar la sala?',
    'fr': 'Fermer le salon ?',
    'de': 'Raum schließen?',
  },
  'lobby.exit_host_body': {
    'it':
        'La stanza si chiude per tutti: gli altri giocatori tornano alla home.',
    'en':
        'The room closes for everyone: the other players go back to the home screen.',
    'es': 'La sala se cierra para todos: los demás vuelven al inicio.',
    'fr':
        "Le salon se ferme pour tout le monde : les autres reviennent à l'accueil.",
    'de': 'Der Raum schließt für alle: Die anderen kehren zum Start zurück.',
  },
  'lobby.exit_title': {
    'it': 'Uscire dalla stanza?',
    'en': 'Leave the room?',
    'es': '¿Salir de la sala?',
    'fr': 'Quitter le salon ?',
    'de': 'Raum verlassen?',
  },
  'lobby.exit_body': {
    'it': 'Gli altri giocatori ti vedranno uscire.',
    'en': 'The other players will see you leave.',
    'es': 'Los demás jugadores te verán salir.',
    'fr': 'Les autres joueurs te verront partir.',
    'de': 'Die anderen Spieler sehen, dass du gehst.',
  },
  'lobby.stay': {
    'it': 'Resta',
    'en': 'Stay',
    'es': 'Quedarse',
    'fr': 'Rester',
    'de': 'Bleiben',
  },
  'lobby.close': {
    'it': 'Chiudi',
    'en': 'Close',
    'es': 'Cerrar',
    'fr': 'Fermer',
    'de': 'Schließen',
  },
  'lobby.leave': {
    'it': 'Esci',
    'en': 'Leave',
    'es': 'Salir',
    'fr': 'Quitter',
    'de': 'Verlassen',
  },
  'lobby.exit_failed': {
    'it': 'Uscita non riuscita: {detail}',
    'en': "Couldn't leave the room: {detail}",
    'es': 'No se pudo salir: {detail}',
    'fr': 'Impossible de quitter : {detail}',
    'de': 'Verlassen fehlgeschlagen: {detail}',
  },
  'lobby.room_closed': {
    'it': 'La stanza è stata chiusa dall\'host.',
    'en': 'The host closed the room.',
    'es': 'El anfitrión ha cerrado la sala.',
    'fr': "L'hôte a fermé le salon.",
    'de': 'Der Host hat den Raum geschlossen.',
  },
  'lobby.reconnecting': {
    'it': 'Riconnessione…',
    'en': 'Reconnecting…',
    'es': 'Reconectando…',
    'fr': 'Reconnexion…',
    'de': 'Verbinde neu…',
  },
  'lobby.entering': {
    'it': 'Entro nella stanza…',
    'en': 'Joining the room…',
    'es': 'Entrando en la sala…',
    'fr': 'Entrée dans le salon…',
    'de': 'Betrete den Raum…',
  },

  // ---------------------------------------------------------------- modalità
  'mode.title': {
    'it': 'Modalità',
    'en': 'Mode',
    'es': 'Modalidad',
    'fr': 'Mode',
    'de': 'Modus',
  },
  'mode.normale': {
    'it': 'Normale',
    'en': 'Normal',
    'es': 'Normal',
    'fr': 'Normal',
    'de': 'Normal',
  },
  'mode.mix': {'it': 'Mix', 'en': 'Mix', 'es': 'Mix', 'fr': 'Mix', 'de': 'Mix'},
  'mode.hot': {'it': 'Hot', 'en': 'Hot', 'es': 'Hot', 'fr': 'Hot', 'de': 'Hot'},
  'mode.normale.desc': {
    'it': 'Perfetta per rompere il ghiaccio senza troppi traumi.',
    'en': 'Perfect for breaking the ice without any trauma.',
    'es': 'Perfecta para romper el hielo sin demasiados traumas.',
    'fr': 'Parfait pour briser la glace sans trop de traumatismes.',
    'de': 'Perfekt zum Eisbrechen ohne große Traumata.',
  },
  'mode.mix.desc': {
    'it': 'I giochi ruotano e il ritmo incalza. Tenetevi forte.',
    'en': 'Games rotate and the pace picks up. Hold on tight.',
    'es': 'Los juegos rotan y el ritmo aumenta. Agarchaos fuerte.',
    'fr': 'Les jeux s\'enchaînent et le rythme s\'accélère. Accrochez-vous.',
    'de': 'Die Spiele wechseln und das Tempo zieht an. Anschnallen!',
  },
  'mode.hot.desc': {
    'it': 'Senza freni. Da giocare solo se siete pronti a tutto.',
    'en': 'No filters. Play only if you\'re ready for anything.',
    'es': 'Sin frenos. Juega solo si estás listo para todo.',
    'fr': 'Sans filtre. À jouer seulement si vous êtes prêts à tout.',
    'de': 'Hemmungslos. Nur spielen, wenn ihr zu allem bereit seid.',
  },
  'settings.rounds': {
    'it': 'Round per partita',
    'en': 'Rounds per game',
    'es': 'Rondas por partida',
    'fr': 'Manches par partie',
    'de': 'Runden pro Partie',
  },

  // ----------------------------------------------------------------- partita
  'game.round_of': {
    'it': 'Round {n} di {total}',
    'en': 'Round {n} of {total}',
    'es': 'Ronda {n} de {total}',
    'fr': 'Manche {n} sur {total}',
    'de': 'Runde {n} von {total}',
  },
  'game.preparing': {
    'it': 'Preparo il round…',
    'en': 'Setting up the round…',
    'es': 'Preparando la ronda…',
    'fr': 'Préparation de la manche…',
    'de': 'Runde wird vorbereitet…',
  },
  'game.create_failed': {
    'it': 'Non riesco a creare il round: {detail}',
    'en': "Couldn't create the round: {detail}",
    'es': 'No se pudo crear la ronda: {detail}',
    'fr': 'Impossible de créer la manche : {detail}',
    'de': 'Runde konnte nicht erstellt werden: {detail}',
  },
  'game.close_failed': {
    'it': 'Non riesco a chiudere il round: {detail}',
    'en': "Couldn't close the round: {detail}",
    'es': 'No se pudo cerrar la ronda: {detail}',
    'fr': 'Impossible de clore la manche : {detail}',
    'de': 'Runde konnte nicht beendet werden: {detail}',
  },
  'game.vote_failed': {
    'it': 'Risposta non registrata: {detail}',
    'en': 'Answer not registered: {detail}',
    'es': 'Respuesta no registrada: {detail}',
    'fr': 'Réponse non enregistrée : {detail}',
    'de': 'Antwort nicht gespeichert: {detail}',
  },
  'game.next_round': {
    'it': 'PROSSIMO ROUND',
    'en': 'NEXT ROUND',
    'es': 'SIGUIENTE RONDA',
    'fr': 'MANCHE SUIVANTE',
    'de': 'NÄCHSTE RUNDE',
  },
  'game.see_podium': {
    'it': 'VEDI IL PODIO',
    'en': 'SEE THE PODIUM',
    'es': 'VER EL PODIO',
    'fr': 'VOIR LE PODIUM',
    'de': 'ZUM PODEST',
  },
  'game.waiting_next': {
    'it': 'L\'host sta per lanciare il prossimo round…',
    'en': 'The host is about to start the next round…',
    'es': 'El anfitrión está a punto de lanzar la siguiente ronda…',
    'fr': "L'hôte va lancer la manche suivante…",
    'de': 'Der Host startet gleich die nächste Runde…',
  },
  'game.finished': {
    'it': 'La partita è finita',
    'en': 'The game is over',
    'es': 'La partida ha terminado',
    'fr': 'La partie est terminée',
    'de': 'Die Partie ist vorbei',
  },
  'game.answered': {
    'it': 'Hanno risposto {n} su {total}',
    'en': '{n} of {total} answered',
    'es': 'Han respondido {n} de {total}',
    'fr': '{n} sur {total} ont répondu',
    'de': '{n} von {total} haben geantwortet',
  },
  'game.back_to_lobby': {
    'it': 'TORNA ALLA LOBBY',
    'en': 'BACK TO LOBBY',
    'es': 'VOLVER A LA SALA',
    'fr': 'RETOUR AU SALON',
    'de': 'ZURÜCK ZUR LOBBY',
  },
  'game.lobby_short': {
    'it': 'LOBBY',
    'en': 'LOBBY',
    'es': 'SALA',
    'fr': 'SALON',
    'de': 'LOBBY',
  },
  'game.host_only': {
    'it': 'L\'host può far ripartire il gioco dalla lobby.',
    'en': 'The host can start a new game from the lobby.',
    'es': 'El anfitrión può reiniciar el juego desde la sala.',
    'fr': "L'hôte peut relancer une partie depuis le salon.",
    'de': 'Der Host kann von der Lobby aus neu starten.',
  },
  'game.coming_soon': {
    'it': 'In arrivo',
    'en': 'Coming soon',
    'es': 'Próximamente',
    'fr': 'Bientôt',
    'de': 'Demnächst',
  },

  // ---------------------------------------------------------------- podio
  'podium.title': {
    'it': 'Fine partita',
    'en': 'Game over',
    'es': 'Fin de la partida',
    'fr': 'Fin de partie',
    'de': 'Spielende',
  },
  'podium.winner': {
    'it': 'Vince {name}',
    'en': '{name} wins',
    'es': 'Gana {name}',
    'fr': '{name} gagne',
    'de': '{name} gewinnt',
  },
  'podium.no_scores': {
    'it':
        'Questo gioco non assegna punti: nessuna classifica, solo la partita.',
    'en': 'This game has no points: no ranking, just the game.',
    'es': 'Este juego no da puntos: sin clasificación, solo la partida.',
    'fr': 'Ce jeu ne donne pas de points : pas de classement, juste la partie.',
    'de': 'Dieses Spiel vergibt keine Punkte: keine Rangliste, nur das Spiel.',
  },
  'podium.points': {
    'it': '{n} punti',
    'en': '{n} points',
    'es': '{n} puntos',
    'fr': '{n} points',
    'de': '{n} Punkte',
  },
  'podium.points_one': {
    'it': '{n} punto',
    'en': '{n} point',
    'es': '{n} punto',
    'fr': '{n} point',
    'de': '{n} Punkt',
  },

  // -------------------------------------------------------------- Preferisci
  'preferisci.name': {
    'it': 'Preferisci',
    'en': 'Would you rather',
    'es': 'Qué prefieres',
    'fr': 'Tu préfères',
    'de': 'Was lieber',
  },
  'preferisci.tagline': {
    'it': 'Scelte atroci: chi la pensa come te?',
    'en': 'Horrible choices: who thinks like you?',
    'es': 'Elecciones atroces: ¿quién piensa como tú?',
    'fr': 'Choix atroces : qui pense come toi ?',
    'de': 'Furchtbare Entscheidungen: Wer denkt wie du?',
  },
  'preferisci.prompt': {
    'it': 'Preferisci…',
    'en': 'Would you rather…',
    'es': '¿Qué prefieres…',
    'fr': 'Tu préfères…',
    'de': 'Was wäre dir lieber…',
  },
  'preferisci.or': {
    'it': 'oppure',
    'en': 'or',
    'es': 'o',
    'fr': 'ou',
    'de': 'oder',
  },
  'preferisci.split': {
    'it': 'Il gruppo si è diviso così',
    'en': 'Here is how the group split',
    'es': 'Así se ha dividido el grupo',
    'fr': 'Voici comment le groupe se répartit',
    'de': 'So hat sich die Gruppe geteilt',
  },
  'preferisci.no_votes': {
    'it': 'Non ha risposto nessuno',
    'en': 'Nobody answered',
    'es': 'No ha respondido nadie',
    'fr': "Personne n'a répondu",
    'de': 'Niemand hat geantwortet',
  },

  // -------------------------------------------------------------- Non ho mai
  'non_ho_mai.name': {
    'it': 'Non ho mai',
    'en': 'Never have I ever',
    'es': 'Yo nunca',
    'fr': "Je n'ai jamais",
    'de': 'Ich habe noch nie',
  },
  'non_ho_mai.tagline': {
    'it': 'Il confessionale è aperto. Confessa e sopravvivi.',
    'en': 'The confessional is open. Confess and survive.',
    'es': 'El confesionario está abierto. Confiesa y sobrevive.',
    'fr': 'Le confessionnal est ouvert. Avoue et survis.',
    'de': 'Das Beichtgelübde ist aufgehoben. Beichte und überlebe.',
  },
  'non_ho_mai.prompt': {
    'it': 'Non ho mai…',
    'en': 'Never have I ever…',
    'es': 'Yo nunca…',
    'fr': "Je n'ai jamais…",
    'de': 'Ich habe noch nie…',
  },
  'non_ho_mai.done': {
    'it': 'L\'HO FATTO',
    'en': 'I HAVE',
    'es': 'YO SÍ',
    'fr': "JE L'AI FAIT",
    'de': 'HABE ICH',
  },
  'non_ho_mai.never': {
    'it': 'MAI',
    'en': 'NEVER',
    'es': 'NUNCA',
    'fr': 'JAMAIS',
    'de': 'NIE',
  },
  'non_ho_mai.anonymous': {
    'it': 'Nessuno vedrà cosa hai risposto: si vede solo il conteggio.',
    'en': 'Nobody sees your answer: only the count is shared.',
    'es': 'Nadie verá tu respuesta: solo se ve el recuento.',
    'fr': 'Personne ne voit ta réponse : seul le total est partagé.',
    'de': 'Niemand sieht deine Antwort: nur die Anzahl wird gezeigt.',
  },
  'non_ho_mai.nobody': {
    'it': 'Nessuno l\'ha fatto',
    'en': 'Nobody has',
    'es': 'Nadie lo ha hecho',
    'fr': "Personne ne l'a fait",
    'de': 'Niemand hat das',
  },
  'non_ho_mai.count': {
    'it': '{n} su {total}',
    'en': '{n} of {total}',
    'es': '{n} de {total}',
    'fr': '{n} sur {total}',
    'de': '{n} von {total}',
  },
  'non_ho_mai.guess_who': {
    'it': 'Ora tocca a voi capire chi',
    'en': 'Now work out who',
    'es': 'Ahora averiguad quién',
    'fr': 'À vous de deviner qui',
    'de': 'Jetzt findet heraus, wer',
  },

  // ---------------------------------------------------- Chi lo potrebbe fare
  'chi.name': {
    'it': 'Chi lo potrebbe fare',
    'en': 'Most likely to',
    'es': 'Quién sería capaz',
    'fr': 'Qui sarebbe capace',
    'de': 'Wer würde eher',
  },
  'chi.tagline': {
    'it': 'Il gioco dove si punta il dito (letteralmente).',
    'en': 'The game where you point fingers (literally).',
    'es': 'El juego donde se señala con el dedo (literalmente).',
    'fr': 'Le jeu où l\'on pointe du doigt (littéralement).',
    'de': 'Das Spiel, bei dem man mit dem Finger zeigt (wörtlich).',
  },
  'chi.decided': {
    'it': 'Il gruppo ha deciso',
    'en': 'The group has decided',
    'es': 'El grupo ha decidido',
    'fr': 'Le groupe a décidé',
    'de': 'Die Gruppe hat entschieden',
  },
  'chi.tie': {
    'it': 'Pari merito',
    'en': 'It\'s a tie',
    'es': 'Empate',
    'fr': 'Égalité',
    'de': 'Gleichstand',
  },
  'chi.no_votes': {
    'it': 'Nessun voto',
    'en': 'No votes',
    'es': 'Sin votos',
    'fr': 'Aucun vote',
    'de': 'Keine Stimmen',
  },

  // ------------------------------------------------------- Obbligo o Verità
  'obbligo.name': {
    'it': 'Obbligo o Verità',
    'en': 'Truth or Dare',
    'es': 'Verdad o Reto',
    'fr': 'Action ou Vérité',
    'de': 'Wahrheit oder Pflicht',
  },
  'obbligo.tagline': {
    'it': 'La bottiglia decide, tu sudi. Zero scuse.',
    'en': 'The bottle decides, you sweat. No excuses.',
    'es': 'La botella decide, tú sudas. Sin excusas.',
    'fr': 'La bouteille décide, tu transpires. Aucune excuse.',
    'de': 'Die Flasche entscheidet, du schwitzt. Keine Ausreden.',
  },
  'obbligo.spinning': {
    'it': 'La bottiglia gira…',
    'en': 'The bottle is spinning…',
    'es': 'La botella está girando…',
    'fr': 'La bouteille tourne…',
    'de': 'Die Flasche dreht sich…',
  },
  'obbligo.your_turn': {
    'it': 'Tocca a te',
    'en': 'Your turn',
    'es': 'Te toca',
    'fr': 'À toi',
    'de': 'Du bist dran',
  },
  'obbligo.turn_of': {
    'it': 'Tocca a {name}',
    'en': "{name}'s turn",
    'es': 'Le toca a {name}',
    'fr': 'Au tour de {name}',
    'de': '{name} ist dran',
  },
  'obbligo.choosing': {
    'it': 'Sta scegliendo…',
    'en': 'Choosing…',
    'es': 'Está eligiendo…',
    'fr': 'En train de choisir…',
    'de': 'Wählt gerade…',
  },
  'obbligo.dare': {
    'it': 'OBBLIGO',
    'en': 'DARE',
    'es': 'RETO',
    'fr': 'ACTION',
    'de': 'PFLICHT',
  },
  'obbligo.truth': {
    'it': 'VERITÀ',
    'en': 'TRUTH',
    'es': 'VERDAD',
    'fr': 'VÉRITÉ',
    'de': 'WAHRHEIT',
  },
  'obbligo.no_choice': {
    'it': '{name} non ha scelto in tempo',
    'en': "{name} didn't choose in time",
    'es': '{name} no ha elegido a tiempo',
    'fr': "{name} n'a pas choisi à temps",
    'de': '{name} hat nicht rechtzeitig gewählt',
  },
  'obbligo.when_done': {
    'it': 'Quando ha finito, l\'host lancia il prossimo giro',
    'en': 'When they are done, the host starts the next spin',
    'es': 'Cuando termine, el anfitrión lanza la siguiente ronda',
    'fr': "Quand c'est fait, l'hôte relance la bouteille",
    'de': 'Danach startet der Host die nächste Runde',
  },

  // ----------------------------------------------------------- Bluff Story
  'bluff.name': {
    'it': 'Bluff Story',
    'en': 'Bluff Story',
    'es': 'Bluff Story',
    'fr': 'Bluff Story',
    'de': 'Bluff Story',
  },
  'bluff.tagline': {
    'it': 'Mentire è un\'arte. Riesci a non farti beccare?',
    'en': 'Lying is an art. Can you avoid getting caught?',
    'es': 'Mentir es un arte. ¿Podrás evitar que te pillen?',
    'fr': 'Mentir est un art. Pourras-tu éviter de te faire prendre ?',
    'de': 'Lügen ist eine Kunst. Lässt du dich nicht erwischen?',
  },
  'bluff.writing': {
    'it': '{name} sta scrivendo\nun fatto vero su di sé',
    'en': '{name} is writing\nsomething true about them',
    'es': '{name} está escribiendo\nalgo verdadero sobre sí',
    'fr': '{name} écrit\nquelque chose de vrai',
    'de': '{name} schreibt\netwas Wahres über sich',
  },
  'bluff.your_turn_body': {
    'it':
        'Scrivi un fatto vero su di te. Il gioco ci metterà in mezzo due bugie: gli altri dovranno indovinare qual è il tuo.',
    'en':
        'Write something true about you. The game adds two lies: the others have to spot yours.',
    'es':
        'Escribe algo verdadero sobre ti. El juego añadirá dos mentiras: los demás deben acertar cuál es la tuya.',
    'fr':
        'Écris quelque chose de vrai sur toi. Le jeu ajoute deux mensonges : aux autres de trouver le vrai.',
    'de':
        'Schreib etwas Wahres über dich. Das Spiel fügt zwei Lügen hinzu: Die anderen müssen deine Wahrheit finden.',
  },
  'bluff.hint': {
    'it': 'Scrivi qui…',
    'en': 'Write here…',
    'es': 'Escribe aquí…',
    'fr': 'Écris ici…',
    'de': 'Hier schreiben…',
  },
  'bluff.send': {
    'it': 'MANDA LA TUA VERITÀ',
    'en': 'SEND YOUR TRUTH',
    'es': 'ENVIAR TU VERDAD',
    'fr': 'ENVOYER TA VÉRITÉ',
    'de': 'WAHRHEIT SENDEN',
  },
  'bluff.too_short': {
    'it': 'Scrivi qualcosa di un po\' più lungo.',
    'en': 'Write something a bit longer.',
    'es': 'Escribe algo un poco più lungo.',
    'fr': 'Écris quelque chose d\'un peu plus long.',
    'de': 'Schreib etwas mehr.',
  },
  'bluff.which_true': {
    'it': 'Qual è la verità di {name}?',
    'en': "Which one is {name}'s truth?",
    'es': '¿Cuál es la verdad de {name}?',
    'fr': 'Quelle est la vérité de {name} ?',
    'de': 'Was ist {name}s Wahrheit?',
  },
  'bluff.in_play': {
    'it': 'La tua storia è in gioco',
    'en': 'Your story is in play',
    'es': 'Tu historia está en juego',
    'fr': 'Ton histoire est en jeu',
    'de': 'Deine Geschichte ist im Spiel',
  },
  'bluff.dont_tell': {
    'it': 'Non lasciarti scappare qual è quella vera.',
    'en': "Don't give away which one is true.",
    'es': 'No dejes escapar cuál es la verdadera.',
    'fr': 'Ne laisse pas deviner laquelle est vraie.',
    'de': 'Verrate nicht, welche wahr ist.',
  },
  'bluff.your_truth': {
    'it': 'la tua verità',
    'en': 'your truth',
    'es': 'tu verdad',
    'fr': 'ta vérité',
    'de': 'deine Wahrheit',
  },
  'bluff.true_label': {
    'it': 'vera',
    'en': 'true',
    'es': 'verdadera',
    'fr': 'vraie',
    'de': 'wahr',
  },
  'bluff.truth_of': {
    'it': 'La verità di {name}',
    'en': "{name}'s truth",
    'es': 'La verdad de {name}',
    'fr': 'La vérité de {name}',
    'de': '{name}s Wahrheit',
  },
  'bluff.nobody_guessed': {
    'it': 'Nessuno ha indovinato: {name} vi ha fregati tutti',
    'en': 'Nobody guessed: {name} fooled everyone',
    'es': 'Nadie ha acertado: {name} os ha engañado a todos',
    'fr': "Personne n'a trouvé : {name} vous a tous eus",
    'de': 'Niemand hat es erraten: {name} hat alle getäuscht',
  },
  'bluff.guessed': {
    'it': '{n} hanno indovinato',
    'en': '{n} guessed right',
    'es': '{n} han acertado',
    'fr': '{n} ont trouvé',
    'de': '{n} lagen richtig',
  },
  'bluff.guessed_one': {
    'it': '{n} ha indovinato',
    'en': '{n} guessed right',
    'es': '{n} ha acertado',
    'fr': '{n} a trouvé',
    'de': '{n} lag richtig',
  },
  'bluff.scoring': {
    'it': '+2 a chi ha indovinato · +1 a {name} per ogni bluff riuscito',
    'en': '+2 for each correct guess · +1 to {name} for every player fooled',
    'es': '+2 por acertar · +1 a {name} por cada jugador engañado',
    'fr': '+2 par bonne réponse · +1 à {name} par joueur trompé',
    'de': '+2 für jeden Treffer · +1 für {name} pro getäuschtem Spieler',
  },
  'bluff.ai_working': {
    'it': 'Sto inventando due bugie…',
    'en': 'Writing two lies…',
    'es': 'Inventando dos mentiras…',
    'fr': 'Invention de deux mensonges…',
    'de': 'Zwei Lügen entstehen…',
  },
  'bluff.ai_working_sub': {
    'it': 'su misura per la storia di {name}',
    'en': "tailored to {name}'s story",
    'es': 'a medida de la historia de {name}',
    'fr': "sur mesure pour l'histoire de {name}",
    'de': 'passend zu {name}s Geschichte',
  },

  // ------------------------------------------------------------- Impostore
  'impostore.name': {
    'it': 'Impostore',
    'en': 'Impostor',
    'es': 'Impostor',
    'fr': 'Imposteur',
    'de': 'Betrüger',
  },
  'impostore.tagline': {
    'it': 'Un intruso tra noi. Trovalo prima che sia tardi.',
    'en': 'An intruder among us. Find them before it\'s too late.',
    'es': 'Un intruso entre nosotros. Encuéntralo antes de que sea tarde.',
    'fr': 'Un intrus parmi nous. Trouve-le avant qu\'il ne soit trop tard.',
    'de': 'Ein Eindringling unter uns. Finde ihn, bevor es zu spät ist.',
  },
  'impostore.only_you': {
    'it': 'Solo tu vedi questo',
    'en': 'Only you can see this',
    'es': 'Solo tú ves esto',
    'fr': 'Toi seul vois ceci',
    'de': 'Nur du siehst das',
  },
  'impostore.you_are': {
    'it': 'Sei l\'impostore',
    'en': 'You are the impostor',
    'es': 'Eres el impostor',
    'fr': "Tu es l'imposteur",
    'de': 'Du bist der Betrüger',
  },
  'impostore.you_are_body': {
    'it':
        'Non conosci la parola. Ascolta, improvvisa e non farti scoprire: se indovini la parola alla fine recuperi punti.',
    'en':
        'You do not know the word. Listen, improvise, stay hidden: guessing the word at the end wins points back.',
    'es':
        'No conoces la palabra. Escucha, improvisa y que no te pillen: si aciertas la palabra al final recuperas puntos.',
    'fr':
        "Tu ne connais pas le mot. Écoute, improvise, reste discret : deviner le mot à la fin rapporte des points.",
    'de':
        'Du kennst das Wort nicht. Hör zu, improvisiere, bleib unentdeckt: Errätst du das Wort am Ende, holst du Punkte zurück.',
  },
  'impostore.the_word': {
    'it': 'La parola è',
    'en': 'The word is',
    'es': 'La palabra es',
    'fr': 'Le mot est',
    'de': 'Das Wort ist',
  },
  'impostore.one_doesnt': {
    'it': 'Uno di voi non la conosce.',
    'en': 'One of you does not know it.',
    'es': 'Uno de vosotros no la conoce.',
    'fr': "L'un de vous ne le connaît pas.",
    'de': 'Einer von euch kennt es nicht.',
  },
  'impostore.round_of_words': {
    'it': 'Giro di parole',
    'en': 'Word round',
    'es': 'Ronda de palabras',
    'fr': 'Tour de mots',
    'de': 'Wortrunde',
  },
  'impostore.round_of_words_body': {
    'it':
        'A turno, ognuno dice una sola parola legata al segreto.\nTroppo precisa e l\'impostore capisce, troppo vaga e sembrate voi l\'impostore.',
    'en':
        'One at a time, say a single word linked to the secret.\nToo precise and the impostor learns it, too vague and you look like the impostor.',
    'es':
        'Por turnos, cada uno dice una sola parola legata al secreto.\nDemasiado precisa y el impostor lo pilla, demasiado vaga y pareces tú el impostor.',
    'fr':
        "Chacun son tour, dites un seul mot lié au secret.\nTrop précis, l'imposteur comprend ; trop vague, c'est vous le suspect.",
    'de':
        'Reihum sagt jeder ein einziges Wort zum Geheimnis.\nZu genau, und der Betrüger versteht es; zu vage, und du wirkst verdächtig.',
  },
  'impostore.your_word': {
    'it': 'La tua parola: {word}',
    'en': 'Your word: {word}',
    'es': 'Tu palabra: {word}',
    'fr': 'Ton mot : {word}',
    'de': 'Dein Wort: {word}',
  },
  'impostore.to_vote': {
    'it': 'PASSA AL VOTO',
    'en': 'GO TO THE VOTE',
    'es': 'PASAR A LA VOTACIÓN',
    'fr': 'PASSER AU VOTE',
    'de': 'ZUR ABSTIMMUNG',
  },
  'impostore.who': {
    'it': 'Chi è l\'impostore?',
    'en': 'Who is the impostor?',
    'es': '¿Quién es el impostor?',
    'fr': "Qui est l'imposteur ?",
    'de': 'Wer ist der Betrüger?',
  },
  'impostore.guess_hint': {
    'it': 'La parola segreta era…',
    'en': 'The secret word was…',
    'es': 'La palabra secreta era…',
    'fr': 'Le mot secret était…',
    'de': 'Das geheime Wort war…',
  },
  'impostore.guess_body': {
    'it':
        'Sei l\'impostore: prova a indovinare la parola. Se ti scoprono ma la azzecchi, recuperi punti.',
    'en':
        'You are the impostor: try to guess the word. Even if caught, a correct guess wins points back.',
    'es':
        'Eres el impostor: intenta adivinar la palabra. Aunque te pillen, acertarla te devuelve puntos.',
    'fr':
        "Tu es l'imposteur : devine le mot. Même démasqué, une bonne réponse rapporte des points.",
    'de':
        'Du bist der Betrüger: Rate das Wort. Selbst entlarvt bringt ein Treffer Punkte zurück.',
  },
  'impostore.confirm': {
    'it': 'CONFERMA',
    'en': 'CONFIRM',
    'es': 'CONFIRMAR',
    'fr': 'CONFIRMER',
    'de': 'BESTÄTIGEN',
  },
  'impostore.vote_registered': {
    'it': 'Voto registrato',
    'en': 'Vote registered',
    'es': 'Voto registrado',
    'fr': 'Vote enregistré',
    'de': 'Stimme gezählt',
  },
  'impostore.caught': {
    'it': 'Impostore smascherato',
    'en': 'Impostor unmasked',
    'es': 'Impostor desenmascarado',
    'fr': 'Imposteur démasqué',
    'de': 'Betrüger entlarvt',
  },
  'impostore.escaped': {
    'it': 'L\'impostore l\'ha fatta franca',
    'en': 'The impostor got away with it',
    'es': 'El impostor se ha salido con la suya',
    'fr': "L'imposteur s'en sort",
    'de': 'Der Betrüger kommt davon',
  },
  'impostore.word_was': {
    'it': 'La parola era',
    'en': 'The word was',
    'es': 'La palabra era',
    'fr': 'Le mot était',
    'de': 'Das Wort war',
  },
  'impostore.guessed_it': {
    'it': 'Ha indovinato: "{guess}" · +3 punti',
    'en': 'Guessed it: "{guess}" · +3 points',
    'es': 'Ha acertado: "{guess}" · +3 puntos',
    'fr': 'Trouvé : "{guess}" · +3 points',
    'de': 'Erraten: „{guess}" · +3 Punkte',
  },
  'impostore.said': {
    'it': 'Aveva detto: "{guess}"',
    'en': 'They said: "{guess}"',
    'es': 'Había dicho: "{guess}"',
    'fr': 'Il avait dit : "{guess}"',
    'de': 'Er sagte: „{guess}"',
  },
  'impostore.points_caught': {
    'it': '+2 a chi ha votato l\'impostore',
    'en': '+2 for everyone who voted the impostor',
    'es': '+2 para quien votó al impostor',
    'fr': "+2 pour ceux qui ont voté l'imposteur",
    'de': '+2 für alle, die den Betrüger gewählt haben',
  },
  'impostore.points_escaped': {
    'it': '+5 all\'impostore',
    'en': '+5 to the impostor',
    'es': '+5 para el impostor',
    'fr': "+5 pour l'imposteur",
    'de': '+5 für den Betrüger',
  },
  'impostore.votes': {
    'it': '{n} voti',
    'en': '{n} votes',
    'es': '{n} votos',
    'fr': '{n} votes',
    'de': '{n} Stimmen',
  },
  'impostore.votes_one': {
    'it': '{n} voto',
    'en': '{n} vote',
    'es': '{n} voto',
    'fr': '{n} vote',
    'de': '{n} Stimme',
  },

  // ------------------------------------------------------------------ premium
  'premium.title': {
    'it': 'Contenuti su misura',
    'en': 'Tailored content',
    'es': 'Contenido a medida',
    'fr': 'Contenu sur mesure',
    'de': 'Maßgeschneiderte Inhalte',
  },
  'premium.body': {
    'it':
        'In "Chi lo potrebbe fare" e "Bluff Story" le frasi vengono scritte sul vostro gruppo invece che pescate da un elenco.',
    'en':
        'In "Most likely to" and "Bluff Story" the lines are written for your group instead of picked from a list.',
    'es':
        'En "Quién sería capaz" y "Bluff Story" las frases se escriben para vuestro grupo en vez de salir de una lista.',
    'fr':
        'Dans « Qui serait capable » et « Bluff Story », les phrases sont écrites pour votre groupe.',
    'de':
        'Bei „Wer würde eher" und „Bluff Story" werden die Sätze für eure Gruppe geschrieben statt aus einer Liste gezogen.',
  },
  'premium.active': {
    'it': 'AI attiva in questa stanza',
    'en': 'AI is on in this room',
    'es': 'IA activa en questa sala',
    'fr': "IA active dans ce salon",
    'de': 'KI in diesem Raum aktiv',
  },
  'premium.active_body': {
    'it': 'Domande e bugie generate sul vostro gruppo',
    'en': 'Questions and lies generated for your group',
    'es': 'Preguntas y mentiras generadas para vuestro grupo',
    'fr': 'Questions et mensonges générés pour votre groupe',
    'de': 'Fragen und Lügen für eure Gruppe erzeugt',
  },
  'premium.unlock': {
    'it': 'SBLOCCA',
    'en': 'UNLOCK',
    'es': 'DESBLOQUEAR',
    'fr': 'DÉBLOQUER',
    'de': 'FREISCHALTEN',
  },
  'premium.watch_ad': {
    'it': 'ANNUNCIO',
    'en': 'WATCH AD',
    'es': 'ANUNCIO',
    'fr': 'PUB',
    'de': 'WERBUNG',
  },
  'premium.host_only': {
    'it': 'Può sbloccarla l\'host.',
    'en': 'Only the host can unlock it.',
    'es': 'Solo el anfitrión puede desbloquearlo.',
    'fr': "Seul l'hôte peut le débloquer.",
    'de': 'Nur der Host kann das freischalten.',
  },
  'premium.credits': {
    'it': '{n} crediti',
    'en': '{n} credits',
    'es': '{n} créditos',
    'fr': '{n} crédits',
    'de': '{n} Credits',
  },
  'premium.unlocked': {
    'it': 'AI sbloccata per questa stanza',
    'en': 'AI unlocked for this room',
    'es': 'IA desbloqueada para esta sala',
    'fr': 'IA débloquée pour ce salon',
    'de': 'KI für diesen Raum freigeschaltet',
  },
  'premium.ad_reward': {
    'it': 'Hai guadagnato un contenuto AI',
    'en': 'You earned one AI content',
    'es': 'Has ganado un contenido con IA',
    'fr': 'Tu as gagné un contenu IA',
    'de': 'Du hast einen KI-Inhalt verdient',
  },
  'premium.ad_incomplete': {
    'it': 'Annuncio non completato.',
    'en': 'Ad not completed.',
    'es': 'Anuncio non completado.',
    'fr': 'Publicité non terminée.',
    'de': 'Werbung nicht zu Ende gesehen.',
  },
  'premium.no_store': {
    'it': 'Acquisti non disponibili qui: servono Google Play o App Store.',
    'en':
        'Purchases are not available here: Google Play or the App Store is required.',
    'es': 'Compras no disponibles aquí: hacen falta Google Play o App Store.',
    'fr':
        "Achats indisponibles ici : Google Play ou l'App Store sont nécessaires.",
    'de': 'Käufe hier nicht möglich: Google Play oder App Store nötig.',
  },
  'premium.ads_mobile_only': {
    'it': 'Gli annunci funzionano solo su telefono.',
    'en': 'Ads only work on phones.',
    'es': 'Los anuncios solo funcionan en el móvil.',
    'fr': 'Les publicités ne marchent que sur téléphone.',
    'de': 'Werbung funktioniert nur auf dem Handy.',
  },
};
