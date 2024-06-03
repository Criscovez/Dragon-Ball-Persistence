//
//  TransformationViewController.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 28-04-24.
//

import UIKit

class TransformationViewController: UIViewController {

    @IBOutlet weak var imageTransformation: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelDescription: UILabel!
    
    
    let viewModel: TransformationProtocol
    
    init(viewModel: TransformationProtocol) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: TransformationViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let photo = viewModel.getImage() {
            imageTransformation.kf.setImage(with: URL(string: photo), options: [.transition(.fade(0.2))])
        }
        print(viewModel.getDescription())
        labelTitle.text = viewModel.getTitle()
        labelDescription.text = viewModel.getDescription()
        print(labelDescription.text!)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
