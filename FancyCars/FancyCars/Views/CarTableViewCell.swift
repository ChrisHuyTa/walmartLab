//
//  CarTableViewCell.swift
//  FancyCars
//
//  Created by Chris Ta on 2019-09-08.
//  Copyright © 2019 WalmartLab. All rights reserved.
//

import UIKit

protocol CarCellDelegate: class {
    func didBuy(from cell: CarTableViewCell)
}

class CarTableViewCell: UITableViewCell {

    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var make: UILabel!
    @IBOutlet weak var model: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var availability: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    weak var delegate: CarCellDelegate?
    
    private let availabilityStr = "Availability: "
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        buyButton.layer.borderWidth = 1
        buyButton.layer.borderColor = UIColor(red: 14/255, green: 122/255, blue: 254/255, alpha: 1).cgColor
        buyButton.layer.cornerRadius = 5
        availability.text = availabilityStr
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.carImage.image = UIImage(named: "PlaceHolder")
    }
    
    func populate(car: FancyCar) {
        if let url = car.imageUrl {
            carImage.loadImage(from: URL(string: url)!)
        }
        name.text = "Name: \(car.name)"
        make.text = "Make: \(car.make)"
        model.text = "Model: \(car.model)"
        year.text = "Year: \(car.year)"
        
    }
    
    @objc func didTapBuyButton() {
        
    }
}
