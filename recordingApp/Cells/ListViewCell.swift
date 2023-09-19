//
//  ListViewCell.swift
//  recordingApp
//
//  Created by Gaurav Sara on 14/09/23.
//

import UIKit
import Alamofire

struct Json: Codable {
    var fileName: String? = ""
}

struct TransScript: Decodable {
    var fileContent: String = ""
}
    
class ListViewCell: UITableViewCell {
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var transcriptBtn: UIButton!
    
    var viewController = ViewController()
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    var audioCollection: [Audio] = []
    var nameCollection: [Json] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        
        if let jsonArrayData = UserDefaults.standard.data(forKey: "uploadedFileName"),
           let decodedArray = try? JSONDecoder().decode([Json].self, from: jsonArrayData) {
            
            print(decodedArray, "decodeArray")
            nameCollection = decodedArray
            print(nameCollection, "from awake from Nib")
            
//            showTranscript()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func setupUI() {
        uploadBtn.setImage(UIImage(systemName: "arrow.up"), for: .normal)
    }
    
    @IBAction func uploadButton(_ sender: Any) {
        let path = viewController.getDirectory().appendingPathComponent("\(indexPath.row + 1).m4a")

        let m4aData = try! Data(contentsOf: path)

        uploadAudioFile(audioData: m4aData)
    }
    
    func uploadAudioFile(audioData: Data) {
        // MULTIPART
//        AF.upload(multipartFormData: { multipartFormData in
//            multipartFormData.append(audioData, withName: "audio", fileName: "\(self.indexPath.row + 1).m4a", mimeType: "audio/mp3")
//        }, to: "https://vzaskrnvze.execute-api.us-east-1.amazonaws.com/uploadFile").responseData { response in
//            switch response.result {
//            case .success(let data):
//                // The audio file was uploaded successfully.
//            let getData = try! JSONDecoder().decode(Json.self, from: data)
//                print(getData)
//            case .failure(let error):
//                // An error occurred while uploading the audio file.
//                print(error)
//            }
//        }
        
    AF.upload(audioData, to: "https://vzaskrnvze.execute-api.us-east-1.amazonaws.com/uploadFile",
              headers: ["Content-Type": "audio/mpeg"])
        .responseData { response in
            switch response.result {
            case .success(let data):
                let getData = try! JSONDecoder().decode(Json.self, from: data)
                
                // storing Data
                self.nameCollection.append(Json(fileName: getData.fileName))
                
                if let jsonData = try? JSONEncoder().encode(self.nameCollection) {
                    UserDefaults.standard.set(jsonData, forKey: "uploadedFileName")
                    
                    UserDefaults.standard.synchronize()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func showTranscript() {
        let filename = nameCollection[0].fileName!
        print(filename, "type of the file")
        
        AF.request("https://7uzj0h0zkb.execute-api.us-east-1.amazonaws.com/default/getTransciptfile",
                   method: .post,
                   parameters: ["fileName": TransScript.init(fileContent: filename)],
                   headers: nil).responseData { response in
            switch response.result {
            case .success(let data):
                print(data, "Data....")
                let getData = try! JSONDecoder().decode(TransScript.self, from: data)
                print(getData, "Hello")
            case .failure(let error):
                print(error)
            }
        }
    }
}
