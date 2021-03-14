//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Fabrício Silva Carvalhal on 13/03/21.
//

import UIKit

class RecordAudioViewController: UIViewController {
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    let recordingText = "Recording in Progress"
    let tapToRecordText = "Tap to Record"
    let stopRecordingSegueIdentifier = "stopRecordingSegue"
    
    lazy var alertRenderer = {
        return AlertRenderer(with: self)
    }()
    
    private let audioRecorder = AudioRecorder(audioFileName: "recordedAudio.wav")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioRecorder.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        toggleStopRecordingButtonEnabled(false)
    }
    
    // MARK: Button actions
    @IBAction func didTapRecordAudioButton(_ sender: AnyObject) {
        startRecording()
    }

    @IBAction func didTapStopRecordingButton(_ sender: AnyObject) {
        toggleRecordAudioButtonEnabled(true)
        toggleRecordingLabelText(isRecording: false)
        toggleStopRecordingButtonEnabled(false)
        audioRecorder.stopRecording()
    }
    
    // MARK: Start recording function
    func startRecording() {
        audioRecorder.askRecordingPermission { [weak self] granted in
            guard let this = self else { return }
            if granted {
                this.toggleStopRecordingButtonEnabled(true)
                this.toggleRecordingLabelText(isRecording: true)
                this.toggleRecordAudioButtonEnabled(false)
                this.audioRecorder.recordAudio(recorderDelegate: this)
            } else {
                this.alertRenderer.showSimpleAlert(AlertMessages.recordingDisabledTitle, message: AlertMessages.recordingDisabledMessage)
            }
        }
    }
    
    
    // MARK: Buttons and label text toggle functions
    func toggleStopRecordingButtonEnabled(_ isEnabled: Bool) {
        stopRecordingButton.isEnabled = isEnabled
    }
    
    func toggleRecordingLabelText(isRecording: Bool) {
        recordingLabel.text = isRecording ? recordingText : tapToRecordText
    }
    
    func toggleRecordAudioButtonEnabled(_ isEnabled: Bool) {
        recordAudioButton.isEnabled = isEnabled
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == stopRecordingSegueIdentifier {
            if let playSoundsViewController = segue.destination as? PlaySoundsViewController {
                playSoundsViewController.recordedAudioUrl = sender as? URL
            }
        }
    }
}

