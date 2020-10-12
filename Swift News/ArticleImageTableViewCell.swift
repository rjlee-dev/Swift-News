//
//  ArticleImageTableViewCell.swift
//  Swift News
//
//  Created by Atomicflare on 2020-10-10.
//

import UIKit

class ArticleImageTableViewCell: UITableViewCell {
    static let reuseseIdentifier = "ArticleImageTableViewCell"
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    func configureWithImageData(_ data: Data, cellWidth: CGFloat) {
        thumbnailImageView.image = UIImage(data: data)
        if let image = thumbnailImageView.image {
            let mode = cellWidth / image.size.width
            let imageHeight = image.size.height * mode
            heightConstraint.constant = imageHeight
        }
    }
    
    override func prepareForReuse() {
        heightConstraint.constant = 0
        thumbnailImageView.image = nil
    }
}
