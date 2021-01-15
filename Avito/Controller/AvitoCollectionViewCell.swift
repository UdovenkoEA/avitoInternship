//
//  AvitoCollectionViewCell.swift
//  Avito
//
//  Created by Егор on 11.01.2021.
//

import UIKit

class AvitoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var serviceImage: UIImageView!
    
    @IBOutlet weak var serviceName: UILabel!
    
    @IBOutlet weak var serviceDescription: UILabel!
    
    @IBOutlet weak var servicePrice: UILabel!
    
    @IBOutlet weak var serviceIsSelected: UIImageView!
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                //                self.contentView.backgroundColor = UIColor.red
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.serviceIsSelected.isHidden = false
                }
            }
            else
            {
                //                self.contentView.backgroundColor = UIColor.gray
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.serviceIsSelected.isHidden = true
                }
            }
        }
    }
}


