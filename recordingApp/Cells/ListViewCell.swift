//
//  ListViewCell.swift
//  recordingApp
//
//  Created by Gaurav Sara on 14/09/23.
//

import UIKit
import Alamofire

struct DecodableType: Decodable { let url: String }

class ListViewCell: UITableViewCell {
    @IBOutlet weak var uploadButton: UIButton!
    var viewController = ViewController()
    var indexPath: IndexPath = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func setupUI() {
        uploadButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
    }
    
    @IBAction func uploadButton(_ sender: Any) {
        let path = viewController.getDirectory().appendingPathComponent("\(indexPath.row + 1).m4a")

        let m4aData = try! Data(contentsOf: path)

        AF.upload(m4aData, to: "https://vzaskrnvze.execute-api.us-east-1.amazonaws.com/uploadFile").responseData { response in
                switch response.result {
                case .success:
                    print("File uploaded successfully")
                case .failure:
                    print(response.error!)
            }
        }
    }
}
