//
//  ChatMessageCell.swift
//  HelloPackageDescription
//
//  Created by Joshua Coleman on 3/27/18.
//

import UIKit

class ChatMessageCell: UITableViewCell {
    
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    func configureWith(_ message: ChatMessage){
        senderLabel.text = message.sender
        contentLabel.text = message.text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = false 
    }
 
    override func prepareForReuse() {
        super.prepareForReuse()
        senderLabel.text = nil
        contentLabel.text = nil
    }
}
