Simulador de Física: Dinámica y Oscilaciones
Descripción General

Esta aplicación es una herramienta educativa y de simulación diseñada para dispositivos iOS. Su objetivo principal es facilitar la visualización y comprensión de principios fundamentales de la física clásica a través de entornos interactivos en tiempo real. La aplicación se divide en dos módulos experimentales: Dinámica de Cuerpos (Leyes de Newton) y Movimiento Pendular (Oscilaciones).

El software permite a estudiantes y docentes manipular variables físicas críticas y observar las consecuencias cinemáticas resultantes, proporcionando representaciones vectoriales y datos numéricos instantáneos.
Módulos de Simulación
1. Dinámica de Cuerpos (Leyes de Newton)

Este módulo simula el comportamiento de un bloque de masa constante sobre una superficie horizontal, permitiendo el estudio de la fricción cinética y estática, así como la aceleración resultante de fuerzas aplicadas.

Características Funcionales:

    Interacción de Fuerzas: Control preciso de la fuerza aplicada (0 a 150 Newtons) y el coeficiente de fricción de la superficie (0.0 a 1.0).

    Visualización Vectorial: Representación gráfica en tiempo real de los vectores de:

        Fuerza Aplicada.

        Fuerza de Fricción (opuesta al movimiento).

        Fuerza Neta Resultante.

    Datos Cinemáticos: Monitoreo instantáneo de velocidad (m/s), posición (m) y tiempo transcurrido (s).

Modelo Físico: La simulación se rige por la Segunda Ley de Newton, donde la aceleración (a) se calcula considerando la fuerza neta (Fneta​) y la masa (m)

Nota: La fricción se aplica dinámicamente en dirección opuesta a la velocidad o a la fuerza inminente de movimiento.
2. Péndulo Simple y Amortiguado

Este módulo recrea el movimiento de un péndulo simple, permitiendo estudiar la transición entre el movimiento armónico simple (para ángulos pequeños) y el comportamiento no lineal (para ángulos grandes).

Características Funcionales:

    Configuración Inicial: Ajuste del ángulo de liberación (10° a 170°) y la longitud de la cuerda (80 a 200 unidades).

    Trayectoria Visual: Sistema de renderizado de estela (trail) que traza el recorrido histórico de la masa, facilitando la visualización de la amplitud y el decaimiento.

    Amortiguamiento: Incorporación de un factor de resistencia del aire (damping) que reduce progresivamente la energía del sistema, simulando condiciones reales.

Modelo Físico: El movimiento se calcula mediante la ecuación de aceleración angular (α), integrando la gravedad (g), la longitud (L) y el seno del ángulo (θ)

El sistema utiliza integración numérica para actualizar la velocidad angular y la posición en cada fotograma, garantizando una representación fluida del periodo de oscilación.
Interfaz de Usuario (HUD)

La aplicación presenta una interfaz limpia diseñada para no obstruir la visualización del fenómeno físico.

    Panel de Datos: Muestra lecturas numéricas precisas de las variables dependientes del tiempo.

    Panel de Control (Overlay): Un menú desplegable permite modificar los parámetros iniciales y las constantes del sistema sin necesidad de reiniciar la aplicación.

    Controles de Tiempo: Funcionalidad de Pausa/Reproducción para detener el análisis en momentos críticos y opción de Reinicio (Reset) para restablecer las condiciones iniciales.

Requisitos del Sistema

    Plataforma: iOS 17.0 o superior.

    Dispositivo: Optimizado para iPhone

Propósito Educativo

Este proyecto busca servir como complemento visual para cursos de física de nivel bachillerato y universitario, permitiendo corroborar cálculos teóricos mediante experimentación virtual controlada.
