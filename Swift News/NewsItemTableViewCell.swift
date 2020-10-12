//
//  NewsItemTableViewCell.swift
//  Swift News
//
//  Created by Atomicflare on 2020-10-10.
//

import UIKit

class NewsItemTableViewCell: UITableViewCell {
    static let reuseseIdentifier = "NewsItemTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var thumbImageHeightConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        thumbImageView.image = nil
        thumbImageHeightConstraint.constant = 0
        super.prepareForReuse()
    }
    
    func configureWithImageData(_ data: Data, cellWidth: CGFloat) {
        thumbImageView.image = UIImage(data: data)
        if let image = thumbImageView.image {
            let mode = cellWidth / image.size.width
            let imageHeight = image.size.height * mode
            thumbImageHeightConstraint.constant = imageHeight
        }
    }
}
