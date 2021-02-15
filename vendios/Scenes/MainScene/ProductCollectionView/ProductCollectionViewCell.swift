//
//  ProductCollectionViewCell.swift
//  vendios
//
//  Created by Rendy K.R on 23/12/20.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNamePriceLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    override var isHighlighted: Bool {
        didSet {
            cellIsHighlighted()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        infoLabel.backgroundColor = .black
        infoLabel.textColor = .white
        infoLabel.layer.cornerRadius = infoLabel.frame.size.height/2
        infoLabel.layer.masksToBounds = true
        
        self.contentView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.17
        self.layer.shadowRadius = 4.0
        self.layer.shadowOffset = CGSize(width: 0, height: 6)
        self.layer.masksToBounds = false
    }
    
    func cellIsHighlighted() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.alpha = self.isHighlighted ? 0.7 : 1.0
            self.transform = self.isHighlighted ?
                CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95) :
                CGAffineTransform.identity
        })
    }
    
}
