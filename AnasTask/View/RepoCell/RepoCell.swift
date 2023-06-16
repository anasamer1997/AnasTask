//
//  RepoCell.swift
//  AnasTask
//
//  Created by mac on 16/06/2023.
//

import UIKit

class RepoCell: UITableViewCell {

    @IBOutlet weak var repo_name: UILabel!
    
    @IBOutlet weak var repo_description: UILabel!
    
    @IBOutlet weak var repo_watcher: UILabel!
    
    var repoData:SearchResult? {
        didSet{
            repo_name.text = "Repo Name : \(repoData?.title ?? "Unknown")"
            repo_watcher.text =  "\(repoData?.watchers ?? 0)"
            repo_description.text = "Description : \(repoData?.description ?? "")"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
