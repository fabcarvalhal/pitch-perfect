//
//  RecordAudioViewController+AudioRecorderDelegate.swift
//  PitchPerfect
//
//  Created by Fabrício Silva Carvalhal on 13/03/21.
//

import UIKit

extension RecordAudioViewController: AudioRecorderDelegate {
    func didFailToRecord(reason: AudioRecorderError) {
        switch reason {
        case .audioRecorderError:
            alertRenderer.showSimpleAlert(AlertMessages.recordingFailedMessage, message: AlertMessages.audioRecorderError)
        case .audioSessionError:
            alertRenderer.showSimpleAlert(AlertMessages.recordingFailedMessage, message: AlertMessages.audioSessionError)
        }
    }
}
