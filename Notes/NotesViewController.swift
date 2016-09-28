//
//  NotesViewController.swift
//  Notes
//
//  Created by Yohannes Wijaya on 8/18/16.
//  Copyright © 2016 Yohannes Wijaya. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
  
  // MARK: - Stored Properties
  
  var note: Notes?
  
  // MARK: - IBOutlet Properties
  
  @IBOutlet weak var textView: UITextView! {
    didSet {
      if let validNote = self.note {
        self.textView.text = validNote.entry
      }
      else {
        self.textView.becomeFirstResponder()
      }
    }
  }
  
  @IBOutlet weak var saveButton: UIBarButtonItem!
  
  @IBOutlet weak var markdownDotImageView: UIImageView!

  // MARK: - IBAction Methods
  
  @IBAction func cancelButtonDidTouch(sender: UIBarButtonItem) {
    self.textView.resignFirstResponder()
    
    // Check the type of an object #1. More: http://stackoverflow.com/a/25345480/2229062
    print("a) I am of type: \(self.presentingViewController.self)")
    
    // Check the type of an object #2. More: http://stackoverflow.com/a/33001534/2229062
    if let unknown: AnyObject = self.presentingViewController {
      let reflection = Mirror(reflecting: unknown)
      print("b) I am of type: \(reflection.subjectType)")
    }
    else {
      print("c) I am of type: \(type(of:self.presentingViewController))")
    }
    
    let isPresentingFromAddButton = self.presentingViewController is UINavigationController
    if isPresentingFromAddButton {
      self.dismiss(animated: true, completion: nil)
    }
    else {
      print("d) I am of type: \(type(of: self.presentingViewController))")
      _ = self.navigationController?.popViewController(animated: true)
    }
  }
  
  @IBAction func SwipeLeftFromRightScreenEdgeGestureToShowMarkdown(_ sender: UIScreenEdgePanGestureRecognizer) {
    guard self.note != nil else { return }
    if sender.state == .ended {
      self.performSegue(withIdentifier: "showSegueToMarkdownNotesViewController", sender: self)
    }
  }
  
  @IBAction func swipeDownGestureToDismissKeyboard(_ sender: UISwipeGestureRecognizer) {
    self.textView.resignFirstResponder()
  }
  
  @IBAction func unwindToNotesViewController(_ sender: UIStoryboardSegue) {}
  
  // MARK: - UIViewController Methods
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let validBarButtonItem = sender as? UIBarButtonItem, validBarButtonItem === self.saveButton {
      let entry = self.textView.text ?? ""
      self.note = Notes(entry: entry)
    }
    else if segue.identifier == "showSegueToMarkdownNotesViewController" {
      guard let validMarkdownNotesViewController = segue.destination as? MarkdownNotesViewController, let validNote = self.note else { return }
      validMarkdownNotesViewController.note = validNote
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.markdownDotImageView.isHidden = true
    
    let swipeDotLeftGestureToShowMarkdown = UISwipeGestureRecognizer(target: self, action: #selector(NotesViewController.respondToSwipeGestureForDot))
    swipeDotLeftGestureToShowMarkdown.direction = .left
    self.markdownDotImageView.addGestureRecognizer(swipeDotLeftGestureToShowMarkdown)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    
    self.markdownDotImageView.isHidden = self.presentingViewController is UINavigationController ? true : false
  }
  
  // MARK: - Helper Methods
  
  func respondToSwipeGestureForDot() {
    self.performSegue(withIdentifier: "showSegueToMarkdownNotesViewController", sender: self)
  }
}
