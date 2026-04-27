//
//  ContentView.swift
//  FishKids
//
//  Created by Ari Everett on 4/21/26.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    enum Screen {
        case menu
        case feedFrenzy
    }

    @State private var screen: Screen = .menu

    var body: some View {
        switch screen {
        case .menu:
            MainMenuView {
                screen = .feedFrenzy
            }

        case .feedFrenzy:
            ZStack(alignment: .topLeading) {
                GeometryReader { geo in
                    let scene = FeedFrenzyScene(size: geo.size)

                    SpriteView(scene: scene)
                        .ignoresSafeArea()
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

#Preview {
    ContentView()
}
