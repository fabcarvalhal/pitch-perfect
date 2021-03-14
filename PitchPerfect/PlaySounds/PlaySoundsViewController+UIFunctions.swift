//
//  PlaySoundsViewController+UIFunctions.swift
//  PitchPerfect
//
//  Created by Fabrício Silva Carvalhal on 13/03/21.
//

import UIKit

// MARK: - PlaySoundsViewController
extension PlaySoundsViewController {
    
    // MARK: PlayingState (raw values correspond to sender tags)
    enum PlayingState { case playing, notPlaying }
    
    // MARK: UI Functions
    func configureUI(_ playState: PlayingState) {
        switch(playState) {
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
