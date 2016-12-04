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
    /**
        A `UIButton` that says "Play". Calls `playButtonTouchUpInside` when
                touched up inside.
    */
    @IBOutlet var playButton: UIButton!

    /// Errors caused when attempting to autoshrink `UILabel`s.
    enum AutoshrinkError: Error {
        /**
            Indicates that a `UIButton`'s `titleLabel` is `nil`.

            - Parameters:
                - button: The `UIButton` that's `titleLabel` is `nil`.
        */
        case noTitleLabel(button: UIButton)
    }

    /// Errors caused when attempting to start a new game.
    enum CreateMessageURLError: Error {
        /**
            Indicates that a `URLComponents`'s `url` is `nil`.

            - Parameters:
                - components: The `URLComponents` that's `url` is `nil`.
        */
        case noURLFromURLComponents(components: URLComponents)
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
                    (`minimumScale`•`titleLabel`).
        
        - Throws: `AutoshrinkError.noTitleLabel(button:)` if one of the
                `buttons`'s `titleLabel` is `nil`.
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
                    `UIButton` to be used as the radius of the corners. In other
                    words, the radius of the circles used to round the
                    `UIButton` `foo`'s corners is equal to
                    (((`foo.width`)/2)•`amountRounded`).
    */
    func roundCorners(of buttons: [UIButton],
            withAmountRounded amountRounded: CGFloat) {
        for button in buttons {
            let buttonWidthHalved = button.frame.size.width / 2
            button.layer.cornerRadius = buttonWidthHalved / 2 * amountRounded
            button.clipsToBounds = true
        }
    }

    // MARK: - Game Handling
    /// Create a new game message, and then send it out.
    func startNewGame() {
        /// The message to be sent to the other user.
        let gameMessage = MSMessage.init()

        // Try to set the `url` using `createMessageURLForNewGame(withBase:)`
        do {
            try gameMessage.url
                    = createMessageURLForNewGame(withBase: "www.tech.burstein")
        } catch CreateMessageURLError .
                noURLFromURLComponents(components: let components) {
            let alert = UIAlertController(title: "Error",
                    message: "An unexpected error occured.",
                    preferredStyle: UIAlertControllerStyle.alert)
            self.present(alert, animated: true, completion: nil)

            print(CreateMessageURLError .
                    noURLFromURLComponents(components: components))

            return
        } catch {
            return
        }

        // Set the `layout` using `createMessageTemplateLayoutForNewGame()`.
        gameMessage.layout = createMessageTemplateLayoutForNewGame()

        // Insert the message into the input field.
        self.activeConversation?.insert(gameMessage, completionHandler: nil)

        // Go back to compact, so that the user knows what just happened.
        self.requestPresentationStyle(MSMessagesAppPresentationStyle.compact)
    }

    /**
        Generates a `URL` for a new game based off of a base `String`.

        - Parameters:
            - base: The `String` to be used as the base URL in
                    `URLComponents(string:)`.

        - Throws: `CreateMessageURLError.noURLFromURLComponents(components:)` if
                the `URLComponents`'s `url` is `nil`.

        - Returns: The `URL` that is generated.
    */
    func createMessageURLForNewGame(withBase base: String) throws -> URL {
        /// The `URLComponents` to be used.
        var infoURLComponents
                = URLComponents(string: "www.burstein.tech/speedPoker")

        /// The first card of the player who the game was sent to.
        let player0Card0 = URLQueryItem(name: "player0Card0", value: "")

        /// The second card of the player who the game was sent to.
        let player0Card1 = URLQueryItem(name: "player0Card1", value: "")

        /// The first card of the player who started the game.
        let player1Card0 = URLQueryItem(name: "player1Card0", value: "")

        /// The second card of the player who started the game.
        let player1Card1 = URLQueryItem(name: "player1Card1", value: "")

        /// The first card on the table (part of the flop).
        let tableCard0 = URLQueryItem(name: "tableCard0", value: "")

        /// The second card on the table (part of the flop).
        let tableCard1 = URLQueryItem(name: "tableCard1", value: "")

        /// The third card on the table (part of the flop).
        let tableCard2 = URLQueryItem(name: "tableCard2", value: "")

        /// The fourth card on the table (part of the turn).
        let tableCard3 = URLQueryItem(name: "tableCard3", value: "")

        /// The fifth card on the table (part of the river).
        let tableCard4 = URLQueryItem(name: "tableCard4", value: "")

        /**
            The amount of decisions the players have made this round.

            Used to see if the next round is eligible to be played (i.e. the
                    value (as an `Int`) is greater than or equal to 2, since
                    at least both players will have acted).
        */
        let amountOfPlayerActionsThisRound
                = URLQueryItem(name: "playerActionsThisRound", value: "0")

        /**
            The total amount of gold that the player who the game was sent to
                    has put in this round.

            The value is equal to "" if it has not been that player's turn
                    yet, "0" if they checked, or any other
                    positive number (as a `String`) if they have put in a bet.
        */
        let player0BetThisRound
                = URLQueryItem(name: "player0BetThisRound", value: "")

        /**
            The total amount of gold that the player who started the game has
                    put in this round.

            The value is equal to "" if it has not been that player's turn
                    yet, "0" if they checked, or any other
                    positive number (as a `String`) if they have put in a bet.
                
        */
        let player1BetThisRound
                = URLQueryItem(name: "player1BetThisRound", value: "")

        /**
            The total amount of gold that the player who the game was sent to
                    owns.
        */
        let player0TotalGold
                = URLQueryItem(name: "player0BetThisRound", value: "")

        /**
            The total amount of gold that the player who started the game owns.

            - ToDo: Automatically set this value by retrieving it from
                    `UserDefaults`.
        */
        let player1TotalGold
                = URLQueryItem(name: "player0BetThisRound", value: "")

        // Add all of the variables.
        infoURLComponents?.queryItems = [player0Card0, player0Card1,
                player1Card0, player1Card1, tableCard0, tableCard1, tableCard2,
                tableCard3, tableCard4, amountOfPlayerActionsThisRound,
                player0BetThisRound, player1BetThisRound, player0TotalGold,
                player1TotalGold]

        guard let finalURL = infoURLComponents?.url else {
            throw CreateMessageURLError .
                    noURLFromURLComponents(components: infoURLComponents!)
        }

        return finalURL
    }

    /**
        Generates an `MSMessageTemplateLayout` for a new game.

        - Returns: The `MSMessageTemplateLayout` that is generated.
    */
    func createMessageTemplateLayoutForNewGame() -> MSMessageTemplateLayout {
        let templateLayout = MSMessageTemplateLayout()
        templateLayout.image = #imageLiteral(resourceName: "thumbnail")
        templateLayout.caption = "Let's Play Poker!"
        templateLayout.subcaption = "with speedPoker"

        return templateLayout
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

    // MARK: - Actions
    /// Called when the `playButton` is touched up inside.
    @IBAction func playButtonTouchUpInside(_ sender: UIButton) {
        try! startNewGame()
    }
}
