//
//  ContentView.swift
//  FishKids
//
//  Created by Ari Everett on 4/21/26.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var body: some View {
        GeometryReader { geo in
            let scene = FeedFrenzyScene(size: geo.size)

            SpriteView(scene: scene)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
