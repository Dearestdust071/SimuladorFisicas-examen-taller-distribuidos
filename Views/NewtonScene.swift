import SpriteKit

class NewtonScene: SKScene {
    // modelo datos
    var simulationModel: NewtonSimulationModel?
    
    // piso  objeto
    private let blockNode = SKShapeNode(rectOf: CGSize(width: 60, height: 60))
    private let floorNode = SKShapeNode(rectOf: CGSize(width: 2000, height: 4))
    
    // flechas (vectores)
    private let appliedForceNode = SKShapeNode()
    private let frictionForceNode = SKShapeNode()
    private let netForceNode = SKShapeNode()
    
    // Etiquetas de vectores
    private let appliedLabel = SKLabelNode(text: "F aplicada")
    private let frictionLabel = SKLabelNode(text: "F fricción")
    private let netLabel = SKLabelNode(text: "ΣF neta")
    
    private var lastTime: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = .white // Fondo blanco limpio
        
        // Configucion del suelo
        floorNode.fillColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.0) // Gris similar a Tailwind #9ca3af
        floorNode.strokeColor = .clear
        floorNode.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        addChild(floorNode)
        
        // Configurar bloques
        blockNode.fillColor = UIColor(red: 0.39, green: 0.40, blue: 0.95, alpha: 1.0) // Indigo #6366f1
        blockNode.strokeColor = UIColor(red: 0.31, green: 0.27, blue: 0.90, alpha: 1.0) // Borde más oscuro
        blockNode.lineWidth = 2
        // Posición inicial: sobre el suelo (y - 100 es el suelo, + 32 es la mitad del bloque + margen)
        blockNode.position = CGPoint(x: frame.midX - 300, y: frame.midY - 68)
        addChild(blockNode)
        
        // Agrgar vectores
        addChild(appliedForceNode)
        addChild(frictionForceNode)
        addChild(netForceNode)
        
        // Configurar etiquetas
        setupLabel(appliedLabel, color: .systemBlue)
        setupLabel(frictionLabel, color: .systemOrange)
        setupLabel(netLabel, color: .systemGreen)
    }
    
    func setupLabel(_ label: SKLabelNode, color: UIColor) {
        label.fontSize = 12
        label.fontName = "HelveticaNeue-Bold"
        label.fontColor = color
        addChild(label)
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let model = simulationModel else { return }
        
        // Calcular Delta Time
        if lastTime == 0 { lastTime = currentTime }
        let deltaTime = currentTime - lastTime
        lastTime = currentTime
        
        // 1 calculos
        
        let normalForce = model.mass * model.gravity
        let frictionForceMag = model.frictionCoeff * normalForce
        
        // Fuerza neta es F_aplicada - F_friccion (solo si se mueve o intenta mover)
        let frictionVal = (model.velocity > 0 || model.appliedForce > frictionForceMag) ? frictionForceMag : model.appliedForce
        
        // Si la velocidad es 0 y la fuerza aplicada es menor que la fricción estática, no se mueve
        var netForce: Double = 0
        
        if model.velocity > 0 {
             netForce = model.appliedForce - frictionForceMag
        } else {
            if model.appliedForce > frictionForceMag {
                netForce = model.appliedForce - frictionForceMag
            } else {
                netForce = 0
            }
        }
        
        let acceleration = netForce / model.mass
        
        if model.isPlaying && deltaTime < 0.1 {
            let newVelocity = max(0, model.velocity + acceleration * deltaTime)
            let newPosition = model.position + newVelocity * deltaTime
            
            model.velocity = newVelocity
            model.position = newPosition
            model.time += deltaTime
            
            // Detener si es muy lento
            if newVelocity < 0.01 && model.appliedForce <= frictionForceMag {
                model.velocity = 0
            }
        }
        
        // Actualizacion visual
        
        // Mover el bloque (se mapean metros a píxeles, ej: 1 metro = 2 pixeles visuales para que no se vaya rápido)
        // Ajustamos la posición base para que empiece a la izquierda
        let startX = frame.midX - 200
        let visualX = startX + (model.position * 20) // Factor de escala visual arbitrario
        
        // Efecto "loop" para que no se salga de la pantalla
        let screenWidth = frame.width
        let loopedX = startX + (visualX.truncatingRemainder(dividingBy: screenWidth - 100))
        
        blockNode.position.x = loopedX
        
        // Dibujar Vectores
        let center = blockNode.position
        
        drawArrow(node: appliedForceNode, label: appliedLabel, start: center, magnitude: model.appliedForce, color: .systemBlue, offsetY: 0)
        
        // Vector F Fricción (Naranja) - Solo si hay velocidad o fuerza opuesta
        let currentFriction = (model.velocity > 0 || netForce > 0) ? -frictionForceMag : 0
        drawArrow(node: frictionForceNode, label: frictionLabel, start: center, magnitude: currentFriction, color: .systemOrange, offsetY: 0)
        
        // Vector F Neta (Verde/Rojo)
        let netColor: UIColor = netForce > 0 ? .systemGreen : .systemRed
        drawArrow(node: netForceNode, label: netLabel, start: center, magnitude: netForce, color: netColor, offsetY: 25, isNet: true)
    }
    
    // Funcion para dibujar flechas
    func drawArrow(node: SKShapeNode, label: SKLabelNode, start: CGPoint, magnitude: Double, color: UIColor, offsetY: CGFloat, isNet: Bool = false) {
        let scale: CGFloat = 1.5 // Escala visual de los vectores
        let length = CGFloat(magnitude) * scale
        
        if abs(length) < 1 {
            node.path = nil
            label.isHidden = true
            return
        }
        
        label.isHidden = false
        let endX = start.x + length
        let endY = start.y + offsetY
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: start.x, y: endY))
        path.addLine(to: CGPoint(x: endX, y: endY))
        
        // Punta de flecha
        let arrowSize: CGFloat = 8
        let direction: CGFloat = length > 0 ? -1 : 1
        path.move(to: CGPoint(x: endX, y: endY))
        path.addLine(to: CGPoint(x: endX + (arrowSize * direction), y: endY + 6))
        path.move(to: CGPoint(x: endX, y: endY))
        path.addLine(to: CGPoint(x: endX + (arrowSize * direction), y: endY - 6))
        
        node.path = path
        node.strokeColor = color
        node.lineWidth = isNet ? 4 : 2
        
        // Posicionar etiqueta
        label.position = CGPoint(x: endX + (direction * -20), y: endY + 10)
    }
}
