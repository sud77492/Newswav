//
//  GistItemTableViewCell.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/02.
//  Copyright © 2017 miso. All rights reserved.
//

import UIKit
import Kingfisher

class GistItemTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var secretLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor().getCustomBlack()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        separatorInset.left = titleLabel.convert(titleLabel.bounds.origin, to: self).x
    }
    
    public var gist: Gist! {
        didSet {
         self.titleLabel.text = gist.getFirstFileName()
            self.descriptionLabel.text = gist.description
            let url = URL(string: self.gist.owner?.avatar_url ?? "")
            self.iconImageView.kf.setImage(with: url)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

