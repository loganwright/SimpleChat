//
//  SimpleChatController.swift
//  SimpleChat
//
//  Created by Logan Wright on 10/16/14.
//  Copyright (c) 2014 Logan Wright. All rights reserved.
//

import UIKit

// MARK: Message

class LGChatMessage : NSObject {
    
    enum SentBy {
        case User, Opponent
    }
    
    var sentBy: SentBy
    var content: String
    var timeStamp: NSTimeInterval?
    
    required init (content: String, sentBy: SentBy, timeStamp: NSTimeInterval? = nil){
        self.sentBy = sentBy
        self.timeStamp = timeStamp
        self.content = content
    }
    
}

// MARK: Message Cell

class LGMessageCell : UITableViewCell {
    
    // MARK: Global MessageCell Appearance Modifier
    
    struct Appearance {
        static var opponentColor = UIColor(red: 0.142954, green: 0.60323, blue: 0.862548, alpha: 0.88)
        static var userColor = UIColor(red: 0.14726, green: 0.838161, blue: 0.533935, alpha: 1)
        static var opponentImage: UIImage? = nil
        static var font: UIFont = UIFont.systemFontOfSize(17.0)
    }
    
    // MARK: Message Bubble TextView
    
    private lazy var textView: MessageBubbleTextView  = {
        let textView = MessageBubbleTextView()
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
    
    // MARK: Sizing
    
    private let minimumHeight: CGFloat = 30.0 // arbitrary minimum height
    
    private var size = CGSizeZero
    
    private var maxSize: CGSize {
        get {
            let maxWidth = CGRectGetWidth(self.bounds) * 0.75
            let maxHeight = CGFloat.max
            return CGSize(width: maxWidth, height: maxHeight)
        }
    }
    
    // MARK: Setup Call
    
    /*!
    Use this in cellForRowAtIndexPath to setup the cell.
    */
    func setupWithMessage(message: LGChatMessage) -> CGSize {
        // TODO: Set
        textView.text = message.content
        size = textView.sizeThatFits(maxSize)
        if size.height < minimumHeight {
            size.height = minimumHeight
        }
        textView.bounds.size = size
        self.styleTextViewForSentBy(message.sentBy)
        
        println("Size: \(size) Text: \(message.content)")
        return size
    }
    
    // MARK: TextBubble Styling
    
    private func styleTextViewForSentBy(sentBy: LGChatMessage.SentBy) {
        let halfTextViewWidth = CGRectGetWidth(self.textView.bounds) / 2.0
        let padding: CGFloat = 5.0
        let targetX = halfTextViewWidth + padding
        let halfTextViewHeight = CGRectGetHeight(self.textView.bounds) / 2.0
        switch sentBy {
        case .Opponent:
            self.textView.center.x = targetX
            self.textView.center.y = halfTextViewHeight
            self.textView.layer.borderColor = Appearance.opponentColor.CGColor
        case .User:
            self.textView.center.x = CGRectGetMaxX(self.contentView.bounds) - targetX
            self.textView.center.y = halfTextViewHeight
            self.textView.layer.borderColor = Appearance.userColor.CGColor
        }
    }
    
}

// MARK: Chat Controller

class LGChatController : UIViewController, LGChatInputDelegate {
    
    // MARK: Constants
    
    struct Constants {
        static let MessagesSection: Int = 0;
        static let MessageCellIdentifier: String = "LGChatController.Constants.MessageCellIdentifier"
    }
    
    // MARK: Public Properties
    
    /*!
    Use this to set the messages to be displayed
    */
    var messages: [LGChatMessage] = []
    
    // MARK: Private Properties
    
    private let sizingCell = LGMessageCell()
    private let tableView: UITableView = UITableView()
    private let chatInput = LGChatInput()
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
        tableView.registerClass(LGMessageCell.classForCoder(), forCellReuseIdentifier: "identifier")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        self.view.addSubview(tableView)
    }
    
    private func setupChatInput() {
        chatInput.delegate = self
        self.view.addSubview(chatInput)
    }
    
    func setupLayoutConstraints() {
        chatInput.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addConstraints(self.chatInputConstraints())
        self.view.addConstraints(self.tableViewConstraints())
    }
    
    private func chatInputConstraints() -> [NSLayoutConstraint] {
        self.bottomChatInputConstraint = NSLayoutConstraint(item: chatInput, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
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
        let duration = keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] as NSTimeInterval
        let keyboardFrame = (keyboardAnimationDetail[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        let keyboardHeight = CGRectGetHeight(keyboardFrame)
        let animationCurve = keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] as UInt
        
        self.tableView.scrollEnabled = false
        self.tableView.decelerationRate = UIScrollViewDecelerationRateFast
        self.view.layoutIfNeeded()
        self.bottomChatInputConstraint.constant = -(CGRectGetHeight(self.view.bounds) - CGRectGetMinY(keyboardFrame))
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions(animationCurve), animations: { () -> Void in
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
        self.scrollToBottom()
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
    }
    
    // MARK: SwiftChatInputDelegate
    
    func chatInputDidResize(chatInput: LGChatInput) {
        self.scrollToBottom()
    }
    
    func chatInput(chatInput: LGChatInput, didSendMessage message: String) {
        self.messages.append(LGChatMessage(content: message, sentBy: .User))
        self.tableView.reloadData()
        self.scrollToBottom()
    }
    
}

extension LGChatController : UITableViewDelegate {
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
}

extension LGChatController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("identifier", forIndexPath: indexPath) as LGMessageCell
        cell.setupWithMessage(self.messages[indexPath.row])
        return cell;
    }
    
}

// MARK: Chat Input

protocol LGChatInputDelegate : class {
    func chatInputDidResize(chatInput: LGChatInput)
    func chatInput(chatInput: LGChatInput, didSendMessage message: String)
}

class LGChatInput : UIView, LGStretchyTextViewDelegate {
    
    // MARK: Public Properties
    
    var textViewInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    weak var delegate: LGChatInputDelegate?
    
    var font: UIFont {
        get {
            return self.textView.font
        }
        set {
            self.textView.font = font
        }
    }
    
    // MARK: Private Properties
    
    private let textView = LGStretchyTextView()
    private let sendButton = UIButton.buttonWithType(.System) as UIButton
    private let blurredBackgroundView: UIToolbar = UIToolbar()
    private var heightConstraint: NSLayoutConstraint!
    
    // MARK: Initialization
    
    override init(frame: CGRect = CGRectZero) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    func setup() {
        self.backgroundColor = UIColor.whiteColor()
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
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
        self.sendButton.setTitle("Send", forState: .Normal)
        self.sendButton.addTarget(self, action: "sendButtonPressed:", forControlEvents: .TouchUpInside)
        self.sendButton.bounds = CGRect(x: 0, y: 0, width: 40, height: 1)
        self.addSubview(sendButton)
    }
    
    func setupSendButtonConstraints() {
        self.sendButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.sendButton.removeConstraints(self.sendButton.constraints())
        
        // TODO: Fix so that button height doesn't change on first newLine
        let topConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .LessThanOrEqual, toItem: self.sendButton, attribute: .Top, multiplier: 1.0, constant: -textViewInsets.top)
        let rightConstraint = NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: self.sendButton, attribute: .Right, multiplier: 1.0, constant: textViewInsets.right)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: self.sendButton, attribute: .Bottom, multiplier: 1.0, constant: textViewInsets.bottom)
        let widthConstraint = NSLayoutConstraint(item: self.sendButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 40)
        self.addConstraints([topConstraint, widthConstraint, rightConstraint, bottomConstraint])
    }
    
    func setupTextViewConstraints() {
        self.textView.setTranslatesAutoresizingMaskIntoConstraints(false)
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
        self.blurredBackgroundView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let topConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: self.blurredBackgroundView, attribute: .Top, multiplier: 1.0, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: self.blurredBackgroundView, attribute: .Left, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: self.blurredBackgroundView, attribute: .Bottom, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: self.blurredBackgroundView, attribute: .Right, multiplier: 1.0, constant: 0)
        self.addConstraints([topConstraint, leftConstraint, bottomConstraint, rightConstraint])
    }
    
    // MARK: StretchyTextViewDelegate
    
    func textViewDidChangeSize(chatInput: LGStretchyTextView) {
        let targetConstant = CGRectGetHeight(chatInput.bounds) + textViewInsets.top + textViewInsets.bottom
        self.heightConstraint.constant = targetConstant
        self.delegate?.chatInputDidResize(self)
        println("SendHeight: \(CGRectGetHeight(self.sendButton.bounds))")
    }
    
    // MARK: Button Presses
    
    func sendButtonPressed(sender: UIButton) {
        if countElements(self.textView.text) > 0 {
            self.delegate?.chatInput(self, didSendMessage: self.textView.text)
            self.textView.text = ""
        }
    }
}

// MARK: Text View

protocol LGStretchyTextViewDelegate : class {
    func textViewDidChangeSize(chatInput: LGStretchyTextView)
}

class LGStretchyTextView : UITextView, UITextViewDelegate {
    
    // MARK: Delegate
    
    weak var stretchyTextViewDelegate: LGStretchyTextViewDelegate?
    
    // MARK: Public Properties
    
    var maxHeight: CGFloat = 200
    
    // MARK: Private Properties
    
    private var maxSize: CGSize {
        get {
            return CGSize(width: CGRectGetWidth(self.bounds), height: self.maxHeight)
        }
    }
    
    private let sizingTextView = UITextView()
    
    // MARK: Property Overrides
    
    override var contentSize: CGSize {
        didSet {
            self.resizeAndAlign()
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
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    func setup() {
        self.font = UIFont.systemFontOfSize(17.0)
        self.textContainerInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        self.delegate = self
    }
    
    // MARK: Resize & Align
    
    func resizeAndAlign() {
        self.resize()
        self.align()
    }
    
    // MARK: Sizing
    
    func resize() {
        self.bounds.size.height = self.targetHeight()
        self.stretchyTextViewDelegate?.textViewDidChangeSize(self)
    }
    
    func targetHeight() -> CGFloat {
        
        /*
        There is an issue when calling `sizeThatFits` on self that results in really weird drawing issues with aligning line breaks ("\n").  For that reason, we have a textView whose job it is to size the textView. It's excess, but apparently necessary.  If there's been an update to the system and this is no longer necessary, or if you find a better solution. Please remove it and submit a pull request as I'd rather not have it.
        */
        sizingTextView.text = self.text
        let targetSize = sizingTextView.sizeThatFits(maxSize)
        var targetHeight = targetSize.height
        return targetHeight < maxHeight ? targetHeight : maxHeight
    }
    
    // MARK: Alignment
    
    func align() {
        
        let caretRect: CGRect = self.caretRectForPosition(self.selectedTextRange?.end)
        
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
}














