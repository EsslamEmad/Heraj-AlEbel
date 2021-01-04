//
//  ChatViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import MessageKit
import SwiftyUserDefaults
import InputBarAccessoryView
import IQKeyboardManagerSwift
import Photos
import Kingfisher

class ChatViewController: MessagesViewController {
    
    // MARK: - Variables
    var viewModel: ChatViewModel!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
    }
    
    // MARK: - UI Helpers
    private func configureUI() {
        navigationItem.title = viewModel.conversation?.otherUser.name ?? " "
        messagesCollectionView.backgroundColor = UIColor(hex: "ebebeb")
        configureCollectionView()
        configureTextBar()
    }
    
    private func configureCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
    }
    
    private func configureTextBar() {
        messageInputBar.delegate = self
        messageInputBar.backgroundView.backgroundColor = UIColor(hex: "ebebeb")
        messageInputBar.separatorLine.backgroundColor = UIColor(hex: "cfcfcf")
        
            messageInputBar.middleContentViewPadding.left = 8
        
        messageInputBar.middleContentViewPadding.bottom = 0
        messageInputBar.middleContentViewPadding.top = 8
        messageInputBar.middleContentView?.layer.borderWidth = 1
        messageInputBar.middleContentView?.layer.borderColor = UIColor(hex: "cfcfcf").cgColor
        messageInputBar.middleContentView?.layer.cornerRadius = 14
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
            messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        
        messageInputBar.inputTextView.backgroundColor = .white
        messageInputBar.inputTextView.tintColor = .themeColor
        
        
            messageInputBar.setLeftStackViewWidthConstant(to: 0, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
            messageInputBar.leftStackView.spacing = 8
        
        messageInputBar.inputTextView.placeholder = "الرسالة"
        configureSendButton()
    }
    
    private func configureSendButton() {
        messageInputBar.sendButton.backgroundColor = UIColor(white: 0.85, alpha: 1)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        
        messageInputBar.sendButton.image = #imageLiteral(resourceName: "ic_send")
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.layer.cornerRadius = 18
        messageInputBar.sendButton
            .onEnabled { item in
                UIView.animate(withDuration: 0.3, animations: {
                    item.backgroundColor = .themeColor
                })
            }.onDisabled { item in
                UIView.animate(withDuration: 0.3, animations: {
                    item.backgroundColor = UIColor(white: 0.85, alpha: 1)
                })
        }
    }
    
    
    
   
    
}

// MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        return Defaults[.user]!
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return viewModel.messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        let message = viewModel.messages[indexPath.section]
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
        let messageSa7B2a = messageSa7(sender: message.messageFromUser, messageId: String(message.id), sentDate: formatter.date(from: message.dateTime)!, kind: MessageKind.text(message.message))
        
        return messageSa7B2a
    }
    
}

// MARK: - MessagesDisplayDelegate
extension ChatViewController: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return UIColor.black
    }
    
    // MARK: - All Messages
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .themeColor : UIColor.init(hex: "ebebeb")
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubbleOutline(isFromCurrentSender(message: message) ? .themeColor : UIColor(hex: "cfcfcf"))
    }
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath,
                             in messagesCollectionView: MessagesCollectionView) -> Bool {
        return false
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let photo = isFromCurrentSender(message: message) ? Defaults[.user]!.photo : viewModel.conversation.otherUser.photo
        guard let urlString = photo, let url = URL(string: urlString) else {
            return
        }
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let photo):
                let avatar = Avatar(image: photo.image)
                avatarView.set(avatar: avatar)
            case .failure:
                return
            }
        }
    }
    
    func avatarPosition(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarPosition {
        return AvatarPosition.init(vertical: .messageTop)
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: viewModel.messages[indexPath.section].dateTime)!
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm"
        if Calendar.current.compare(date, to: Date(), toGranularity: .year) == .orderedSame {
            dateFormatter.dateFormat = "dd-MMM HH:mm"
            if Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedSame {
                dateFormatter.dateFormat = "HH:mm"
            }
            
        }
        let strDate = dateFormatter.string(from: date)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont(name: FontNames.BahijPlain, size: 12)]
        return NSAttributedString(string: strDate, attributes: attributes as [NSAttributedString.Key : Any])
        
    }
    
}

// MARK: - MessagesLayoutDelegate
extension ChatViewController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func heightForLocation(message: MessageType, at indexPath: IndexPath,
                           with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
}

// MARK: - MessageInputBarDelegate
extension ChatViewController: MessageInputBarDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        viewModel.sendMessage(message: text)
        inputBar.inputTextView.text = ""
    }
    
}

// MARK: - ChatViewModelDelegate
extension ChatViewController: ChatViewModelDelegate {
    
    func addMessageDidSucceedWithMessage() {
        let isLatestMessage = true
        messagesCollectionView.reloadData()
        if isLatestMessage {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
    func addMessageDidFailWithError(_ error: Error) {
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    
    
    
}


