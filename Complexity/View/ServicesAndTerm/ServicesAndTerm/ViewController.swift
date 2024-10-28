//
//  ViewController.swift
//  ServicesAndTerm
//
//  Created by IE12 on 26/03/24.
//
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create attributed string
        let attributedString = NSMutableAttributedString(string: "By continuing you agree to terms and conditions and the privacy policy")

        // Add links to specific text ranges
        attributedString.addAttribute(.link, value: "", range: (attributedString.string as NSString).range(of: "terms and conditions"))
        attributedString.addAttribute(.link, value: "", range: (attributedString.string as NSString).range(of: "privacy policy"))

        // Set attributes for clickable text
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        // Apply clickable attributes to the entire string
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))

        // Set attributed text to label
        myLabel.attributedText = attributedString

        // Enable user interaction on label
        myLabel.isUserInteractionEnabled = true

        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        myLabel.addGestureRecognizer(tapGesture)
    }

    @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
        guard let attributedText = myLabel.attributedText else { return }

        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: attributedText)

        let tapLocation = gesture.location(in: myLabel)
        let indexOfCharacter = layoutManager.characterIndex(for: tapLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        attributedText.enumerateAttribute(.link, in: NSRange(location: 0, length: attributedText.length), options: []) { value, range, _ in
            if let url = value as? URL, NSLocationInRange(indexOfCharacter, range) {
                handleURL(url)
            }
        }
    }

    func handleURL(_ url: URL) {
        if url.scheme == "terms" {
            // Push view controller for terms
            print("Terms tapped")
        } else if url.scheme == "privacy" {
            // Push view controller for privacy policy
            print("Privacy tapped")
        }
    }
}


