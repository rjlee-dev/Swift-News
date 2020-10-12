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
    var thumbnailUrl: String?
    
    init(title: String, url: String, body: String, thumbnailUrl: String? ) {
        self.title = title
        self.url = url
        self.body = body
        self.thumbnailUrl = thumbnailUrl
    }
}

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
        guard let url = URL(string: url ?? ""), let imageData = try? Data(contentsOf: url) else { return }
        onComplete?(imageData)
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

private func parseRedditSwiftNews(_ data: Data) throws -> [Article]  {
    var pool: [Article] = []
    
    do {
        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            let data1 = jsonResult["data"] as! [String: Any]
            let data2 = data1["children"] as! [[String: Any]]
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
