//
//  PlaySoundsViewController+AudioMixerDelegate.swift
//  PitchPerfect
//
//  Created by Fabrício Silva Carvalhal on 13/03/21.
//

import UIKit

extension PlaySoundsViewController: AudioMixerDelegate {
    func audioMixerDidFinishPlaying() {
        setupUI(for: .stoppped)
    }
}
