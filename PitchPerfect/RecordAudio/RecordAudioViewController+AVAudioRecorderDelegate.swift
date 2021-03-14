//
//  RecordAudioViewController+AVAudioRecorderDelegate.swift
//  PitchPerfect
//
//  Created by Fabrício Silva Carvalhal on 13/03/21.
//

import UIKit
import AVFoundation

extension RecordAudioViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: stopRecordingSegueIdentifier, sender: recorder.url)
        } else {
            alertRenderer.showSimpleAlert(AlertMessages.recordingFailedTitle, message: AlertMessages.recordingFailedMessage)
        }
    }
}
