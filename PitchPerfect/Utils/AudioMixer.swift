//
//  AudioMixer.swift
//  PitchPerfect
//
//  Created by Fabrício Silva Carvalhal on 13/03/21.
//

import AVFoundation

protocol AudioMixerDelegate: class {
    func audioMixerDidFinishPlaying()
}

class AudioMixer {
    private var audioFile:AVAudioFile!
    private var audioEngine:AVAudioEngine!
    private var audioPlayerNode: AVAudioPlayerNode!
    private var stopTimer: Timer!
    weak var delegate: AudioMixerDelegate?
    
    enum AudioEffect {
        case ratePitch(rateValue: Float? = nil, pitchValue: Float? = nil)
        case echo(distortion: AVAudioUnitDistortionPreset)
        case reverb(acousticCharacteristics: AVAudioUnitReverbPreset, wetDryMix: Float)
    }
    
    init(with audioFileUrl: URL) throws {
        self.audioFile = try AVAudioFile(forReading: audioFileUrl)
    }
    
    // connect all audio nodes together into the audio engine using the specified audio format
    private func connectAudioNodes(_ nodes: [AVAudioNode], to audioEngine: AVAudioEngine, using audioFormat: AVAudioFormat) {
        for nodeIndex in 0..<nodes.count-1 {
            audioEngine.connect(nodes[nodeIndex], to: nodes[nodeIndex+1], format: audioFormat)
        }
    }
    
    private func attach(nodes: [AVAudioNode], to engine: AVAudioEngine) {
        nodes.forEach { node in audioEngine.attach(node) }
    }
    
    // MARK: Play and stop functions
    func playSound(with effects: AudioEffect...) throws {
        // 1. initialize engine and player node
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        // 2. create and attach nodes to the audio engine
        var nodes = createAudioNodes(using: effects)
        attach(nodes: nodes, to: audioEngine)
        
        // 3. connect audio nodes to audio engine using engine audio format
        nodes.insert(audioPlayerNode, at: 0)
        nodes.insert(audioEngine.outputNode, at: nodes.endIndex)
        connectAudioNodes(nodes, to: audioEngine, using: audioFile.processingFormat)
        
        // 4. stop audio player before start
        audioPlayerNode.stop()
        
        // 5. schedule to play sound
        let customRate = nodes
            .filter { $0 is AVAudioUnitTimePitch }
            .compactMap { $0 as? AVAudioUnitTimePitch }
            .first?
            .rate
        schedule(audioPlayerNode: audioPlayerNode, audioFile: audioFile, customRate: customRate)
        
        // 6. start the audio engine
        try audioEngine.start()
        
        // 7. finally play the recording!
        audioPlayerNode.play()
    }
    
    @objc func stopSound() {
        audioPlayerNode?.stop()
        stopTimer?.invalidate()
        delegate?.audioMixerDidFinishPlaying()
        audioEngine?.stop()
        audioEngine?.reset()
    }
    
    private func schedule(audioPlayerNode: AVAudioPlayerNode, audioFile: AVAudioFile, customRate: Float?) {
        audioPlayerNode.scheduleFile(audioFile, at: nil) {
            var delayInSeconds: Double = 0
            
            if let lastRenderTime = audioPlayerNode.lastRenderTime, let playerTime = audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {
                
                if let rate = customRate {
                    delayInSeconds = Double(audioFile.length - playerTime.sampleTime) / Double(audioFile.processingFormat.sampleRate) / Double(rate)
                } else {
                    delayInSeconds = Double(audioFile.length - playerTime.sampleTime) / Double(audioFile.processingFormat.sampleRate)
                }
            }
            
            // schedule a stop timer for when audio finishes playing
            self.stopTimer = Timer(timeInterval: delayInSeconds, target: self, selector: #selector(self.stopSound), userInfo: nil, repeats: false)
            RunLoop.main.add(self.stopTimer!, forMode: RunLoop.Mode.default)
        }
    }
    
    
    // MARK: Audio nodes creation
    private func createAudioNodes(using effects: [AudioEffect]) -> [AVAudioNode] {
        return effects.map { effect in
            var node: AVAudioNode!
            switch effect {
            case .echo(let distortion):
                node = createEchoNode(distortion: distortion)
            case .ratePitch(let rateValue, let pitchValue):
                node = createRatePitchNode(rateValue: rateValue, pitchValue: pitchValue)
            case .reverb(let acousticCharacteristics, let wetDryMix):
                node = createReverbNode(with: acousticCharacteristics, and: wetDryMix)
            }
            return node
        }
    }
    
    private func createRatePitchNode(rateValue: Float?, pitchValue: Float?) -> AVAudioUnitTimePitch {
        let node = AVAudioUnitTimePitch()
        if let pitch = pitchValue {
            node.pitch = pitch
        }
        if let rate = rateValue {
            node.rate = rate
        }
        return node
    }
    
    private func createEchoNode(distortion: AVAudioUnitDistortionPreset) -> AVAudioUnitDistortion {
        let echoNode = AVAudioUnitDistortion()
        echoNode.loadFactoryPreset(distortion)
        return echoNode
    }
    
    private func createReverbNode(with acousticCharacteristics: AVAudioUnitReverbPreset, and wetDryMix: Float) -> AVAudioUnitReverb {
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(acousticCharacteristics)
        reverbNode.wetDryMix = wetDryMix
        return reverbNode
    }
    
}
