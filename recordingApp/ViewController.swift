//
//  ViewController.swift
//  recordingApp
//
//  Created by Gaurav Sara on 13/09/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var isRecording = false
    var numberOfRecords = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
        self.initRecordSession()
    }
    
    func setupUi() {
        recordButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
        recordButton.tintColor = .red
//        recordButton.frame.size = CGSize(width: 140, height: 140)
        
        recordLabel.isHidden = true
    }
    
    func initRecordSession() {
        // Setting up Session for recording
        recordingSession = AVAudioSession.sharedInstance()
        if let number = UserDefaults.standard.object(forKey: "myRecord") as? Int {
            numberOfRecords = number
        }
        AVAudioSession.sharedInstance().requestRecordPermission { hasSession in
            if hasSession {
                print("Accepted")
            } else {
                print("Not Accepted")
            }
        }
    }
    
    @IBAction func startRecording(_ sender: Any) {
        // Check if we have an active recorder
        if audioRecorder == nil {
            numberOfRecords += 1
            isRecording = true
            recordLabel.isHidden = !isRecording
            
            recordButton.setImage(UIImage(systemName: "stop.circle"), for: .normal)
            
            let filename = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            // Start Audio Recording
            do {
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
            } catch {
                print(error)
            }
        } else {
            //Stop audio recording
            audioRecorder.stop()
            recordButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
            
            // saving data
            UserDefaults.standard.set(numberOfRecords, forKey: "myRecord")
            
            audioRecorder = nil
            
            isRecording = false
            recordLabel.isHidden = !isRecording
        }
    }

    // Function that get path to directory
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        
        return documentDirectory
    }

}
