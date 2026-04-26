//
//  ContentView.swift
//  FishKids
//
//  Created by Ari Everett on 4/21/26.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene: SKScene {
        let scene = FeedFrenzyScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
