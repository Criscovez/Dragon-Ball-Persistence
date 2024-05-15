//
//  HeroCell.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 19-04-24.
//

import UIKit
import Kingfisher

struct HeroCellModel {
    let name: String?
    let photo: String?
}

class HeroCell: UICollectionViewCell {
    
    @IBOutlet weak var imageHero: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    
    static var reuseIdentifier: String {
        return String(describing:self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
  //  }
    
//    func configureWith(model: HeroCellModel) {
//        labelName.text = model.name
//        if let photo = model.photo {
//            imageHero.kf.setImage(with: URL(string: photo), options: [.transition(.fade(0.2))])
//        }
//    }
    
    override func prepareForReuse() {
        labelName.text = nil
    }
    
    func configureWith(name: String?) {
        labelName.text = name
    }
    
}
