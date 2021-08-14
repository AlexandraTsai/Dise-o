//
//  Banner.swift
//  Diseno
//
//  Created by 蔡佳宣 on 2021/7/31.
//  Copyright © 2021 蔡佳宣. All rights reserved.
//

import UIKit

class NotificationBanner: UIView {
    /// If this is not nil, then this height will be used instead of the auto calculated height
    var customBannerHeight: CGFloat?

    /// If false, the banner will not be dismissed until the developer programatically dismisses it
    var autoDismiss: Bool = true

    /// The time before the notificaiton is automatically dismissed
    var dismissDuration: TimeInterval = 3.0

    init(title: String,
         style: BannerStyle,
         color: UIColor? = nil,
         animationDuration: TimeInterval = 0.3) {
        self.bannerStyle = style
        self.animationDuration = animationDuration
        super.init(frame: .zero)

        titleLabel.text = title
        contentView.backgroundColor = color ?? style.color
        setupViews()
        setupStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyStyling(font: UIFont? = nil,
                      titleColor: UIColor? = nil,
                      alignment: NSTextAlignment? = nil) {
        if let font = font {
            titleLabel.font = font
        }
        titleLabel.textColor = titleColor ?? bannerStyle.titleColor
        titleLabel.textAlignment = alignment ?? .left
    }

    func show() {
        appWindow?.addSubview(self)
        prepareEndFrame()
        prepareStartFrame()

        frame = startFrame

        UIView.animate(
            withDuration: animationDuration,
            delay: 0.0,
            options: [.curveLinear],
            animations: {
                self.frame = self.endFrame
            },
            completion: { _ in
                if self.autoDismiss {
                    self.dismiss()
                }
            })
    }

    private let bannerStyle: BannerStyle

    /// The view that the notification layout is presented on. The constraints/frame of this should not be changed
    private let contentView = UIView()

    private let titleLabel = UILabel() --> {
        $0.font = .fontMedium(ofSize: 18)
        $0.textColor = .black
    }

    private var startFrame: CGRect = .zero

    private var endFrame: CGRect = .zero

    /// Banner show and dimiss animation duration
    private let animationDuration: TimeInterval

    /// The main window of the application which banner views are placed on
    private let appWindow: UIWindow? = {
        UIApplication.shared.appWindow
    }()
}

// MARK: - Private Proterties
private extension NotificationBanner {
    /// The height of the banner when it is presented
    var bannerHeight: CGFloat {
        if let customBannerHeight = customBannerHeight {
            return customBannerHeight
        } else {
            return 40.0 + heightAdjustment
        }
    }

    /// The height adjustment needed in order for the banner to look properly displayed.
    var heightAdjustment: CGFloat {
        if IPhoneUtility.isNotchFeaturedIPhone() {
            return appWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        }
        return 0
    }
}

private extension NotificationBanner {
    func setupViews() {
        addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.greaterThanOrEqualToSuperview()
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }

    func setupStyle() {
        backgroundColor = contentView.backgroundColor
        titleLabel.textColor = bannerStyle.titleColor
    }

    func dismiss() {
        UIView.animate(
            withDuration: animationDuration,
            delay: dismissDuration,
            options: [.curveLinear],
            animations: {
                self.frame = self.startFrame
            },
            completion: { _ in
                self.removeFromSuperview()
           })
    }

    func prepareEndFrame() {
        endFrame = CGRect(origin: .zero, size: .init(width: appWindow?.width ?? 0, height: bannerHeight))
    }

    func prepareStartFrame() {
        startFrame = CGRect(origin: .init(x: 0, y: -bannerHeight),
                            size: endFrame.size)
    }
}

extension NotificationBanner {
    enum BannerStyle {
        case success
        case fail

        var color: UIColor {
            switch self {
            case .success: return UIColor.DSColor.yellow
            case .fail:    return UIColor.DSColor.error
            }
        }

        var titleColor: UIColor {
            .white
        }
    }
}
