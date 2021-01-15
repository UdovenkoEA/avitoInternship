//
//  InformationManager.swift
//  Avito
//
//  Created by Егор on 09.01.2021.
//

import Foundation

protocol AvitoManagerDelegate {
    func didUpdate (_ avitoManager: AvitoManager, avitoModel: AvitoModel)
    func didFailWithError(error: Error)
}

struct AvitoManager {
    
    var delegate: AvitoManagerDelegate?
    
    func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
               let avitoData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                if let avitoModel = self.parseJSON(avitoData) {
                    self.delegate?.didUpdate(self, avitoModel: avitoModel)
                }
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    private func parseJSON(_ avitoData: Data) -> AvitoModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(AvitoData.self, from: avitoData)
            
            let title = decodedData.result.title
            let actionTitle = decodedData.result.actionTitle
            let selectedActionTitle = (decodedData.result.selectedActionTitle)
            let listId = [decodedData.result.list[0].id, decodedData.result.list[1].id]
            let listTitle = [decodedData.result.list[0].title, decodedData.result.list[1].title]
            let listDescription = [decodedData.result.list[0].description!, decodedData.result.list[1].description!]
            let listIcon = [decodedData.result.list[0].icon._52x52, decodedData.result.list[1].icon._52x52]
            let listPrice = [decodedData.result.list[0].price, decodedData.result.list[1].price]
            let listIsSelected = [decodedData.result.list[0].isSelected, decodedData.result.list[1].isSelected]
            
            let avitoModel = AvitoModel(title: title, actionTitle: actionTitle, selectedActionTitle: selectedActionTitle, listId: listId, listTitle: listTitle, listDescription: listDescription, listIcon: listIcon, listPrice: listPrice, listIsSelected: listIsSelected)
            
            return avitoModel
            
        } catch {
            print(error)
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
}
