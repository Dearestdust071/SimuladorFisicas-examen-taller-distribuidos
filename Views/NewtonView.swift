import SwiftUI
import SpriteKit

struct NewtonView: View {
    // Acción para volver
    var onBack: () -> Void
    
    // Estado: Instancia del modelo de simulación
    @State private var model = NewtonSimulationModel()
    // Estado: Controlar visibilidad del menú
    @State private var showMenu = false
    
    // Propiedad calculada para inicializar la escena de SpriteKit
    var scene: SKScene {
        let scene = NewtonScene()
        scene.scaleMode = .resizeFill
        scene.simulationModel = model // Conectamos el modelo a la escena visual
        return scene
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 1 CAPA DE FONDO: La Simulación (SpriteKit)
                SpriteView(scene: scene)
                    .ignoresSafeArea()
                
                // 2 CAPA DE INTERFAZ: HUD (Arriba Izquierda)
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Tiempo:")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                        Text(String(format: "%.1f s", model.time))
                            .bold()
                            .font(.system(size: 14))
                    }
                    HStack {
                        Text("Velocidad:")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                        Text(String(format: "%.1f m/s", model.velocity))
                            .bold()
                            .font(.system(size: 14))
                    }
                }
                .padding(12)
                .background(.regularMaterial) // Efecto translúcido (Blur)
                .cornerRadius(12)
                .position(x: 80, y: 50) // Posición forzada arriba izquierda
                
                // 3 CAPA DE INTERFAZ: Botón Menú (Arriba Derecha)
                VStack {
                    HStack {
                        Spacer()
                        Button(action: { withAnimation { showMenu.toggle() } }) {
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                                .frame(width: 44, height: 44)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                    }
                    Spacer()
                }
                .padding()
                
                // 4 CAPA DE INTERFAZ: Controles Inferiores (Play/Pause)
                VStack {
                    Spacer()
                    Button(action: { model.isPlaying.toggle() }) {
                        HStack {
                            Image(systemName: model.isPlaying ? "pause.fill" : "play.fill")
                            Text(model.isPlaying ? "Pausar" : "Iniciar")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(16)
                        .shadow(radius: 4)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                
                // 5 OVERLAY: Menú de Configuración
                if showMenu {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture { withAnimation { showMenu = false } }
                        .zIndex(2) // Asegurar que esté encima
                    
                    VStack(spacing: 24) {
                        Text("Controles")
                            .font(.title2)
                            .bold()
                        
                        // Slider Fuerza
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Fuerza Aplicada")
                                Spacer()
                                Text("\(Int(model.appliedForce)) N")
                            }
                            Slider(value: $model.appliedForce, in: 0...150, step: 5)
                                .accentColor(.blue)
                        }
                        
                        // Slider Fricción
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Coef. Fricción")
                                Spacer()
                                Text(String(format: "%.2f", model.frictionCoeff))
                            }
                            Slider(value: $model.frictionCoeff, in: 0...1.0, step: 0.05)
                                .accentColor(.orange)
                        }
                        
                        Divider()
                        
                        // Botones de acción del menú
                        Button(action: {
                            model.reset()
                            withAnimation { showMenu = false }
                        }) {
                            HStack {
                                Image(systemName: "arrow.counterclockwise")
                                Text("Reiniciar Simulación")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(uiColor: .systemGray6))
                            .cornerRadius(12)
                            .foregroundColor(.black)
                        }
                        
                        Button(action: {
                            onBack()
                        }) {
                            HStack {
                                Image(systemName: "house.fill")
                                Text("Volver al Menú")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(uiColor: .systemGray6))
                            .cornerRadius(12)
                            .foregroundColor(.black)
                        }
                    }
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(24)
                    .padding(32)
                    .shadow(radius: 20)
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(3)
                }
            }
        }
    }
}

#Preview {
    NewtonView(onBack: {})
}
