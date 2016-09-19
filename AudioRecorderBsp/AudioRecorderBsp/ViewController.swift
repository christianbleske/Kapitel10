//
//  ViewController.swift
//  AudioRecorderBsp
//
//  Created by Christian Bleske on 23.02.15.
//  Copyright (c) 2015 Christian Bleske. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    var avAudioPlayer: AVAudioPlayer?
    var avAudioRecorder: AVAudioRecorder?
    
    @IBOutlet var btnRecord: UIButton!
    @IBOutlet var btnStop: UIButton!
    @IBOutlet var btnPlay: UIButton!
    
    @IBOutlet var uiLabelStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnPlay.isEnabled = false
        btnStop.isEnabled = true

        avAudioPlayer?.delegate = self;
        avAudioRecorder?.delegate = self;
        
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        let docsDir = dirPaths[0] as String
        let soundFilePath = docsDir + ("/sound.caf")

        let soundFileURL = URL(fileURLWithPath: soundFilePath)
        let recordSettings =
        [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0] as [String : Any]
        
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch {
            print("Fehler bei der Initialisierung")
        }

        do {
            try avAudioRecorder = AVAudioRecorder(url: soundFileURL, settings: recordSettings as [String : AnyObject])
            avAudioRecorder?.prepareToRecord()
        } catch {
            print("Fehler bei der Initialisierung")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnRecord_Pressed(_ sender: AnyObject) {
        if avAudioRecorder?.isRecording == false {
            btnPlay.isEnabled = false
            btnStop.isEnabled = true
            avAudioRecorder?.record()
            uiLabelStatus.text = "Aufnahme läuft..."
        }
    }

    @IBAction func btnStop_Pressed(_ sender: AnyObject) {
        btnStop.isEnabled = false
        btnPlay.isEnabled = true
        btnRecord.isEnabled = true
        
        if avAudioRecorder?.isRecording == true {
            avAudioRecorder?.stop()
            uiLabelStatus.text = "Aufnahme beendet..."
        } else {
            avAudioPlayer?.stop()
            uiLabelStatus.text = "Wiedergabe beendet..."
        }
    }
    
    @IBAction func btnPlay_Pressed(_ sender: AnyObject) {
        if avAudioRecorder?.isRecording == false {
            btnStop.isEnabled = true
            btnRecord.isEnabled = false
            uiLabelStatus.text = "Wiedergabe läuft..."
            
            do {
                avAudioPlayer = try AVAudioPlayer(contentsOf: (avAudioRecorder?.url)!)
                avAudioPlayer?.play()
            } catch {
               print("Fehler bei der Wiedergabe!")
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer,
        successfully flag: Bool) {
            print("Wiedergabe beendet...")
            uiLabelStatus.text = "Wiedergabe beendet..."
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer,
        error: Error?) {
        print("Ein Fehler ist während der Wiedergabe aufgetreten...")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Aufnahme beendet...")
        uiLabelStatus.text = "Aufnahme beendet..."
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Ein Fehler ist während der Aufnahme aufgetreten...")
    }
}

