/*
    MessagesViewController.swift

    MessagesExtension

    Created by Skunk on 11/27/16.

    speedPoker is licensed under an MIT LICENSE.
*/

import UIKit
import Messages

/// The root view controller that the Messages app uses.
class MessagesViewController: MSMessagesAppViewController {
    // MARK: - Properties
    /// A `UIButton` that says "Play".
    @IBOutlet var playButton: UIButton!

    /// Errors caused when attempting to autoshrink `UILabel`s.
    enum AutoshrinkError: Error {
        /**
            Indicates that a `UIButton` did not have an available `titleLabel`
                    to shrink.

            - Parameters:
                - button: The `UIButton` that had a `titleLabel` that could not
                        be autoshrunk.
        */
        case noTitleLabel(button: UIButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        try! autoshrinkTitleLabels(of: [playButton],
                withMinumumScale: 0.01)

        roundCorners(of: [playButton], withAmountRounded: 0.25)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - UI Setup
    /**
        Autoshrinks the `titleLabel`s of an `Array` of `UIButton`s, with a
                selected `minimumScaleFactor`.

        - Parameters:
            - buttons: The `Array` of `UIButton`s to have their `titleLabel`s
                    autoshrank.
            - minimumScale: The `minimumScaleFactor` to be used when shrinking
                    the `titleLabel`s. In other words, the smallest font
                    size that the `titleLabel` can have is equal to
                    (`minimumScale`×`titleLabel`).
    */
    func autoshrinkTitleLabels(of buttons: [UIButton],
            withMinumumScale minimumScale: CGFloat) throws {
        for button in buttons {
            guard button.titleLabel != nil else {
                throw AutoshrinkError.noTitleLabel(button: button)
            }

            button.titleLabel!.adjustsFontSizeToFitWidth = true
            button.titleLabel!.numberOfLines = 0
            button.titleLabel!.lineBreakMode = NSLineBreakMode.byTruncatingTail

            button.titleLabel!.baselineAdjustment
                    = UIBaselineAdjustment.alignCenters
        }
    }

    /**
        Rounds the corners of an `Array` of `UIButton`s with a selected radius.

        - Parameters:
            - buttons: The `Array` of `UIButton`s to be rounded.
            - amountRounded: The fraction of half of the width of the
                    `UIButton` used as the radius of the corners. In other
                    words, the radius of the circles used to round the
                    `UIButton` `foo`'s corners is equal to
                    (((`foo.width`)÷2)×`amountRounded`).
    */
    func roundCorners(of buttons: [UIButton],
            withAmountRounded amountRounded: CGFloat) {
        for button in buttons {
            let buttonWidthHalved = button.frame.size.width / 2
            button.layer.cornerRadius = buttonWidthHalved / 2 * amountRounded
            button.clipsToBounds = true
        }
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
