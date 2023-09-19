//
//  ListViewController.swift
//  recordingApp
//
//  Created by Gaurav Sara on 13/09/23.
//

import UIKit
import AVFAudio
import Alamofire

struct Audio: Decodable {
    let id: Int
    let url: Data
}

class ListViewController: UIViewController, Reloadable {
    
//    var audioCollection: [Audio] = []
    @IBOutlet weak var listTableView: UITableView!
    
    var delegate: Reloadable?
    
    let viewController = ViewController()
    let listViewCell = ListViewCell()
    let nib = UINib(nibName: "ListViewCell", bundle: nil)
    
    var audioPlayer = AVAudioPlayer()
    var isPlaying = false
    var indexNumber = 0
    
    var number = UserDefaults.standard.object(forKey: "myRecord")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        // Create the new button
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
        number = UserDefaults.standard.removeObject(forKey: "myRecord")
        
        listViewCell.nameCollection = [Json()]
        UserDefaults.standard.removeObject(forKey: "uploadedFileName")

        viewController.numberOfRecords = 0
        listViewCell.indexPath = IndexPath(row: 0, section: 0)
        cleanDocumentDirectory()
        reloadData()

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
    
    func reloadData() {
        delegate?.reloadData()
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (UserDefaults.standard.object(forKey: "myRecord")) != nil {
            
            return number as! Int
        } else {
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell") as? ListViewCell else { return UITableViewCell() }
        
        if cell.indexPath.row == 0 && indexPath.section == 0 {
            cell.indexPath = IndexPath(row: 0, section: 0)
        } else {
            cell.indexPath = indexPath
        }
        
        let directoryPath = viewController.getDirectory().appendingPathComponent("\(indexPath.row + 1)")
        cell.recordingLabel?.text = directoryPath.absoluteString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = viewController.getDirectory().appendingPathComponent("\(indexPath.row + 1).m4a")
    
        do {
            isPlaying = !isPlaying
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            
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
