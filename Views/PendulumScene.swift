import SpriteKit

class PendulumScene: SKScene {
    var simulationModel: PendulumSimulationModel?
    
    private let pivotNode = SKShapeNode(circleOfRadius: 8)
    private let rodNode = SKShapeNode()
    private let bobNode = SKShapeNode(circleOfRadius: 20)
    private let trailNode = SKShapeNode() // Para dibujar la estela
    
    // Variables de lógica
    private var lastTime: TimeInterval = 0
    private var trailPoints: [CGPoint] = []
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0) // Gris muy claro (bg-gray-50)
        
        // Configurar Pivote (Punto fijo arriba donde se conecta el pendulu)
        pivotNode.fillColor = UIColor(red: 0.22, green: 0.25, blue: 0.32, alpha: 1.0) // Gris oscuro
        pivotNode.strokeColor = .clear
        // Posición: Arriba al centro
        pivotNode.position = CGPoint(x: frame.midX, y: frame.height - 150)
        addChild(pivotNode)
        
        // Configurar Estela
        trailNode.strokeColor = UIColor(red: 0.75, green: 0.52, blue: 0.99, alpha: 0.5) // Púrpura suave
        trailNode.lineWidth = 2
        addChild(trailNode)
        
        // Configurar Cuerda (Rod)
        rodNode.strokeColor = UIColor.gray
        rodNode.lineWidth = 3
        addChild(rodNode)
        
        // Configurar Bob (La bola)
        // Gradiente simulado con color sólido por simplicidad en SpriteKit puro
        bobNode.fillColor = UIColor(red: 0.66, green: 0.33, blue: 0.97, alpha: 1.0) // Púrpura vibrante
        bobNode.strokeColor = UIColor(red: 0.42, green: 0.13, blue: 0.66, alpha: 1.0) // Borde oscuro
        bobNode.lineWidth = 2
        addChild(bobNode)
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let model = simulationModel else { return }
        
        // Delta Time
        if lastTime == 0 { lastTime = currentTime }
        let deltaTime = currentTime - lastTime
        lastTime = currentTime
        
        // --- 1. FÍSICA (Migración de PendulumSimulation.tsx) ---
        if model.isPlaying && deltaTime < 0.1 {
            // Ecuación: a = (-g / L) * sin(theta)
            // Nota: En el original usaban (length / 10) como factor de escala físico
            // Mantenemos esa proporción para que se sienta igual.
            let physicalLength = model.length / 10.0
            
            let angularAcceleration = (-model.gravity / physicalLength) * sin(model.angle)
            
            // Integración de Euler semi-implícita
            let newVelocity = (model.angularVelocity + angularAcceleration * deltaTime) * model.damping
            let newAngle = model.angle + newVelocity * deltaTime
            
            // Actualizar Modelo
            model.angularVelocity = newVelocity
            model.angle = newAngle
            model.time += deltaTime
            
            // Actualizar Estela (Trail)
            // Calculamos la posición absoluta del bob para la estela
            let bobX = pivotNode.position.x + CGFloat(model.length * sin(newAngle))
            let bobY = pivotNode.position.y - CGFloat(model.length * cos(newAngle))
            
            trailPoints.append(CGPoint(x: bobX, y: bobY))
            if trailPoints.count > 60 { // Mantener solo últimos 60 puntos
                trailPoints.removeFirst()
            }
        } else if !model.isPlaying {
            // Si está pausado y movemos los sliders, reiniciamos la estela
            if trailPoints.count > 0 && model.time == 0 {
                trailPoints.removeAll()
            }
        }
        
        // --- 2. RENDERIZADO VISUAL ---
        
        // Calcular posición relativa del bob basada en el ángulo actual
        let bobRelX = CGFloat(model.length * sin(model.angle))
        let bobRelY = -CGFloat(model.length * cos(model.angle)) // Y negativo porque baja
        
        let bobAbsPos = CGPoint(x: pivotNode.position.x + bobRelX, y: pivotNode.position.y + bobRelY)
        
        // Mover el Bob
        bobNode.position = bobAbsPos
        
        // Dibujar Cuerda (Desde pivote hasta bob)
        let rodPath = CGMutablePath()
        rodPath.move(to: pivotNode.position)
        rodPath.addLine(to: bobAbsPos)
        rodNode.path = rodPath
        
        // Dibujar Estela
        if trailPoints.count > 1 {
            let trailPath = CGMutablePath()
            trailPath.move(to: trailPoints[0])
            for i in 1..<trailPoints.count {
                trailPath.addLine(to: trailPoints[i])
            }
            trailNode.path = trailPath
        } else {
            trailNode.path = nil
        }
    }
}
