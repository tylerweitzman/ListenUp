//
//  Speech.swift
//  ParseStarterProject
//
//  Created by Tyler Weitzman on 6/27/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import AVFoundation

protocol SpeechDelegate {
    func wordWillBeSpoken(word: String)
    func didFinish()
}

class Speech: NSObject {
    var synthesizer = AVSpeechSynthesizer()
    var delegate : SpeechDelegate?
    var utterance : AVSpeechUtterance?
    var refreshRate = false
    var scaledRate : Float = 1.0 {
        didSet {
//            0 -> 1
//            0.5 -> 3
//             scaledRate = (rate + 0.5) * 2
            rate = (Float)((scaledRate-(0.2)-0.5) / 2.5)
            println("setting rate equal to \(rate)")
//            println("yo")
        }
    }
    var rate : Float = 0.5 {
        didSet {
//           let sr = (Float)((rate + 0.5) * 2)
//           if sr != scaledRate {
//                scaledRate = sr
//           }
            utterance?.rate = rate
        }
    }
    override init() {
        super.init()
        synthesizer.delegate = self
        println("\(AVSpeechUtteranceMinimumSpeechRate) \(AVSpeechUtteranceDefaultSpeechRate) \(AVSpeechUtteranceMaximumSpeechRate)")
        
    }
    
    func speak(string: String) {
        if let utterance = utterance {
            synthesizer.continueSpeaking()
        } else {
            utterance = AVSpeechUtterance(string: string)
            utterance!.rate = rate
            println(rate)
            synthesizer.speakUtterance(utterance)
        }
    }
    
    func pause() {
        synthesizer.pauseSpeakingAtBoundary(AVSpeechBoundary.Immediate)
    }
}

extension Speech : AVSpeechSynthesizerDelegate {
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance!) {
        var speechString = utterance.speechString
        let range = Range(start: advance(speechString.startIndex, characterRange.location), end: advance(speechString.startIndex, characterRange.location + characterRange.length))
//        println("\(speechString) \(characterRange.location) : \(characterRange.length)")
        let word = speechString.substringWithRange(range)
        if let delegate = delegate {
            delegate.wordWillBeSpoken(word)
        }
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didFinishSpeechUtterance utterance: AVSpeechUtterance!)
    {
        self.utterance = nil
        if let delegate = delegate {
            delegate.didFinish()
        }
    }

}
