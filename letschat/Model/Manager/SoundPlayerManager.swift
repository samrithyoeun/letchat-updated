//
//  SoundPlayer.swift
//  letschat
//
//  Created by Samrith Yoeun on 7/26/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
import AVFoundation

class SoundPlayer{
    static let shared = SoundPlayer()
    var player: AVAudioPlayer?
    func playSound() {
        guard let url = Bundle.main.url(forResource: "beep", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }

}


