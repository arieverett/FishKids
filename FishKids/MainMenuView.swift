//
//  MainMenuView.swift
//  FishKids
//
//  Created by Ari Everett on 4/26/26.
//

import SwiftUI

struct MainMenuView: View {
    let startFeedFrenzy: () -> Void

    @ObservedObject private var audio = AudioManager.shared

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

            VStack(spacing: 10) {
                Button {
                    audio.isMusicOn.toggle()
                } label: {
                    Image(systemName: audio.isMusicOn ? "music.note" : "music.note.slash")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 50, height: 50)
                        .background(.black.opacity(0.45))
                        .clipShape(Circle())
                }

                Button {
                    audio.isSFXOn.toggle()
                } label: {
                    Image(systemName: audio.isSFXOn ? "speaker.wave.2.fill" : "speaker.slash.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 50, height: 50)
                        .background(.black.opacity(0.45))
                        .clipShape(Circle())
                }
            }
            .padding(.top, 55)
            .padding(.trailing, 20)
        }
        .onAppear {
            AudioManager.shared.playMusic(named: "bgMusic")
        }
    }
}

#Preview {
    MainMenuView(startFeedFrenzy: {})
}
