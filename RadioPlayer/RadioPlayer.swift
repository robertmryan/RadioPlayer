//
//  RadioPlayer.swift
//  RadioPlayer
//
//  Created by Robert Ryan on 12/17/16.
//  Copyright © 2016 Robert Ryan. All rights reserved.
//

import UIKit
import AVFoundation

class RadioPlayer: NSObject {

    static let shared = RadioPlayer()
    
    fileprivate var observerContext = 0

    /// Is the RadioPlayer playing or not
    
    var isPlaying = false
    
    /// Closure called when `reasonForWaitingToPlay` changes. Parameter is "message", a human readable explanation of why it's waiting.
    
    var reasonForWaitingToPlayHandler: ((String?) -> ())?

    let player = AVPlayer()
    
    private override init() {
        super.init()

        player.addObserver(self, forKeyPath: "reasonForWaitingToPlay", context: &observerContext)
    }
    
    deinit {
        player.removeObserver(self, forKeyPath: "reasonForWaitingToPlay")
    }
    
    func play() {
        let item = AVPlayerItem(url: URL(string: "http://rfcmedia.streamguys1.com/classicrock.mp3")!)
        player.replaceCurrentItem(with: item)
        player.play()
        isPlaying = true
    }
    
    func pause() {
        player.pause()
        isPlaying = false
        player.replaceCurrentItem(with: nil)
    }
    
    func toggle() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &observerContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == "reasonForWaitingToPlay" {
            var message: String?
            
            if let reason = player.reasonForWaitingToPlay {
                switch reason {
                case AVPlayerWaitingToMinimizeStallsReason:
                    message = "Buffering"
                case AVPlayerWaitingWithNoItemToPlayReason:
                    message = "No item to play"
                case AVPlayerWaitingWhileEvaluatingBufferingRateReason:  // docs say "It is recommended that you do not show UI indicating a waiting state to the user while this is the value of reasonForWaitingToPlay."
                    message = nil
                default:
                    message = "Unknown reason"
                }
            }
            
            reasonForWaitingToPlayHandler?(message)
        }
    }

}
