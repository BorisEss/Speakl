//
//  CommentsViewController.swift
//  stori
//
//  Created by Alex on 13.04.2022.
//

import UIKit
import GrowingTextView

struct Comment {
    var image: UIImage
    var name: String
    var comment: String
    var time: String
}

protocol CommentsViewControllerDelegate: AnyObject {
    func didSelectUser(id: Int)
}

class CommentsViewController: UIViewController {

    weak var delegate: CommentsViewControllerDelegate?
    
    private lazy var keyboardHandler = KeyboardApperenceHandler()
    
    private var comments: [Comment] = []
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentTextField: GrowingTextView!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var bottomSpacingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CommentTableViewCell.nib(),
                           forCellReuseIdentifier: CommentTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardHandler.subscribe(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        commentTextField.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let nextVc = segue.destination as? UserProfileViewController {
            nextVc.isTeacher = false
        }
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        let item = Comment(image: UIImage(named: "test_user") ?? UIImage(),
                           name: Storage.shared.currentUser?.username ?? "",
                           comment: commentTextField.text ?? "",
                           time: Date().getFormattedDate(format: "HH:mm"))
        comments.append(item)
        commentTextField.resignFirstResponder()
        commentTextField.text = ""
        commentView.borderColor = .speaklGreyLight
        sendView.isHidden = true
        tableView.reloadData()
    }
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noDataLabel.isHidden = !comments.isEmpty
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mainCell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier,
                                                     for: indexPath)
        if let cell = mainCell as? CommentTableViewCell {
            cell.setUp(image: comments[indexPath.row].image,
                       name: comments[indexPath.row].name,
                       comment: comments[indexPath.row].comment,
                       time: comments[indexPath.row].time)
            return cell
        }
        return mainCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showUserProfile", sender: nil)
    }
}

extension CommentsViewController: GrowingTextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        commentView.borderColor = UIColor.speaklViolet
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if #available(iOS 13.0, *) {
            commentView.borderColor = UIColor.speaklGreyLight
        } else {
            commentView.borderColor = .speaklGray
        }
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        sendView.isHidden = textView.text.isEmpty
    }
}

extension CommentsViewController: KeyboardApperenceHandlerDelegate {
    func keyboardWillAppear(keyboardHeight: CGFloat) {
        let bottomPadding = view.safeAreaInsets.bottom
        UIView.animate(withDuration: 0.3) {
            self.bottomSpacingConstraint.constant = keyboardHeight - bottomPadding
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillDisapear() {
        UIView.animate(withDuration: 0.3) {
            self.bottomSpacingConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
