import '../content_tone.dart';

/// Contenuti di gioco in spagnolo, a parità con i pool italiani:
/// 150 voci per tono in ogni gioco.
class ContentEs {
  const ContentEs._();

  /// Frasi che completano "Yo nunca…" (150 soft, 150 piccante, 150 cattivo).
  static const List<({String text, String tone})>
  nonHoMai = <({String text, String tone})>[
    // ---------------------------------------------------------- soft
    (
      text: 'fingido estar enfermo para no ir a trabajar',
      tone: ContentTone.soft,
    ),
    (text: 'dormido hasta media tarde', tone: ContentTone.soft),
    (text: 'comido algo que se había caído al suelo', tone: ContentTone.soft),
    (text: 'cantado en la ducha a todo volumen', tone: ContentTone.soft),
    (
      text: 'fingido conocer una canción para no quedar mal',
      tone: ContentTone.soft,
    ),
    (
      text: 'olvidado el cumpleaños de un amigo cercano',
      tone: ContentTone.soft,
    ),
    (text: 'perdido un vuelo o un tren', tone: ContentTone.soft),
    (text: 'viajado completamente solo', tone: ContentTone.soft),
    (text: 'roto un hueso', tone: ContentTone.soft),
    (text: 'hecho un tatuaje', tone: ContentTone.soft),
    (text: 'teñido el pelo de un color absurdo', tone: ContentTone.soft),
    (
      text: 'enviado un mensaje a la persona equivocada',
      tone: ContentTone.soft,
    ),
    (text: 'reído de un chiste que no había entendido', tone: ContentTone.soft),
    (text: 'hablado solo en voz alta', tone: ContentTone.soft),
    (text: 'llorado viendo una película', tone: ContentTone.soft),
    (text: 'visto una temporada entera en un día', tone: ContentTone.soft),
    (text: 'comido pizza con cuchillo y tenedor', tone: ContentTone.soft),
    (text: 'puesto piña en la pizza', tone: ContentTone.soft),
    (text: 'cocinado algo incomible', tone: ContentTone.soft),
    (text: 'quemado la cena sin remedio', tone: ContentTone.soft),
    (
      text: 'dejado el fuego encendido al salir de casa',
      tone: ContentTone.soft,
    ),
    (text: 'dejado las llaves dentro de casa', tone: ContentTone.soft),
    (text: 'olvidado dónde había aparcado', tone: ContentTone.soft),
    (text: 'recibido una multa', tone: ContentTone.soft),
    (text: 'fingido no ver a un conocido por la calle', tone: ContentTone.soft),
    (text: 'inventado una excusa para no salir', tone: ContentTone.soft),
    (text: 'cancelado un plan en el último momento', tone: ContentTone.soft),
    (
      text: 'dicho "llego en cinco minutos" desde el sofá',
      tone: ContentTone.soft,
    ),
    (text: 'ido a la compra con hambre', tone: ContentTone.soft),
    (text: 'comprado algo que no he usado nunca', tone: ContentTone.soft),
    (text: 'gastado demasiado en algo inútil', tone: ContentTone.soft),
    (text: 'ganado un premio', tone: ContentTone.soft),
    (text: 'cantado en un karaoke', tone: ContentTone.soft),
    (text: 'bailado sin música', tone: ContentTone.soft),
    (text: 'tocado un instrumento delante de alguien', tone: ContentTone.soft),
    (text: 'dormido en un aeropuerto', tone: ContentTone.soft),
    (text: 'dormido en el coche', tone: ContentTone.soft),
    (text: 'dormido en una tienda de campaña', tone: ContentTone.soft),
    (text: 'nadado de noche en el mar', tone: ContentTone.soft),
    (text: 'tenido miedo a la oscuridad siendo adulto', tone: ContentTone.soft),
    (
      text: 'dormido con la luz encendida siendo adulto',
      tone: ContentTone.soft,
    ),
    (text: 'gritado por una pesadilla', tone: ContentTone.soft),
    (text: 'caminado dormido', tone: ContentTone.soft),
    (text: 'roncado tan fuerte que desperté a alguien', tone: ContentTone.soft),
    (text: 'comido en la cama', tone: ContentTone.soft),
    (text: 'saltado el desayuno una semana entera', tone: ContentTone.soft),
    (text: 'bebido un café olvidado y ya frío', tone: ContentTone.soft),
    (text: 'derramado algo encima de alguien', tone: ContentTone.soft),
    (text: 'roto algo valioso sin decirlo', tone: ContentTone.soft),
    (text: 'culpado a otro de algo mío', tone: ContentTone.soft),
    (text: 'copiado en un examen', tone: ContentTone.soft),
    (
      text: 'terminado un trabajo la última noche posible',
      tone: ContentTone.soft,
    ),
    (text: 'enviado un correo sin el adjunto', tone: ContentTone.soft),
    (
      text: 'llamado a alguien por el nombre equivocado a la cara',
      tone: ContentTone.soft,
    ),
    (text: 'olvidado una contraseña importante', tone: ContentTone.soft),
    (text: 'buscado mi nombre en internet', tone: ContentTone.soft),
    (text: 'bloqueado a alguien en redes', tone: ContentTone.soft),
    (
      text: 'publicado algo y borrado a los cinco minutos',
      tone: ContentTone.soft,
    ),
    (
      text: 'fingido que el móvil estaba sin batería para no contestar',
      tone: ContentTone.soft,
    ),
    (
      text: 'respondido días después fingiendo no haberlo visto',
      tone: ContentTone.soft,
    ),
    (text: 'usado el wifi del vecino sin permiso', tone: ContentTone.soft),
    (
      text: 'cantado en el coche mirando a los demás conductores',
      tone: ContentTone.soft,
    ),
    (text: 'bailado solo en un ascensor', tone: ContentTone.soft),
    (
      text: 'hablado con un animal como si lo entendiera todo',
      tone: ContentTone.soft,
    ),
    (text: 'puesto nombre a mi coche', tone: ContentTone.soft),
    (
      text: 'hecho una promesa sabiendo que no la cumpliría',
      tone: ContentTone.soft,
    ),
    (text: 'mentido sobre mi edad', tone: ContentTone.soft),
    (text: 'exagerado cuánto me gustaba un regalo', tone: ContentTone.soft),
    (text: 'regalado algo que me habían regalado a mí', tone: ContentTone.soft),
    (text: 'guardado durante años algo prestado', tone: ContentTone.soft),
    (text: 'prestado dinero que nunca volví a ver', tone: ContentTone.soft),
    (text: 'pedido un aumento de sueldo', tone: ContentTone.soft),
    (text: 'cambiado de trabajo de un día para otro', tone: ContentTone.soft),
    (
      text: 'hecho una entrevista para un puesto que no quería',
      tone: ContentTone.soft,
    ),
    (
      text: 'comido comida rápida dos veces el mismo día',
      tone: ContentTone.soft,
    ),
    (text: 'desayunado helado', tone: ContentTone.soft),
    (text: 'hecho horas de cola por algo', tone: ContentTone.soft),
    (text: 'olvidado una cita importante', tone: ContentTone.soft),
    (text: 'discutido por el mando de la tele', tone: ContentTone.soft),
    (
      text: 'visto la misma película más de cinco veces',
      tone: ContentTone.soft,
    ),
    (
      text: 'aprendido de memoria una escena de una película',
      tone: ContentTone.soft,
    ),
    (text: 'perdido una apuesta absurda', tone: ContentTone.soft),
    (text: 'ganado a las cartas haciendo trampas', tone: ContentTone.soft),
    (text: 'roto la pantalla del móvil', tone: ContentTone.soft),
    (text: 'dejado el móvil olvidado en un bar', tone: ContentTone.soft),
    (
      text: 'chocado contra una puerta de cristal limpísima',
      tone: ContentTone.soft,
    ),
    (
      text:
          'saludado a alguien que en realidad saludaba a la persona de detrás',
      tone: ContentTone.soft,
    ),
    (text: 'tirado de una puerta que ponía "empujar"', tone: ContentTone.soft),
    (
      text: 'buscado el móvil en pánico mientras lo tenía en la mano',
      tone: ContentTone.soft,
    ),
    (
      text: 'llamado "mamá" a un profesor delante de todos',
      tone: ContentTone.soft,
    ),
    (
      text: 'mandado un audio de cinco minutos para algo de diez segundos',
      tone: ContentTone.soft,
    ),
    (
      text: 'escuchado mi voz en un audio y sentido vergüenza',
      tone: ContentTone.soft,
    ),
    (
      text: 'fingido hablar por teléfono para no hablar con alguien',
      tone: ContentTone.soft,
    ),
    (text: 'aplaudido al aterrizar el avión', tone: ContentTone.soft),
    (text: 'reído en el peor momento posible', tone: ContentTone.soft),
    (
      text: 'tropezado en público y seguido andando como si nada',
      tone: ContentTone.soft,
    ),
    (
      text: 'puesto diez alarmas y las he ignorado todas',
      tone: ContentTone.soft,
    ),
    (
      text:
          'buscado mis síntomas en internet convencido de tener algo rarísimo',
      tone: ContentTone.soft,
    ),
    (text: 'llorado con un anuncio', tone: ContentTone.soft),
    (
      text: 'respondido "igualmente" al camarero que me deseaba buen provecho',
      tone: ContentTone.soft,
    ),
    (
      text: 'dormido en una videollamada con la cámara encendida',
      tone: ContentTone.soft,
    ),
    (
      text: 'llevado la misma camiseta una semana seguida',
      tone: ContentTone.soft,
    ),
    (
      text: 'olido una camiseta para decidir si aguantaba otro día',
      tone: ContentTone.soft,
    ),
    (
      text: 'comido de pie directamente de la olla en la cocina',
      tone: ContentTone.soft,
    ),
    (
      text: 'dicho "el último capítulo y a dormir" y visto amanecer',
      tone: ContentTone.soft,
    ),
    (
      text: 'olvidado por qué había entrado en una habitación',
      tone: ContentTone.soft,
    ),
    (
      text: 'reído solo recordando un ridículo de hace años',
      tone: ContentTone.soft,
    ),
    (
      text: 'comido crema de cacao a cucharadas directamente del bote',
      tone: ContentTone.soft,
    ),
    (text: 'llorado de hambre', tone: ContentTone.soft),
    (
      text: 'pedido una pizza entera solo para mí y terminarla',
      tone: ContentTone.soft,
    ),
    (text: 'discutido a gritos con el GPS', tone: ContentTone.soft),
    (
      text: 'releído veinte veces un mensaje antes de enviarlo',
      tone: ContentTone.soft,
    ),
    (
      text: 'pedido "solo las puntas" y salido irreconocible de la peluquería',
      tone: ContentTone.soft,
    ),
    (text: 'perdido horas viendo vídeos de animales', tone: ContentTone.soft),
    (
      text: 'convencido a alguien de algo inventado por broma',
      tone: ContentTone.soft,
    ),
    (text: 'fingido trabajar cuando llegaba el jefe', tone: ContentTone.soft),
    (
      text: 'mandado "ok" solo para cerrar una discusión',
      tone: ContentTone.soft,
    ),
    (text: 'puesto el pijama a las seis de la tarde', tone: ContentTone.soft),
    (text: 'saltado el gimnasio para irme a comer', tone: ContentTone.soft),
    (
      text: 'aplazado la dieta "al lunes" durante meses',
      tone: ContentTone.soft,
    ),
    (text: 'usado la bicicleta estática de perchero', tone: ContentTone.soft),
    (
      text: 'dicho "nos vemos pronto" esperando no volver a ver a esa persona',
      tone: ContentTone.soft,
    ),
    (text: 'hablado con las plantas de casa', tone: ContentTone.soft),
    (
      text: 'culpado al perro de algo que había hecho yo',
      tone: ContentTone.soft,
    ),
    (
      text: 'terminado las palomitas antes de que empezara la película',
      tone: ContentTone.soft,
    ),
    (text: 'escondido los dulces para no compartirlos', tone: ContentTone.soft),
    (
      text: 'abierto la nevera diez veces esperando encontrar comida nueva',
      tone: ContentTone.soft,
    ),
    (
      text: 'usado la excusa "mañana madrugo" para irme de una fiesta',
      tone: ContentTone.soft,
    ),
    (
      text: 'envuelto un regalo cinco minutos antes de entregarlo',
      tone: ContentTone.soft,
    ),
    (
      text: 'pedido comida a domicilio tras olvidar descongelar la cena',
      tone: ContentTone.soft,
    ),
    (
      text: 'leído solo el titular y opinado como un experto',
      tone: ContentTone.soft,
    ),
    (
      text: 'animado a un equipo solo porque iba ganando',
      tone: ContentTone.soft,
    ),
    (
      text: 'acabado empapado por no mirar la previsión del tiempo',
      tone: ContentTone.soft,
    ),
    (text: 'empezado diez libros sin terminar ninguno', tone: ContentTone.soft),
    (text: 'dado like a una publicación sin leerla', tone: ContentTone.soft),
    (text: 'hecho cien fotos iguales para elegir una', tone: ContentTone.soft),
    (
      text: 'pedido consejo sobre una foto y luego ignorado la respuesta',
      tone: ContentTone.soft,
    ),
    (
      text: 'usado un filtro en todas las fotos que he publicado',
      tone: ContentTone.soft,
    ),
    (text: 'visto mis propias historias más que nadie', tone: ContentTone.soft),
    (
      text: 'bailado en mi cuarto como si estuviera en un concierto',
      tone: ContentTone.soft,
    ),
    (
      text: 'ensayado un discurso importante delante del espejo',
      tone: ContentTone.soft,
    ),
    (
      text: 'ganado una discusión imaginaria en la ducha',
      tone: ContentTone.soft,
    ),
    (text: 'puesto diez apodos distintos a mi mascota', tone: ContentTone.soft),
    (
      text: 'comido el último trozo sin preguntar a nadie',
      tone: ContentTone.soft,
    ),
    (
      text: 'bebido directamente del cartón delante de la nevera',
      tone: ContentTone.soft,
    ),
    (
      text: 'llevado calcetines desparejados esperando que nadie lo notara',
      tone: ContentTone.soft,
    ),
    (text: 'dormido con un peluche siendo adulto', tone: ContentTone.soft),
    (
      text: 'mirado detrás de las cortinas después de una peli de miedo',
      tone: ContentTone.soft,
    ),
    (
      text: 'subido las escaleras corriendo tras apagar la luz',
      tone: ContentTone.soft,
    ),
    (
      text: 'celebrado un aparcamiento perfecto a la primera',
      tone: ContentTone.soft,
    ),
    (
      text: 'declarado la guerra a un mosquito a las tres de la mañana',
      tone: ContentTone.soft,
    ),
    (
      text: 'puesto el aire acondicionado para dormir bajo el edredón',
      tone: ContentTone.soft,
    ),
    (
      text: 'escrito una lista de tareas y no hecho ni una',
      tone: ContentTone.soft,
    ),
    (text: 'fingido haber leído un libro famoso', tone: ContentTone.soft),
    (
      text: 'perdido el hilo de lo que estaba contando yo mismo',
      tone: ContentTone.soft,
    ),
    // ------------------------------------------------------ piccante
    (text: 'besado a alguien la primera noche', tone: ContentTone.piccante),
    (
      text: 'estado colado por alguien de esta sala',
      tone: ContentTone.piccante,
    ),
    (
      text: 'estado colado por la pareja de un amigo',
      tone: ContentTone.piccante,
    ),
    (text: 'escrito a un ex de madrugada', tone: ContentTone.piccante),
    (
      text: 'contestado a un ex después de meses de silencio',
      tone: ContentTone.piccante,
    ),
    (
      text: 'fingido dormir para evitar un momento de intimidad',
      tone: ContentTone.piccante,
    ),
    (
      text: 'mentido a alguien con quien estaba saliendo',
      tone: ContentTone.piccante,
    ),
    (text: 'mirado el móvil de mi pareja', tone: ContentTone.piccante),
    (text: 'tenido dos citas el mismo día', tone: ContentTone.piccante),
    (text: 'besado a dos personas la misma noche', tone: ContentTone.piccante),
    (
      text: 'dicho "te quiero" sin sentirlo de verdad',
      tone: ContentTone.piccante,
    ),
    (text: 'cortado una relación por mensaje', tone: ContentTone.piccante),
    (text: 'vuelto con un ex', tone: ContentTone.piccante),
    (text: 'mantenido una relación en secreto', tone: ContentTone.piccante),
    (text: 'flirteado para conseguir algo', tone: ContentTone.piccante),
    (text: 'usado una app de citas', tone: ContentTone.piccante),
    (
      text: 'usado una foto de perfil de hace diez años',
      tone: ContentTone.piccante,
    ),
    (
      text: 'quedado en persona con alguien conocido por internet',
      tone: ContentTone.piccante,
    ),
    (
      text: 'dedicado una canción a alguien presente en esta sala',
      tone: ContentTone.piccante,
    ),
    (
      text: 'dormido en casa de alguien recién conocido',
      tone: ContentTone.piccante,
    ),
    (
      text: 'perdido la cuenta de lo que había bebido',
      tone: ContentTone.piccante,
    ),
    (
      text: 'hecho algo vergonzoso estando borracho',
      tone: ContentTone.piccante,
    ),
    (
      text: 'arrepentido por la mañana de los mensajes de la noche anterior',
      tone: ContentTone.piccante,
    ),
    (text: 'olvidado trozos de una noche entera', tone: ContentTone.piccante),
    (
      text: 'cantado por la calle a las cuatro de la mañana',
      tone: ContentTone.piccante,
    ),
    (text: 'bañado sin bañador', tone: ContentTone.piccante),
    (
      text: 'paseado por casa sin ropa con visitas dentro',
      tone: ContentTone.piccante,
    ),
    (text: 'olvidado cerrar la puerta del baño', tone: ContentTone.piccante),
    (
      text: 'soltado una mentira enorme en una primera cita',
      tone: ContentTone.piccante,
    ),
    (text: 'fingido estar soltero', tone: ContentTone.piccante),
    (
      text: 'espiado el perfil de la nueva pareja de mi ex',
      tone: ContentTone.piccante,
    ),
    (text: 'discutido en público con una pareja', tone: ContentTone.piccante),
    (
      text: 'hecho las paces con un beso sin aclarar nada',
      tone: ContentTone.piccante,
    ),
    (text: 'besado a alguien por una apuesta', tone: ContentTone.piccante),
    (
      text: 'arrepentido de una respuesta dada en verdad o reto',
      tone: ContentTone.piccante,
    ),
    (
      text: 'oído a los vecinos haciéndolo a través de la pared',
      tone: ContentTone.piccante,
    ),
    (text: 'tenido un flirteo en el trabajo', tone: ContentTone.piccante),
    (text: 'escrito al jefe cosas que no debería', tone: ContentTone.piccante),
    (text: 'dejado plantada una cita sin avisar', tone: ContentTone.piccante),
    (
      text:
          'dicho "¿subes a tomar algo?" sabiendo perfectamente lo que quería decir',
      tone: ContentTone.piccante,
    ),
    (text: 'besado a alguien en el baño de un bar', tone: ContentTone.piccante),
    (
      text: 'pasado una película entera en el cine sin ver ni una escena',
      tone: ContentTone.piccante,
    ),
    (
      text: 'guardado una foto vergonzosa de un amigo',
      tone: ContentTone.piccante,
    ),
    (
      text: 'llegado tres años atrás cotilleando el perfil de alguien',
      tone: ContentTone.piccante,
    ),
    (
      text: 'respondido a una historia solo para hacerme notar',
      tone: ContentTone.piccante,
    ),
    (
      text: 'mentido sobre dónde estaba pasando la noche',
      tone: ContentTone.piccante,
    ),
    (
      text: 'dicho que estaba en casa estando fuera',
      tone: ContentTone.piccante,
    ),
    (text: 'escondido una relación a mi familia', tone: ContentTone.piccante),
    (
      text: 'besado a alguien cuyo nombre no recordaba',
      tone: ContentTone.piccante,
    ),
    (
      text: 'pedido a un amigo que me llamara para escapar de una cita',
      tone: ContentTone.piccante,
    ),
    (
      text: 'salido de un bar a escondidas para no despedirme',
      tone: ContentTone.piccante,
    ),
    (
      text: 'terminado la noche en un sitio que no recuerdo',
      tone: ContentTone.piccante,
    ),
    (
      text: 'dado mi número a alguien recién conocido en un bar',
      tone: ContentTone.piccante,
    ),
    (text: 'mentido durante esta partida', tone: ContentTone.piccante),
    (
      text: 'hecho ghosting a alguien sin explicaciones',
      tone: ContentTone.piccante,
    ),
    (text: 'releído un chat antiguo por nostalgia', tone: ContentTone.piccante),
    (
      text: 'dado like a una foto de hace tres años en pleno cotilleo nocturno',
      tone: ContentTone.piccante,
    ),
    (
      text: 'inventado una pareja imaginaria para quitarme a alguien de encima',
      tone: ContentTone.piccante,
    ),
    (
      text: 'ensayado frases para ligar delante del espejo',
      tone: ContentTone.piccante,
    ),
    (text: 'besado al ex de un amigo', tone: ContentTone.piccante),
    (
      text: 'pedido a un amigo que investigara si le gustaba a alguien',
      tone: ContentTone.piccante,
    ),
    (
      text: 'vomitado en un sitio absurdo durante una fiesta',
      tone: ContentTone.piccante,
    ),
    (text: 'tenido un rollo de una noche', tone: ContentTone.piccante),
    (
      text: 'hecho el paseo de la vergüenza con la ropa de la noche anterior',
      tone: ContentTone.piccante,
    ),
    (
      text: 'mandado una foto que jamás enviaría a mis padres',
      tone: ContentTone.piccante,
    ),
    (
      text: 'tenido un sueño subido de tono con alguien de esta sala',
      tone: ContentTone.piccante,
    ),
    (
      text: 'flirteado con el personal para que me invitaran a algo',
      tone: ContentTone.piccante,
    ),
    (
      text: 'pasado la noche fuera mintiendo sobre dónde estaba',
      tone: ContentTone.piccante,
    ),
    (
      text: 'guardado un contacto con nombre falso para que no me pillaran',
      tone: ContentTone.piccante,
    ),
    (
      text: 'besado a alguien solo porque era medianoche en Nochevieja',
      tone: ContentTone.piccante,
    ),
    (text: 'hecho sexting hasta altas horas', tone: ContentTone.piccante),
    (
      text: 'empezado yo una conversación que acabó en sexting',
      tone: ContentTone.piccante,
    ),
    (
      text: 'besado a alguien mucho mayor o mucho más joven que yo',
      tone: ContentTone.piccante,
    ),
    (
      text: 'tenido una fantasía con un compañero de trabajo',
      tone: ContentTone.piccante,
    ),
    (text: 'dado un masaje que acabó en otra cosa', tone: ContentTone.piccante),
    (
      text: 'besado a alguien antes de una hora de conocerlo',
      tone: ContentTone.piccante,
    ),
    (
      text: 'comprado ropa interior pensando en quién la iba a ver',
      tone: ContentTone.piccante,
    ),
    (
      text: 'flirteado en el gimnasio en vez de entrenar',
      tone: ContentTone.piccante,
    ),
    (
      text: 'tenido un romance de verano que terminó con las vacaciones',
      tone: ContentTone.piccante,
    ),
    (text: 'besado a alguien en un ascensor', tone: ContentTone.piccante),
    (text: 'compartido ducha con otra persona', tone: ContentTone.piccante),
    (
      text: 'compartido cama con un amigo preguntándome si pasaría algo',
      tone: ContentTone.piccante,
    ),
    (
      text: 'besado a alguien durante un juego como este',
      tone: ContentTone.piccante,
    ),
    (
      text: 'mandado mi ubicación a un amigo antes de una cita a ciegas',
      tone: ContentTone.piccante,
    ),
    (
      text: 'intentado ligar con una frase sacada de internet',
      tone: ContentTone.piccante,
    ),
    (
      text: 'hecho un cumplido atrevido a un desconocido',
      tone: ContentTone.piccante,
    ),
    (
      text: 'recibido unas calabazas delante de todos',
      tone: ContentTone.piccante,
    ),
    (text: 'tenido sexo en la primera cita', tone: ContentTone.piccante),
    (text: 'fingido un orgasmo', tone: ContentTone.piccante),
    (
      text:
          'hecho sexting con alguien conocido hacía menos de veinticuatro horas',
      tone: ContentTone.piccante,
    ),
    (text: 'pedido yo primero una foto atrevida', tone: ContentTone.piccante),
    (
      text:
          'recibido una foto subida de tono sin pedirla y respondido con un cumplido',
      tone: ContentTone.piccante,
    ),
    (
      text: 'empañado los cristales de un coche, y no por el frío',
      tone: ContentTone.piccante,
    ),
    (
      text: 'tenido sexo en casa de desconocidos durante una fiesta',
      tone: ContentTone.piccante,
    ),
    (
      text: 'pasado la noche con alguien y descubierto que no sabía su nombre',
      tone: ContentTone.piccante,
    ),
    (
      text:
          'cruzado a un conocido en pleno paseo de la vergüenza y saludado como si nada',
      tone: ContentTone.piccante,
    ),
    (
      text: 'besado a alguien solo porque la noche lo pedía',
      tone: ContentTone.piccante,
    ),
    (
      text: 'besado a alguien en los primeros diez minutos de la primera cita',
      tone: ContentTone.piccante,
    ),
    (text: 'besado a una persona de mi mismo sexo', tone: ContentTone.piccante),
    (
      text: 'deseado a alguien presente en esta sala',
      tone: ContentTone.piccante,
    ),
    (text: 'tenido un sueño erótico con un amigo', tone: ContentTone.piccante),
    (
      text: 'imaginado un futuro entero con alguien recién conocido',
      tone: ContentTone.piccante,
    ),
    (
      text: 'tenido una relación solo física durante más de seis meses',
      tone: ContentTone.piccante,
    ),
    (
      text: 'dicho "te quiero" solo para salvar la noche',
      tone: ContentTone.piccante,
    ),
    (
      text: 'hecho las paces en la cama tras una pelea empezada a propósito',
      tone: ContentTone.piccante,
    ),
    (
      text: 'flirteado con dos personas a la vez la misma noche',
      tone: ContentTone.piccante,
    ),
    (
      text: 'dado un número falso a alguien que intentaba ligar conmigo',
      tone: ContentTone.piccante,
    ),
    (text: 'ligado en el gimnasio', tone: ContentTone.piccante),
    (text: 'ligado en una boda', tone: ContentTone.piccante),
    (text: 'ligado en el supermercado', tone: ContentTone.piccante),
    (
      text: 'besado a mi mejor amigo o a mi mejor amiga',
      tone: ContentTone.piccante,
    ),
    (
      text: 'sentido atracción por la pareja de un amigo',
      tone: ContentTone.piccante,
    ),
    (
      text: 'tenido sexo con un compañero de trabajo',
      tone: ContentTone.piccante,
    ),
    (
      text: 'tenido una historia con alguien mucho mayor que yo',
      tone: ContentTone.piccante,
    ),
    (text: 'mentido sobre mi body count', tone: ContentTone.piccante),
    (
      text: 'olvidado el nombre de alguien estando en la cama',
      tone: ContentTone.piccante,
    ),
    (
      text: 'tenido sexo con los calcetines puestos',
      tone: ContentTone.piccante,
    ),
    (
      text: 'reído en pleno momento íntimo estropeándolo todo',
      tone: ContentTone.piccante,
    ),
    (
      text: 'mandado un mensaje subido de tono a la persona equivocada',
      tone: ContentTone.piccante,
    ),
    (
      text: 'releído mi propio sexting y sentido orgullo',
      tone: ContentTone.piccante,
    ),
    (
      text: 'creado una playlist especial para las noches acompañado',
      tone: ContentTone.piccante,
    ),
    (
      text: 'mirado el móvil mientras la otra persona dormía a mi lado',
      tone: ContentTone.piccante,
    ),
    (
      text: 'buscado en internet cómo mejorar en la cama',
      tone: ContentTone.piccante,
    ),
    (
      text: 'pedido a un amigo una opinión sincera sobre mis dotes',
      tone: ContentTone.piccante,
    ),
    (
      text: 'visto una película para adultos en compañía',
      tone: ContentTone.piccante,
    ),
    (
      text: 'comprado lencería para una noche concreta',
      tone: ContentTone.piccante,
    ),
    (text: 'tenido sexo en la ducha', tone: ContentTone.piccante),
    (
      text: 'tenido sexo en el sofá de otra persona',
      tone: ContentTone.piccante,
    ),
    (
      text: 'hecho ruido a propósito para que nos oyeran',
      tone: ContentTone.piccante,
    ),
    (
      text: 'tenido que esconderme a toda prisa cuando llegaba alguien',
      tone: ContentTone.piccante,
    ),
    (
      text: 'vestido a toda prisa y salido con la camiseta equivocada',
      tone: ContentTone.piccante,
    ),
    (
      text: 'dejado marcas visibles en el cuello de alguien',
      tone: ContentTone.piccante,
    ),
    (
      text: 'tapado una marca en el cuello con maquillaje o una bufanda',
      tone: ContentTone.piccante,
    ),
    (
      text: 'dicho a una pareja que era la mejor, mintiendo',
      tone: ContentTone.piccante,
    ),
    (
      text:
          'puesto nota a una noche contándosela a los amigos al día siguiente',
      tone: ContentTone.piccante,
    ),
    (
      text: 'hecho rankings de mis ex con los amigos',
      tone: ContentTone.piccante,
    ),
    (
      text: 'reencontrado a un rollo de una noche en el trabajo',
      tone: ContentTone.piccante,
    ),
    (
      text: 'usado una app de citas sentado al lado de mis padres',
      tone: ContentTone.piccante,
    ),
    (
      text: 'tenido un match al que no escribí jamás por miedo',
      tone: ContentTone.piccante,
    ),
    (text: 'dado el primer paso y llevado un no', tone: ContentTone.piccante),
    (
      text: 'besado a alguien bajo la lluvia sintiéndome en una película',
      tone: ContentTone.piccante,
    ),
    (
      text: 'organizado un encuentro "casual" con mi crush',
      tone: ContentTone.piccante,
    ),
    (
      text: 'ofrecido un masaje con segundas intenciones evidentes',
      tone: ContentTone.piccante,
    ),
    (
      text: 'aceptado un masaje sabiendo perfectamente cómo iba a acabar',
      tone: ContentTone.piccante,
    ),
    (
      text: 'desayunado en la cama con alguien conocido la noche anterior',
      tone: ContentTone.piccante,
    ),
    (
      text:
          'guardado un cepillo de dientes de reserva para invitados de una noche',
      tone: ContentTone.piccante,
    ),
    (
      text: 'coqueteado por mensajes durante una cena familiar entera',
      tone: ContentTone.piccante,
    ),
    (
      text: 'guardado el chat de un ex solo para releerlo de vez en cuando',
      tone: ContentTone.piccante,
    ),
    (
      text: 'escrito y borrado el mismo mensaje diez veces esta semana',
      tone: ContentTone.piccante,
    ),
    (
      text: 'dejado mi número apuntado en una servilleta o en un tique',
      tone: ContentTone.piccante,
    ),
    // ------------------------------------------------------- cattivo
    (
      text: 'hablado mal de una persona presente en esta sala',
      tone: ContentTone.cattivo,
    ),
    (text: 'revelado el secreto de un amigo', tone: ContentTone.cattivo),
    (
      text: 'compartido la captura de un chat privado',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'creado un perfil falso para espiar a alguien',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'alegrado en secreto del fracaso de alguien que me cae mal',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'fingido alegrarme por un amigo mientras me moría de envidia',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'pensado que la pareja de un amigo no se lo merecía en absoluto',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'deseado que la relación de una pareja de amigos se acabara',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          'dicho "no se lo cuento a nadie" y soltado todo en menos de una hora',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'creado un grupo sin una persona solo para hablar de ella',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'flirteado con alguien solo para dar celos a otra persona',
      tone: ContentTone.cattivo,
    ),
    (text: 'dado un mal consejo a propósito', tone: ContentTone.cattivo),
    (text: 'estropeado una sorpresa a propósito', tone: ContentTone.cattivo),
    (
      text: 'fingido olvidar la cartera para no pagar',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'contado un cotilleo añadiendo detalles inventados',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'usado las lágrimas para conseguir lo que quería',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'leído un chat en el móvil de un amigo mientras estaba en el baño',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'fingido escuchar los problemas de un amigo pensando en mis cosas',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'negado hasta la muerte algo que sí había hecho',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          'criticado a alguien y negado todo cuando me lo preguntaron a la cara',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'usado un secreto de alguien para ganar una discusión',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          'dividido la cuenta a partes iguales sabiendo que había pedido el triple',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'invitado a una persona solo porque tenía coche',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'callado a un amigo que su pareja flirteaba con otros',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'borrado un mensaje del móvil de otra persona',
      tone: ContentTone.cattivo,
    ),
    (text: 'tenido sexo en un lugar público', tone: ContentTone.cattivo),
    (
      text: 'tenido un amigo con derecho a roce en secreto',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'vuelto a ver a un ex solo por una noche jurando que era la última',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'olvidado el nombre de alguien con quien había pasado la noche',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'pensado en otra persona mientras besaba a mi pareja',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'mentido sobre el número de mis conquistas',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenido sexo en una fiesta con la casa llena de gente',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'usado mi encanto para que me perdonaran algo grave',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'pasado la noche con alguien conocido esa misma tarde en una app',
      tone: ContentTone.cattivo,
    ),
    (text: 'deseado seriamente probar un trío', tone: ContentTone.cattivo),
    (text: 'sido infiel a una pareja', tone: ContentTone.cattivo),
    (text: 'besado a otra persona teniendo pareja', tone: ContentTone.cattivo),
    (text: 'mandado una foto mía sin ropa', tone: ContentTone.cattivo),
    (
      text: 'enseñado a un amigo una foto íntima recibida en privado',
      tone: ContentTone.cattivo,
    ),
    (text: 'pasado la noche con el ex de un amigo', tone: ContentTone.cattivo),
    (text: 'tenido sexo en un coche', tone: ContentTone.cattivo),
    (
      text: 'tenido sexo en casa de los padres de mi pareja',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenido sexo con dos personas distintas en la misma semana',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenido una historia con una persona comprometida',
      tone: ContentTone.cattivo,
    ),
    (text: 'fingido placer en la cama', tone: ContentTone.cattivo),
    (
      text: 'puesto nota a mis ex hablando con los amigos',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'usado el sexo para que me perdonaran después de una pelea',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          'escrito a alguien a las tres de la mañana con un solo objetivo en mente',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenido una noche de pasión con alguien de este grupo',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'imaginado cómo sería en la cama una persona presente en esta sala',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'comparado en la cama a una pareja con un ex',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'mantenido un chat secreto con un ex teniendo pareja',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'aceptado un "ven a ver una peli" sabiendo cómo iba a acabar',
      tone: ContentTone.cattivo,
    ),
    (text: 'flirteado con la pareja de un amigo', tone: ContentTone.cattivo),
    (
      text: 'mandado un mensaje muy subido de tono cenando con más gente',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'hecho sexting con mi pareja en la habitación de al lado',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenido un plan B preparado estando en una relación',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'besado a alguien solo por venganza contra un ex',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenido sexo con una persona que me caía fatal',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'ilusionado a alguien solo para llevármelo a la cama',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'hecho ghosting a alguien después de pasar la noche juntos',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'guardado las fotos íntimas de un ex tras la ruptura',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'contado por ahí los detalles íntimos de un ex',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'fingido sentimientos solo para no quedarme solo',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'intentado ligarme a la persona que le gustaba a un amigo',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'desaparecido justo después de conseguir lo que quería',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'dicho "te quiero" en la cama solo por el momento',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenido sexo sabiendo que desde la habitación de al lado nos oían',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'contestado a un ex estando en la cama con otra persona',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenido sexo con alguien presente en esta sala',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          'tenido sexo con más de una persona en las mismas veinticuatro horas',
      tone: ContentTone.cattivo,
    ),
    (text: 'hecho un trío', tone: ContentTone.cattivo),
    (
      text: 'recibido una propuesta de trío y aceptado',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenido sexo con una persona comprometida sabiéndolo',
      tone: ContentTone.cattivo,
    ),
    (text: 'sido infiel sin confesarlo jamás', tone: ContentTone.cattivo),
    (
      text: 'descubierto una infidelidad y hecho como si nada',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenido sexo con el ex de mi mejor amigo',
      tone: ContentTone.cattivo,
    ),
    (text: 'usado juguetes, solo o en compañía', tone: ContentTone.cattivo),
    (
      text:
          'comprado un juguete online mirando el seguimiento del paquete cada hora',
      tone: ContentTone.cattivo,
    ),
    (text: 'grabado un vídeo mientras tenía sexo', tone: ContentTone.cattivo),
    (text: 'vuelto a ver ese vídeo', tone: ContentTone.cattivo),
    (
      text: 'guardado fotos subidas de tono en el móvil sin contraseña',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'mandado la misma foto atrevida a varias personas',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'fingido un orgasmo más de una vez con la misma persona',
      tone: ContentTone.cattivo,
    ),
    (text: 'dicho el nombre equivocado en la cama', tone: ContentTone.cattivo),
    (
      text: 'oído el nombre equivocado y hecho como si no pasara nada',
      tone: ContentTone.cattivo,
    ),
    (text: 'tenido sexo en un baño público', tone: ContentTone.cattivo),
    (
      text: 'tenido sexo al aire libre arriesgándome a que me vieran',
      tone: ContentTone.cattivo,
    ),
    (text: 'sido pillado en pleno acto por alguien', tone: ContentTone.cattivo),
    (text: 'pillado yo a alguien en pleno acto', tone: ContentTone.cattivo),
    (
      text: 'tenido sexo mientras otros dormían en la misma habitación',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenido sexo en casa de mis padres con mis padres en casa',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenido sexo en casa de sus padres con sus padres en casa',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'faltado al trabajo para quedarme en la cama acompañado',
      tone: ContentTone.cattivo,
    ),
    (text: 'tenido sexo en horario de trabajo', tone: ContentTone.cattivo),
    (
      text: 'usado la oficina de un modo nada profesional',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenido una debilidad seria por un superior',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenido sexo con un amigo y no vuelto a hablar del tema jamás',
      tone: ContentTone.cattivo,
    ),
    (text: 'arruinado una amistad por una noche', tone: ContentTone.cattivo),
    (
      text: 'tenido dos historias paralelas sin que se supieran',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'quedado con los dos la misma noche sin que me descubrieran',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'usado la casa de un amigo para un encuentro secreto',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'colado a alguien en casa de noche y sacado al alba',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          'escondido a una persona en el armario o en el balcón, literalmente',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'borrado mensajes para que no los encontraran',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'guardado a una persona en la agenda con un nombre en clave',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'pensado en alguien de esta sala estando con otra persona',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'empezado algo en un bar y terminado en el aparcamiento',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenido sexo sin saber el apellido de la otra persona',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          'cruzado la línea con un amigo con derecho y fingido que nada había cambiado',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'mantenido un amigo con derecho en secreto más de un año',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          'mandado "¿estás despierto?" a las tres de la mañana y conseguido respuesta',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          'respondido a un "¿estás despierto?" a las tres de la mañana y salido de casa',
      tone: ContentTone.cattivo,
    ),
    (text: 'tenido sexo con alguien que detestaba', tone: ContentTone.cattivo),
    (
      text: 'usado el sexo para que me perdonaran algo',
      tone: ContentTone.cattivo,
    ),
    (text: 'usado el sexo para conseguir algo', tone: ContentTone.cattivo),
    (
      text: 'dicho que no al empezar la noche y cambiado de idea a mitad',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'dicho "no volverá a pasar" cuando ya había pasado tres veces',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'contado mi body count y tenido que empezar de nuevo',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'dicho a mi pareja un body count más bajo que el real',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenido una lista escrita de las personas con las que he estado',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          'puesto un nombre en clave a una aventura para hablar de ella tranquilamente',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'contado los detalles de una noche a un grupo entero',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          'reconocido en una app de citas a una persona comprometida que conozco',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'encontrado un perfil que no debía existir y hecho una captura',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'usado un perfil falso para controlar a alguien',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'mirado el móvil de mi pareja mientras dormía',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'encontrado algo que habría preferido no encontrar',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'hecho como si nada después de encontrarlo todo',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'probado un fetiche y descubierto que me gustaba',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'confesado un fetiche y visto cambiar la cara de la otra persona',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'atado a alguien o dejado que me ataran por juego',
      tone: ContentTone.cattivo,
    ),
    (text: 'usado hielo o comida en la cama', tone: ContentTone.cattivo),
    (
      text: 'vendado los ojos a alguien o dejado que me los vendaran',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'puesto la música alta para tapar los ruidos',
      tone: ContentTone.cattivo,
    ),
    (text: 'recibido quejas de los vecinos', tone: ContentTone.cattivo),
    (text: 'roto algo en casa durante el sexo', tone: ContentTone.cattivo),
    (
      text: 'explicado un moratón o un arañazo con una excusa inventada',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'usado la mesa de la cocina para algo que no era una cena',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenido sexo en un ascensor o en unas escaleras',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          'tenido sexo en la playa y encontrado arena por todas partes durante días',
      tone: ContentTone.cattivo,
    ),
    (text: 'tenido sexo en la piscina o en el mar', tone: ContentTone.cattivo),
    (
      text: 'tenido sexo en una tienda de campaña con el camping lleno',
      tone: ContentTone.cattivo,
    ),
    (text: 'tenido sexo en un tren o en un avión', tone: ContentTone.cattivo),
    (
      text: 'pagado una habitación solo por unas horas',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'usado la pausa de la comida de un modo muy creativo',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenido un despertar del que no hablaré jamás en detalle',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'hecho algo en la cama que este grupo no se creería de mí',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'salido por la ventana para que no me vieran salir por la puerta',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          'jurado "solo subo a por un café" sabiendo perfectamente cómo acabaría',
      tone: ContentTone.cattivo,
    ),
    (text: 'tragado el esperma de mi pareja', tone: ContentTone.cattivo),
    (text: 'lamido el ano a alguien', tone: ContentTone.cattivo),
    (text: 'tenido sexo anal sin protección', tone: ContentTone.cattivo),
    (
      text: 'usado un vibrador o dildo durante una relación',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'grabado un vídeo mientras tenía sexo y luego lo he guardado',
      tone: ContentTone.cattivo,
    ),
    (text: 'venido en la cara de alguien', tone: ContentTone.cattivo),
    (
      text: 'tenido sexo con una persona de la que no sabía el nombre',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenido relaciones en un lugar público muy concurrido',
      tone: ContentTone.cattivo,
    ),
    (text: 'probado mi propio esperma o eyaculación', tone: ContentTone.cattivo),
    (
      text: 'tenido sexo con dos personas distintas en la misma noche',
      tone: ContentTone.cattivo,
    ),
    (text: 'recibido o hecho bondage pesado', tone: ContentTone.cattivo),
    (text: 'tenido sexo oral en un lugar público', tone: ContentTone.cattivo),
    (
      text: 'usado objetos domésticos como juguetes sexuales',
      tone: ContentTone.cattivo,
    ),
    (text: 'recibido sexo oral mientras conducía', tone: ContentTone.cattivo),
    (text: 'tenido sexo durante la regla', tone: ContentTone.cattivo),
    (
      text: 'tenido un orgasmo múltiple en la misma relación',
      tone: ContentTone.cattivo,
    ),
    (
      text: 'tenido sexo con alguien conocido hace menos de una hora',
      tone: ContentTone.cattivo,
    ),
    (text: 'pagado o recibido dinero por sexo', tone: ContentTone.cattivo),
  ];

  /// Domande sul gruppo (150 soft, 150 piccante, 150 cattivo).
  static const List<({String text, String tone})>
  chiLoPotrebbeFare = <({String text, String tone})>[
    // ---------------------------------------------------------- soft
    (
      text: '¿Quién se perdería en una ciudad que conoce de sobra?',
      tone: ContentTone.soft,
    ),
    (text: '¿Quién llegaría tarde a su propia boda?', tone: ContentTone.soft),
    (text: '¿Quién se haría famoso por accidente?', tone: ContentTone.soft),
    (
      text: '¿Quién sobreviviría más tiempo en una isla desierta?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién pasaría un fin de semana entero sin salir de casa?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién daría conversación a un desconocido en un ascensor?',
      tone: ContentTone.soft,
    ),
    (text: '¿Quién olvidaría su propio aniversario?', tone: ContentTone.soft),
    (text: '¿Quién discutiría con el GPS?', tone: ContentTone.soft),
    (
      text: '¿Quién compraría algo por internet a las tres de la mañana?',
      tone: ContentTone.soft,
    ),
    (text: '¿Quién comería pizza siete días seguidos?', tone: ContentTone.soft),
    (text: '¿Quién se dormiría en el cine?', tone: ContentTone.soft),
    (
      text: '¿Quién cantaría en un karaoke sin dudarlo?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién sería el primero en la pista de baile?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién organizaría el viaje de todo el grupo?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién perdería el pasaporte en el aeropuerto?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién llevaría tres maletas para dos días?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién se iría mañana de viaje solo con una mochila?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién se mudaría al extranjero sin pensarlo?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién volvería a vivir con sus padres sin problema?',
      tone: ContentTone.soft,
    ),
    (text: '¿Quién adoptaría diez gatos?', tone: ContentTone.soft),
    (
      text: '¿Quién hablaría a su perro como a una persona?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién dejaría morir todas las plantas de casa?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién cocinaría para veinte personas sin motivo?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién sería capaz de quemar hasta el agua de la pasta?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién probaría cualquier comida, hasta la más rara?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién olvidaría la cartera justo cuando le toca pagar?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién se gastaría el sueldo en una semana?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién se haría rico con una idea absurda?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién ganaría la lotería y no se lo diría a nadie?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién regatearía hasta en el supermercado?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién compraría una máquina de gimnasio y no la usaría jamás?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién se apuntaría al gimnasio en enero y lo dejaría en febrero?',
      tone: ContentTone.soft,
    ),
    (text: '¿Quién correría una maratón sin entrenar?', tone: ContentTone.soft),
    (
      text: '¿Quién se haría daño haciendo algo facilísimo?',
      tone: ContentTone.soft,
    ),
    (text: '¿Quién iría a urgencias por una uña rota?', tone: ContentTone.soft),
    (
      text: '¿Quién no iría al médico ni con 39 de fiebre?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién buscaría sus síntomas en internet y entraría en pánico?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién dormiría hasta las dos de la tarde?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién pondría diez alarmas y las apagaría todas?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién mandaría un audio de siete minutos?',
      tone: ContentTone.soft,
    ),
    (text: '¿Quién respondería solo con emojis?', tone: ContentTone.soft),
    (text: '¿Quién te dejaría en visto durante días?', tone: ContentTone.soft),
    (text: '¿Quién siempre tiene el móvil al 1%?', tone: ContentTone.soft),
    (
      text: '¿Quién haría cien fotos para publicar una?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién diría que sí a todo y luego se arrepentiría?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién cancelaría un plan en el último minuto?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién sería el último en irse de la fiesta?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién se iría de una fiesta sin despedirse de nadie?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién se llevaría a casa las sobras del bufé?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién pelearía por el último trozo de tarta?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién conduciría cantando a pleno pulmón?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién se perdería incluso con el GPS encendido?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién recibiría dos multas de aparcamiento el mismo día?',
      tone: ContentTone.soft,
    ),
    (text: '¿Quién pondría nombre a su coche?', tone: ContentTone.soft),
    (
      text: '¿Quién tendría la habitación en desorden perpetuo?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién limpiaría la casa a las dos de la madrugada?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién compraría un mueble y no lograría montarlo?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién arreglaría cualquier cosa con cinta adhesiva?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién llamaría a un técnico para cambiar una bombilla?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién vería un tutorial y se sentiría un experto?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién terminaría una serie en una sola noche?',
      tone: ContentTone.soft,
    ),
    (text: '¿Quién haría spoiler sin darse cuenta?', tone: ContentTone.soft),
    (text: '¿Quién lloraría con un anuncio?', tone: ContentTone.soft),
    (
      text: '¿Quién se reiría en el momento menos oportuno?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién contaría la misma historia por décima vez?',
      tone: ContentTone.soft,
    ),
    (text: '¿Quién interrumpiría siempre a los demás?', tone: ContentTone.soft),
    (
      text: '¿Quién daría consejos que nadie ha pedido?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién estropearía una sorpresa por hablar demasiado?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién compraría el regalo en el último minuto?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién envolvería un regalo de forma desastrosa?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién tendría el árbol de Navidad puesto hasta marzo?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién se emocionaría en la boda de un amigo?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién daría el discurso más largo en una cena?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién se apuntaría a un curso y no iría jamás?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién ganaría un concurso de comer perritos calientes?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién escribiría un libro sobre su propia vida?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién abriría un canal y lo abandonaría tras tres vídeos?',
      tone: ContentTone.soft,
    ),
    (text: '¿Quién se presentaría a un reality?', tone: ContentTone.soft),
    (
      text: '¿Quién se haría viral por un vídeo grabado sin querer?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién respondería "llego en cinco minutos" todavía en la cama?',
      tone: ContentTone.soft,
    ),
    (
      text:
          '¿Quién mandaría un mensaje al chat equivocado hablando justo de ese chat?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién pondría piña en la pizza sin ninguna vergüenza?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién pediría un capuchino después de cenar en un restaurante?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién haría trampas en un juego de mesa con tal de ganar?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién sería el primero en morir en una película de terror?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién se creería una noticia falsa y la compartiría con todos?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién olvidaría dónde ha aparcado el coche?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién se terminaría las patatas de los demás "solo por probar"?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién se haría amigo del taxista en diez minutos?',
      tone: ContentTone.soft,
    ),
    (
      text:
          '¿Quién consultaría el horóscopo para tomar decisiones importantes?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién usaría el móvil con la pantalla completamente rota?',
      tone: ContentTone.soft,
    ),
    (
      text:
          '¿Quién llegaría puntual solo el día en que los demás llegan tarde?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién haría cola de noche por el lanzamiento de un móvil nuevo?',
      tone: ContentTone.soft,
    ),
    (
      text:
          '¿Quién saludaría con entusiasmo a alguien confundiéndolo con otro?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién respondería "todo bien" mientras todo va fatal?',
      tone: ContentTone.soft,
    ),
    (
      text:
          '¿Quién se ofendería por una broma y juraría que no se ha ofendido?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién compraría diez libros sin haber terminado ni uno?',
      tone: ContentTone.soft,
    ),
    (
      text:
          '¿Quién llevaría el paraguas un mes y lo olvidaría el día de lluvia?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién tendría una playlist para cada estado de ánimo posible?',
      tone: ContentTone.soft,
    ),
    (text: '¿Quién hablaría solo mientras cocina?', tone: ContentTone.soft),
    (
      text: '¿Quién pediría consejo al camarero y luego pediría lo de siempre?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién presumiría de una receta copiada de internet?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién pondría la alarma a las seis para correr y no iría jamás?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién organizaría una cena elaborada y acabaría pidiendo pizzas?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién perdería las llaves de casa una vez al mes?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién guardaría en la cartera tiques de hace tres años?',
      tone: ContentTone.soft,
    ),
    (text: '¿Quién aplaudiría al aterrizar el avión?', tone: ContentTone.soft),
    (
      text: '¿Quién llevaría el cargador a todas partes como si fuera el DNI?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién escribiría una reseña larguísima por una pizza fría?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién llamaría a su madre para saber cómo se cuece el arroz?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién viviría de maravilla un año entero sin redes?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién volvería tres veces a comprobar si ha cerrado la puerta?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién compraría cualquier cosa a un vendedor simpático?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién cambiaría de equipo según quién vaya ganando?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién vería las historias de todos sin publicar jamás una?',
      tone: ContentTone.soft,
    ),
    (
      text:
          '¿Quién se emocionaría en un viaje más por la comida que por los monumentos?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién pediría siempre el mismo plato en cualquier restaurante?',
      tone: ContentTone.soft,
    ),
    (
      text:
          '¿Quién elegiría el destino de vacaciones mirando solo fotos de restaurantes?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién discutiría con la impresora hasta amenazarla?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién pasaría más tiempo eligiendo la película que viéndola?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién usaría todavía la excusa "no me llegó el mensaje"?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién contestaría correos de trabajo hasta a medianoche?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién dejaría el trabajo para abrir un chiringuito en la playa?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién se presentaría a una entrevista con la camiseta del revés?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién haría una siesta "de diez minutos" de tres horas?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién tendría doscientas pestañas abiertas en el navegador?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién fotografiaría el plato antes de dejar comer a nadie?',
      tone: ContentTone.soft,
    ),
    (
      text:
          '¿Quién se sabría las canciones de memoria pero jamás el nombre del cantante?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién se perdería dentro de un centro comercial?',
      tone: ContentTone.soft,
    ),
    (
      text:
          '¿Quién se tomaría demasiado en serio un disfraz para una fiesta temática?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién ganaría una discusión por puro agotamiento del rival?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién se cambiaría de peinado después de cada desilusión?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién se cortaría el flequillo solo a las dos de la madrugada?',
      tone: ContentTone.soft,
    ),
    (
      text:
          '¿Quién compraría ropa y la dejaría meses en el armario con la etiqueta?',
      tone: ContentTone.soft,
    ),
    (
      text:
          '¿Quién juraría "el lunes empiezo la dieta" cada domingo por la noche?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién pediría postre justo después de decir "estoy llenísimo"?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién probaría del plato de los demás sin pedir permiso?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién pondría kétchup hasta en un plato gourmet?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién compraría los regalos de Navidad ya en octubre?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién compraría los regalos de Navidad la tarde del 24?',
      tone: ContentTone.soft,
    ),
    (
      text:
          '¿Quién empezaría un hobby nuevo cada dos meses abandonando el anterior?',
      tone: ContentTone.soft,
    ),
    (
      text:
          '¿Quién tardaría una hora en elegir el look para salir luego en sudadera?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién hablaría a las plantas convencido de que así crecen mejor?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién usaría audios hasta para responder "ok"?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién escribiría "jajaja" completamente serio?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién llegaría el primero a un bufé gratis?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién contaría los días para las vacaciones desde enero?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién se dormiría viendo la película que ha elegido?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién haría amistad con un desconocido en la cola de correos?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién pediría indicaciones y luego iría en dirección contraria?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién se apuntaría a un concurso de la tele convencido de ganar?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién ganaría un premio por la excusa más creativa?',
      tone: ContentTone.soft,
    ),
    (
      text:
          '¿Quién tendría el móvil en silencio y se quejaría de las llamadas perdidas?',
      tone: ContentTone.soft,
    ),
    (
      text:
          '¿Quién vería vídeos de cocina de madrugada sin saber cocinar nada?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién llevaría crema solar y se quemaría igualmente?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién celebraría su cumpleaños durante una semana entera?',
      tone: ContentTone.soft,
    ),
    (
      text:
          '¿Quién olvidaría el cumpleaños de su mejor amigo y culparía al móvil?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién intentaría usar un cupón caducado como si nada?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién pediría comida a domicilio con la nevera llena?',
      tone: ContentTone.soft,
    ),
    (
      text: '¿Quién viviría a base de café negando ser adicto?',
      tone: ContentTone.soft,
    ),
    // ------------------------------------------------------ piccante
    (
      text: '¿Quién escribiría a un ex a las tres de la mañana?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién volvería con un ex por tercera vez?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién se enamoraría en dos días de vacaciones?',
      tone: ContentTone.piccante,
    ),
    (text: '¿Quién diría "te quiero" primero?', tone: ContentTone.piccante),
    (text: '¿Quién cortaría por mensaje?', tone: ContentTone.piccante),
    (
      text: '¿Quién flirtearía con el camarero delante de todos?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién usaría la misma frase para ligar desde hace diez años?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién tiene más chats abiertos ahora mismo?',
      tone: ContentTone.piccante,
    ),
    (text: '¿Quién miraría el móvil de su pareja?', tone: ContentTone.piccante),
    (
      text: '¿Quién escondería una relación a todo el grupo?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién besaría a alguien por una apuesta?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién se declararía delante de todos?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién haría ghosting sin explicaciones?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién respondería a una historia solo para hacerse notar?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién miraría el perfil de un ex cada semana?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién daría like a una foto de hace tres años sin querer?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién contaría un secreto después de dos copas?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién acabaría cantando encima de una mesa?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién se dormiría en su propia fiesta de cumpleaños?',
      tone: ContentTone.piccante,
    ),
    (text: '¿Quién olvidaría una noche entera?', tone: ContentTone.piccante),
    (
      text: '¿Quién mandaría mensajes de los que arrepentirse por la mañana?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién llamaría a un amigo para que lo rescatara de una cita?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién mentiría sobre su edad en una cita?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién usaría una foto de perfil de hace diez años?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién llegaría una hora tarde a una primera cita?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién hablaría de su ex en una primera cita?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién se haría un tatuaje de vacaciones por impulso?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién bailaría encima de la barra tras el tercer cóctel?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién se tiraría a la piscina vestido?',
      tone: ContentTone.piccante,
    ),
    (text: '¿Quién se bañaría sin bañador?', tone: ContentTone.piccante),
    (
      text: '¿Quién convencería a todos de hacer algo que no querían hacer?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién se llevaría un vaso del bar de recuerdo?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién acabaría discutiendo con el portero de la discoteca?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién se encerraría en el baño de una fiesta con alguien, y no precisamente a hablar?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién se despertaría en la cama de alguien sin recordar cómo llegó?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién pasaría la noche con alguien y se escaparía antes del amanecer?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién leería los mensajes en la pantalla de otro?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién diría que está en casa estando fuera?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién dejaría plantado a alguien sin avisar?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién fingiría estar enfermo para saltarse un compromiso?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién acabaría llorando en el baño en una fiesta?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién se apuntaría a una app de citas al día siguiente de una ruptura?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién se haría pasar por soltero en una fiesta?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién flirtearía solo para que le invitaran a una copa?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién daría su número a alguien conocido hace cinco minutos?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién besaría a un desconocido en Nochevieja?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién contaría los detalles de la primera cita en el chat de grupo?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién releería los chats con su ex antes de dormir?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién subiría una historia solo para que la vea una persona concreta?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién diría "la última y nos vamos" cinco veces la misma noche?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién tendría un rollo de una noche en vacaciones sin pensarlo?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién tiene la lista de conquistas más larga de lo que admite?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién se ha vestido hoy así para llamar la atención de alguien concreto?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién mandaría un mensaje atrevido y le echaría la culpa al móvil?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién saldría con dos personas distintas el mismo fin de semana?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién se quedaría hasta el desayuno tras una primera noche?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién ha tenido más rollos de una noche de todo el grupo?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién mandaría un nude y luego miraría el móvil en pánico esperando respuesta?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién diría "yo no soy de esos" mintiendo descaradamente?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién probaría un trío al menos una vez en la vida?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién pasaría la noche con alguien conocido dos horas antes en el bar?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién volvería a casa a las seis de la mañana con la ropa de la noche anterior?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién habrá tenido sexo en el sitio más absurdo?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién tendría sexo en la playa arriesgándose a que lo pillen?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién mandaría un mensaje picante a la persona equivocada?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién tiene un cajón que es mejor no abrir delante de las visitas?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién presumiría de sus dotes en la cama sin que nadie pregunte?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién decidiría si repetir con alguien según cómo besa?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién habrá besado a más gente en una sola noche?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién aceptaría un "vente a ver una peli" sabiendo que la peli no empezará jamás?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién propondría la ducha en pareja "para ahorrar agua"?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién habrá tenido ya sexo en un coche?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién usaría las apps de citas solo para aventuras de una noche?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién respondería a un "¿qué haces esta noche?" recibido a las dos de la mañana?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién tiene un ex que todavía lo busca de vez en cuando para una noche?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién llamaría "amistad" a algo que de amistoso tiene bien poco?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién conquistaría a alguien con un solo mensaje?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién publicaría una foto en bañador solo para provocar a alguien concreto?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién propondría sexo de reconciliación tras cada pelea?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién tiene una fantasía que nunca se ha atrevido a confesar?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién compraría lencería nueva solo para una cita prometedora?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién dejaría una marca visible en el cuello de alguien sin disculparse?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién recordaría el nombre de todas las personas con las que ha estado?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién saldría de casa sin ropa interior y lo revelaría solo al final de la noche?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién convertiría un masaje inocente en algo mucho menos inocente?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién mandaría un audio susurrado solo para volver loco a alguien?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién aceptaría una última noche con un ex "solo para cerrar el círculo"?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién habrá fingido un orgasmo al menos una vez, seguro?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién acabaría en la cama con un desconocido esta misma noche?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién tiene el body count más alto del grupo?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién miente más sobre su body count?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién ha hecho sexting esta última semana?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién mandaría una foto atrevida tras dos cumplidos bien puestos?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién tiene una carpeta oculta en la galería?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién flirtearía con quien atiende la barra para que le sirvan antes?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién se enamoraría después de una sola noche?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién desaparecería después de una sola noche?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién haría el paseo de la vergüenza con orgullo?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién volvería con un ex por puro aburrimiento?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién escribe a sus ex cuando la noche se alarga?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién mira las redes de su crush todos los días?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién tendría más matches en una app de citas?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién respondería a un "¿estás despierto?" a las tres de la mañana?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién mandaría un "¿estás despierto?" a las tres de la mañana?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién besaría a alguien del grupo por una apuesta de diez euros?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién pasaría más vergüenza enseñando su historial de búsqueda?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién ha pensado ya cómo sería una noche con alguien de los presentes?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién se casaría con un desconocido en Las Vegas?',
      tone: ContentTone.piccante,
    ),
    (text: '¿Quién ligaría en una boda?', tone: ContentTone.piccante),
    (
      text: '¿Quién flirtearía con el médico en plena consulta?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién daría un beso de verdad durante un juego como este?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién tiene el móvil en silencio por motivos sospechosos?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién tiene más chats archivados que visibles?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién sabría seducir a alguien en menos de diez minutos?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién lo intenta siempre pero no concreta nunca?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién concreta siempre y no lo cuenta jamás?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién lo cuenta todo pero concreta poco?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién tendría una historia con un compañero de trabajo?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién se enamoraría de su entrenador personal?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién caería mejor a los padres de su pareja que a la propia pareja?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién acabará besando a alguien antes de que termine la noche?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién ha besado ya a alguien de esta sala?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién flirtearía hasta en la cola de correos?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién tiene un tipo ideal tan concreto que parece un retrato robot?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién no tiene ningún tipo ideal, y se nota?',
      tone: ContentTone.piccante,
    ),
    (text: '¿Quién se declararía por audio?', tone: ContentTone.piccante),
    (
      text:
          '¿Quién daría el primer paso con la persona más guapa de la fiesta?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién se mira en cada escaparate antes de una cita?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién llegaría a una cita con rosas y playlist preparada?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién llevaría una cita al fast food llamándolo romántico?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién duerme abrazado a la almohada desde que está soltero?',
      tone: ContentTone.piccante,
    ),
    (text: '¿Quién ha llorado por amor este mes?', tone: ContentTone.piccante),
    (
      text: '¿Quién miraría las fotos de su ex la noche de Fin de Año?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién mandaría un audio de diez minutos para explicar un "me gustas"?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién ha escrito y borrado un mensaje esta misma noche?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién besa mejor según la leyenda del grupo?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién usaría una frase de ligue sacada de una película?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién se ofendería si nadie intentara ligar con él jamás?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién diría que no a su celebrity crush por timidez?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién se iría mañana de fin de semana con su último flirteo?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién tiene a su crush guardada en la agenda con nombre en clave?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién entrena solo para los resultados de playa?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién mandaría un mensaje atrevido y apagaría el móvil del miedo?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién se dormiría en mitad de una cita aburrida?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién daría celos a su crush a propósito?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién tiene ya una fecha marcada en el calendario por alguien?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién pasaría la noche hablando en vez de dormir, con la persona adecuada?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién confesaría un flechazo solo bajo interrogatorio, como ahora?',
      tone: ContentTone.piccante,
    ),
    (
      text:
          '¿Quién tiene una frase infalible y jamás la comparte con el grupo?',
      tone: ContentTone.piccante,
    ),
    (
      text: '¿Quién sabría convertir una cita desastrosa en una gran noche?',
      tone: ContentTone.piccante,
    ),
    // ------------------------------------------------------- cattivo
    (
      text: '¿Quién besaría a alguien de este grupo si no fuera un juego?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha mentido ya al menos una vez esta noche?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién está pensando en alguien ahora mismo?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién compartiría la captura de un chat privado?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién crearía un perfil falso para cotillear?',
      tone: ContentTone.cattivo,
    ),
    (text: '¿Quién mentiría mirándote a los ojos?', tone: ContentTone.cattivo),
    (
      text: '¿Quién criticaría a un amigo en cuanto sale de la habitación?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién tendría un chat secreto sin alguno de los presentes?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién desaparecería del grupo en cuanto tenga pareja?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién vendería un secreto de un amigo por mil euros?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién soltaría un secreto en menos de veinticuatro horas?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién se atribuiría el mérito de una idea ajena?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién fingiría alegrarse por un amigo mientras se muere de envidia?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién borraría a un amigo de su vida sin explicaciones?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién no devolvería jamás el dinero prestado?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién culparía a otro con tal de salvarse?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién miraría el móvil de un amigo dejado desbloqueado?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién flirtearía con el ex de un amigo?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién abandonaría un plan con amigos por una invitación mejor?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién llevaría una lista mental de todas las ofensas recibidas?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién diría "no te juzgo" mientras te está juzgando?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién no aguantaría una semana sin criticar a nadie?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién fingiría no ver un mensaje para librarse de una mudanza?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha juzgado ya en silencio a todos los de esta sala?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién haría un cumplido falso sin pestañear?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién acabaría en la cama con un ex esta misma noche si diera señales de vida?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién tendría sexo en la primera cita sin ningún problema?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién tendría un amigo con derecho secreto sin decírnoslo a ninguno?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién ha mirado ya a alguno de los presentes de un modo nada inocente?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién contaría por ahí cada detalle de sus noches locas?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién se ha imaginado ya en la cama con alguno de los presentes?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién se acostaría con el ex de su mejor amigo si nadie lo supiera jamás?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién sería infiel y lograría que no lo pillaran en años?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién perdonaría una infidelidad aunque jure delante de todos lo contrario?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién escribiría "te echo de menos" a dos personas distintas la misma noche?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién tendría una historia secreta con un compañero de trabajo y la negaría hasta el final?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién pasaría una noche con una persona comprometida sin remordimientos?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién se sabría el código de desbloqueo de su pareja sin que su pareja lo sepa?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién diría "llego tarde al trabajo" desde la cama de otra persona?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién flirtearía con la pareja de uno de los presentes en cuanto se queden solos?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién ha besado ya a escondidas a una persona que todos conocemos?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién aceptaría una propuesta indecente de un desconocido rico sin pensarlo mucho?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién mandaría un nude a un casi desconocido solo por sentirse deseado?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién se acostaría con el jefe por un ascenso?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién negaría una infidelidad incluso ante las pruebas?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién tendría todavía las fotos picantes de un ex guardadas en alguna parte?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién contaría a los amigos los detalles íntimos de su pareja sin decírselo?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién negaría hasta la muerte una noche de la que ya todos sabemos todo?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha pensado "contigo sí" mirando a alguien de esta sala?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién intentaría compensar una infidelidad con un regalo caro?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién escribiría a un ex comprometido sabiendo perfectamente que está comprometido?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién guardaría a un amante en la agenda con nombre falso?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién sería infiel por despecho tras una pelea?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién se acostaría con un ex aun sabiendo que ahora tiene pareja?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién probaría un trío con dos personas de este grupo?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién besaría a la pareja de un amigo tras un par de copas de más?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién revelaría con quién se acuesta un amigo tras jurar guardar el secreto?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién fingiría entusiasmo en la cama con tal de acabar rápido una noche decepcionante?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién pondría nota a sus ex delante de los amigos?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién presumiría de una infidelidad en vez de avergonzarse?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha mentido ya a su pareja para estar aquí esta noche?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién se quitaría el anillo antes de entrar en una discoteca?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién usaría su encanto para que le paguen todo sin conceder nada?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién habrá tenido sexo en un sitio donde se jugaba el despido?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién mantendría dos historias a la vez durante meses sin cargo de conciencia?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién volvería con un ex solo por el sexo, sabiendo perfectamente que es un error?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién declararía solo la mitad de las personas con las que ha estado en realidad?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién leería los chats de su pareja y no lo confesaría jamás?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién se escaparía un fin de semana con la persona equivocada con tal de no aburrirse?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién está mirando a alguno de los presentes con segundas intenciones ahora mismo?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién habrá tenido sexo en un lugar público, seguro?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha grabado al menos un vídeo subido de tono en su vida?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién tiene una carpeta protegida con contraseña que no veremos jamás?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién se ha acostado con alguien que todos conocemos y no lo ha dicho nunca?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién acabaría en la cama con el ex de su mejor amigo?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha sido infiel al menos una vez?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién perdonaría una infidelidad con tal de no quedarse solo?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién ha tenido ya un pensamiento nada inocente sobre uno de los presentes?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién ha soñado ya con uno de los presentes en versión no apta para menores?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién tiene seguro un juguete en la mesilla de noche?',
      tone: ContentTone.cattivo,
    ),
    (text: '¿Quién tiene más de uno?', tone: ContentTone.cattivo),
    (
      text: '¿Quién ha hecho un trío o se muere de ganas de probarlo?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién aceptaría una propuesta de trío si llegara esta noche?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha tenido sexo en la primera cita más de una vez?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién se ha escapado de casa de alguien antes del amanecer?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha colado a alguien en casa a escondidas?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha escondido a una persona en el armario, literalmente?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién tiene un amigo con derecho justo en esta época?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién ha arruinado una amistad por acabar en la cama con la persona equivocada?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha mentido a su pareja sobre dónde pasó la noche?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha borrado un chat entero por seguridad?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién tiene un nombre en clave en la agenda para una persona concreta?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién ha tenido sexo mientras nosotros estábamos en la habitación de al lado?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha tenido una debilidad seria por un jefe o un profesor?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha usado la oficina para algo nada laboral?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha tenido sexo en un coche en un aparcamiento lleno?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién fue pillado por sus padres en el peor momento?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién pilló a sus padres y no se ha recuperado jamás?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha fingido un orgasmo hace poco?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha dicho el nombre equivocado en la cama alguna vez?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha dejado marcas en el cuello de alguien este año?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha tenido que inventarse una excusa por un moratón?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha tenido sexo en vacaciones con alguien del lugar?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién volvería con un ex solo por una noche y lo llamaría casualidad?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ya ha vuelto con un ex y lo niega?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién tiene dos chats abiertos con dos llamas a la vez, ahora mismo?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién ha mandado la misma foto atrevida a dos personas distintas?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha recibido una foto atrevida cenando con sus padres?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha hecho sexting esta misma noche, desde esta sala?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién tiene un fetiche que no confesará jamás?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién lo confesaría si se lo pidiéramos ahora todos a coro?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha probado a que lo aten por juego?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién usaría una venda en los ojos sin pensarlo dos veces?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha comprado lencería para una sola noche concreta?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién tiene una playlist hecha a propósito para las noches acompañado?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha puesto la música alta para que no lo oyeran?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha recibido quejas de los vecinos al menos una vez?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha roto una cama o un mueble y ha tenido que explicarlo?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién se ha resbalado al menos una vez probando la ducha en pareja?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha ascendido la cocina a escenario y no se arrepiente?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién lo ha hecho en la playa aunque todos desaconsejen la arena?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién lo haría en un avión si surgiera la ocasión?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha pagado una habitación solo por unas horas?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha usado la pausa de la comida de un modo muy creativo?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha mentido sobre su body count hasta a sí mismo?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién lleva la cuenta exacta, con fechas incluidas?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién tiene una lista escrita en alguna parte?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha contado una noche censurando el noventa por ciento?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién ha exagerado los detalles de una noche para dar espectáculo?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién es mejor en la cama de lo que deja intuir?',
      tone: ContentTone.cattivo,
    ),
    (text: '¿Quién es peor de lo que cuenta?', tone: ContentTone.cattivo),
    (
      text: '¿Quién ha mirado el móvil de su pareja mientras dormía?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién ha encontrado algo en un móvil ajeno y ha hecho como si nada?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha usado un perfil falso para controlar a alguien?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién ha reconocido a una persona comprometida en una app de citas y ha callado?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién se apuntaría a una web para adultos con nombre artístico?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién tiene ya el nombre artístico preparado?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién aceptaría una noche con su celebrity crush aunque se enterara todo el mundo?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién diría que no y encima mentiría sobre el motivo?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién ha hecho las paces en la cama tras una pelea creada a propósito?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha usado el sexo para que le perdonaran algo gordo?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién ha dicho "no volverá a pasar" sabiendo perfectamente que volvería a pasar?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién saldría esta noche de aquí acompañado, si tuviera el valor?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién tiene ya un plan preciso de cómo acabará su noche?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién tiene el móvil lleno de conversaciones que no podemos ver jamás?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién se ha despertado en una cama desconocida sin recordar cómo?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién ha hecho el paseo de la vergüenza cruzándose con un conocido?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha mentido diciendo "estaba en casa durmiendo"?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién lo está haciendo más que nadie últimamente, sin contárselo a nadie?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién terminará esta partida con un secreto menos y un plan más?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién aceptaría que le orinaran encima por un millón de euros?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ya ha tenido sexo anal esta noche antes de venir aquí?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién en este grupo tiene el esperma más rico, por el olfato?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién dejaría que un completo desconocido le lamiera el culo?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién ha intentado ya seguramente tragarse su propia eyaculación?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién cambiaría a su pareja por una noche de sexo extremo con otro de los presentes?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién tiene la ropa interior más mojada en este momento?',
      tone: ContentTone.cattivo,
    ),
    (
      text:
          '¿Quién le haría sexo oral a quien tiene a su izquierda para saltarse una ronda?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién de nosotros acabaría haciendo cine porno si le pagaran bien?',
      tone: ContentTone.cattivo,
    ),
    (
      text: '¿Quién tiene el juguete sexual más grande en su habitación?',
      tone: ContentTone.cattivo,
    ),
  ];

  /// Obblighi (retos) per tono: 150 ciascuno.
  static const Map<String, List<String>> obblighi = {
    ContentTone.soft: [
      'Imita la forma de andar de la persona de tu derecha.',
      'Canta el estribillo de la última canción que escuchaste.',
      'Habla en rima hasta tu próximo turno.',
      'Haz el sonido de tres animales y que los demás los adivinen.',
      'Baila diez segundos sin música.',
      'Cuenta un chiste: si nadie se ríe, repítelo más alto.',
      'Imita a tu personaje favorito de una serie.',
      'Haz una pose de estatua y quédate inmóvil treinta segundos.',
      'Habla como un comentarista deportivo durante un minuto.',
      'Enseña la última foto que hiciste.',
      'Enseña tu pantalla de inicio sin abrir nada.',
      'Enseña el emoji que más usas y explica por qué justo ese.',
      'Enseña cuántas alarmas tienes puestas.',
      'Hazle al asistente de voz una pregunta absurda elegida por el grupo.',
      'Manda un audio cantado a un contacto al azar.',
      'Llama a un amigo y cántale cumpleaños feliz aunque no sea su cumpleaños.',
      'Haz un cumplido sincero a cada persona presente.',
      'Describe a la persona de tu izquierda usando solo tres palabras.',
      'Inventa un rap de veinte segundos sobre la persona de tu izquierda.',
      'Imita al profesor que peor recuerdes.',
      'Haz de vendedor e intenta vendernos esta mesa.',
      'Presenta el tiempo de mañana como en la tele.',
      'Habla con acento extranjero hasta la próxima ronda.',
      'Cuenta la trama de una película sin decir el título: los demás adivinan.',
      'Haz un discurso de agradecimiento como si hubieras ganado un premio.',
      'Improvisa un anuncio del objeto que tengas más cerca.',
      'Enseña cómo bailas cuando estás solo en casa.',
      'Canta en vez de hablar durante los próximos dos minutos.',
      'Camina con un libro en equilibrio sobre la cabeza.',
      'Ponte una prenda del revés durante dos rondas.',
      'Déjate hacer un peinado nuevo por quien está a tu derecha.',
      'Dibuja al grupo en treinta segundos.',
      'Escribe tu nombre con la mano mala y enséñalo.',
      'Dibuja el retrato de un presente con los ojos cerrados y regálaselo.',
      'Recita el abecedario al revés lo más rápido que puedas.',
      'Cuenta hasta veinte saltándote los múltiplos de tres.',
      'Di tres palabras al revés, empezando por la última letra.',
      'Cuenta una historia inventada de treinta segundos que empiece por "Anoche…".',
      'Cuenta tu día como si fuera una película de terror.',
      'Explica tu trabajo o tu día a día como lo haría un niño de cinco años.',
      'Haz de robot durante un minuto.',
      'Responde solo con preguntas hasta tu próximo turno.',
      'No puedes decir "sí" ni "no" hasta tu próximo turno.',
      'Habla de ti en tercera persona hasta tu próximo turno.',
      'Ríete lo más fuerte que puedas sin motivo.',
      'Quédate serísimo treinta segundos mientras los demás intentan hacerte reír.',
      'Aguanta veinte segundos de plancha mientras cuentan.',
      'Haz cinco flexiones contadas por el grupo.',
      'Corre sin moverte del sitio hasta el final del turno.',
      'Haz diez sentadillas diciendo el nombre de un presente en cada una.',
      'Come algo elegido por la persona de tu izquierda.',
      'Prueba juntas dos cosas de comer que no pegan nada.',
      'Haz una reseña de crítico con estrella de lo último que has comido hoy.',
      'Prepara una bebida sin alcohol y dásela a probar a alguien.',
      'Haz un brindis improvisado en honor del grupo.',
      'Cuenta tu mejor recuerdo con una persona presente.',
      'Cuenta cómo conociste a quien tienes enfrente.',
      'Di qué envidias (en el buen sentido) a cada persona presente.',
      'Haz una predicción sobre el futuro de una persona presente.',
      'Asigna un apodo a cada uno y explícalo.',
      'Responde solo a un apodo nuevo elegido por el grupo hasta el final de la partida.',
      'Elige a quién del grupo te llevarías a una isla desierta y explica por qué.',
      'Cuenta la cosa más cara que has comprado inútilmente.',
      'Confiesa una costumbre rara que tengas.',
      'Cuenta un miedo ridículo que tengas.',
      'Finge que te da miedo un objeto de la habitación.',
      'Cuenta tu talento más inútil y demuéstralo.',
      'Enséñanos tu mejor "truco de magia" improvisado.',
      'Haz una figura de papiroflexia con lo que encuentres en un minuto.',
      'Construye una torre con tres objetos de la habitación.',
      'Encuentra tres objetos amarillos en la casa en treinta segundos.',
      'Intercambia algo que llevas puesto con quien está a tu derecha.',
      'Hazte el peor selfie que puedas.',
      'Hazte una foto imitando la pose de quien está a tu izquierda.',
      'Graba un vídeo de diez segundos como si fueras influencer.',
      'Graba un mensaje motivacional para el grupo.',
      'Lee el horóscopo de hoy con voz dramática.',
      'Inventa un horóscopo para la persona de tu derecha.',
      'Describe cómo será tu vida dentro de diez años, sin pensarlo mucho.',
      'Declara tu amor eterno a un objeto de la habitación: el sofá cuenta.',
      'Interpreta una despedida lacrimógena con un cojín.',
      'Di qué canción te sabes de memoria y canta un trozo.',
      'Haz un karaoke de diez segundos sin música.',
      'Silba una canción y que los demás la adivinen.',
      'Haz cinco segundos de beatbox.',
      'Imita el sonido de tres instrumentos distintos.',
      'Toca una guitarra imaginaria como en un concierto.',
      'Baila como si estuvieras solo en la discoteca.',
      'Enseña al grupo un paso de baile.',
      'Haz una foto de grupo dando tú todas las indicaciones.',
      'Elige la banda sonora de la noche y explica por qué.',
      'Cuenta lo más bonito que te ha pasado esta semana.',
      'Di algo que te gustaría aprender y por qué no has empezado.',
      'Haz una lista de tres cosas por las que estás agradecido ahora mismo.',
      'Manda un mensaje bonito a alguien a quien no escribes hace tiempo.',
      'Llama a tu madre o a un familiar y dile que lo quieres.',
      'Manda "¡Buenos días!" con tres emojis al azar al chat de la familia.',
      'Deja que el grupo elija tu próximo reto del siguiente turno.',
      'Desfila como un modelo de una punta a otra de la habitación, giro incluido.',
      'Compórtate como un T-Rex de brazos cortos hasta tu próximo turno.',
      'Usa un mando o un cepillo como micrófono cada vez que hables, durante una ronda.',
      'Haz de camarero: toma con total seriedad los pedidos imaginarios de todos.',
      'Representa una película sin hablar hasta que el grupo la adivine.',
      'Imita a un famoso elegido por el grupo hasta que alguien adivine quién es.',
      'Haz un cumplido a cada presente saltando a la pata coja.',
      'Intenta lamerte el codo con total dedicación durante diez segundos.',
      'Cuenta un cuento de buenas noches en treinta segundos haciendo todas las voces.',
      'Habla un minuto de un tema elegido por el grupo como si fueras el mayor experto.',
      'Repite tres veces seguidas un trabalenguas elegido por el grupo sin equivocarte.',
      'Narra lo que hace la persona de enfrente como un documental de naturaleza.',
      'Haz cinco expresiones a la orden: feliz, enfadado, sorprendido, enamorado, sospechoso.',
      'Baila una lenta romántica con una escoba o un cojín.',
      'Presenta un telediario con tres noticias absurdas sobre los presentes.',
      'Haz de eco: repite la última palabra de quien hable hasta tu próximo turno.',
      'Habla susurrando hasta tu próximo turno, pase lo que pase.',
      'Mantén una sonrisa gigante durante tres minutos, pase lo que pase.',
      'Inventa un himno del grupo con la música de una canción famosa y cántalo.',
      'Deja que el grupo te coloque como una estatua y quédate así para una foto.',
      'Monta un drama de telenovela porque se ha acabado una galleta.',
      'Intenta hacer reír a la persona más seria del grupo en treinta segundos, sin tocarla.',
      'Apila sobre ti todos los cojines que puedas y aguanta diez segundos en equilibrio.',
      'Inventa un idioma y "traduce" lo que diga la persona de tu derecha.',
      'Finge estar atrapado en una caja invisible hasta que alguien te "libere".',
      'Cuenta cómo se formó este grupo en plan documental histórico.',
      'Trata a todos de usted hasta tu próximo turno, con formalidad extrema.',
      'Haz un tutorial de cocina imaginario con los objetos que tengas delante.',
      'Muévete a cámara lenta hasta el final del turno, repeticiones incluidas.',
      'Saluda en cinco idiomas distintos, inventando los que no sepas.',
      'Imita a un animal hasta que alguien adivine cuál es.',
      'Responde cantando a todo lo que te digan hasta tu turno.',
      'Da diez saltos en el sitio gritando tu nombre.',
      'Cuenta un chiste malo: si nadie se ríe, prueba con otro.',
      'Haz de comentarista de la sala durante treinta segundos.',
      'Inventa un anuncio para el objeto de tu derecha.',
      'Aguanta la mirada a quien tienes enfrente sin reírte durante veinte segundos.',
      'Baila quince segundos la canción que elija el grupo.',
      'Describe tu día usando solo sonidos.',
      'Cuenta la trama de una película famosa en exactamente diez palabras.',
      'Finge ganar un Óscar y da las gracias a los presentes uno por uno.',
      'Camina como un robot hasta la puerta y vuelve.',
      'Presenta a cada presente como si fuera un luchador de wrestling.',
      'Canta "Cumpleaños feliz" como si fuera una canción de rock.',
      'Pon cinco caras distintas en cinco segundos.',
      'Mantén un cojín en equilibrio sobre la cabeza una ronda entera.',
      'Da el parte del tiempo inventado con la máxima seriedad.',
      'Pide una pizza imaginaria de forma épica y dramática.',
      'Aplaude cada frase que digan los demás hasta tu turno.',
      'Lee en voz alta la última nota de tu móvil.',
      'Describe al grupo tu desayuno ideal como si fuera alta cocina.',
      'Enseña la foto más antigua que tengas en el móvil y cuenta su historia.',
    ],
    ContentTone.piccante: [
      'Haz un masaje de hombros de treinta segundos a una persona que quiera: ella pone nota en voz alta.',
      'Susurra al oído de la persona de tu derecha la frase más atrevida que se te ocurra.',
      'Besa la mano de cada persona del grupo mirándola a los ojos, como un seductor de otros tiempos.',
      'Da un beso en la mejilla, lo más cerca posible de la oreja, a una persona que quiera elegida por el grupo.',
      'Haz un lap dance de broma de quince segundos a una persona que quiera, elegida por el grupo.',
      'Baila una lenta sensual, mejilla con mejilla, con una persona que quiera durante treinta segundos.',
      'Recorre con un dedo el perfil de la cara de la persona de tu izquierda (si le apetece), en silencio total.',
      'Da la mano a la persona más atractiva de la sala hasta tu próximo turno, sin explicar la elección.',
      'Déjate vendar los ojos y reconoce a tres personas del grupo tocando solo manos y brazos.',
      'Déjate vendar los ojos y deja que una persona elegida por el grupo te dé algo de comer.',
      'Apoya la cabeza en las piernas de una persona que quiera y quédate ahí una ronda entera.',
      'Abraza por detrás a una persona que quiera y susúrrale "te he echado de menos" con tu voz más cálida.',
      'Mira a los ojos a la persona que te parezca más atractiva durante veinte segundos sin hablar: el grupo comenta.',
      'Sopla suavemente en el cuello de la persona de tu derecha (si le apetece) y vuelve a sentarte como si nada.',
      'Guiña el ojo más provocador que tengas a cada persona del grupo, una por una, sin reírte.',
      'Muérdete el labio despacio mirando a la persona de enfrente hasta que uno de los dos se ría.',
      'Quítate un accesorio o una capa (zapatos, calcetines, camisa sobre la camiseta: tú eliges) del modo más sensual posible.',
      'Recrea la escena más sensual de una película que conozcas, con una persona que quiera como compañero de escena.',
      'Baila veinte segundos como si intentaras seducir a toda la sala a la vez.',
      'Imita cómo reaccionas cuando te hacen un masaje perfecto, con audio incluido.',
      'Recita tu repertorio de sexting en voz alta, como si fuera poesía. Inventa si hace falta, pero poco.',
      'Dicta al grupo, palabra por palabra, el mensaje de seducción perfecto para conquistar a tu crush.',
      'Describe en voz alta cómo seducirías a la persona de tu izquierda, paso a paso, mirándola.',
      'Enseña al grupo tu movimiento estrella para pasar del sofá al dormitorio.',
      'Explica paso a paso cómo conviertes una cita en una noche entera, del aperitivo a la puerta de casa.',
      'Haz un anuncio de treinta segundos de ti mismo como amante, sin falsa modestia.',
      'Cuenta tu mejor noche como si fuera el tráiler de una película: sin nombres, pero que se entienda el clima.',
      'Describe tu beso perfecto con todo detalle mirando a la persona de enfrente, sin apartar los ojos.',
      'Di en voz alta la frase exacta que usarías para invitar a alguien a pasar la noche contigo.',
      'Susurra "buenas noches" con tu voz más sensual al oído de tres personas distintas.',
      'Interpreta la escena: te despiertas junto a tu crush. Enseña la cara, la primera frase y el siguiente movimiento.',
      'Haz tu imitación de cómo flirteas después de la tercera copa, con entrega total.',
      'Lanza un beso a cámara lenta a la persona de enfrente, manteniendo el contacto visual de principio a fin.',
      'Enseña a cámara lenta cómo besas, con el aire como pareja: el grupo puntúa del 1 al 10.',
      'Manda "¿Qué haces luego?" a la última persona con la que flirteaste y enseña la respuesta cuando llegue.',
      'Manda "Estoy pensando cosas que no puedo escribir aquí." a un contacto elegido por ti.',
      'Manda un emoji de fuego a la última persona con la que flirteaste y enseña la respuesta.',
      'Lee en voz alta el mensaje más atrevido del chat con tu última llama.',
      'Enseña la conversación más picante que estés dispuesto a mostrar al grupo.',
      'Lee en voz alta el último mensaje que mandaste después de medianoche, con el tono con que lo pensaste.',
      'Enseña la foto tuya en la que te ves más irresistible.',
      'Escribe "He pensado en ti toda la tarde." a la persona que te gusta y enseña la respuesta cuando llegue.',
      'Deja que el grupo lea tu bio de app de citas, o crea una ahora mismo sin censura.',
      'Manda un audio de diez segundos con tu voz más sensual a un contacto elegido por el grupo (sin ofender).',
      'Graba un audio leyendo la lista de la compra como si fuera un audio prohibido.',
      'Cuenta hasta dónde llegaste en la primera cita más exitosa de tu vida.',
      'Cuenta tu noche más loca en treinta segundos: puedes saltarte detalles, no hechos.',
      'Confiesa la fantasía más confesable que tengas y aguanta los comentarios del grupo sin defenderte.',
      'Enumera tres cosas que te vuelven loco en la cama, en orden creciente de vergüenza.',
      'Cuenta tu despertar más vergonzoso en casa de otra persona.',
      'Cuenta cómo empezó tu última aventura, parando el relato en la puerta de la habitación.',
      'Di en voz alta el sitio más absurdo donde lo has hecho: solo el sitio, sin historia.',
      'Cuenta la vez que te pillaron en el peor momento.',
      'Cuenta tu peor ridículo en un momento de intimidad, sin decir nombres.',
      'Confiesa la hora más absurda a la que has mandado (o recibido) un "¿estás despierto?".',
      'Revela tu récord: cuánto pasó entre el "hola, ¿cómo te llamas?" y todo lo demás.',
      'Imita tu reacción cuando recibes una foto atrevida que no esperabas.',
      'Di qué canción pondrías de banda sonora de una noche importante y defiende la elección.',
      'Describe tu "después": ¿eres de abrazo, de silencio, de nevera o de fuga?',
      'Di quién del grupo tiene la mirada más peligrosa y qué te esperarías de una noche suya.',
      'Elige a la persona del grupo con la que compartirías tienda de campaña y explica el criterio, todo el criterio.',
      'Haz el ranking de los presentes por "carisma de fin de fiesta", del primero al último, y defiéndelo.',
      'Asigna a cada presente un nivel de peligrosidad sentimental del 1 al 10, en voz alta.',
      'Di qué pareja potencial de esta sala funcionaría de maravilla y cuál sería un desastre.',
      'Elige quién del grupo sobreviviría mejor a una historia contigo y pídele perdón por adelantado.',
      'Haz a una persona del grupo, mirándola a los ojos, el cumplido más atrevido que te puedas permitir.',
      'Suelta tu mejor frase para ligar a la persona elegida por el grupo, que debe responder al mismo nivel.',
      'Recita una declaración incendiaria a la persona de enfrente como si fuera la última noche en la Tierra.',
      'Propón una cita ficticia a la persona de tu derecha: adónde la llevarías y cómo querrías que acabara la noche.',
      'Mira a cada persona del grupo y dile solo "sí", "no" o "quizá", sin explicar jamás la pregunta.',
      'Aguanta un cubito de hielo en la boca mientras dices la frase más seductora que conozcas.',
      'Acerca despacio la cara a la de la persona de enfrente (si le apetece) y párate a un centímetro: el primero que se ría pierde turno.',
      'Baila una canción elegida por el grupo como si estuvieras en el videoclip, versión no apta pero bailable.',
      'Cruza la sala como en una pasarela, párate delante de la persona más atractiva y dile "nos vemos luego".',
      'Pide a cada persona del grupo una nota del 1 al 10 para tu mirada seductora.',
      'Deja una marca de pintalabios (o dibuja un corazón con un boli) en la mejilla de una persona que quiera.',
      'Juego del espejo: la persona de enfrente hace gestos de seducción y tú los repites idénticos, veinte segundos.',
      'Siéntate en las rodillas de una persona que quiera durante toda la próxima ronda.',
      'Déjate masajear la cabeza por una persona elegida por el grupo y comenta en voz alta como si estuvieras en un restaurante.',
      'Apoya la frente en la de la persona de enfrente y aguantad la mirada diez segundos: quien se ría paga prenda doble.',
      'Intercambia una prenda o un accesorio con la persona de tu izquierda hasta el final de la partida.',
      'Haz tres flexiones diciendo en cada una el nombre de una persona con la que saldrías.',
      'Di el abecedario con tu voz más sensual hasta que alguien te suplique parar (pasará pronto).',
      'Come o bebe algo de la mesa del modo más provocador posible.',
      'Bebe un sorbo mirando a los ojos a la persona más atractiva de la sala, sin apartar la mirada.',
      'Improvisa dos frases de una canción dedicada a tu última noche memorable.',
      'Cuenta la excusa más creativa que has usado para quedarte a dormir en casa de alguien.',
      'Cuenta la excusa más creativa que has usado para NO quedarte a dormir en casa de alguien.',
      'Confiesa el ritual secreto que tienes antes de una cita que promete.',
      'Imita tu rutina de preparación para una noche importante, sin saltarte pasos.',
      'Di qué superpoder elegirías para tu vida amorosa y cómo lo usarías esta misma noche.',
      'Cuenta lo más atrevido que has hecho de vacaciones y que en casa no repetirías jamás.',
      'Di lo más descarado que te han dicho en una discoteca o por la calle, y qué respondiste.',
      'Relee en voz alta, con voz de cine, el mensaje más empalagoso que hayas enviado.',
      'Cuenta tu rollo de una noche más memorable: el grupo puede hacer tres preguntas, tú solo puedes pasar una.',
      'Describe tu noche perfecta que termina en desayuno, sin saltarte la noche de en medio.',
      'Di tres sitios donde te gustaría hacerlo al menos una vez en la vida: el grupo comenta cada uno.',
      'Confiesa si esta noche hay alguien, aquí o fuera, en quien estás pensando de un modo no exactamente inocente.',
      'Recita un falso anuncio: "Se busca cómplice para noches en vela", describiendo los requisitos reales.',
      'Haz un brindis en voz alta "por mi próxima noche inolvidable" y aguanta las miradas del grupo.',
      'Llama a tu vieja llama favorita y dile "estaba pensando en nosotros", aguantando diez segundos de silencio.',
      'Manda "Estaba pensando en aquella noche…" a una persona con la que de verdad estuviste y enseña la respuesta.',
      'Escribe a tu crush "Tengo algo que decirte, pero solo en persona." y enseña la respuesta cuando llegue.',
      'Deja que el grupo escriba un mensaje atrevido (sin ofender) y mándalo a un contacto elegido por ti.',
      'Di sin filtros qué es lo primero que miras en una persona que te atrae, y admite desde cuándo lo haces.',
      'Describe el beso perfecto de primera cita y demuéstralo en el dorso de tu mano, con total entrega.',
      'Pon la cara exacta que pones cuando entiendes que la noche va a acabar muy bien.',
      'Quítate dos prendas o accesorios a tu elección, lo más despacio posible, con la banda sonora que elija el grupo.',
      'Da un azote de broma, con su consentimiento, a la persona elegida por el grupo.',
      'Reproduce cinco segundos de los sonidos que haces en la cama, versión sin vergüenza.',
      'Pon la cara que pones en el mejor momento de todos: tres segundos, cara seria, el grupo vota.',
      'Cuenta tu último sueño erótico, o invéntate uno tan creíble que nadie note la diferencia.',
      'Besa despacio el cuello de una persona que quiera, elegida por ti.',
      'Representa vestido, durante cinco segundos y con total seriedad, tu postura favorita.',
      'Di en voz alta, mirando al techo, el nombre de la persona con la que repetirías tu mejor noche.',
      'Haz un masaje de treinta segundos en la espalda a una persona que quiera: se para solo cuando ella lo diga.',
      'Susurra al oído de la persona elegida por el grupo por qué a la mañana siguiente haría falta un buen desayuno.',
      'Haz tres rondas de miradas intensas con la persona de enfrente sin reírte jamás.',
      'Describe a la persona más atractiva que has visto esta semana, con detalles.',
      'Manda "Me haces perder la cabeza." a un contacto elegido por ti y enseña la respuesta.',
      'Haz un cumplido sobre el físico, elegante pero sincero, a cada persona del grupo que quiera.',
      'Baila medio minuto de reguetón como si nadie te mirara. Te miramos todos.',
      'Déjate poner un cubito de hielo en el cuello sin cambiar la expresión.',
      'Cruza la sala como si acabaras de salir de la ducha con la toalla puesta.',
      'Interpreta la escena "nos acabamos de ver de lejos en un bar" con la persona elegida por el grupo.',
      'Susurra tu bebida favorita al oído de alguien como si fuera un secreto de Estado.',
      'Describe cómo te vestirías para una noche que tiene que salir sí o sí bien.',
      'Explica la diferencia entre un beso de saludo y un beso de verdad, con ejemplos teóricos detallados.',
      'Interpreta "el despertar junto a alguien": primero versión película romántica, luego versión realidad.',
      'Cuenta el momento exacto en que entendiste que le gustabas a alguien.',
      'Haz tu caminata más segura a través de la sala y termina con una mirada.',
      'Pide un tema al grupo e improvisa veinte segundos de discurso seductor.',
      'Lee un menú imaginario con voz de anuncio de perfume.',
      'Representa "estoy escribiendo a mi crush" con todas las fases del pánico.',
      'Di tres formas infalibles de hacerte notar por alguien sin hablar.',
      'Enseña tu mejor pose de foto de perfil y explica la estrategia.',
      'Concede a la persona de tu derecha tres preguntas sobre tu vida sentimental: debes responder al menos dos.',
      'Cuenta el cumplido más bonito que has hecho jamás y a quién.',
      'Repite "qué noche tan interesante" con cinco intenciones distintas: el grupo debe adivinarlas.',
      'Haz el gesto más romántico posible usando solo un objeto de la habitación.',
      'Organiza sobre la marcha una cita perfecta para dos personas del grupo.',
      'Enseña al grupo cómo salir con dignidad de un flirteo fracasado.',
      'Revela qué canción te recuerda a una persona concreta, y baila ocho segundos.',
      'Di qué perfume te vuelve loco y a quién de los presentes se lo asociarías.',
      'Baila una lenta de diez segundos con un cojín, con entrega auténtica.',
      'Describe al grupo tu idea de desayuno perfecto del día después.',
      'Pon la cara de cuando recibes un mensaje de la persona correcta en el momento correcto.',
      'Escribe un mensaje de buenos días capaz de derretir a cualquiera y léelo en voz alta.',
      'Elige quién del grupo interpretaría a tu crush en una película y dirígelo en una escena de dos frases.',
      'Cierra los ojos y describe tu cita ideal mientras el grupo añade imprevistos.',
    ],
    ContentTone.cattivo: [
      'Di en voz alta, uno por uno, con cuántos de los presentes te acostarías si estuvieras soltero y sin consecuencias.',
      'Mira a cada persona del grupo y di solo "sí", "no" o "depende de la noche", sin explicar la pregunta.',
      'Haz el ranking completo de los presentes del más atractivo hacia abajo y defiéndelo hasta el final.',
      'Di quién de los presentes crees que se maneja mejor en la cama, solo por instinto.',
      'Di quién se maneja peor, y pide perdón justo después.',
      'Asigna a cada presente su "especialidad" de dormitorio, basándote solo en su cara.',
      'Di a cada presente, uno por uno, si en otra vida te habrías acostado con él: solo sí o no.',
      'Elige a la persona del grupo con la que mejor sobrevivirías a una convivencia empezada por una noche juntos.',
      'Revela si alguna vez ha habido un momento de tensión, de ese tipo, entre tú y uno de los presentes.',
      'Cuenta el sueño más vergonzoso que has tenido con una persona presente, o jura que nunca has tenido ninguno.',
      'Da un beso en el cuello, con su consentimiento, a la persona elegida por el grupo.',
      'Haz un lap dance de veinte segundos a una persona que quiera: la canción la elige el grupo.',
      'Déjate vendar los ojos y adivina a tres personas del grupo tocando solo la cara.',
      'Quítate una prenda a tu elección (dignidad mediante) y déjatela quitada dos rondas.',
      'La persona de tu derecha debe quitarte un accesorio sin usar las manos, si le apetece.',
      'Intercambia un masaje de hombros de treinta segundos con una persona que quiera: el grupo decide quién de los dos lo hace mejor.',
      'Siéntate en las rodillas de la persona elegida por el grupo hasta tu próximo turno.',
      'Susurra al oído de la persona de enfrente lo más atrevido que has hecho en tu vida: ella solo puede decir "apruebo" o "guau".',
      'Apoya la cabeza en el regazo de una persona que quiera y quédate ahí una ronda entera.',
      'Baila una lenta mejilla con mejilla con la persona elegida por el grupo durante una estrofa entera.',
      'Da la vuelta a la sala y deja un beso en la mejilla a cada persona que quiera, en orden de preferencia: el orden habla por ti.',
      'Aguanta un cubito de hielo en la boca y haz un cumplido atrevido a cada presente antes de que se derrita.',
      'Recrea con una persona que quiera la pose de portada de una novela romántica y aguantadla diez segundos.',
      'Acércate a un centímetro de la cara de la persona de enfrente (si le apetece) y susurra "hola": quien se ría pierde un turno.',
      'Lee en voz alta el último mensaje del chat más picante que tengas en el móvil.',
      'Enseña la foto más sexy de ti mismo que estés dispuesto a mostrar al grupo.',
      'Manda "Me acordé de aquella noche…" a una persona con la que estuviste de verdad y enseña la respuesta.',
      'Manda "¿Te apetece que nos veamos? Solo nosotros dos." a una vieja llama elegida por ti.',
      'Lee los mensajes de tu última conversación en una app de citas, o explica por qué no puedes.',
      'Enseña tu historial de apps de citas o jura solemnemente que no has usado ninguna jamás.',
      'Deja que el grupo elija un contacto y manda "Tengo debilidad por ti desde hace tiempo. Tenía que decírtelo."',
      'Manda un audio con tu voz más sensual a un contacto elegido por el grupo: el texto lo escriben ellos (sin ofender).',
      'Deja que el grupo lea tu último sexting cambiando solo los nombres, o paga la prenda que el grupo decida.',
      'Llama a una vieja llama y dile que te has acordado de ella, aguantando treinta segundos de llamada.',
      'Abre la galería, ve al año que elija el grupo y enseña la primera foto que aparezca, sea la que sea.',
      'Di el nombre de la última persona que buscaste en redes a las dos de la mañana.',
      'Enseña el chat con la última persona con la que flirteaste y deja leer un mensaje elegido por el grupo.',
      'Manda "esta noche he soñado contigo" a un contacto elegido por el grupo y enseña la respuesta.',
      'Cuenta tu última noche de sexo en tres palabras, elegidas con mucho cuidado.',
      'Cuenta cómo empezó tu última aventura de una noche, saltándote solo los detalles que no podemos oír.',
      'Cuenta tu primera cita que acabó en la cama, parando el relato en la puerta de la habitación.',
      'Describe sin nombres a la persona de tu mejor noche: el grupo puede hacerte tres preguntas.',
      'Confiesa tu fantasía más atrevida de las que puedas decir en voz alta.',
      'Revela tu sitio público más arriesgado, y si casi os pillan.',
      'Di lo más atrevido que has hecho para llevarte a alguien a casa.',
      'Confiesa una mentira que le dijiste a una pareja y que sigue en pie.',
      'Revela el nombre en clave que usas con los amigos para hablar de tus aventuras.',
      'Haz un anuncio serísimo que empiece por "Se busca compañía para esta noche" y describe los requisitos reales.',
      'Di qué regla personal rompiste por alguien que te atraía muchísimo.',
      'Confiesa eso que hiciste una sola vez en la cama y nunca más: solo el título, sin trama.',
      'Di la edad de tu primera vez y la nota que le pondrías con perspectiva.',
      'Confiesa tu racha más larga sin nada, y la época más movida.',
      'Cuenta la vez que dijiste "me quedo solo diez minutos" y saliste a la mañana siguiente.',
      'Cuenta el cotilleo más gordo que sabes de alguien presente.',
      'Revela algo que te contaron en confianza (eliges tú la gravedad).',
      'Da el móvil desbloqueado a quien tienes a la izquierda durante treinta segundos.',
      'Deja que otra persona abra un chat al azar y léelo en voz alta.',
      'Lee en voz alta los últimos diez mensajes del chat que elija el grupo.',
      'Si existe un chat paralelo sin alguno de los presentes, admítelo y di de qué habláis.',
      'Di qué apodo usas para cada presente cuando hablas de él con otros.',
      'Manda un mensaje elegido por el grupo a la persona elegida por el grupo.',
      'Di quién del grupo crees que tiene la vida secreta más interesante, y qué sospechas exactamente.',
      'Cuenta algo que dijiste de alguien presente a sus espaldas.',
      'Di a cada persona presente lo primero que pensaste de ella al conocerla, versión sin filtros.',
      'Di quién de los presentes te ha acelerado el corazón alguna vez, aunque fuera una sola noche, o jura que nadie.',
      'Confiesa si alguna vez has cotilleado el perfil de uno de los presentes hasta fotos de hace años. ¿De quién?',
      'Revela qué pareja, real o potencial, de esta sala te intriga más de lo que admitirías.',
      'Di a quién de los presentes llevarías a una boda como acompañante para dar celos a alguien.',
      'Cuenta la última vez que hablaste de uno de los presentes en otro chat, citando textualmente.',
      'Deja que el grupo te haga tres preguntas, sin derecho a pasar: valen también las prohibidas.',
      'Responde con sinceridad absoluta a las próximas tres preguntas, sean las que sean.',
      'Di algo que nadie en esta sala sabe de ti, de lo de verdad.',
      'Cierra tu turno diciendo una verdad que nadie se espera.',
      'Imita cómo intentas ligar al final de la noche, versión sin dignidad.',
      'Baila de forma provocadora delante de la persona elegida por el grupo, que debe quedarse impasible.',
      'Representa a cámara lenta tu cara durante un beso de película, durante diez segundos.',
      'Interpreta "la mañana siguiente": enseña cómo saludas a alguien con quien no tenía que pasar nada.',
      'Recita la llamada imaginaria en la que le cuentas a tu mejor amigo la noche que acabas de pasar.',
      'Enseña cómo te comportas cuando tu plan de seducción está funcionando: cara, voz y movimientos.',
      'Haz tu "caminata triunfal" del día después a través de la sala, con la cara adecuada.',
      'Graba un audio de seducción para una pareja imaginaria y mándaselo de verdad a un amigo de confianza.',
      'Cuenta cómo seducirías a la persona elegida por el grupo si os hubierais conocido esta noche, mirándola.',
      'Di con quién de los presentes rodarías la escena de un beso para una película, si pagaran bien, y cómo te prepararías.',
      'Enumera tres cosas que hay en tu mesilla de noche, o deja que el grupo adivine y confirma.',
      'Confiesa qué objeto de tu habitación esconderías antes de dejar entrar a alguien.',
      'Describe tu "kit de noche prometedora": qué compruebas o preparas antes de salir.',
      'Cuenta el paseo de la vergüenza más largo de tu vida: trayecto, hora y outfit.',
      'Enseña a cuánta gente tienes bloqueada y di qué ex encabeza la lista.',
      'Admite qué mensaje borrarías ahora mismo si fuéramos a coger tu móvil.',
      'Enseña lo último que buscaste en internet y admite qué buscas solo en incógnito.',
      'Publica una historia elegida por el grupo (nada irreversible) y déjala puesta diez minutos.',
      'Déjate maquillar o peinar por el grupo "para una cita" y quédate así hasta el final de la partida.',
      'Ponte algo elegido por el grupo hasta el final de la partida y desfila con ello.',
      'Di quién se ha portado peor esta noche y asígnale una prenda.',
      'Cuenta la peor traición que has hecho, del tipo que sea: el grupo decide si estás perdonado.',
      'Confiesa lo más deshonesto que has hecho por celos.',
      'Confiesa si alguna vez besaste a alguien solo para que te viera otra persona. ¿Funcionó?',
      'Di a cada uno algo que nunca le has dicho a la cara.',
      'Di sin rodeos qué dos presentes acabarían juntos antes de un año si esta noche se lo propusieran.',
      'Elige a los dos presentes que mandarías juntos a una cita a ciegas y organízala de verdad por chat.',
      'Haz una predicción sobre la vida amorosa de cada presente para el próximo año: una frase por cabeza, sin piedad.',
      'Revela quién del grupo recibiría más mensajes atrevidos si publicara una historia en el gimnasio.',
      'Di quién del grupo sobreviviría peor a una relación a distancia y por qué.',
      'Mira a una cámara imaginaria y confiesa, como en un reality, qué piensas de verdad de la noche y de los presentes.',
      'Cuenta lo más absurdo que has hecho después de medianoche con el móvil en la mano: chats, llamadas o compras.',
      'Besa en la boca, durante tres segundos, a una persona del grupo que quiera, elegida por ti.',
      'Quítate dos prendas (ropa interior excluida) y quédate así dos rondas.',
      'Representa vestido tu postura favorita durante cinco segundos, con cara de estar leyendo un manual de instrucciones.',
      'Reproduce el sonido exacto que haces en el mejor momento, hasta que el grupo te crea.',
      'Da un azote, con su consentimiento, a la persona elegida por el grupo.',
      'Confiesa si tienes juguetes de dormitorio: cuántos, y dónde los escondes.',
      'Describe tu último sueño erótico con protagonista real sin decir el nombre: el grupo intenta adivinarlo.',
      'Di en voz alta lo más sucio que has escrito en un mensaje, parafraseando solo lo imprescindible.',
      'Desliza despacio un cubito de hielo por el cuello de una persona que quiera.',
      'Admite la última vez que te diste placer a solas: hoy, ayer o "prefiero la prenda".',
      'Di quién de los presentes tiene según tú la fantasía más fuerte, mirándolo a los ojos.',
      'Cuenta tu fantasía en tres palabras exactas.',
      'Enumera los sitios donde lo has hecho por categorías: casa, aire libre, público, transporte. Cuenta los puntos en voz alta.',
      'Confiesa qué habitación de tu casa ha visto las mejores cosas.',
      'Describe tu "antes": la rutina completa desde que entiendes que vais a casa juntos.',
      'Cuenta la vez que casi os pillan: dónde estabais y quién estaba llegando.',
      'Reproduce la cara que pones cuando entiendes que esta noche no se duerme.',
      'Cuenta la escena de tu despertar más vergonzoso, outfit incluido.',
      'Enseña en tu brazo cómo te gusta que te acaricien.',
      'Di quién de los presentes sobreviviría a un fin de semana entero contigo.',
      'Confiesa cuántas veces has mirado esta noche el móvil por la persona que te interesa.',
      'Llama a la persona de tu última noche y pídele una nota del uno al diez, o paga la prenda del grupo.',
      'Lee en voz alta, censurando solo los nombres, el mensaje más subido de tono que hayas recibido.',
      'Describe la ropa interior que llevas esta noche y admite si fue una elección estratégica.',
      'Revela tu momento favorito: por la mañana temprano, de madrugada o en la pausa de la comida.',
      'Cuenta tu vez más rápida y la más larga, en minutos honestos.',
      'Di qué película te hizo descubrir cosas que luego quisiste probar.',
      'Confiesa qué hay de verdad en tu mesilla de noche, objeto por objeto.',
      'Enumera tres cosas que no repetirías jamás en la cama y una que repetirías esta noche.',
      'Asigna a cada presente un título de película no apta para menores basado solo en su cara.',
      'Cuenta la excusa exacta que usaste la última vez para irte a la mañana siguiente.',
      'Di con cuántos contactos de tu agenda ha pasado algo: solo el número.',
      'Haz el ranking de tus ex: nota técnica y nota artística. Sin nombres. O con ellos.',
      'Revela el día y la hora de tu último sexting, con precisión.',
      'Confiesa el mensaje que mandarías ahora mismo si no hubiera consecuencias, y a quién.',
      'Cuenta la vez que dijiste "solo subo a por un café" sabiendo perfectamente cómo iba a acabar.',
      'Expón tu teoría sobre qué hace a alguien inolvidable en la cama.',
      'Di quién de los presentes te sorprendería más en la cama, para bien o para mal.',
      'Representa la diferencia entre tu primer beso de la vida y cómo besas ahora.',
      'Cuenta lo más fuerte que has hecho de vacaciones, nombrando la ciudad.',
      'Revela si esta noche acabará como una noche cualquiera o si ya tienes un plan. Sé honesto.',
      'Haz una llamada perdida a tu última llama. Si devuelve la llamada, responde en manos libres.',
      'Cuenta la vez que rompiste tu regla más férrea por una sola noche, y si mereció la pena.',
      'Di qué persona de tu pasado no debería volver a escribirte jamás, y por qué lo haría igualmente.',
      'Confiesa qué prenda de tu armario existe solo para las noches que prometen.',
    ],
  };

  /// Verità per tono: 150 ciascuna.
  static const Map<String, List<String>> verita = {
    ContentTone.soft: [
      '¿Qué es lo más vergonzoso que has hecho en público?',
      '¿Cuál fue tu mentira más gorda de pequeño?',
      '¿Cuál es tu placer culpable musical?',
      '¿Qué película te ha hecho llorar más?',
      '¿Cuál es la tontería más grande por la que has discutido?',
      '¿Cuál es tu peor defecto según tú?',
      '¿Qué defecto te atribuyen tus amigos y tú no reconoces en absoluto?',
      '¿Qué es lo más caro que has roto?',
      '¿Has fingido estar enfermo para librarte de algo?',
      '¿Qué excusa usas más a menudo?',
      '¿Qué haces cuando estás solo y no te ve nadie?',
      '¿Cuál es tu costumbre más rara?',
      '¿Cuánto tiempo pasas de verdad en el móvil cada día?',
      '¿Qué app abres más veces sin motivo?',
      '¿Cuál fue tu última búsqueda en internet, la de verdad?',
      '¿Cuál es la foto más antigua que tienes en el móvil?',
      '¿Quién es la última persona a la que escribiste?',
      '¿Cuál es el mensaje más vergonzoso que has mandado?',
      '¿Has mandado un mensaje a la persona equivocada? ¿Qué decía?',
      '¿Qué es lo más bonito que te han dicho?',
      '¿Cuál es el cumplido más raro que has recibido?',
      '¿Quién es la persona más importante de tu vida?',
      '¿A quién llamarías con un problema serio a las tres de la mañana?',
      '¿Qué es lo que más valoras en un amigo?',
      '¿Cuál ha sido el mejor momento de tu año?',
      '¿Cuál ha sido el momento más difícil de tu año?',
      '¿Qué te da más miedo del futuro?',
      '¿Cuál es el sueño que todavía no has contado a nadie?',
      '¿Qué harías si mañana no tuvieras que trabajar nunca más?',
      'Si pudieras cambiar una decisión, ¿cuál sería?',
      '¿De qué estás más orgulloso?',
      '¿Qué cumplido te gustaría recibir?',
      '¿Qué te pone de buen humor en cinco minutos?',
      '¿Qué es lo que te hace enfadar más rápido?',
      '¿Cuál es la manía de la que no consigues librarte?',
      '¿Eres más ordenado o más desordenado de lo que admites?',
      '¿Cuándo fue la última vez que lloraste de risa?',
      '¿Qué es lo más valiente que has hecho?',
      '¿Qué no harías jamás por dinero?',
      '¿Cuánto habría que pagarte por raparte la cabeza?',
      '¿Cuál es tu talento oculto?',
      '¿Qué es eso que todo el mundo sabe hacer menos tú?',
      '¿Qué es lo más difícil que has aprendido?',
      '¿Qué nota le pondrías a tu vida ahora mismo, del 1 al 10?',
      '¿Qué te falta para llegar al 10?',
      '¿Cuál es el sitio más bonito en el que has estado?',
      '¿Dónde te gustaría vivir si pudieras elegir?',
      '¿Qué viaje repetirías mañana mismo?',
      '¿Cuáles son las peores vacaciones que has tenido?',
      '¿Has perdido un vuelo o un tren? ¿Cómo acabó?',
      '¿Qué es lo más raro que has comido?',
      '¿Qué plato cocinas mejor?',
      '¿Cuál es tu comida de consuelo?',
      '¿Comerías el mismo plato un mes entero por mil euros?',
      '¿Qué es lo más inútil que has comprado?',
      '¿Cuánto tardas de verdad en arreglarte?',
      '¿Qué prenda no tiras aunque deberías?',
      '¿Qué moda seguiste y ahora reniegas de ella?',
      '¿Qué corte de pelo te arrepientes de haberte hecho?',
      '¿Te harías un tatuaje? ¿Dónde y de qué?',
      '¿Qué has hecho solo por contentar a otra persona?',
      '¿Has fingido entender algo para no quedar mal?',
      '¿Sobre qué tema fanfarroneas más?',
      '¿Qué libro dices que has leído pero no terminaste?',
      '¿Qué serie abandonaste a la mitad?',
      '¿Qué personaje de ficción se parece más a ti?',
      'Si fueras un animal, ¿cuál serías y por qué?',
      'Si tuvieras que cambiarte el nombre, ¿cuál elegirías?',
      '¿Qué apodo odiabas de pequeño?',
      '¿Qué es lo más aburrido que has hecho por trabajo?',
      '¿Qué compañero de trabajo o de clase no soportabas y por qué?',
      '¿Qué llevas aplazando más tiempo?',
      '¿A qué hora te vas a dormir de verdad?',
      '¿Cuántas veces apagas la alarma antes de levantarte?',
      '¿Cuál es tu rincón favorito de casa?',
      '¿Qué salvarías si tuvieras que huir de casa en un minuto?',
      '¿A qué objeto le tienes más cariño?',
      '¿Cuál es el mejor regalo que has recibido?',
      '¿Cuál es el peor regalo que te han hecho?',
      '¿Has reciclado alguna vez un regalo?',
      '¿Qué propósito de Año Nuevo no has cumplido jamás?',
      '¿Qué costumbre te gustaría eliminar?',
      '¿Qué costumbre te gustaría empezar?',
      '¿A quién del grupo llamarías para pedir un consejo serio?',
      '¿Quién del grupo te hace reír más?',
      '¿Qué has aprendido de las personas presentes esta noche?',
      '¿Qué te gustaría que el grupo supiera de ti?',
      '¿Cuál es la pregunta que esperabas que no saliera esta noche?',
      '¿Hay algo que siempre has querido preguntarle a alguien de aquí?',
      'Si tuvieras que describir esta noche con una palabra, ¿cuál sería?',
      '¿Qué es lo más vergonzoso que te pasó en el colegio?',
      '¿Cuál es el sueño nocturno más absurdo que recuerdas?',
      '¿Cuál es la mentira piadosa que dices más a menudo?',
      '¿Qué comida finges apreciar por pura educación?',
      'Si tuvieras un superpoder por un día, ¿qué harías primero?',
      '¿A qué famoso invitarías a cenar y qué le preguntarías?',
      '¿Qué es lo más divertido que ha pasado en una reunión de tu familia?',
      'Si pudieras cambiar tu vida con alguien un día, ¿a quién elegirías?',
      '¿Qué canción cantas siempre con la letra equivocada?',
      '¿Qué es lo más raro que has hecho por aburrimiento?',
      '¿Se te ha escapado la risa en un momento prohibidísimo? Cuenta.',
      '¿Qué ridículo te hace reír hoy pero en su momento te destrozó?',
      '¿Cuál es el objeto más raro que guardas en tu cuarto?',
      '¿Qué es lo más infantil que sigues haciendo hoy?',
      'Si tu vida fuera una película, ¿qué actor te interpretaría?',
      '¿Cuál fue tu peor idea "genial"?',
      '¿Has cantado frente al espejo usando el cepillo de micrófono?',
      '¿Qué palabra pronuncias siempre mal?',
      '¿Cuál es tu récord más absurdo, cuente lo que cuente como récord?',
      '¿Qué harías primero si mañana ganaras un millón?',
      '¿Cuál es la app más inútil que has descargado y jamás usado?',
      '¿Te has dormido en un sitio absurdo? ¿Dónde?',
      '¿Qué buscas en internet porque te da vergüenza no saberlo?',
      '¿Qué plato arruinaste de la forma más espectacular?',
      '¿Qué regla de tu casa creías normal y era rarísima?',
      '¿Qué personaje de dibujos te daba miedo de pequeño?',
      '¿Qué es lo más absurdo que creías de niño?',
      '¿Has contestado al saludo de alguien que saludaba a otra persona?',
      '¿Qué notificación te da más ansiedad?',
      '¿Qué canción te dispara los recuerdos cada vez?',
      'Si pudieras teletransportarte un día a cualquier sitio, ¿adónde irías?',
      '¿Qué trabajo soñabas de pequeño?',
      '¿Qué es eso que a todo el mundo le encanta y a ti no?',
      '¿Qué programa basura ves y defenderías a muerte?',
      '¿Hablas con tu mascota o con las plantas como si lo entendieran todo?',
      '¿Qué es lo que peor haces pero sigues haciendo con entusiasmo?',
      '¿Cuál es el mensaje más bonito que guardas en el móvil?',
      '¿Qué teoría disparatada te crees un poco aunque sepas que es absurda?',
      '¿Cuál es tu plan de supervivencia para un apocalipsis zombi?',
      '¿Preferirías volar o leer la mente, y por qué?',
      '¿Cuál es la excusa más creativa que has usado por un retraso?',
      '¿Qué hacías de pequeño que te gustaría que fuera aceptable hoy?',
      '¿Quién del grupo sobreviviría más tiempo en una isla desierta según tú?',
      '¿Qué palabra española te parece más graciosa?',
      '¿Qué sonido o ruido no soportas en absoluto?',
      '¿Qué es lo más bonito que has hecho en secreto por alguien?',
      '¿Has ganado algo en un concurso o una lotería? ¿Qué?',
      '¿Qué sabor de helado prohibirías por ley?',
      '¿Qué película adora todo el mundo y tú nunca lograste terminar?',
      '¿Qué comida finges que no te gusta pero comerías a escondidas?',
      '¿Qué canción cantas solo cuando estás seguro de que nadie te oye?',
      '¿Cuál es tu costumbre más rara cuando estás solo en casa?',
      '¿Cuál es tu talento más inútil?',
      '¿Cuál es tu miedo más irracional?',
      '¿Qué hay de vergonzoso en tu historial de YouTube?',
      '¿Qué excusa usas más para irte de una fiesta?',
      '¿Qué dibujos animados verías todavía hoy sin vergüenza?',
      'Si pudieras cambiar tu vida con uno de los presentes un día, ¿con quién?',
      '¿Cuál fue el mejor día de tu vida hasta ahora?',
      '¿Qué es lo último que te hizo reír a carcajadas?',
    ],
    ContentTone.piccante: [
      '¿Cómo fue tu primera vez: edad, lugar y nota del 1 al 10?',
      '¿Con cuántas personas has pasado la noche? Puedes responder con un rango, pero un rango honesto.',
      '¿Cuál es el sitio más absurdo en el que lo has hecho?',
      '¿En qué sitio te gustaría hacerlo al menos una vez en la vida?',
      '¿Te has acostado con alguien el mismo día de conocerlo?',
      '¿Cuál fue tu rollo de una noche más memorable?',
      '¿Y el que querrías borrar de la memoria?',
      '¿Has pasado la noche con un amigo y fingido que nada al día siguiente?',
      '¿Has hecho sexting? ¿Con cuántas personas distintas?',
      '¿Cuál es el mensaje más atrevido que has escrito? Puedes parafrasear, pero poco.',
      '¿Has mandado una foto tuya atrevida? ¿Todavía te fías de quien la recibió?',
      '¿Has recibido una foto atrevida sin pedirla? ¿Qué respondiste?',
      '¿Cuál es tu fantasía más confesable?',
      '¿Y la que confesarías solo después de medianoche?',
      'Un trío: ¿lo has pensado en serio alguna vez? Sí o no.',
      '¿Hay una persona con la que repetirías todo encantado, aunque fuera solo una noche?',
      '¿Mejor una noche inolvidable sin continuación o diez citas perfectas sin noche?',
      '¿Qué te hace perder la cabeza en un beso?',
      '¿Quién fue tu mejor beso? ¿Y el peor?',
      '¿Has besado a dos personas la misma noche alguna vez?',
      '¿Has besado a alguien por una apuesta? ¿Mereció la pena?',
      '¿Has besado a alguien y te arrepentiste mientras todavía lo estabas besando?',
      '¿Te has despertado junto a alguien preguntándote cómo había pasado?',
      '¿Te has escapado de casa de alguien antes de que se despertara?',
      '¿Has sido tú del que se escaparon? ¿Cuándo lo entendiste?',
      '¿Cuál es tu récord de tiempo entre la primera mirada y el primer beso?',
      '¿Qué cuenta más en la cama según tú: química, imaginación o entrenamiento?',
      'En la cama, ¿eres más tradicional o experimentador? Una sola palabra.',
      '¿Luces encendidas o apagadas? Defiende la respuesta.',
      '¿Eres más de mañana, de tarde o de madrugada? Sé específico.',
      '¿Música sí o música no? ¿Y cuál?',
      '¿Cuál es el mejor cumplido que te han hecho en la cama? Puedes parafrasear.',
      '¿Has fingido pasarlo bien por amabilidad? ¿Cuántas veces, a ojo?',
      '¿Te has reído en el momento menos oportuno? Cuenta.',
      '¿Qué es lo más vergonzoso que te ha pasado en un momento íntimo?',
      '¿Te han interrumpido en el mejor momento? ¿Qué o quién?',
      '¿Te has vestido a toda prisa porque llegaba alguien?',
      '¿Has fingido dormir para evitar un momento de intimidad?',
      '¿Has exagerado los detalles de una noche al contársela a tus amigos?',
      '¿Has tenido una relación solo física? ¿Cuánto duró?',
      '¿Tu relación solo física acabó porque se acabó la atracción o porque uno se enamoró?',
      '¿Has tenido un "amigo especial" del que el grupo nunca supo nada?',
      '¿Hay alguien que te atrae y que a los demás les parecería improbable?',
      '¿Qué es lo primero que notas en una persona que te atrae? Sé honesto, no diplomático.',
      '¿Qué gesto inocente te parece irresistible en una persona?',
      '¿Qué prenda o detalle te hace girar la cabeza?',
      '¿Te consideras bueno en la cama? Nota del 1 al 10, sin falsa modestia.',
      '¿Qué mejorarías de ti como amante?',
      '¿Cuál es tu arma de seducción principal? El grupo puede pedirte una demostración.',
      '¿Qué frase para ligar funcionaría de verdad contigo?',
      '¿Has usado una frase para ligar sacada de internet? ¿Cómo fue?',
      '¿Has flirteado para conseguir un favor? ¿Funcionó?',
      '¿Has flirteado con dos personas la misma noche? ¿Se dieron cuenta la una de la otra?',
      '¿Has dado un número falso? ¿A quién y por qué?',
      '¿Has pedido un número y luego no escribiste jamás? ¿Por qué?',
      '¿Qué es lo más atrevido que has hecho para llamar la atención de alguien?',
      '¿Qué es lo más atrevido que has hecho en un local público?',
      '¿Qué es lo más atrevido que has hecho en un transporte?',
      '¿Has tenido un flirteo en vacaciones? ¿Hasta dónde llegó?',
      '¿Has salido con alguien con una diferencia de edad que dio que hablar? ¿Cuántos años?',
      '¿Has estado colado por la pareja de un amigo? ¿Hiciste algo al respecto?',
      '¿Has besado a alguien de esta sala? El silencio cuenta como un sí.',
      '¿Has pensado en una persona presente de un modo no exactamente inocente? Sí o no.',
      '¿Quién es la persona más atractiva de esta sala? La pareja, si está presente, no vale.',
      'Si tuvieras que fingir un noviazgo de un mes con alguien del grupo, ¿quién aguantaría mejor el papel?',
      '¿Quién del grupo tiene una vida amorosa más movida de lo que cuenta?',
      '¿Quién del grupo tendría más éxito en una app de citas para aventuras de una noche?',
      '¿Has usado una app de citas? Cuenta el mejor match y el peor.',
      '¿Cuál es la mentira más gorda que has leído (o escrito) en un perfil?',
      '¿Has reconocido a alguien conocido en una app de citas? ¿Qué hiciste?',
      '¿Has chateado hasta el amanecer con alguien a escondidas de todos?',
      '¿Qué notificación te ha acelerado más el corazón últimamente?',
      '¿Has releído una conversación entera para descifrar qué quería decir de verdad una persona?',
      '¿Has escrito, borrado y reescrito un mensaje durante más de diez minutos? ¿A quién?',
      '¿Qué mensaje lamentas más: uno que mandaste o uno que no mandaste jamás?',
      '¿Has mandado un mensaje atrevido a quien no debía llegar? ¿Qué decía?',
      '¿Has escrito a un ex después de medianoche? ¿Cómo acabó?',
      '¿Has vuelto con un ex solo por una noche? ¿Repetirías?',
      '¿Todavía sientes atracción por un ex? ¿Cuál, si tienes valor?',
      '¿Qué es lo que más echas de menos de tu última historia, de esas cosas que no se cuentan en una cena?',
      '¿Por qué terminó de verdad tu última historia?',
      '¿Has tenido una historia secreta? ¿Quién lo sabía?',
      '¿Has sido el secreto de alguien? ¿Cuándo lo descubriste?',
      '¿Has tenido una historia con un compañero de trabajo o de clase? ¿Quién lo sabía?',
      '¿Cuál fue tu flechazo más fuerte? ¿En qué acabó?',
      '¿Tu "tipo ideal" corresponde de verdad a las personas con las que sales?',
      '¿Qué elegirías entre un año sin besos y un año sin móvil?',
      '¿Qué es lo más loco que has hecho por una noche con alguien?',
      '¿Cuál es la excusa más absurda que has inventado para volver a ver a alguien?',
      '¿Te has vestido a propósito para que te notara una persona concreta? ¿Funcionó?',
      '¿Has dado un rodeo larguísimo solo para pasar "por casualidad" delante de alguien?',
      '¿Cuáles fueron tus peores calabazas? ¿Cómo reaccionaste?',
      'Tus mejores calabazas dadas: ¿fuiste elegante o brutal?',
      '¿Has dicho "te quiero" sin sentirlo? ¿En qué momento?',
      '¿Te lo han dicho en un momento clarísimamente equivocado? ¿Cuál?',
      '¿Qué no repetirías jamás en una primera cita?',
      '¿Cómo es tu primera cita perfecta: cómo empieza y, sobre todo, cómo termina?',
      'En la primera cita, ¿quién debe dar el primer paso? ¿Tú lo has dado alguna vez?',
      '¿Cuál es el momento exacto en que entiendes que la noche acabará bien?',
      '¿Qué señal te hace entender que es mejor pedir un taxi e irte a casa solo?',
      '¿Has pasado una noche entera solo hablando cuando estaba claro que podía pasar otra cosa? ¿Arrepentimientos?',
      '¿Qué te gustaría tener más valor de pedirle a una pareja?',
      '¿Qué es lo más romántico y lo más atrevido que has hecho en la misma noche?',
      'Cuenta la vez que un flirteo salió mucho mejor de lo previsto, hasta donde quieras.',
      '¿Qué sueño despierto tienes más a menudo con una persona real? Sin nombres, todos los detalles confesables.',
      'Si tu vida amorosa fuera una película, ¿qué título tendría y para qué edad sería?',
      '¿Qué te alegra que tu madre no sepa de tu vida privada?',
      '¿A qué pregunta de este juego esperabas no tener que responder jamás? Ahora responde.',
      '¿Has fingido un orgasmo alguna vez? ¿Cuántas, a ojo?',
      '¿Cuál es tu postura favorita? La respuesta de verdad, no un voto a la banalidad.',
      '¿Arriba o abajo? Justifica la respuesta.',
      '¿Eres ruidoso o silencioso? ¿Hay alguien que podría confirmarlo?',
      '¿Dónde te gusta que te besen, además de la boca?',
      '¿Cuál es tu zona más sensible? Nómbrala o señálala, tú eliges.',
      '¿Qué te pones para dormir cuando no duermes solo?',
      '¿Has dormido desnudo en casa de otra persona la primera noche?',
      '¿Preliminares largos o directo al grano? Sé honesto, no elegante.',
      '¿Cuánto duró tu maratón más larga? Redondea, pero no hacia arriba.',
      '¿Te has excitado en el momento más inoportuno posible? ¿Dónde estabas?',
      '¿Has comprado lencería pensando en una persona concreta? ¿Llegó a verla?',
      '¿Has tenido un sueño erótico con un amigo? ¿Puedes mirarlo igual que antes?',
      '¿Luces, espejos u oscuridad total: con qué estás más cómodo?',
      '¿Qué cumplido te gustaría oír en la cama y nadie te ha hecho jamás?',
      '¿Qué hace inolvidable un beso para ti: técnica, momento o persona? Pon un ejemplo real.',
      '¿Qué beso recuerdas más a menudo?',
      '¿Quién te enseñó, de hecho, a besar?',
      '¿Qué es lo más atrevido que has hecho con otras personas en la habitación, sin que se enteraran?',
      '¿Prefieres conquistar o que te conquisten? Ejemplos concretos.',
      '¿En qué momento del día te sientes irresistible?',
      '¿Qué parte de tu cuerpo te gusta más?',
      '¿Y cuál recibe más cumplidos?',
      '¿Te has mirado al espejo después de una buena noche y te has guiñado el ojo?',
      '¿Qué es lo más bonito que te han susurrado al oído?',
      '¿Has bailado una lenta pensando "ya está"?',
      '¿Cuál fue tu flirteo de verano más memorable?',
      '¿Dónde flirteas más: gimnasio, trabajo o transporte público?',
      'Para flirtear: ¿audios o mensajes escritos? ¿Por qué?',
      '¿Cuál es tu hora favorita para un primer beso?',
      '¿Qué te hace entender que un abrazo no es solo un abrazo?',
      '¿Qué gesto te hace entender que alguien está intentando ligar contigo?',
      '¿Cómo sabes que están a punto de besarte? Cuenta la última vez.',
      '¿Cuál es tu récord de mensajes en un día con una sola persona?',
      '¿Cuál fue tu enamoramiento más largo jamás confesado?',
      '¿Qué haces solo cuando alguien te gusta de verdad?',
      '¿Te gusta más la conquista o la confirmación?',
      '¿Cuál es la frase que te hizo caer rendido?',
      '¿Has salido con dos personas el mismo fin de semana alguna vez?',
      '¿Qué cita repetirías idéntica mañana por la noche?',
      '¿Quién del grupo besaría mejor según tu instinto?',
      '¿Cuál es la mejor parte: antes, durante o después del beso?',
    ],
    ContentTone.cattivo: [
      '¿Con cuántas personas has estado de verdad? Esta vez sin descuentos.',
      '¿Has pasado la noche con alguien de esta sala? El silencio cuenta como un sí.',
      '¿Con quién de nosotros pasarías la noche, si tuvieras que elegir ahora un nombre?',
      '¿Has pensado en alguien de nosotros estando en la cama con otra persona? Sí o no.',
      '¿A quién de nosotros besarías si no hubiera consecuencias? Un nombre.',
      '¿Has besado ya a alguien de esta sala? ¿Todavía lo piensas?',
      '¿Has deseado a la pareja de alguien aquí presente? Sí o no.',
      '¿Has soñado con uno de nosotros de un modo que no contarías en el desayuno? ¿Con quién?',
      'Si tuvieras que pasar una semana en una isla desierta con uno de nosotros, ¿quién la haría interesante?',
      '¿Quién de nosotros tiene seguro una vida de cama más interesante de lo que cuenta?',
      '¿Y quién de nosotros la cuenta mucho mejor de lo que es?',
      'Entre todos los presentes, ¿a quién te llevarías a casa esta noche si fuéramos todos desconocidos en un bar?',
      '¿Has sentido atracción por uno de nosotros mientras tenía pareja? ¿Se te pasó?',
      '¿Cuál es el pensamiento más prohibido que has tenido durante esta partida?',
      '¿Cuál es la fantasía que no has confesado jamás a nadie? Esta noche nos toca a nosotros.',
      '¿Qué querrías más a menudo en la cama pero nunca tienes el valor de pedir?',
      '¿Qué probaste una sola vez y no repetirías jamás?',
      '¿Y qué repetirías ahora mismo?',
      'La mejor persona con la que has estado en la cama: ¿la conocemos?',
      '¿Y la peor: la conocemos?',
      '¿Te has acostado con dos personas distintas en la misma semana? ¿Y en el mismo día?',
      '¿Con cuántas personas te has acostado sin recordar su nombre al día siguiente?',
      '¿Cuál es el sitio más absurdo donde has tenido sexo? Sin rodeos.',
      '¿Y el más arriesgado? ¿Casi os pillan alguna vez?',
      '¿Has hecho sexting estando rodeado de gente que no se enteraba de nada?',
      '¿Has mandado una foto tuya sin nada de ropa? ¿Todavía te fías de quien la recibió?',
      '¿Existen fotos o vídeos tuyos que no deben salir jamás? ¿Quién los tiene ahora?',
      '¿Has recibido una propuesta de trío? ¿Qué respondiste?',
      'Un trío: ¿lo harías si nadie se enterara jamás? Sí o no.',
      '¿Has fingido en la cama? ¿Cuántas veces, a ojo?',
      '¿Te han dado a entender que contigo fue decepcionante? ¿Cómo lo encajaste?',
      '¿Cuál es el cumplido más atrevido que te han hecho en la cama? Parafrasea, pero poco.',
      '¿Cuál es tu mayor inseguridad en la cama?',
      '¿Qué elegirías entre un año sin sexo y un año sin móvil?',
      '¿Cuánto hace de tu última vez? Sé honesto al menos con el mes.',
      '¿Cuál es tu récord en una misma noche? Responde solo con un número.',
      'Tu peor rollo de una noche: ¿qué salió mal?',
      '¿Te has cruzado por casualidad con un rollo de una noche? ¿Cómo os saludasteis?',
      '¿Te has escapado de casa de alguien antes de que despertara? Cuenta la huida.',
      '¿Cuál es el mensaje más subido de tono que tienes en el móvil ahora mismo?',
      '¿Qué es lo más atrevido que has hecho con alguien recién conocido?',
      '¿Has tenido una historia con una persona comprometida? ¿Lo sabías desde el principio?',
      '¿Has sido la aventura secreta de alguien? ¿Cuándo lo entendiste?',
      '¿Has sido infiel? ¿Te han sido infiel? Responde a las dos.',
      'Si una infidelidad quedara en secreto para siempre, ¿seguiría siendo una infidelidad para ti? ¿Has probado la teoría?',
      '¿Cuál es la mentira más gorda que has dicho para tapar una noche?',
      '¿Has usado la casa, o la cama, de otra persona sin que lo supiera? ¿De quién?',
      '¿Has mentido sobre con quién pasaste la noche? ¿A quién?',
      '¿Qué hay en tu mesilla que no querrías que encontrara tu madre?',
      '¿Qué búsqueda en incógnito borrarías para siempre si pudiéramos verla?',
      '¿Cuál es tu kink más confesable? ¿Y a qué distancia está del menos confesable, del 1 al 10?',
      '¿Luces o penumbra? ¿Arriba o abajo? ¿Mañana o noche? Responde en ráfaga sin pensar.',
      '¿Qué palabra o tono de voz te hace perder la cabeza si se usa bien?',
      '¿Te has enamorado de alguien con quien debía ser "solo una noche"? ¿Cómo acabó?',
      '¿Alguien se ha enamorado de ti cuando para ti era solo una noche? ¿Cómo lo gestionaste?',
      '¿Has vuelto a ver a alguien solo porque en la cama era memorable, sabiendo que era una pésima idea?',
      '¿Has dicho un nombre equivocado en el peor momento? ¿O te lo han dicho a ti?',
      '¿Qué es lo más absurdo que has hecho justo después: huir, comer, llamar a alguien?',
      '¿Qué regla tuya has roto más veces: nunca con amigos, nunca con compañeros de trabajo, nunca con ex?',
      'Nunca con amigos: ¿cuántas veces has roto justo esa?',
      '¿A quién de nosotros no invitarías a tu boda?',
      '¿Quién de nosotros te cae peor hoy?',
      '¿A quién de nosotros has criticado a sus espaldas? ¿Qué dijiste?',
      '¿A quién de nosotros consideras un amigo de verdad y a quién solo un conocido?',
      '¿A quién de nosotros contactas solo cuando necesitas algo?',
      '¿Quién de nosotros exagera más sus historias cuando las cuenta?',
      '¿Quién de nosotros posa en redes de un modo más distinto a como es en persona?',
      'Si el grupo votara al más falso de nosotros, ¿quién ganaría según tú?',
      '¿Has traicionado la confianza de alguien presente?',
      '¿Has leído mensajes que no eran tuyos? ¿Qué descubriste?',
      '¿Has mentido en este grupo sobre algo importante? ¿Sobre qué?',
      '¿Cuál es la mentira que sigues contando todavía hoy?',
      '¿Cuál es la verdad que estás evitando decirle a alguien de esta sala?',
      '¿Has inventado un compromiso para no ver al grupo? ¿Cuántas veces este año?',
      '¿Has escrito en un chat algo sobre uno de nosotros que no repetirías aquí?',
      '¿Qué es lo más cruel que has escrito de alguien y nunca borraste?',
      '¿Qué es lo peor que le has hecho a un ex?',
      '¿Has fingido perdonar sin perdonar?',
      '¿Sigues enfadado con alguien de nosotros? ¿Por qué?',
      '¿Has llorado por culpa de uno de nosotros sin decírselo jamás?',
      '¿Te has alegrado de la mala suerte de alguien? ¿De quién?',
      '¿Qué es lo más egoísta que has hecho?',
      '¿Has usado un secreto de alguien en tu beneficio? ¿Cómo salió?',
      '¿Qué mensaje de tu móvil te pondría más en apuros si lo leyéramos ahora?',
      '¿Hay algo en tu móvil que rompería una amistad de esta sala?',
      '¿Quién de nosotros no debe ver jamás tu galería, y qué encontraría exactamente?',
      'Si pudieras leer un día los chats de uno de nosotros, ¿a quién elegirías y qué buscarías?',
      '¿Has hecho una captura de un chat para hacerla circular? ¿A quién se la mandaste?',
      '¿Qué temes que digamos de ti esta noche en cuanto salgas por la puerta?',
      '¿Qué es eso que todos en el grupo piensan pero nadie ha dicho jamás en voz alta?',
      '¿A quién de los presentes le escondes algo ahora mismo?',
      '¿Hay alguien en esta sala a quien hayas querido? ¿Lo sigues queriendo?',
      '¿Hay alguien a quien quieres y no lo sabe? ¿Por qué no se lo has dicho?',
      '¿Has deseado a la persona que le gustaba a un amigo? ¿Hiciste algo al respecto?',
      '¿Qué versión de los hechos nos contaste mejor de lo que fue en realidad?',
      '¿Qué no nos dirás jamás a ninguno de nosotros?',
      '¿Qué querrías que nadie te preguntara jamás? Prepárate: ahora el grupo puede preguntártelo.',
      '¿Quién de nosotros tiene más probabilidades de tener un chat secreto que nadie sospecha?',
      '¿Qué pareja de esta sala, real o potencial, apostarías dinero a que acaba junta?',
      '¿Quién de nosotros ya ha sido pillado en una mentira esta noche, según tú?',
      '¿Cuál es el secreto del grupo que creemos que no sabes?',
      '¿Preferirías que leyéramos tus chats o que escucháramos tus audios de las dos de la mañana?',
      'Si las paredes de tu cuarto hablaran, ¿cuál sería la primera historia que contarían?',
      '¿Cuál es la noche que el grupo no debe conocer jamás? Obviamente ahora queremos el resumen.',
      '¿Qué has hecho que, si lo contaras ahora, cambiaría la idea que tenemos de ti?',
      'Di un porcentaje honesto: ¿cuánto de lo que has respondido esta noche era toda la verdad?',
      '¿Quién de nosotros ha mentido más esta noche según tú, y en qué respuesta?',
      'Penúltima y simple: ¿hay algo que te habría gustado que te preguntáramos esta noche? Responde como si lo hubiéramos hecho.',
      '¿Has fingido un orgasmo con alguien que conocemos?',
      '¿Cuál es tu postura favorita? Nombre y apellido de la postura, esta vez.',
      '¿Tienes juguetes en casa? ¿Cuántos, y quién más lo sabe?',
      '¿Te has tocado pensando en alguien de esta sala? Sí o no, sin nombres.',
      '¿Cuántas veces a la semana, de media? Honestamente.',
      'El mejor sexo de tu vida: ¿dónde estabais y qué lo hizo el mejor?',
      '¿Has tenido sexo con más de una persona en las mismas veinticuatro horas alguna vez?',
      '¿Has hecho fotos o vídeos durante? ¿Existen todavía?',
      'Sexo en la primera cita: ¿cuántas veces ha pasado de verdad?',
      '¿Cuál es el fetiche que admitirías solo en esta sala?',
      'Comida, hielo o venda en los ojos: ¿qué has probado ya y qué te gustaría probar?',
      '¿Te excita más el riesgo de que os pillen o la calma total? Pon un ejemplo vivido.',
      '¿Qué es lo más sucio que te han susurrado jamás? Parafrasea lo mínimo.',
      '¿Has tenido sexo sabiendo que alguien podía oíros? ¿Os oyó?',
      'Tu récord personal: ¿cuánto pasó entre conocer a alguien y la cama?',
      '¿Qué rincón de tu casa mirarían distinto tus invitados si supieran?',
      '¿Has vuelto a quedar con un ex solo por el sexo, negándolo ante todos?',
      'Estriptis: ¿has hecho alguno de verdad? ¿Y recibido?',
      '¿Cuál es tu número exacto? No un rango: el número.',
      'El tiempo más corto entre el "encantado" y la cama: ¿horas o minutos?',
      '¿Qué hiciste una vez, juraste "nunca más", y volviste a hacer?',
      '¿Quién fue la persona más equivocada con la que estuviste? ¿Por qué era equivocada?',
      '¿Qué pensamiento has tenido esta noche sobre alguien y no dirías jamás?',
      '¿Mejor por la mañana o por la noche? ¿Y tus parejas estaban de acuerdo?',
      '¿Cuál es tu récord de veces en un solo día?',
      '¿Has llorado después? ¿Por qué?',
      '¿Te has reído durante? ¿Cómo acabó?',
      '¿Qué te han pedido en la cama y rechazaste?',
      '¿Y qué pediste tú y te lo rechazaron?',
      '¿Qué fetiche te parece absurdo en los demás pero un poco te intriga?',
      '¿Qué miras primero en una persona cuando piensas "sí, caería"?',
      '¿Has tenido una historia que nadie en esta sala sospecha ni siquiera ahora?',
      '¿Qué noche repetirías idéntica, de principio a fin?',
      '¿Y cuál borrarías pagando?',
      '¿Qué mentira has dicho para parecer más experto?',
      '¿Te ha pasado no recordar el nombre a la mañana siguiente? ¿Cómo lo resolviste?',
      '¿En qué sitio no lo repetirías jamás? ¿Motivo práctico o emotivo?',
      '¿Quién te hizo cambiar de idea sobre qué significa "bueno en la cama"?',
      '¿A qué pregunta de este tema ya has mentido esta noche?',
      '¿Qué harías esta noche si estuvieras seguro de que ninguno de nosotros lo sabrá jamás?',
      '¿Quién del grupo ha entendido más cosas de ti esta noche, y cuánto te preocupa?',
      'Última: ¿esta noche duermes solo por elección o por falta de alternativas? Sé despiadado contigo mismo.',
      '¿Te gusta el sexo anal? Responde con sinceridad o paga una prenda pesadísima.',
      '¿Cuántas veces te has masturbado hoy?',
      '¿A qué sabe el esperma de tu pareja habitual?',
      '¿Has usado alguna vez un vibrador o dildo durante el sexo con otra persona?',
      '¿Qué es lo más asqueroso que has hecho en la cama pero que te gustó?',
      'Describe cómo te masturbas con todo lujo de detalles.',
      '¿Quién en esta habitación crees que es el más dotado/a?',
      '¿Has hecho alguna vez sexo oral a alguien y luego le has besado inmediatamente después?',
    ],
  };

  /// Bugie pre-scritte per Bluff Story: 150 frasi plausibili in prima persona.
  static const List<String> bluffFakes = [
    'Una vez dormí doce horas seguidas en un aeropuerto.',
    'Aprendí a nadar a los dieciocho años.',
    'Perdí un vuelo por quedarme dormido en la puerta de embarque.',
    'De pequeño me perdí una hora en un centro comercial.',
    'Gané un concurso de baile en el colegio.',
    'Salí sin querer en la foto de boda de unos desconocidos.',
    'Trabajé una semana de camarero y me despidieron.',
    'Cociné para veinte personas sin haber cocinado nunca antes.',
    'Salí tres segundos en la televisión durante un informativo.',
    'Me encontré a un actor famoso en el supermercado.',
    'Hice cincuenta kilómetros a dedo.',
    'Dormí en el coche durante una tormenta en la montaña.',
    'Me subí al tren equivocado y acabé en otra provincia.',
    'Pasé un fin de año en el hospital acompañando a un amigo.',
    'Me caí de un árbol de pequeño y no me hice nada.',
    'Me rompí un brazo jugando al escondite.',
    'Me hice un tatuaje y me arrepentí al día siguiente.',
    'Me corté el pelo yo mismo en una mala época.',
    'Me teñí el pelo de verde por una apuesta.',
    'Canté en un karaoke delante de cien personas.',
    'Toqué la guitarra en un grupo durante dos meses.',
    'Escribí una canción que no le he enseñado a nadie.',
    'Llevé un diario cinco años seguidos.',
    'Me leí un libro entero en una noche.',
    'Vi la misma película tres veces en el cine.',
    'Me aprendí de memoria un monólogo entero de una película.',
    'Actué en una obra del colegio y olvidé mi frase.',
    'Canté en un coro durante un año.',
    'Aprendí un idioma viendo series.',
    'Aprobé un examen sin haber estudiado nada.',
    'Copié en un examen y me pillaron.',
    'Falté una semana al colegio sin que nadie se diera cuenta.',
    'Fui el último en enterarme de una noticia importante de mi familia.',
    'Descubrí que tenía un primo que no sabía que existía.',
    'Viví en tres ciudades distintas en dos años.',
    'Hice una mudanza yo solo con un coche pequeñísimo.',
    'Viví un mes sin televisión ni internet.',
    'Pasé un verano entero sin usar redes sociales.',
    'Borré todas mis redes durante tres meses.',
    'Perdí el móvil en el mar.',
    'Me dejé la cartera en un tren y me la devolvieron.',
    'Encontré dinero en la calle y lo entregué.',
    'Gané veinte euros con un rasca y gana.',
    'Compré un billete de lotería y nunca lo comprobé.',
    'Pagué la cena de unos desconocidos por error.',
    'Pedí el mismo plato durante un mes entero.',
    'Comí pizza siete días seguidos.',
    'Intenté hacerme vegetariano y aguanté dos semanas.',
    'Cociné un postre que nadie logró comerse.',
    'Quemé una olla por olvidarla en el fuego.',
    'Hice saltar la alarma de incendios cocinando.',
    'Rompí el horno el día antes de una cena importante.',
    'Monté un mueble y me sobraron piezas.',
    'Pinté una habitación de un color que odié al instante.',
    'Dormí en un colchón en el suelo durante seis meses.',
    'Viví con un compañero de piso al que nunca vi despierto.',
    'Adopté una mascota por impulso.',
    'Le puse nombre a una planta.',
    'Se me murieron todas las plantas que me regalaron.',
    'Salvé a un gato de un árbol.',
    'Me dio miedo un perro del tamaño de un gato.',
    'Corrí una media maratón sin entrenar.',
    'Me apunté al gimnasio y fui tres veces.',
    'Jugué en un equipo de fútbol un solo partido.',
    'Esquié por primera vez a los treinta años.',
    'Probé el paracaidismo y no lo repetiría.',
    'Hice submarinismo y me asusté a diez metros.',
    'Subí una montaña sin el calzado adecuado.',
    'Dormí en una tienda de campaña bajo la lluvia dos noches.',
    'Hice un viaje solo sin decírselo a nadie.',
    'Reservé un viaje en la fecha equivocada.',
    'Pasé una noche en la estación esperando el primer tren.',
    'Conocí a mi mejor amigo haciendo cola en alguna parte.',
    'Me reencontré con un amigo de la infancia por casualidad en el extranjero.',
    'Mantuve una amistad durante años solo por mensajes.',
    'Escribí una carta que nunca envié.',
    'Recibí una carta que me cambió el día.',
    'Llamé a un número equivocado y hablé diez minutos.',
    'Contesté una llamada del trabajo estando en la playa.',
    'Trabajé durante todas las vacaciones de Navidad.',
    'Cambié de trabajo sin tener un plan B.',
    'Rechacé una oferta de trabajo mejor que la que tenía.',
    'Hice una entrevista en un idioma que apenas hablaba.',
    'Tomé una decisión importante lanzando una moneda.',
    'Me dormí en una reunión importante.',
    'Mandé un correo a toda la empresa por error.',
    'Llamé a mi jefe por el nombre equivocado.',
    'Trabajé meses con alguien sin saber su apellido.',
    'Fingí conocer a alguien que me saludaba por la calle.',
    'Saludé a un desconocido pensando que era un amigo.',
    'Reconocí a alguien solo por la voz después de diez años.',
    'Olvidé el cumpleaños de una persona importante.',
    'Organicé una fiesta sorpresa que se descubrió antes.',
    'Guardé un secreto durante cinco años.',
    'Conté una mentira que duró un año entero.',
    'Confesé algo solo porque me sentía culpable.',
    'Lloré viendo un anuncio.',
    'Me reí en el momento más inoportuno.',
    'Me dormí en el cine en una película que quería ver.',
    'Aplaudí yo solo al final de una película.',
    'Canté en el coche creyendo que nadie me veía.',
    'Bailé en un ascensor con alguien a quien no conocía.',
    'Me hice amigo de un vecino solo después de tres años.',
    'Perdí las llaves de casa el día de la mudanza.',
    'Me quedé fuera de casa en pijama.',
    'Me quedé encerrado en un ascensor veinte minutos.',
    'Subí por la escalera mecánica en sentido contrario.',
    'Me equivoqué de baño en un restaurante.',
    'Entré en la reunión equivocada y me quedé diez minutos.',
    'Hablé por teléfono con el volumen alto sin darme cuenta.',
    'Mandé un mensaje a la persona de la que estaba hablando.',
    'Hice una captura y la mandé a la persona equivocada.',
    'Le di like a una foto de hace diez años sin querer.',
    'Escribí un comentario y lo borré un segundo después.',
    'Me creé un perfil en redes que no he usado nunca.',
    'Me vi una serie entera un fin de semana sin salir.',
    'Me terminé un videojuego en una sola noche.',
    'Jugué al mismo juego durante cinco años.',
    'Gané un torneo de cartas en familia haciendo trampas.',
    'Perdí una apuesta y tuve que teñirme el pelo.',
    'Hice una apuesta que me costó una cena para ocho.',
    'Comí algo picantísimo por una apuesta.',
    'Me tomé tres cafés en una hora y no dormí.',
    'Pasé una noche en blanco por una ansiedad absurda.',
    'Tuve un sueño tan real que al despertar me lo creí.',
    'Hablé en sueños y revelé algo importante.',
    'Fui sonámbulo de pequeño.',
    'Me desperté en un sitio distinto de donde me dormí.',
    'Dormí en un banco de un parque por la tarde.',
    'Pasé un día entero sin hablar con nadie.',
    'Hablé dos horas con un desconocido en el tren.',
    'Devolví una cartera llena que encontré en la calle.',
    'Gané un premio en una tómbola del pueblo y nunca lo recogí.',
    'Comí lo mismo cada día durante un mes entero.',
    'Fingí hablar otro idioma para que no me reconocieran.',
    'Me quedé fuera de casa en pijama durante tres horas.',
    'Contesté una llamada importante fingiendo no estar en la cama.',
    'Aplaudí yo solo en el cine al acabar la película.',
    'Paseé al perro equivocado durante veinte minutos.',
    'Saludé con mucho entusiasmo a alguien que no conocía en absoluto.',
    'Hice un tour turístico de mi propia ciudad fingiendo ser extranjero.',
    'Felicité el cumpleaños a la persona equivocada dos años seguidos.',
    'Gané una discusión citando una estadística que me inventé.',
    'Llevé el paraguas abierto diez minutos después de dejar de llover.',
    'Hice el ridículo en una entrevista y me cogieron igual.',
    'Tuve una planta falsa en casa durante años y la regaba a veces.',
    'Perdí las llaves y las encontré en la nevera.',
    'Le dije "buen provecho" al camarero que me lo acababa de desear.',
    'Corrí doscientos metros detrás de un autobús y lo cogí.',
    'Olvidé dónde había aparcado y di vueltas una hora.',
  ];

  /// Parole segrete per Impostore: 150 parole concrete e note a tutti.
  static const List<String> impostoreWords = [
    'Playa',
    'Montaña',
    'Aeropuerto',
    'Estación',
    'Metro',
    'Hospital',
    'Farmacia',
    'Supermercado',
    'Panadería',
    'Pizzería',
    'Restaurante',
    'Bar',
    'Discoteca',
    'Gimnasio',
    'Piscina',
    'Biblioteca',
    'Museo',
    'Cine',
    'Teatro',
    'Estadio',
    'Colegio',
    'Universidad',
    'Oficina',
    'Fábrica',
    'Obra',
    'Peluquería',
    'Dentista',
    'Banco',
    'Correos',
    'Hotel',
    'Camping',
    'Zoo',
    'Acuario',
    'Parque',
    'Jardín',
    'Bosque',
    'Desierto',
    'Isla',
    'Volcán',
    'Cascada',
    'Ascensor',
    'Escalera mecánica',
    'Semáforo',
    'Autopista',
    'Ferry',
    'Avión',
    'Tren',
    'Bicicleta',
    'Patinete',
    'Moto',
    'Paraguas',
    'Gafas',
    'Reloj',
    'Mochila',
    'Maleta',
    'Cartera',
    'Llaves',
    'Teléfono',
    'Cargador',
    'Auriculares',
    'Televisión',
    'Nevera',
    'Lavadora',
    'Aspiradora',
    'Horno',
    'Colchón',
    'Almohada',
    'Manta',
    'Sofá',
    'Sillón',
    'Espejo',
    'Ducha',
    'Toalla',
    'Cepillo de dientes',
    'Jabón',
    'Café',
    'Croissant',
    'Helado',
    'Pizza',
    'Lasaña',
    'Bocadillo',
    'Ensalada',
    'Pasta',
    'Paella',
    'Sopa',
    'Chocolate',
    'Palomitas',
    'Patatas fritas',
    'Sandía',
    'Piña',
    'Limón',
    'Guindilla',
    'Queso',
    'Miel',
    'Sal',
    'Perro',
    'Gato',
    'Caballo',
    'Pingüino',
    'Delfín',
    'Tiburón',
    'Abeja',
    'Hormiga',
    'Araña',
    'Serpiente',
    'Balón',
    'Raqueta',
    'Canasta',
    'Bici de carretera',
    'Esquí',
    'Guitarra',
    'Piano',
    'Batería',
    'Micrófono',
    'Karaoke',
    'Boda',
    'Cumpleaños',
    'Nochevieja',
    'Vacaciones',
    'Mudanza',
    'Faro',
    'Crucero',
    'Granja',
    'Circo',
    'Viñedo',
    'Tiovivo',
    'Planetario',
    'Molino',
    'Gasolinera',
    'Túnel de lavado',
    'Lavandería',
    'Mercado',
    'Heladería',
    'Sushi',
    'Barbacoa',
    'Picnic',
    'Mina',
    'Bolera',
    'Feria',
    'Glaciar',
    'Sauna',
    'Balneario',
    'Trineo',
    'Surf',
    'Tienda de campaña',
    'Hoguera',
    'Kárate',
    'Maratón',
    'Tatuaje',
    'Castillo',
  ];
}
