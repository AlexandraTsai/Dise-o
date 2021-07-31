//
//  SelectionView.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/23.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

enum PortfoliManageType: CaseIterable {
    case open
    case download
    case share
    case rename
    case delete

    var title: String {
        switch self {
        case .open: return "Open"
        case .download: return "Download"
        case .share: return "Share"
        case .rename: return "Rename"
        case .delete: return "Delete"
        }
    }

    var titleColor: UIColor {
        switch self {
        case .open, .delete:
            return .white
        default:
            return .black
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .open:
            return UIColor.DSColor.heavyGreen
        case .delete:
            return UIColor.DSColor.red
        default:
            return .white
        }
    }

    var borderColor: UIColor? {
        switch self {
        case .open, .delete:
            return nil
        default:
            return UIColor.DSColor.heavyGreen
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .open, .delete:
            return 0
        default:
            return 1
        }
    }
}

class ManagePortfolioView: UIView {
    let openButton = UIButton()
    let saveButton = UIButton()
    let shareButton = UIButton()
    let renameButton = UIButton()
    let deleteButton = UIButton()
    
    let cancelButton = UIButton() --> {
        $0.backgroundColor = UIColor.DSColor.lightGray
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = UIFont.fontMedium(ofSize: 16)
        $0.alpha = 0.6
        $0.layer.cornerRadius = 15
        $0.setTitle("CANCEL", for: .normal)
    }
    let closeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 20
        
        //Shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 12
        layer.shadowOpacity = 1
        
        //Add sub views
        setupLayout()
    }
    
    func setupLayout() {
        let actionContainer = UIStackView()
        actionContainer.axis = .vertical
        actionContainer.spacing = 15
        actionContainer.alignment = .center
        actionContainer.distribution = .fillEqually
        addSubview(actionContainer)
        actionContainer.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.left.right.equalToSuperview().inset(15)
        }

        PortfoliManageType.allCases.forEach {
            let button = UIButton()
            button.setTitle($0.title, for: .normal)
            button.titleLabel?.font = UIFont.fontMedium(ofSize: 16)
            button.setTitleColor($0.titleColor, for: .normal)
            button.backgroundColor = $0.backgroundColor
            button.layer.cornerRadius = 17
            button.layer.borderWidth = $0.borderWidth
            button.layer.borderColor = $0.borderColor?.cgColor
            actionContainer.addArrangedSubview(button)
            button.snp.makeConstraints {
                $0.left.right.equalToSuperview()
            }
        }

        //Cancel Button
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(actionContainer.snp.bottom).offset(15)
            $0.left.right.equalToSuperview().inset(50)
            $0.height.equalTo(30)
            $0.bottom.equalToSuperview().inset(20)
        }

        //Close Button
        addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(10)
            $0.height.width.equalTo(20)
        }
        closeButton.setImage(#imageLiteral(resourceName: "noun_Cancel"), for: .normal)
    }
}
