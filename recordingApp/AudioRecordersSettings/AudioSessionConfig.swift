//
//  AudioSessionConfig.swift
//  recordingApp
//
//  Created by Repcard on 26/09/23.
//

import UIKit
import AVFoundation

/// This class will be responsible for configuring the Audio session
class AudioSessionConfig: NSObject {
    /// AVAudio session
    public var audioSession: AVAudioSession!
    
    /// Singleton object for MPAudioSessionConfig
    static let shared = AudioSessionConfig()
    
    /// Initialising the AVAudioSession for recording
    ///
    /// - Parameter completionHandlerWithGrantPermission: Permission status that is granted or not will be return with success true and failed false.
    public func initialiseRecordingSession( completionHandlerWithGrantPermission :@escaping (_ permissionStatus : Bool, _ audioSession: AVAudioSession?) -> Void)
    {
        if audioSession == nil
        {
            audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
                try audioSession.setActive(true)
                
                audioSession.requestRecordPermission()
                { [unowned self] allowed in
                    DispatchQueue.main.async {
                        if allowed {
                            completionHandlerWithGrantPermission(true, self.audioSession)
                        } else {
                            completionHandlerWithGrantPermission(false, nil)
                        }
                    }
                }
            } catch {
                completionHandlerWithGrantPermission(false, nil)
            }
        }
    }
    
    class func getDirectoryURLForFileName(fName : String) -> URL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent("\(fName).m4a")
//        do
//        {
//            try FileManager.default.removeItem(at: soundURL)
//        } catch let error as NSError
//        {
//            print(error.debugDescription)
//        }
//        return soundURL as URL?
        return soundURL
    }
    
    class func getDefaultAudioSettings() -> [String : Int] {
        return [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
    }
}
