//
//  ListViewController.swift
//  recordingApp
//
//  Created by Gaurav Sara on 13/09/23.
//

import UIKit
import AVFAudio
import Alamofire

class ListViewController: UIViewController {
    @IBOutlet weak var ListTableView: UITableView!
    
    let viewController = ViewController()
    
    var audioPlayer = AVAudioPlayer()
    var isPlaying = false
    var indexNumber = 0
    
    var number = UserDefaults.standard.object(forKey: "myRecord")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ListTableView.register(UINib(nibName: "ListViewCell", bundle: nil), forCellReuseIdentifier: "ListViewCell")
    }
    
    @IBAction func clearButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "myRecord")
        number = nil
        
        DispatchQueue.main.async {
            self.ListTableView.reloadData()
        }
    }
    
    func getIndexNumber(_ num: Int) -> Int {
        return num
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if number != nil {
            indexNumber = getIndexNumber(number as! Int)
            return number as! Int
        } else {
            indexNumber = getIndexNumber(0)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell") as? ListViewCell else { return UITableViewCell() }

        cell.textLabel?.text = String("recording \(indexPath.row + 1)")
        cell.indexPath = indexPath
        
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
