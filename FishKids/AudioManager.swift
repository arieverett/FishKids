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

    var isSoundOn: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isSoundOn")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isSoundOn")

            if newValue == false {
                stopMusic()
            }
        }
    }

    private init() {
        if UserDefaults.standard.object(forKey: "isSoundOn") == nil {
            UserDefaults.standard.set(true, forKey: "isSoundOn")
        }
    }

    func playMusic(named assetName: String, loop: Bool = true) {
        guard isSoundOn else { return }

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

    func toggleSound() {
        isSoundOn.toggle()

        if isSoundOn {
            playMusic(named: "bgMusic")
        }
    }
}
