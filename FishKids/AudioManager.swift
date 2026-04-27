//
//  AudioManager.swift
//  FishKids
//
//  Created by Ari Everett on 4/26/26.
//

import Foundation
import UIKit
import AVFoundation

class AudioManager {
    static let shared = AudioManager()

    private var musicPlayer: AVAudioPlayer?

    func playMusic(named assetName: String, loop: Bool = true) {
        stopMusic()

        guard let musicAsset = NSDataAsset(name: assetName) else {
            print("Music asset not found: \(assetName)")
            return
        }

        do {
            musicPlayer = try AVAudioPlayer(data: musicAsset.data)
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
}
