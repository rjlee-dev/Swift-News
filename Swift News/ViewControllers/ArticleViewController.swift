//
//  ArticleViewController.swift
//  Swift News
//
//  Created by Atomicflare on 2020-10-10.
//

import UIKit

class ArticleViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var model = ArticleModel()
    
    func configure(_ articleItem: Article) {
        model.articleItem = articleItem
        navigationItem.title = model.title()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK - UITableViewDelegate, UITableViewDataSource
extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch model.cellForIndex(indexPath) {
        case .content(let content):
            let cell = tableView.dequeueReusableCell(withIdentifier: ArticleContentTableViewCell.reuseseIdentifier) as! ArticleContentTableViewCell
            cell.contentLabel?.text = content
            return cell
        case .image(let url) :
            let cell = tableView.dequeueReusableCell(withIdentifier: ArticleImageTableViewCell.reuseseIdentifier) as! ArticleImageTableViewCell
            
            APIRequest.loadThumbnail(url: url, indexPath: indexPath) { (data) in
                
                cell.configureWithImageData(data, cellWidth: tableView.bounds.width)
            }
            return cell
        case .none:
            return UITableViewCell()
        }

    }
    
}

// MARK - Model Class
class ArticleModel {
    enum CellType {
        case image(String), content(String), none
    }
    
    var articleItem: Article?
    func title() -> String {
        return articleItem?.title ?? ""
    }
    
    func cellForIndex(_ indexPath: IndexPath) -> CellType {
        switch indexPath.row {
        case 0:
            return .image(articleItem?.thumbnailUrl ?? "")
        case 1:
            return .content(articleItem?.body ?? "")
        default:
            return .none
        }
    }
    
    func numberOfRows() -> Int  {
        guard let articleItem = articleItem else {
            return 0
        }
        
        if articleItem.thumbnailUrl != nil {
            return 2
        } else {
            return 1
        }
    }
}
