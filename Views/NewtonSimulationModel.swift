import Foundation
import Observation

@Observable
class NewtonSimulationModel {
    // Variables de control (Sliders)
    var appliedForce: Double = 50.0 // Newtons simpr
    var frictionCoeff: Double = 0.2
    
    // Variables de estado (Simulación)
    var isPlaying = false
    var time: Double = 0.0
    var velocity: Double = 0.0 // m/s
    var position: Double = 0.0 // metros
    
    // Constantes físicas
    let mass: Double = 10.0 // kg
    let gravity: Double = 9.8 // m/s²
    
    // Función para reiniciar
    func reset() {
        isPlaying = false
        time = 0
        velocity = 0
        position = 0
    }
}
