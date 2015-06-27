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
}

class Speech: NSObject {
    var synthesizer = AVSpeechSynthesizer()
    var delegate : SpeechDelegate?
//    var utterance : AVSpeechUtterance
    var scaledRate : Float = 1.0 {
        didSet {
//            0 -> 1
//            0.5 -> 3
//             scaledRate = (rate + 0.5) * 2
            rate = (Float)((scaledRate-0.5) / 2.5)
        }
    }
    var rate : Float = 0.5 {
        didSet {
            scaledRate = (Float)((rate + 0.5) * 2)
        }
    }
    override init() {
        super.init()
        synthesizer.delegate = self
        println("\(AVSpeechUtteranceMinimumSpeechRate) \(AVSpeechUtteranceDefaultSpeechRate) \(AVSpeechUtteranceMaximumSpeechRate)")
        
    }
    
    func speak(string: String) {
        var utterance = AVSpeechUtterance(string: "Hello World my name is Banana")
        utterance.rate = rate
        synthesizer.speakUtterance(utterance)
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
}
