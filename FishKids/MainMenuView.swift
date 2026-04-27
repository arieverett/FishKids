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
            Color.cyan
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Fish Kids")
                    .font(.system(size: 46, weight: .bold))
                    .foregroundStyle(.white)

                Text("Choose a mini game")
                    .font(.title3)
                    .foregroundStyle(.white)

                Button(action: startFeedFrenzy) {
                    Text("Feed Frenzy")
                        .font(.title2.bold())
                        .foregroundStyle(.blue)
                        .frame(width: 240, height: 60)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }

                VStack(spacing: 12) {
                    Text("Trace the Tide")
                    Text("Drop Dive")
                }
                .font(.headline)
                .foregroundStyle(.white.opacity(0.6))
                .padding(.top, 10)
            }
        }
    }
}

#Preview {
    MainMenuView(startFeedFrenzy: {})
}
