//
//  SoundHelper.swift
//  habitude
//
//  Created by Maxim Skryabin on 09.11.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import AVFoundation

class SoundHelper {
  
  static let shared = SoundHelper()
  
  private var player: AVAudioPlayer?
  
  func playSound(_ type: SoundType) {
    guard let url = Bundle.main.url(forResource: type.rawValue, withExtension: "mp3") else { return }
    do {
      try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)
      player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
      player?.play()
    } catch let error {
      print("🔥 Error at SoundHelper (playSound): \(error.localizedDescription)")
    }
  }
}

extension SoundHelper {
  enum SoundType: String {
    case activation = "sound_activation"
    case deactivation = "sound_deactivation"
  }
}
