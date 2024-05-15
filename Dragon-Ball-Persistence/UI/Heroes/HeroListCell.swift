//
//  HeroListCell.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 21-04-24.
//

import UIKit
import Kingfisher

class HeroListCell: UICollectionViewCell {

    @IBOutlet weak var imageHero: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    
    static var reuseIdentifier: String {
        print(String(describing:self))
        return String(describing:self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func prepareForReuse() {
        labelName.text = nil
    }
    
    func configureWith(name: String?) {
        labelName.text = name
    }
    
    func configureWith(image: String?) {
        if let photo = image{
            
            let processor = RoundCornerImageProcessor(cornerRadius: 10)
            imageHero.kf.setImage(with: URL(string: photo), placeholder: nil, options: [.transition(.fade(0.2)), .processor(processor)])
           
        }
    }

}
