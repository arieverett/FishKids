import SwiftUI
import SpriteKit

struct ContentView: View {
    enum Screen {
        case menu
        case feedFrenzy
    }

    @State private var screen: Screen = .menu
    @State private var feedFrenzyScene = FeedFrenzyScene(size: CGSize(width: 390, height: 844))

    var body: some View {
        switch screen {
        case .menu:
            MainMenuView {
                screen = .feedFrenzy
            }

        case .feedFrenzy:
            ZStack(alignment: .topLeading) {
                GeometryReader { geo in
                    SpriteView(
                        scene: feedFrenzyScene,
                        options: [.ignoresSiblingOrder]
                    )
                    .ignoresSafeArea()
                    .onAppear {
                        feedFrenzyScene.size = geo.size
                        feedFrenzyScene.scaleMode = .resizeFill
                    }
                }

                Button {
                    screen = .menu
                } label: {
                    Text("Menu")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(.black.opacity(0.35))
                        .clipShape(Capsule())
                }
                .padding(.top, 55)
                .padding(.leading, 18)
            }
        }
    }
}
