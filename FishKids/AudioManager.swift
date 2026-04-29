//
//  AudioManager.swift
//  FishKids
//
//  Created by Ari Everett on 4/26/26.
//

import Foundation
import UIKit
import AVFoundation
import Combine

final class AudioManager: ObservableObject {
    static let shared = AudioManager()

    private var musicPlayer: AVAudioPlayer?
    private var sfxPlayers: [AVAudioPlayer] = []
    private var currentMusicName: String?

    @Published var isSoundOn: Bool {
        didSet {
            UserDefaults.standard.set(isSoundOn, forKey: "isSoundOn")

            if isSoundOn {
                if let currentMusicName {
                    playMusic(named: currentMusicName)
                }
            } else {
                stopMusic()
            }
        }
    }

    private init() {
        if UserDefaults.standard.object(forKey: "isSoundOn") == nil {
            UserDefaults.standard.set(true, forKey: "isSoundOn")
        }

        isSoundOn = UserDefaults.standard.bool(forKey: "isSoundOn")
    }

    func playMusic(named assetName: String, loop: Bool = true) {
        currentMusicName = assetName
        stopMusic()

        guard isSoundOn else { return }

        guard let asset = NSDataAsset(name: assetName) else {
            print("Music asset not found: \(assetName)")
            return
        }

        do {
            musicPlayer = try AVAudioPlayer(data: asset.data)
            musicPlayer?.numberOfLoops = loop ? -1 : 0
            musicPlayer?.volume = 0.35
            musicPlayer?.prepareToPlay()
            musicPlayer?.play()
        } catch {
            print("Error playing music: \(error)")
        }
    }

    func stopMusic() {
        musicPlayer?.stop()
        musicPlayer = nil
    }

    func toggleSound() {
        isSoundOn.toggle()
    }

    func playSFX(named assetName: String) {
        guard isSoundOn else { return }

        guard let asset = NSDataAsset(name: assetName) else {
            print("SFX asset not found: \(assetName)")
            return
        }

        do {
            let player = try AVAudioPlayer(data: asset.data)
            sfxPlayers.append(player)
            player.prepareToPlay()
            player.play()

            DispatchQueue.main.asyncAfter(deadline: .now() + player.duration + 0.1) { [weak self, weak player] in
                self?.sfxPlayers.removeAll { $0 === player }
            }
        } catch {
            print("Error playing SFX: \(error)")
        }
    }
}
