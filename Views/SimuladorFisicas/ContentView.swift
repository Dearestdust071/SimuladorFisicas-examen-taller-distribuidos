import SwiftUI

struct ContentView: View {
    // Estado para controlar qué pantalla se muestra
    // Equivalente a: const [currentScreen, setCurrentScreen] = useState<Screen>('welcome');
    @State private var currentScreen: String = "welcome"

    var body: some View {
        // Switch para decidir qué vista mostrar
        VStack {
            if currentScreen == "welcome" {
                WelcomeScreenView(onSelectExperiment: { experiment in
                    // Transición simple cambiando el estado
                    withAnimation {
                        currentScreen = experiment
                    }
                })
            } else if currentScreen == "newton" {
                NewtonView(onBack: {
                    withAnimation {
                        currentScreen = "welcome"
                    }
                })
            } else if currentScreen == "pendulum" {
                PendulumView(onBack: {
                    withAnimation {
                        currentScreen = "welcome"
                    }
                })
            }
        }
        // Forzamos el modo claro para que coincida con el diseño original
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
