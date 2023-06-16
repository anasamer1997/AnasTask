//
//  RespositoryVM.swift
//  AnasTask
//
//  Created by mac on 16/06/2023.
//

import Foundation
class RepositoryViewModel{
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var currentPage = 1
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var allRepos:[SearchResult] = []
    
    func getRepository(){
        state = .loading
        
        Networking.shared.fetchRepository(currentPage:currentPage) { [weak self] repos,error in
            guard let self = self else {
                return
            }
            if error != nil {
                self.state = .error
                self.alertMessage = error
            }else{
                self.state = .populated
                repos?.forEach({
                    self.allRepos.append(SearchResult(id: $0.id,
                                                      title: $0.name,
                                                      description: $0.description ?? "",
                                                      watchers: $0.watchers,
                                                      url: $0.html_url))
                })
            }
        }
    }
}

class SearchResult{
    let id:Int
    let title:String
    let description:String
    let url:String
    let watchers:Int
    init(id: Int, title: String, description: String, watchers: Int,url:String) {
        self.id = id
        self.title = title
        self.description = description
        self.watchers = watchers
        self.url = url
    }
}
