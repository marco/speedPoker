/*
    MessagesViewController.swift

    MessagesExtension

    Created by Skunk on 11/27/16.

    speedPoker is licensed under an MIT LICENSE.
*/

import UIKit
import Messages

/// The root view controller that the Messages app uses
class MessagesViewController: MSMessagesAppViewController {
    // MARK: - Properties
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Conversation Handling
    override func willBecomeActive(with conversation: MSConversation) {
    }

    override func didResignActive(with conversation: MSConversation) {
    }

    override func didReceive(_ message: MSMessage,
            conversation: MSConversation) {
    }

    override func didStartSending(_ message: MSMessage,
            conversation: MSConversation) {
    }

    override func didCancelSending(_ message: MSMessage,
            conversation: MSConversation) {
    }
    
    override func willTransition(
            to presentationStyle: MSMessagesAppPresentationStyle) {
    }
    
    override func didTransition(
            to presentationStyle: MSMessagesAppPresentationStyle) {
    }
}
