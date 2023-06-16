//
//  ViewController.swift
//  AnasTask
//
//  Created by mac on 16/06/2023.
//

import UIKit



class RepositoryVC: UIViewController ,UISearchBarDelegate{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var repo_tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    lazy var viewModel: RepositoryViewModel = {
        return RepositoryViewModel()
    }()
    var filteredData:[SearchResult] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initReposList()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.allRepos = []
    }

    
    private func initReposList(){
        viewModel.showAlertClosure = { [weak self] in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    print("message \(message)")
                    self?.showAlert(message)
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                switch viewModel.state {
                    
                case .loading:
                    print("loading")
                    activityIndicator.startAnimating()
                    
                case .populated:
                    print("populated")
                    activityIndicator.stopAnimating()
                    self.filteredData = viewModel.allRepos
                    DispatchQueue.main.async {
                        self.repo_tableView.reloadData()
                    }
                case .error, .empty:
                    print("error")
                    activityIndicator.stopAnimating()
                }
            }
            
        }
        viewModel.getRepository()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        if searchText == ""{
            filteredData = viewModel.allRepos
        }else{
            for repo in viewModel.allRepos {
                if repo.title.contains(searchText.lowercased()){
                    filteredData.append(repo)
                }
            }
        }
        self.repo_tableView.reloadData()
    }
}
extension RepositoryVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let repoCell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as! RepoCell
        repoCell.repoData = filteredData[indexPath.row]
        return repoCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // open repo on browser
        let selectedLink = filteredData[indexPath.row].url
        guard let url = URL(string: selectedLink) else {return}
        UIApplication.shared.open(url)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.currentPage < 11 && indexPath.row == viewModel.allRepos.count - 1 {
            viewModel.currentPage += 1
            initReposList()
        }
    }
    
}

