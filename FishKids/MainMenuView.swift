//
//  MainMenuView.swift
//  FishKids
//
//  Created by Ari Everett on 4/26/26.
//

import SwiftUI

struct MainMenuView: View {
    let startFeedFrenzy: () -> Void

    @State private var isSoundOn = AudioManager.shared.isSoundOn

    var body: some View {
        ZStack(alignment: .topTrailing) {
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()

            Button {
                AudioManager.shared.toggleSound()
                isSoundOn = AudioManager.shared.isSoundOn
            } label: {
                Text(isSoundOn ? "🔊" : "🔇")
                    .font(.system(size: 26))
                    .frame(width: 50, height: 50)
                    .background(.black.opacity(0.45))
                    .clipShape(Circle())
            }
            .padding(.top, 55)
            .padding(.trailing, 20)
        }
        .onAppear {
            isSoundOn = AudioManager.shared.isSoundOn

            if isSoundOn {
                AudioManager.shared.playMusic(named: "bgMusic")
            }
        }
    }
}

#Preview {
    MainMenuView(startFeedFrenzy: {})
}
