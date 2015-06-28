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
    var letterTimeRate : Double?
    var letterTimeRateScale : Double = 1
    var scaledRate : Float = 1.0 {
        didSet {
//            0 -> 1
//            0.5 -> 3
//             scaledRate = (rate + 0.5) * 2
            rate = (Float)((scaledRate-(0.2)-0.5) / 2.5)
            refreshRate = synthesizer.speaking
            letterTimeRate = nil
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
    static func defaultLengthForString(string: String) -> String? {
        var len = (Double)(count(string)) * Constants.defaultLetterTime
        len = 64.4
        var string = formatTime(len)
        string = string! + " "
//        if let str = string {}
        return string
        /*
        println(len)
        len = 64.0
        var nsstring = NSString(format:"%2d", len)
        if let str = nsstring as? String {
            return str
        } else {
            return " "
        }*/

    }
    
    static func formatTime(time: Double?) -> String? {
        if let t : Double = time {
            var intTime = (Int)(t)
            switch t {
                case 0...60:
                    return String(format: "0:%02d", intTime)
                case 60...60*60*60:
                    let seconds = intTime % 60
                    let minutes = (Int)(intTime / 60)
                    return String(format: "%d:%02d", minutes, seconds)
                default:
                    return " "
            }
        } else{
            return " "
        }
    }
    func speak(string: String) {
        wordRefreshCount = 0
        if let utterance = utterance {
            synthesizer.continueSpeaking()
        } else {
            utterance = AVSpeechUtterance(string: string)
            utterance!.rate = rate
//            println(rate)
            synthesizer.speakUtterance(utterance)
            wordRefreshCount = 0
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
            letterTimeRateScale = (Double)(characterRange.length)
        } else if wordRefreshCount==3 {
            letterTimeRate = NSDate().timeIntervalSinceDate(startDate!) / letterTimeRateScale
            println("\(letterTimeRate)")

        }
        var speechString = utterance.speechString
        
        /* Estimate time */
        

        
        let remaining = speechString.substringFromIndex(advance(speechString.startIndex, characterRange.location))

        let range = Range(start: advance(speechString.startIndex, characterRange.location), end: advance(speechString.startIndex, characterRange.location + characterRange.length))
//        println("\(speechString) \(characterRange.location) : \(characterRange.length)")
        let word = speechString.substringWithRange(range)
        if refreshRate {
//            println("Refresh rate")
//            startDate = NSDate()
//            wordRefreshCount = 0
            synthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
            self.utterance = nil
//            self.utterance = nil
            speak(remaining)
            refreshRate = false
        }
        if let delegate = delegate {
            delegate.wordWillBeSpoken(word)
            if let letterTimeRate = letterTimeRate {
                var lenRemaining = (Double)(count(remaining))
                var punchCount = countCharacters(remaining, characters: ",.?!;—-")
                println(punchCount)
                var timeRemaining = lenRemaining * (Double)(letterTimeRate) + punchCount * 0.35
                delegate.updateTimeRemaining(timeRemaining)
                
            }
            
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
