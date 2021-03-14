//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Fabrício Silva Carvalhal on 13/03/21.
//

import UIKit

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var stopPlayingButton: UIButton!
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    
    var recordedAudioUrl: URL?
    
    var audioMixer: AudioMixer!
    
    lazy var alertRenderer = {
        return AlertRenderer(with: self)
    }()

    enum PlayingState {
        case playing
        case stoppped
    }
    
    enum ButtonType: Int {
        case slow = 0
        case fast
        case chipmunk
        case vader
        case echo
        case reverb
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI(for: .stoppped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    
    @IBAction func playSound(_ sender: UIButton) {
        do {
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            try audioMixer.playSound(with: .ratePitch(rateValue: 0.5))
        case .fast:
            try audioMixer.playSound(with: .ratePitch(rateValue: 2))
        case .chipmunk:
            try audioMixer.playSound(with: .ratePitch(pitchValue: 1000))
        case .vader:
            try audioMixer.playSound(with: .ratePitch(pitchValue: -1000))
        case .echo:
            try audioMixer.playSound(with: .echo(distortion: .multiEcho1))
        case .reverb:
            try audioMixer.playSound(with: .reverb(acousticCharacteristics: .cathedral, wetDryMix: 50))
        }
        } catch {
            alertRenderer.showSimpleAlert(AlertMessages.audioEngineError, message: AlertMessages.audioEngineError)
        }
        setupUI(for: .playing)
    }
    
    @IBAction func stopPlay(_ sender: AnyObject) {
        audioMixer.stopSound()
    }
}

extension PlaySoundsViewController: AudioMixerDelegate {
    // MARK: Audio Functions
    func setupAudio() {
        do {
            audioMixer = try AudioMixer(with: recordedAudioUrl!)
            audioMixer.delegate = self
        } catch {
            alertRenderer.showSimpleAlert(AlertMessages.audioFileError, message: String(describing: error))
        }
    }
    
    func audioMixerDidFinishPlaying() {
        setupUI(for: .stoppped)
    }
}
