import UIKit
import SwiftUI
import ComposeApp

struct ComposeView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        MainViewControllerKt.MainViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No-op
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            ComposeView()
                .ignoresSafeArea(.keyboard) // Compose has its own keyboard handler
        }
    }
}
