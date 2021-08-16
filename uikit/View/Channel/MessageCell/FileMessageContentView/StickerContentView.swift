//
//  StickerContentView.swift
//  SendBirdUIKit-Sample
//
//  Created by Jay Ahn on 2021/08/02.
//  Copyright © 2021 SendBird, Inc. All rights reserved.
//

import UIKit
import SendBirdSDK

class StickerContentView: BaseFileContentView {
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .center
        return imageView
    }()
    
    var widthConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
    
    var text: String = ""
    
    // MARK: - Properties (Private)
    private var loadImageSession: URLSessionTask? {
        willSet {
            loadImageSession?.cancel()
        }
    }
    
    init() {
        super.init(frame: .zero)
        self.setupViews()
        self.setupAutolayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        self.setupAutolayout()
    }
    
    @available(*, unavailable, renamed: "ImageContentView(frame:)")
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupViews() {
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true
        
        self.addSubview(self.imageView)
        self.addSubview(self.iconImageView)
    }
    
    func setupAutolayout() {
        self.imageView.setConstraint(
            from: self,
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            priority: .defaultLow
        )
        
        self.setupSizeContraint()
        
        self.iconImageView
            .setConstraint(from: self, centerX: true, centerY: true)
            .setConstraint(width: 48, height: 48)
        self.iconImageView.layoutIfNeeded()
    }
    
    func setupSizeContraint() {
        self.widthConstraint = self.imageView.widthAnchor.constraint(
            equalToConstant: SBUConstant.thumbnailSize.width
        )
        self.heightConstraint = self.imageView.heightAnchor.constraint(
            equalToConstant: SBUConstant.thumbnailSize.height
        )
        
        NSLayoutConstraint.activate([
            self.widthConstraint,
            self.heightConstraint
        ])
    }
    
    override func setupStyles() {
        super.setupStyles()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupStyles()
    }
    
    override func configure(message: SBDFileMessage, position: MessagePosition) {
        if self.message?.requestId != message.requestId ||
            self.message?.updatedAt != message.updatedAt {
            self.imageView.image = nil
        }
        
        super.configure(message: message, position: position)
        
        self.resizeImageView(by: SBUConstant.stickerSize)
        
        
        self.imageView.loadImage(urlString: message.url)
        self.imageView.backgroundColor = .white
    }
    
    func setImage(_ image: UIImage?) {
        self.imageView.image = image
    }
    
    func resizeImageView(by size: CGSize) {
        self.widthConstraint.constant = min(size.width,
                                            SBUConstant.thumbnailSize.width)
        self.heightConstraint.constant = min(size.height,
                                             SBUConstant.thumbnailSize.height)
    }
}
