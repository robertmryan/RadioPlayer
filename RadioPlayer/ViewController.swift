//
//  ViewController.swift
//  RadioPlayer
//
//  Created by Robert Ryan on 12/17/16.
//  Copyright © 2016 Robert Ryan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.text = " "
        
        RadioPlayer.shared.reasonForWaitingToPlayHandler = { [weak self] message in
            self?.statusLabel.text = message ?? " "
        }
    }

    @IBAction func didTapPlayPauseButton(_ sender: UIButton) {
        if RadioPlayer.shared.isPlaying {
            RadioPlayer.shared.pause()
            playButton.setTitle("Play", for: .normal)
        } else {
            RadioPlayer.shared.play()
            playButton.setTitle("Pause", for: .normal)
        }
    }

}

