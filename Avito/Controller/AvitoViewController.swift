//
//  ViewController.swift
//  Avito
//
//  Created by Егор on 09.01.2021.
//

import UIKit

class AvitoViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    
    var selectedIndexPath: IndexPath?
    var selectedCellforAlert: Int?
    var selectedCell: AvitoCollectionViewCell?
    var a: Int?
    
    var avitoManager = AvitoManager()
    
    var buttonText = ""
    var headerText = ""
    var serviceName: [String] = []
    var serviceDescription: [String] = []
    var servicePrice: [String] = []
    var serviceIcon: [String] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        avitoManager.delegate = self
        
        if let _ = avitoManager.readLocalFile(forName: "result") {
            avitoManager.readLocalFile(forName: "result")
        }
        
        button.layer.cornerRadius = button.frame.size.height / 10
        button.setTitle(buttonText, for: .normal)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        if selectedCellforAlert == nil {
            let alert = UIAlertController(title: "Пожалуйста, выберите услугу", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else {
            
            let alert = UIAlertController(title: "\(serviceName[selectedCellforAlert!])", message: "Теперь Ваш товар увидит большее количество потенциальных покупателей!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
}



//MARK: - UIImageView

extension UIImageView {
    public func imageFromURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
}

//MARK: - AvitoManagerDelegate

extension AvitoViewController: AvitoManagerDelegate {
    
    func didUpdate (_ avitoManager: AvitoManager, avitoModel: AvitoModel) {
        
        buttonText = avitoModel.selectedActionTitle
        headerText = avitoModel.title
        serviceName = avitoModel.listTitle
        serviceDescription = avitoModel.listDescription
        servicePrice = avitoModel.listPrice
        serviceIcon = avitoModel.listIcon
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - llectionViewDelegateFlowLayout, UICollectionViewDataSource

extension AvitoViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvitoCell", for: indexPath) as! AvitoCollectionViewCell
        
        var row = 0
        
        switch indexPath.row{
        case 0:
            row = 0
        default:
            row = 1
        }
        
        cell.layer.cornerRadius = cell.frame.size.height / 20
        cell.serviceIsSelected.image = #imageLiteral(resourceName: "checkmark")
        cell.serviceIsSelected.isHidden = true
        cell.serviceImage.imageFromURL(urlString: serviceIcon[row])
        
        cell.serviceName.text = serviceName[row]
        cell.serviceDescription.text = serviceDescription[row]
        cell.servicePrice.text = servicePrice[row]
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.row {
        case 0:
            return CGSize(width: button.frame.size.width, height: 180)
        default:
            return CGSize(width: button.frame.size.width, height: 150)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "AvitoHeader", for: indexPath) as! AvitoHeaderView
        
        header.annotation.frame.size.width = button.frame.size.width
        header.annotation.text = headerText
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! AvitoCollectionViewCell
        
        if cell.isSelected {
            collectionView.deselectItem(at: indexPath, animated: true)
            selectedCellforAlert = indexPath.row
            selectedCell = cell
            animation()
            selectedCellforAlert = nil
            return false
        } else {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            selectedCellforAlert = indexPath.row
            selectedCell = cell
            animation()
            return true
        }
    }
    
    func animation () {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.selectedCell?.contentView.alpha = 0.4
                       }) { (completed) in
            UIView.animate(withDuration: 0.1,
                           animations: {
                            self.selectedCell?.contentView.alpha = 1
                           })
        }
    }
}

