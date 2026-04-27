//
//  MainMenuView.swift
//  FishKids
//
//  Created by Ari Everett on 4/26/26.
//

import SwiftUI

struct MainMenuView: View {
    let startFeedFrenzy: () -> Void

    var body: some View {
        ZStack {
            Image("menuBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            Color.black.opacity(0.18)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Fish Kids")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(.white)
                    .shadow(radius: 6)

                Text("Choose a mini game")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .shadow(radius: 4)

                Button(action: startFeedFrenzy) {
                    Text("Feed Frenzy")
                        .font(.title2.bold())
                        .foregroundStyle(.blue)
                        .frame(width: 250, height: 62)
                        .background(.white.opacity(0.92))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 6)
                }

                VStack(spacing: 12) {
                    Text("Trace the Tide")
                    Text("Drop Dive")
                }
                .font(.headline)
                .foregroundStyle(.white.opacity(0.75))
                .shadow(radius: 4)
                .padding(.top, 8)
            }
            .padding()
        }
        .onAppear {
            AudioManager.shared.playMusic(named: "bgMusic")
        }
    }
}

#Preview {
    MainMenuView(startFeedFrenzy: {})
}
