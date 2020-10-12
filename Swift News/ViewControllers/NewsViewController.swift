//
//  NewsViewController.swift
//  Swift News
//
//  Created by Atomicflare on 2020-10-10.
//

import UIKit

final class NewsViewController: UIViewController {

    let newsModel = NewsModel()
    var selectedArticle: Article?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Swift News"
        activityIndicatorView.startAnimating()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        APIRequest.getArticleData { (result) in
            switch result {
            case .success(let articles):
                self.newsModel.data = articles
                self.tableView.reloadData()
            case .failure(_):
                break
            }
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? UITableViewCell,
              let indexPath = tableView.indexPath(for: sender),
              let articleViewController = segue.destination as? ArticleViewController
              else { return }

        let selectedArticle = newsModel.articleForIndexPath(indexPath)
        articleViewController.configure(selectedArticle!)
    }
  
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let articleItem = newsModel.articleForIndexPath(indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsItemTableViewCell.reuseseIdentifier) as? NewsItemTableViewCell else {
            return UITableViewCell()
        }

        APIRequest.loadThumbnail(url: articleItem?.thumbnailUrl) { (data) in
            cell.configureWithImageData(data, cellWidth: tableView.bounds.width)
        }
        cell.titleLabel.text = articleItem?.title
        return cell
    }
    
}

// MARK - Model Class
class NewsModel {
    
    var data: [Article] = []
    
    func numberOfRows() -> Int  {
        return data.count
    }
    
    func articleForIndexPath(_ indexPath: IndexPath) -> Article? {
        return data[safe: indexPath.row]
    }
}
