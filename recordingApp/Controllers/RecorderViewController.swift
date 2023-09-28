//
//  ViewController.swift
//  recordingApp
//
//  Created by Gaurav Sara on 13/09/23.
//

import UIKit
import AVFoundation

class RecorderViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet var isRecordingLabel: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    var isRecording = false
    var numberOfRecords = 0
    var filename: String = ""
    
    var isRecord = true
    var audioFileURL: URL?
    
    var AARecorder: AppAudioRecorder = AppAudioRecorder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUi()
        AARecorder.delegateAAR = self
    }
    
    func setupUi() {
        recordButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
        recordButton.tintColor = .red
        isRecordingLabel.isHidden = true
    }
    
    @IBAction func startRecording(_ sender: Any) {
        if isRecord {
            isRecord = false
            isRecording = true
            numberOfRecords = UserDefaults.standard.object(forKey: "myRecord") as! Int
            numberOfRecords += 1
            
            // Handling the numbers for assigning the filename of the records
            if numberOfRecords > 99 {
                filename = "\(numberOfRecords)"
            } else if numberOfRecords > 9 {
                filename = "0\(numberOfRecords)"
            } else {
                filename = "00\(numberOfRecords)"
            }
            
            isRecordingLabel.isHidden = !isRecording
            recordButton.setImage(UIImage(systemName: "stop.circle"), for: .normal)
            AARecorder.startAudioRecording(numberOfRecords, filename)
        } else {
            isRecord = true
            AARecorder.stopAudioRecording()
            recordButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
            UserDefaults.standard.set(numberOfRecords, forKey: "myRecord")
            isRecording = false
            isRecordingLabel.isHidden = !isRecording
        }
    }

    
    @IBAction func openRecordingList(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "RecordingListViewController") as? RecordingListViewController else {
           return
         }
        vc.filename = filename
        navigationController?.pushViewController(vc, animated: true)
    }
}

    extension RecorderViewController: AppAudioRecorderDelegate {
        func audioRecorderFailed(errorMessage: String) {
            print(errorMessage)
            self.showBasicAlert(title: "Failed", message: "\(errorMessage)")
        }
        
        func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
            audioFileURL = recorder.url
            self.showBasicAlert(title: "\(flag == true ? "Success" : "Failed")", message: "Audio has been recorded at \(audioFileURL!)")
        }
        
        func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
            print("\(recorder) \n /n \(String(describing: error?.localizedDescription))")
        }
        
        func audioRecorderBeginInterruption(_ recorder: AVAudioRecorder) {
            print("\(recorder)")
        }
        
        func audioRecorderEndInterruption(_ recorder: AVAudioRecorder, withOptions flags: Int) {
            print("\(recorder) \n /n \(flags)")
        }
        
        func audioSessionPermission(granted: Bool) {
            print(granted)
        }
    }

    // MARK: - Extension to show alert
    extension UIViewController {
        func showBasicAlert(title : String?, message : String) {
            // Show alert
            let alertController: UIAlertController = UIAlertController(title: title == nil ? "Title" : title!, message: message, preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "OK", style: .default, handler: { action in
                alertController .dismiss(animated: true, completion: nil)
            })
            alertController.addAction(actionOk)
            self.present(alertController, animated: true, completion: nil)
        }
}
