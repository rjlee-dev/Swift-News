 //
//  APIRequest.swift
//  Swift News
//
//  Created by Atomicflare on 2020-10-10.
//

import UIKit

struct Article: Decodable {
    var title: String?
    var url: String?
    var body: String?
//    var thumbnail: Thumbnail?
    var thumbnailUrl: String?
    
    init(title: String, url: String, body: String, thumbnailUrl: String? ) {
        self.title = title
        self.url = url
        self.body = body
//        self.thumbnail = thumbnail
        self.thumbnailUrl = thumbnailUrl
    }
}

//struct Thumbnail: Decodable {
//    var url: String
//    var width: String
//    var height: String
//
//    init?(path: String?, width: String?, height: String?) {
//        guard let path = path, let width = width, let height = height, path != "<null>", path != "self", path != "default" , width != "<null>", height != "<null>" else {
//            return nil
//        }
//        self.url = path
//        self.width = width
//        self.height = height
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case url = "thumbnail", width = "thumbnail_width" , height = "thumbnail_height"
//    }
//}

enum ArticleResult {
    case success([Article])
    case failure(NSError)
}

protocol APIRequestProtocol {
    static func getArticleData(onComplete: @escaping (ArticleResult) -> ())
    static func loadThumbnail(url: String?, indexPath: IndexPath, onComplete: ((Data) -> ())?)
}

enum APIRequest: APIRequestProtocol {
    
    static func loadThumbnail(url: String?, indexPath: IndexPath, onComplete:  ((Data) -> ())?) {
        guard let url = URL(string: url ?? "") else { return }
        
        
        guard let imageData = try? Data(contentsOf: url) else {
          return
        }
        onComplete?(imageData)
        
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data, error != nil else {
//                return
//            }
//            DispatchQueue.main.async {
////                indexPath
//                    onComplete?(data)
////                    self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
//
//            }
//            }.resume()
    }

    
    
    static func getArticleData(onComplete: @escaping (ArticleResult) -> ()) {
        guard let url = URL(string: "https://www.reddit.com/r/swift/.json") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, responce, error) in
            DispatchQueue.main.async {
                if let error = error as NSError? {
                    onComplete(ArticleResult.failure(error))
                    return
                }
                var pool: [Article] = []
                do {
                    pool = try parseRedditSwiftNews(data!)
                    onComplete(ArticleResult.success(pool))
                } catch let error as NSError {
                    print(error.localizedDescription)
                    onComplete(ArticleResult.failure(error))
                }
                
            }
        }
        task.resume()
    }
    
}


func parseRedditSwiftNews(_ data: Data) throws -> [Article]  {
    var pool: [Article] = []
    
    do {
        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            let data1 = jsonResult["data"] as! [String: Any]
            let data2 = data1["children"] as! [[String: Any]]
            print(data1)
            print(data2)
            for item in data2 {
                let data = item["data"] as! [String: Any]
                var thumbnailURL = data["thumbnail"] as? String
                
                if thumbnailURL == "self" {
                    thumbnailURL = nil
                }
                let article = Article(title: data["title"] as! String,
                                      url: data["url"] as! String,
                                      body: data["selftext"] as! String,
                                      thumbnailUrl: thumbnailURL)
                pool.append(article)
            }
            
        }
    }
    
    return pool
}
