//
//  ListViewController.swift
//  recordingApp
//
//  Created by Gaurav Sara on 13/09/23.
//

import UIKit
import AVFAudio
import Alamofire

class RecordingListViewController: UIViewController {
    @IBOutlet weak var listTableView: UITableView!
    
    let nib = UINib(nibName: "ListViewCell", bundle: nil)
    
    var audioPlayer = AVAudioPlayer()
    var isPlaying = false
    var indexNumber = 0
    var number = 0
    var filename: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        number = UserDefaults.standard.object(forKey: "myRecord") as! Int
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        // Create a new button and set it as a clear button
        let button = UIButton(type: .system)
        button.setTitle("Clear All", for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        // Get the existing right bar button items
        let existingButtons = navigationItem.rightBarButtonItems ?? []

        // Add our new button to the array
        let newButton = UIBarButtonItem(customView: button)
        let buttons = existingButtons + [newButton]

        // Set rightBarButtonItems to the array
        navigationItem.rightBarButtonItems = buttons
        
        listTableView.register(nib, forCellReuseIdentifier: "ListViewCell")
    }
    
    @objc func buttonTapped() {
        UserDefaults.standard.set(0, forKey: "myRecord")
        number = 0
        
        UserDefaults.standard.removeObject(forKey: "uploadedFileName")
        
        cleanDocumentDirectory()
        
        DispatchQueue.main.async {
            self.listTableView.reloadData()
        }
    }
    
    func cleanDocumentDirectory() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil, options: [])

            for fileURL in fileURLs {
                print(fileURL, "FiLEUROLLLLLL")
                try FileManager.default.removeItem(at: fileURL)
                print("Deleted: \(fileURL.lastPathComponent)")
            }
        } catch {
            print("Error cleaning document directory: \(error)")
        }
    }
}

extension RecordingListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         number
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell") as? ListViewCell else { return UITableViewCell() }
        
        cell.indexPath = indexPath
        cell.recordingLabel?.text = "00\(indexPath.row + 1)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row + 1
        if index > 99 {
            filename = "\(index)"
        } else if index > 9 {
            filename = "0\(index)"
        } else {
            filename = "00\(index)"
        }
        
        let directoryPath = AudioSessionConfig.getDirectoryURLForFileName(fName: filename)!
        do {
            isPlaying = !isPlaying
            audioPlayer = try AVAudioPlayer(contentsOf: directoryPath)
            
            if isPlaying {
                audioPlayer.play()
            } else {
                audioPlayer.stop()
            }
        } catch {
            print(error)
        }
    }
}
