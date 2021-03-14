//
//  AudioRecorder.swift
//  PitchPerfect
//
//  Created by Fabrício Silva Carvalhal on 13/03/21.
//

import Foundation
import AVFoundation

enum AudioRecorderError {
    case audioSessionError, audioRecorderError
}

protocol AudioRecorderDelegate: class {
    func didFailToRecord(reason: AudioRecorderError)
}

class AudioRecorder {
    private var audioFileName: String
    private var recorder: AVAudioRecorder!
    weak var delegate: AudioRecorderDelegate?
    
    init(audioFileName: String) {
        self.audioFileName = audioFileName
    }
    
    func stopRecording() {
        recorder.stop()
        try? AVAudioSession.sharedInstance().setActive(false)
    }
    
    func recordAudio(recorderDelegate: AVAudioRecorderDelegate) {
        guard let filePathUrl = getFilePathUrl() else {
            delegate?.didFailToRecord(reason: .audioRecorderError)
            return
        }
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        } catch {
            delegate?.didFailToRecord(reason: .audioSessionError)
        }
        
        do {
            recorder = try AVAudioRecorder(url: filePathUrl, settings: [:])
            recorder.isMeteringEnabled = true
            recorder.delegate = recorderDelegate
            recorder.prepareToRecord()
            recorder.record()
        } catch {
            delegate?.didFailToRecord(reason: .audioRecorderError)
            
        }
    }
    
    private func getDocumentDirectoryPath() -> String {
        return (NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true).first ?? "") as String
    }
    
    // Creates and return the file path used to save the audiofile
    private func getFilePathUrl() -> URL? {
        let pathArray = [getDocumentDirectoryPath(), audioFileName]
        return URL(string: pathArray.joined(separator: "/"))
    }
    
    // Ask for recording permission and call completion block function
    func askRecordingPermission(completion: @escaping ((Bool) -> Void)) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
}
