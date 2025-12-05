import Foundation
import Observation

@Observable
class PendulumSimulationModel {
    // Controles de Usuario
    var initialAngle: Double = 45.0 { // Grados
        didSet {
            // Si cambiamos el slider mientras está en pausa cambiamos la posición visual
            if !isPlaying {
                updateAngleFromInitial()
            }
        }
    }
    var length: Double = 150.0 // Pixels
    
    // Estado de la Simulación
    var isPlaying = false
    var angle: Double = 0.0 // Radianes
    var angularVelocity: Double = 0.0
    var time: Double = 0.0
    
    // Constantes Físicas
    let gravity: Double = 9.8
    let damping: Double = 0.995
    
    init() {
        updateAngleFromInitial()
    }
    
    func updateAngleFromInitial() {
        // Grados a radianes
        angle = (initialAngle * .pi) / 180.0
        angularVelocity = 0
        time = 0
    }
    
    func reset() {
        isPlaying = false
        updateAngleFromInitial()
    }
}
