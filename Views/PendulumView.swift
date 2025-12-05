import SwiftUI
import SpriteKit

struct PendulumView: View {
    var onBack: () -> Void
    
    @State private var model = PendulumSimulationModel()
    @State private var showMenu = false
    
    // Escena de SpriteKit
    var scene: SKScene {
        let scene = PendulumScene()
        scene.scaleMode = .resizeFill
        scene.simulationModel = model
        return scene
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 1 Simulación
                SpriteView(scene: scene)
                    .ignoresSafeArea()
                
                // 2 HUD (Datos en tiempo real)
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Tiempo:")
                            .foregroundColor(.gray)
                        Text(String(format: "%.1f s", model.time))
                            .bold()
                    }
                    HStack {
                        Text("Ángulo:")
                            .foregroundColor(.gray)
                        // Convertir radianes a grados para mostrar
                        Text(String(format: "%.1f°", model.angle * 180 / .pi))
                            .bold()
                    }
                    HStack {
                        Text("Vel. Angular:")
                            .foregroundColor(.gray)
                        Text(String(format: "%.2f rad/s", model.angularVelocity))
                            .bold()
                    }
                }
                .font(.system(size: 14))
                .padding(12)
                .background(.regularMaterial)
                .cornerRadius(12)
                .position(x: 90, y: 60) 
                
                // 3 Botón de Menú
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
                                .shadow(radius: 4)
                        }
                    }
                    Spacer()
                }
                .padding()
                
                // 4 Botón Play/Pause Inferior
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
                        .background(Color.purple)
                        .cornerRadius(16)
                        .shadow(radius: 4)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                
                // 5 Menú Overlay
                if showMenu {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture { withAnimation { showMenu = false } }
                        .zIndex(2)
                    
                    VStack(spacing: 24) {
                        Text("Controles Péndulo")
                            .font(.title2)
                            .bold()
                        
                        // Slider Ángulo Inicial
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Ángulo Inicial")
                                Spacer()
                                Text("\(Int(model.initialAngle))°")
                            }
                            Slider(value: $model.initialAngle, in: 10...170, step: 5)
                                .accentColor(.purple)
                            
                            Text(model.initialAngle > 60 ? "Amplitud grande: no armónico" : "Amplitud pequeña: armónico simple")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        // Slider Longitud
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Longitud Cuerda")
                                Spacer()
                                Text("\(Int(model.length)) px")
                            }
                            Slider(value: $model.length, in: 80...200, step: 10)
                                .accentColor(.purple)
                        }
                        
                        Divider()
                        
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
    PendulumView(onBack: {})
}
