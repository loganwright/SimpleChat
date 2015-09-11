//
//  SimpleChatController.swift
//  SimpleChat
//
//  Created by Logan Wright on 10/16/14.
//  Copyright (c) 2014 Logan Wright. All rights reserved.
//

/*
Mozilla Public License
Version 2.0
https://tldrlegal.com/license/mozilla-public-license-2.0-(mpl-2)
*/

import UIKit

// MARK: Message

class LGChatMessage : NSObject {
    
    enum SentBy : String {
        case User = "LGChatMessageSentByUser"
        case Opponent = "LGChatMessageSentByOpponent"
    }
    
    // MARK: ObjC Compatibility
    
    /*
    ObjC can't interact w/ enums properly, so this is used for converting compatible values.
    */
    
    class func SentByUserString() -> String {
        return LGChatMessage.SentBy.User.rawValue
    }
    
    class func SentByOpponentString() -> String {
        return LGChatMessage.SentBy.Opponent.rawValue
    }
    
    var sentByString: String {
        get {
            return sentBy.rawValue
        }
        set {
            if let sentBy = SentBy(rawValue: newValue) {
                self.sentBy = sentBy
            } else {
                print("LGChatMessage.Error : Property Set : Incompatible string set to SentByString!")
            }
        }
    }
    
    // MARK: Public Properties
    
    var sentBy: SentBy
    var content: String
    var timeStamp: NSTimeInterval?
    
    required init (content: String, sentBy: SentBy, timeStamp: NSTimeInterval? = nil){
        self.sentBy = sentBy
        self.timeStamp = timeStamp
        self.content = content
    }
    
    // MARK: ObjC Compatibility
    
    convenience init (content: String, sentByString: String) {
        if let sentBy = SentBy(rawValue: sentByString) {
            self.init(content: content, sentBy: sentBy, timeStamp: nil)
        } else {
            fatalError("LGChatMessage.FatalError : Initialization : Incompatible string set to SentByString!")
        }
    }
    
    convenience init (content: String, sentByString: String, timeStamp: NSTimeInterval) {
        if let sentBy = SentBy(rawValue: sentByString) {
            self.init(content: content, sentBy: sentBy, timeStamp: timeStamp)
        } else {
            fatalError("LGChatMessage.FatalError : Initialization : Incompatible string set to SentByString!")
        }
    }
}

// MARK: Message Cell

class LGChatMessageCell : UITableViewCell {
    
    // MARK: Global MessageCell Appearance Modifier
    
    struct Appearance {
        static var opponentColor = UIColor(red: 0.142954, green: 0.60323, blue: 0.862548, alpha: 0.88)
        static var userColor = UIColor(red: 0.14726, green: 0.838161, blue: 0.533935, alpha: 1)
        static var font: UIFont = UIFont.systemFontOfSize(17.0)
    }
    
    /*
    These methods are included for ObjC compatibility.  If using Swift, you can set the Appearance variables directly.
    */
    
    class func setAppearanceOpponentColor(opponentColor: UIColor) {
        Appearance.opponentColor = opponentColor
    }
    
    class func setAppearanceUserColor(userColor: UIColor) {
        Appearance.userColor = userColor
    }
    
    class  func setAppearanceFont(font: UIFont) {
        Appearance.font = font
    }
    
    // MARK: Message Bubble TextView
    
    private lazy var textView: MessageBubbleTextView = {
        let textView = MessageBubbleTextView(frame: CGRectZero, textContainer: nil)
        self.contentView.addSubview(textView)
        return textView
        }()
    
    private class MessageBubbleTextView : UITextView {
        
        override init(frame: CGRect = CGRectZero, textContainer: NSTextContainer? = nil) {
            super.init(frame: frame, textContainer: textContainer)
            self.font = Appearance.font
            self.scrollEnabled = false
            self.editable = false
            self.textContainerInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
            self.layer.cornerRadius = 15
            self.layer.borderWidth = 2.0
        }
        
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    // MARK: ImageView
    
    private lazy var opponentImageView: UIImageView = {
        let opponentImageView = UIImageView()
        opponentImageView.hidden = true
        opponentImageView.bounds.size = CGSize(width: self.minimumHeight, height: self.minimumHeight)
        let halfWidth = CGRectGetWidth(opponentImageView.bounds) / 2.0
        let halfHeight = CGRectGetHeight(opponentImageView.bounds) / 2.0
        
        // Center the imageview vertically to the textView when it is singleLine
        let textViewSingleLineCenter = self.textView.textContainerInset.top + (Appearance.font.lineHeight / 2.0)
        opponentImageView.center = CGPointMake(self.padding + halfWidth, textViewSingleLineCenter)
        opponentImageView.backgroundColor = UIColor.lightTextColor()
        opponentImageView.layer.rasterizationScale = UIScreen.mainScreen().scale
        opponentImageView.layer.shouldRasterize = true
        opponentImageView.layer.cornerRadius = halfHeight
        opponentImageView.layer.masksToBounds = true
        self.contentView.addSubview(opponentImageView)
        return opponentImageView
        }()
    
    // MARK: Sizing
    
    private let padding: CGFloat = 5.0
    
    private let minimumHeight: CGFloat = 30.0 // arbitrary minimum height
    
    private var size = CGSizeZero
    
    private var maxSize: CGSize {
        get {
            let maxWidth = CGRectGetWidth(self.bounds) * 0.75 // Cells can take up to 3/4 of screen
            let maxHeight = CGFloat.max
            return CGSize(width: maxWidth, height: maxHeight)
        }
    }
    
    // MARK: Setup Call
    
    /*!
    Use this in cellForRowAtIndexPath to setup the cell.
    */
    func setupWithMessage(message: LGChatMessage) -> CGSize {
        textView.text = message.content
        size = textView.sizeThatFits(maxSize)
        if size.height < minimumHeight {
            size.height = minimumHeight
        }
        textView.bounds.size = size
        self.styleTextViewForSentBy(message.sentBy)
        return size
    }
    
    // MARK: TextBubble Styling
    
    private func styleTextViewForSentBy(sentBy: LGChatMessage.SentBy) {
        let halfTextViewWidth = CGRectGetWidth(self.textView.bounds) / 2.0
        let targetX = halfTextViewWidth + padding
        let halfTextViewHeight = CGRectGetHeight(self.textView.bounds) / 2.0
        switch sentBy {
        case .Opponent:
            self.textView.center.x = targetX
            self.textView.center.y = halfTextViewHeight
            self.textView.layer.borderColor = Appearance.opponentColor.CGColor
            
            if self.opponentImageView.image != nil {
                self.opponentImageView.hidden = false
                self.textView.center.x += CGRectGetWidth(self.opponentImageView.bounds) + padding
            }
            
        case .User:
            self.opponentImageView.hidden = true
            self.textView.center.x = CGRectGetWidth(self.bounds) - targetX
            self.textView.center.y = halfTextViewHeight
            self.textView.layer.borderColor = Appearance.userColor.CGColor
        }
    }
}

// MARK: Chat Controller

@objc protocol LGChatControllerDelegate {
    optional func shouldChatController(chatController: LGChatController, addMessage message: LGChatMessage) -> Bool
    optional func chatController(chatController: LGChatController, didAddNewMessage message: LGChatMessage)
}

class LGChatController : UIViewController, UITableViewDelegate, UITableViewDataSource, LGChatInputDelegate {
    
    // MARK: Constants
    
    private struct Constants {
        static let MessagesSection: Int = 0;
        static let MessageCellIdentifier: String = "LGChatController.Constants.MessageCellIdentifier"
    }
    
    // MARK: Public Properties
    
    /*!
    Use this to set the messages to be displayed
    */
    var messages: [LGChatMessage] = []
    var opponentImage: UIImage?
    weak var delegate: LGChatControllerDelegate?
    
    // MARK: Private Properties
    
    private let sizingCell = LGChatMessageCell()
    private let tableView: UITableView = UITableView()
    private let chatInput = LGChatInput(frame: CGRectZero)
    private var bottomChatInputConstraint: NSLayoutConstraint!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.listenForKeyboardChanges()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollToBottom()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardObservers()
    }
    
    deinit {
        /*
        Need to remove delegate and datasource or they will try to send scrollView messages.
        */
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
    
    // MARK: Setup
    
    private func setup() {
        self.setupTableView()
        self.setupChatInput()
        self.setupLayoutConstraints()
    }
    
    private func setupTableView() {
        tableView.allowsSelection = false
        tableView.separatorStyle = .None
        tableView.frame = self.view.bounds
        tableView.registerClass(LGChatMessageCell.classForCoder(), forCellReuseIdentifier: "identifier")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        self.view.addSubview(tableView)
    }
    
    private func setupChatInput() {
        chatInput.delegate = self
        self.view.addSubview(chatInput)
    }
    
    private func setupLayoutConstraints() {
        chatInput.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(self.chatInputConstraints())
        self.view.addConstraints(self.tableViewConstraints())
    }
    
    private func chatInputConstraints() -> [NSLayoutConstraint] {
        self.bottomChatInputConstraint = NSLayoutConstraint(item: chatInput, attribute: .Bottom, relatedBy: .Equal, toItem: self.bottomLayoutGuide, attribute: .Top, multiplier: 1.0, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: chatInput, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let rightConstraint = NSLayoutConstraint(item: chatInput, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: 0.0)
        return [leftConstraint, self.bottomChatInputConstraint, rightConstraint]
    }
    
    private func tableViewConstraints() -> [NSLayoutConstraint] {
        let leftConstraint = NSLayoutConstraint(item: tableView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let rightConstraint = NSLayoutConstraint(item: tableView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .Equal, toItem: chatInput, attribute: .Top, multiplier: 1.0, constant: 0)
        return [rightConstraint, leftConstraint, topConstraint, bottomConstraint]//, rightConstraint, bottomConstraint]
    }
    
    // MARK: Keyboard Notifications
    
    private func listenForKeyboardChanges() {
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    private func unregisterKeyboardObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
 
    func keyboardWillChangeFrame(note: NSNotification) {
        let keyboardAnimationDetail = note.userInfo!
        let duration = keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        var keyboardFrame = (keyboardAnimationDetail[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        if let window = self.view.window {
            keyboardFrame = window.convertRect(keyboardFrame, toView: self.view)
        }
        let animationCurve = keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        
        self.tableView.scrollEnabled = false
        self.tableView.decelerationRate = UIScrollViewDecelerationRateFast
        self.view.layoutIfNeeded()
        var chatInputOffset = -((CGRectGetHeight(self.view.bounds) - self.bottomLayoutGuide.length) - CGRectGetMinY(keyboardFrame))
        if chatInputOffset > 0 {
            chatInputOffset = 0
        }
        self.bottomChatInputConstraint.constant = chatInputOffset
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions(rawValue: animationCurve), animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.scrollToBottom()
            }, completion: {(finished) -> () in
                self.tableView.scrollEnabled = true
                self.tableView.decelerationRate = UIScrollViewDecelerationRateNormal
        })
    }
    
    // MARK: Rotation
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        super.willAnimateRotationToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        self.tableView.reloadData()
    }
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.scrollToBottom()
            }, completion: nil)
    }
    
    // MARK: Scrolling
    
    private func scrollToBottom() {
        if messages.count > 0 {
            var lastItemIdx = self.tableView.numberOfRowsInSection(Constants.MessagesSection) - 1
            if lastItemIdx < 0 {
                lastItemIdx = 0
            }
            let lastIndexPath = NSIndexPath(forRow: lastItemIdx, inSection: Constants.MessagesSection)
            self.tableView.scrollToRowAtIndexPath(lastIndexPath, atScrollPosition: .Bottom, animated: false)
        }
    }
    
    // MARK: New messages
    
    func addNewMessage(message: LGChatMessage) {
        messages += [message]
        tableView.reloadData()
        self.scrollToBottom()
        self.delegate?.chatController?(self, didAddNewMessage: message)
    }
    
    // MARK: SwiftChatInputDelegate
    
    func chatInputDidResize(chatInput: LGChatInput) {
        self.scrollToBottom()
    }
    
    func chatInput(chatInput: LGChatInput, didSendMessage message: String) {
        let newMessage = LGChatMessage(content: message, sentBy: .User)
        var shouldSendMessage = true
        if let value = self.delegate?.shouldChatController?(self, addMessage: newMessage) {
            shouldSendMessage = value
        }
        
        if shouldSendMessage {
            self.addNewMessage(newMessage)
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let padding: CGFloat = 10.0
        sizingCell.bounds.size.width = CGRectGetWidth(self.view.bounds)
        let height = self.sizingCell.setupWithMessage(messages[indexPath.row]).height + padding;
        return height
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.dragging {
            self.chatInput.textView.resignFirstResponder()
        }
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("identifier", forIndexPath: indexPath) as! LGChatMessageCell
        let message = self.messages[indexPath.row]
        cell.opponentImageView.image = message.sentBy == .Opponent ? self.opponentImage : nil
        cell.setupWithMessage(message)
        return cell;
    }
    
}

// MARK: Chat Input

protocol LGChatInputDelegate : class {
    func chatInputDidResize(chatInput: LGChatInput)
    func chatInput(chatInput: LGChatInput, didSendMessage message: String)
}

class LGChatInput : UIView, LGStretchyTextViewDelegate {
    
    // MARK: Styling
    
    struct Appearance {
        static var includeBlur = true
        static var tintColor = UIColor(red: 0.0, green: 120 / 255.0, blue: 255 / 255.0, alpha: 1.0)
        static var backgroundColor = UIColor.whiteColor()
        static var textViewFont = UIFont.systemFontOfSize(17.0)
        static var textViewTextColor = UIColor.darkTextColor()
        static var textViewBackgroundColor = UIColor.whiteColor()
    }
    
    /*
    These methods are included for ObjC compatibility.  If using Swift, you can set the Appearance variables directly.
    */
    
    class func setAppearanceIncludeBlur(includeBlur: Bool) {
        Appearance.includeBlur = includeBlur
    }
    
    class func setAppearanceTintColor(color: UIColor) {
        Appearance.tintColor = color
    }
    
    class func setAppearanceBackgroundColor(color: UIColor) {
        Appearance.backgroundColor = color
    }
    
    class func setAppearanceTextViewFont(textViewFont: UIFont) {
        Appearance.textViewFont = textViewFont
    }
    
    class func setAppearanceTextViewTextColor(textColor: UIColor) {
        Appearance.textViewTextColor = textColor
    }
    
    class func setAppearanceTextViewBackgroundColor(color: UIColor) {
        Appearance.textViewBackgroundColor = color
    }
    
    // MARK: Public Properties
    
    var textViewInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    weak var delegate: LGChatInputDelegate?
    
    // MARK: Private Properties
    
    private let textView = LGStretchyTextView(frame: CGRectZero, textContainer: nil)
    private let sendButton = UIButton(type: .System)
    private let blurredBackgroundView: UIToolbar = UIToolbar()
    private var heightConstraint: NSLayoutConstraint!
    private var sendButtonHeightConstraint: NSLayoutConstraint!
    
    // MARK: Initialization
    
    override init(frame: CGRect = CGRectZero) {
        super.init(frame: frame)
        self.setup()
        self.stylize()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupSendButton()
        self.setupSendButtonConstraints()
        self.setupTextView()
        self.setupTextViewConstraints()
        self.setupBlurredBackgroundView()
        self.setupBlurredBackgroundViewConstraints()
    }
    
    func setupTextView() {
        textView.bounds = UIEdgeInsetsInsetRect(self.bounds, self.textViewInsets)
        textView.stretchyTextViewDelegate = self
        textView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        self.styleTextView()
        self.addSubview(textView)
    }
    
    func styleTextView() {
        textView.layer.rasterizationScale = UIScreen.mainScreen().scale
        textView.layer.shouldRasterize = true
        textView.layer.cornerRadius = 5.0
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor(white: 0.0, alpha: 0.2).CGColor
    }
    
    func setupSendButton() {
        self.sendButton.enabled = false
        self.sendButton.setTitle("Send", forState: .Normal)
        self.sendButton.addTarget(self, action: "sendButtonPressed:", forControlEvents: .TouchUpInside)
        self.sendButton.bounds = CGRect(x: 0, y: 0, width: 40, height: 1)
        self.addSubview(sendButton)
    }
    
    func setupSendButtonConstraints() {
        self.sendButton.translatesAutoresizingMaskIntoConstraints = false
        self.sendButton.removeConstraints(self.sendButton.constraints)
        
        // TODO: Fix so that button height doesn't change on first newLine
        let rightConstraint = NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: self.sendButton, attribute: .Right, multiplier: 1.0, constant: textViewInsets.right)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: self.sendButton, attribute: .Bottom, multiplier: 1.0, constant: textViewInsets.bottom)
        let widthConstraint = NSLayoutConstraint(item: self.sendButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 40)
        sendButtonHeightConstraint = NSLayoutConstraint(item: self.sendButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30)
        self.addConstraints([sendButtonHeightConstraint, widthConstraint, rightConstraint, bottomConstraint])
    }
    
    func setupTextViewConstraints() {
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: self.textView, attribute: .Top, multiplier: 1.0, constant: -textViewInsets.top)
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: self.textView, attribute: .Left, multiplier: 1, constant: -textViewInsets.left)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: self.textView, attribute: .Bottom, multiplier: 1, constant: textViewInsets.bottom)
        let rightConstraint = NSLayoutConstraint(item: self.textView, attribute: .Right, relatedBy: .Equal, toItem: self.sendButton, attribute: .Left, multiplier: 1, constant: -textViewInsets.right)
        heightConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.00, constant: 40)
        self.addConstraints([topConstraint, leftConstraint, bottomConstraint, rightConstraint, heightConstraint])
    }
    
    func setupBlurredBackgroundView() {
        self.addSubview(self.blurredBackgroundView)
        self.sendSubviewToBack(self.blurredBackgroundView)
    }
    
    func setupBlurredBackgroundViewConstraints() {
        self.blurredBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: self.blurredBackgroundView, attribute: .Top, multiplier: 1.0, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: self.blurredBackgroundView, attribute: .Left, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: self.blurredBackgroundView, attribute: .Bottom, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: self.blurredBackgroundView, attribute: .Right, multiplier: 1.0, constant: 0)
        self.addConstraints([topConstraint, leftConstraint, bottomConstraint, rightConstraint])
    }
    
    // MARK: Styling
    
    func stylize() {
        self.textView.backgroundColor = Appearance.textViewBackgroundColor
        self.sendButton.tintColor = Appearance.tintColor
        self.textView.tintColor = Appearance.tintColor
        self.textView.font = Appearance.textViewFont
        self.textView.textColor = Appearance.textViewTextColor
        self.blurredBackgroundView.hidden = !Appearance.includeBlur
        self.backgroundColor = Appearance.backgroundColor
    }
    
    // MARK: StretchyTextViewDelegate
    
    func stretchyTextViewDidChangeSize(textView: LGStretchyTextView) {
        let textViewHeight = CGRectGetHeight(textView.bounds)
        if textView.text.characters.count == 0 {
            self.sendButtonHeightConstraint.constant = textViewHeight
        }
        let targetConstant = textViewHeight + textViewInsets.top + textViewInsets.bottom
        self.heightConstraint.constant = targetConstant
        self.delegate?.chatInputDidResize(self)
    }
    
    func stretchyTextView(textView: LGStretchyTextView, validityDidChange isValid: Bool) {
        self.sendButton.enabled = isValid
    }
    
    // MARK: Button Presses
    
    func sendButtonPressed(sender: UIButton) {
        if self.textView.text.characters.count > 0 {
            self.delegate?.chatInput(self, didSendMessage: self.textView.text)
            self.textView.text = ""
        }
    }
}

// MARK: Text View

@objc protocol LGStretchyTextViewDelegate {
    func stretchyTextViewDidChangeSize(chatInput: LGStretchyTextView)
    optional func stretchyTextView(textView: LGStretchyTextView, validityDidChange isValid: Bool)
}

class LGStretchyTextView : UITextView, UITextViewDelegate {
    
    // MARK: Delegate
    
    weak var stretchyTextViewDelegate: LGStretchyTextViewDelegate?
    
    // MARK: Public Properties
    
    var maxHeightPortrait: CGFloat = 160
    var maxHeightLandScape: CGFloat = 60
    var maxHeight: CGFloat {
        get {
            return UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation) ? maxHeightPortrait : maxHeightLandScape
        }
    }
    // MARK: Private Properties
    
    private var maxSize: CGSize {
        get {
            return CGSize(width: CGRectGetWidth(self.bounds), height: self.maxHeightPortrait)
        }
    }
    
    private var isValid: Bool = false {
        didSet {
            if isValid != oldValue {
                stretchyTextViewDelegate?.stretchyTextView?(self, validityDidChange: isValid)
            }
        }
    }
    
    private let sizingTextView = UITextView()
    
    // MARK: Property Overrides
    
    override var contentSize: CGSize {
        didSet {
            resize()
        }
    }
    
    override var font: UIFont! {
        didSet {
            sizingTextView.font = font
        }
    }
    
    override var textContainerInset: UIEdgeInsets {
        didSet {
            sizingTextView.textContainerInset = textContainerInset
        }
    }
    
    // MARK: Initializers
    
    override init(frame: CGRect = CGRectZero, textContainer: NSTextContainer? = nil) {
        super.init(frame: frame, textContainer: textContainer);
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    func setup() {
        font = UIFont.systemFontOfSize(17.0)
        textContainerInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        delegate = self
    }
    
    // MARK: Sizing
    
    func resize() {
        bounds.size.height = self.targetHeight()
        stretchyTextViewDelegate?.stretchyTextViewDidChangeSize(self)
    }
    
    func targetHeight() -> CGFloat {
        
        /*
        There is an issue when calling `sizeThatFits` on self that results in really weird drawing issues with aligning line breaks ("\n").  For that reason, we have a textView whose job it is to size the textView. It's excess, but apparently necessary.  If there's been an update to the system and this is no longer necessary, or if you find a better solution. Please remove it and submit a pull request as I'd rather not have it.
        */
        
        sizingTextView.text = self.text
        let targetSize = sizingTextView.sizeThatFits(maxSize)
        let targetHeight = targetSize.height
        let maxHeight = self.maxHeight
        return targetHeight < maxHeight ? targetHeight : maxHeight
    }
    
    // MARK: Alignment
    
    func align() {
        guard let end = self.selectedTextRange?.end, let caretRect: CGRect = self.caretRectForPosition(end) else { return }
        
        let topOfLine = CGRectGetMinY(caretRect)
        let bottomOfLine = CGRectGetMaxY(caretRect)
        
        let contentOffsetTop = self.contentOffset.y
        let bottomOfVisibleTextArea = contentOffsetTop + CGRectGetHeight(self.bounds)
        
        /*
        If the caretHeight and the inset padding is greater than the total bounds then we are on the first line and aligning will cause bouncing.
        */
        
        let caretHeightPlusInsets = CGRectGetHeight(caretRect) + self.textContainerInset.top + self.textContainerInset.bottom
        if caretHeightPlusInsets < CGRectGetHeight(self.bounds) {
            var overflow: CGFloat = 0.0
            if topOfLine < contentOffsetTop + self.textContainerInset.top {
                overflow = topOfLine - contentOffsetTop - self.textContainerInset.top
            } else if bottomOfLine > bottomOfVisibleTextArea - self.textContainerInset.bottom {
                overflow = (bottomOfLine - bottomOfVisibleTextArea) + self.textContainerInset.bottom
            }
            self.contentOffset.y += overflow
        }
    }
    
    // MARK: UITextViewDelegate
    
    func textViewDidChangeSelection(textView: UITextView) {
        self.align()
    }
    
    func textViewDidChange(textView: UITextView) {
        // TODO: Possibly filter spaces and newlines
        self.isValid = textView.text.characters.count > 0
    }
}
