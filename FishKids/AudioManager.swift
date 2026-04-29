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
    private var currentMusicName: String?

    @Published var isMusicOn: Bool {
        didSet {
            UserDefaults.standard.set(isMusicOn, forKey: "isMusicOn")
            if isMusicOn {
                if let name = currentMusicName {
                    playMusic(named: name)
                }
            } else {
                musicPlayer?.pause()
            }
        }
    }

    @Published var isSFXOn: Bool {
        didSet {
            UserDefaults.standard.set(isSFXOn, forKey: "isSFXOn")
        }
    }

    private init() {
        if UserDefaults.standard.object(forKey: "isMusicOn") == nil {
            UserDefaults.standard.set(true, forKey: "isMusicOn")
        }
        if UserDefaults.standard.object(forKey: "isSFXOn") == nil {
            UserDefaults.standard.set(true, forKey: "isSFXOn")
        }

        self.isMusicOn = UserDefaults.standard.bool(forKey: "isMusicOn")
        self.isSFXOn = UserDefaults.standard.bool(forKey: "isSFXOn")
    }

    func playMusic(named assetName: String, loop: Bool = true) {
        currentMusicName = assetName
        guard isMusicOn else { return }

        if musicPlayer?.isPlaying == true {
            return
        }

        stopMusic()

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

    func playSFX(named assetName: String) {
        guard isSFXOn else { return }

        guard let asset = NSDataAsset(name: assetName) else {
            print("SFX asset not found: \(assetName)")
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let player = try AVAudioPlayer(data: asset.data)
                player.prepareToPlay()
                player.play()
                Thread.sleep(forTimeInterval: player.duration + 0.1)
            } catch {
                print("Error playing SFX: \(error)")
            }
        }
    }
}
