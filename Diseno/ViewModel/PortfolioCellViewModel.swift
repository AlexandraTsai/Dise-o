//
//  PortfolioCellViewModel.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/7/18.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import UIKit

struct Portfolio {
    var image: UIImage?
    let name: String
}

protocol PortfolioCellViewModelOutput {
    var portfolio: Portfolio { get }
}

class PortfolioCellViewModel: PortfolioCellViewModelOutput {
    var portfolio = Portfolio(image: nil, name: "")

    init(design: Design) {
        self.design = design
        guard let designName = design.designName,
              let screeshot = design.screenshot else { return }
        portfolio = Portfolio(image: FileManager.loadImageFromDisk(fileName: screeshot), name: designName)
    }

    private let design: Design
}
