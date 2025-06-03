import UIKit
import SwiftUI
import ComposeApp // XCFramework generated from Kotlin Multiplatform

/// A SwiftUI-compatible wrapper around a Kotlin Multiplatform view.
/// `MainViewController()` is defined in the iOS target of the KMP shared module.
struct ComposeView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        // This is the entry point for the Compose Multiplatform UI
        MainViewControllerKt.MainViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No updates needed for static content
    }
}

/// SwiftUI view demonstrating native interaction with Kotlin and SwiftPM
/// via Objective-C-compatible wrappers (DummyPackageIOS)
struct ContentView: View {
    @State private var showContent = false
    @State private var dummyDescription = ""

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            // ComposeView() ->  uncomment this line to see KMP app.
            Button(action: {
                // Instantiate the Objective-C wrapper class, which internally:
                // - Calls into Kotlin code (getDummyPackage())
                // - Which uses SwiftPackageObjC (from SwiftPM)
                // - Which calls into Swift
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

            // Display the multi-layered description with animation
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

