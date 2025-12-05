import SwiftUI

struct WelcomeScreenView: View {
    // Esta variable nos servirá para decirle a la App principal qué botón se presionó
    var onSelectExperiment: (String) -> Void

    var body: some View {
        ZStack {
            // Fokin degradado (azul claro a índigo claro en ese orden)
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.indigo.opacity(0.1)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 40) {
                // Encabezado
                VStack(spacing: 8) {
                    Text("Simulador de Física")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                    Text("Explora las leyes del movimiento")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                }
                .padding(.top, 60)

                // Botones de selección
                VStack(spacing: 20) {
                    // Botón Newton
                    Button(action: { onSelectExperiment("newton") }) {
                        ExperimentCard(
                            iconName: "cube.box.fill",
                            color: .blue,
                            title: "Dinámica de Cuerpos",
                            subtitle: "Leyes de Newton"
                        )
                    }

                    // Boton Péndulo
                    Button(action: { onSelectExperiment("pendulum") }) {
                        ExperimentCard(
                            iconName: "metronome",
                            color: .purple,
                            title: "Péndulo",
                            subtitle: "Movimiento armónico"
                        )
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                Text("Toca para comenzar")
                    .foregroundColor(.gray.opacity(0.5))
                    .padding(.bottom, 40)
            }
        }
    }
}

// Disenio tarjetas
struct ExperimentCard: View {
    let iconName: String
    let color: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
                    .frame(width: 56, height: 56)
                Image(systemName: iconName)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    WelcomeScreenView(onSelectExperiment: { _ in })
}
