//
//  TransformationCollectionViewCell.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 26-04-24.
//

import UIKit
import Kingfisher

struct TransformationCellModel {
    let name: String?
    let photo: String?
}

class TransformationCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        return String(describing:self)
    }
    
    @IBOutlet weak var imageTransformation: UIImageView!
    
    @IBOutlet weak var nameTransformation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        imageTransformation.layer.cornerRadius = 80
        //        imageTransformation.layer.masksToBounds = true
        nameTransformation.layer.cornerRadius = 8
        nameTransformation.layer.masksToBounds = true
        // Initialization code
    }
    
    
    //imageView.kf.setImage(with: url, placeholder: nil, options: [.processor(processor)])
    
    func configureWith(model: TransformationCellModel) {
        nameTransformation.text = model.name
        if let photo = model.photo {
            let processor = RoundCornerImageProcessor(cornerRadius: 40)
            imageTransformation.kf.setImage(with: URL(string: photo), placeholder: nil, options: [.transition(.fade(0.2)), .processor(processor)])
        }
    }
    
    func configureWith(name: String?) {
        nameTransformation.text = "   " + (name ?? "") + "   "
    }
    
    func configureWith(image: String?) {
        if let photo = image{
            
            let processor = RoundCornerImageProcessor(cornerRadius: 10)
            imageTransformation.kf.setImage(with: URL(string: photo), placeholder: nil, options: [.transition(.fade(0.2)), .processor(processor)])
            
        }
        
    }
}
