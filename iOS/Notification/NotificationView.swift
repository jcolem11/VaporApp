//
//  NotificationView.swift
//  VaporApp
//
//  Created by Joshua Coleman on 3/14/18.
//

import Foundation
import UIKit


struct NotificationMessage{
    var title: String = ""
    var content: String = ""
}

class NotificationView: UIView {
    
    typealias NotificationViewTapHandler = () -> Void
    
    //MARK: Properties
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            self.titleLabel.text = message.title
        }
    }
    
    @IBOutlet weak var contentLabel: UILabel!{
        didSet{
            self.contentLabel.text = message.content
        }
    }
    
    var message: NotificationMessage{
        didSet{
            titleLabel.text = message.title
            contentLabel.text = message.content
        }
    }
    
    var tapHandler: NotificationViewTapHandler?
    
    //MARK: Init
    init(notificationMessage message: NotificationMessage, tapHandler handler:@escaping NotificationViewTapHandler = {}) {
        self.message = message
        self.tapHandler = handler
        super.init(frame: CGRect.zero)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        message = NotificationMessage()
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    //MARK: Private

    private func nibSetup() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        contentView = loadViewFromNib()
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .red
        
        addSubview(contentView)

        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0).isActive = true
        contentView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0).isActive = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(executeTapHandler))
        addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func executeTapHandler() {
        guard let handler = tapHandler else {
            return
        }
        handler()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
}
