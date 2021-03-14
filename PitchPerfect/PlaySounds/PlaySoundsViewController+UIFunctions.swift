//
//  PlaySoundsViewController+UIFunctions.swift
//  PitchPerfect
//
//  Created by Fabrício Silva Carvalhal on 13/03/21.
//

import UIKit

// MARK: - PlaySoundsViewController
extension PlaySoundsViewController {
    
    func setupUI(for state: PlayingState) {
        switch(state) {
        case .playing:
            setPlayButtonsEnabled(false)
            stopPlayingButton.isEnabled = true
        case .notPlaying:
            setPlayButtonsEnabled(true)
            stopPlayingButton.isEnabled = false
        }
    }
    
    func setPlayButtonsEnabled(_ enabled: Bool) {
        slowButton.isEnabled = enabled
        lowPitchButton.isEnabled = enabled
        fastButton.isEnabled = enabled
        highPitchButton.isEnabled = enabled
        echoButton.isEnabled = enabled
        reverbButton.isEnabled = enabled
    }
}
