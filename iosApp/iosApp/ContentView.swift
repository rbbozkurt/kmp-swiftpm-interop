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
    @State private var showContent = false
    @State private var dummyDescription = ""

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Button(action: {
                let dummy = DummyPackageIOS()
                dummyDescription = dummy.describe()
                withAnimation {
                    showContent.toggle()
                }
            }) {
                Text("Describe!")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            if showContent {
                Text(dummyDescription)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .transition(.opacity)
                    .multilineTextAlignment(.leading)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
