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
    func updateTimeRemaining (time: Double)
}

class Speech: NSObject {
    var synthesizer = AVSpeechSynthesizer()
    var delegate : SpeechDelegate?
    var utterance : AVSpeechUtterance?
    var refreshRate = false
    var wordRefreshCount = 0
    var startDate : NSDate?
    var letterTimeRate : NSTimeInterval?
    var scaledRate : Float = 1.0 {
        didSet {
//            0 -> 1
//            0.5 -> 3
//             scaledRate = (rate + 0.5) * 2
            rate = (Float)((scaledRate-(0.2)-0.5) / 2.5)
            refreshRate = synthesizer.speaking
//            println("setting rate equal to \(rate)")
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
    
//    func timePerCharacterPerWord
    
    func speak(string: String) {
        wordRefreshCount = 0
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
    
    func countCharacters(string: String, characters: String) -> Double {
        var i = 0.0
        for x in string {
            for char in characters {
                if x==char {
                    i++
                }
            }
        }
        return i
    }
}

extension Speech : AVSpeechSynthesizerDelegate {
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance!) {
        wordRefreshCount++
        if wordRefreshCount==2 {
            startDate = NSDate()
        } else if wordRefreshCount==3 {
            letterTimeRate = NSDate().timeIntervalSinceDate(startDate!)

        }
        var speechString = utterance.speechString
        
        /* Estimate time */
        
        var punchCount = countCharacters(utterance.speechString, characters: ",.?!;")
        
        let remaining = speechString.substringFromIndex(advance(speechString.startIndex, characterRange.location))
        var lenRemaining = (Double)(count(remaining))
        var timeRemaining = lenRemaining * (Double)(letterTimeRate!) + punchCount * 0.2
        delegate.updateTimeRemaining(timeRemaining)
        let range = Range(start: advance(speechString.startIndex, characterRange.location), end: advance(speechString.startIndex, characterRange.location + characterRange.length))
//        println("\(speechString) \(characterRange.location) : \(characterRange.length)")
        let word = speechString.substringWithRange(range)
        if refreshRate {
//            println("Refresh rate")
//            startDate = NSDate()
            wordRefreshCount = 0
            synthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
            self.utterance = nil
//            self.utterance = nil
            speak(remaining)
            refreshRate = false
        }
        if let delegate = delegate {
            delegate.wordWillBeSpoken(word)
        }
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didFinishSpeechUtterance utterance: AVSpeechUtterance!)
    {
//        println("Stopping")
        self.utterance = nil
        if let delegate = delegate {
            delegate.didFinish()
        }
    }
    


}
