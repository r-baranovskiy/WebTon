import UIKit
import WebKit

class ViewController: UIViewController {
    
    
    //MARK: - Constants
    
    private var browserWebView = WKWebView()
    private var previousURL = String()
    
    //MARK: - Outlets
    
    @IBOutlet weak var bottomScrollConstraint: NSLayoutConstraint!
    @IBOutlet weak var webScrollView: UIScrollView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var webView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    //MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openWebBrowser()
    }
    
    //MARK: - IBActions button
    
    @IBAction func yandexButtonPressed() {
        openURLlink(address: "http://yandex.ru")
        hideKeyboard()
        searchTextField.text = nil
    }
    
    @IBAction func youtubeButtonPressed() {
        openURLlink(address: "http://youtube.com")
        hideKeyboard()
        searchTextField.text = nil
    }
    
    @IBAction func backButtonPressed() {
        hideKeyboard()
    }
    
    //MARK: - Functions
    
    private func openWebBrowser() {
        browserWebView = WKWebView(frame: webView.frame)
        webView.addSubview(browserWebView)
    }
    
    private func openURLlink(address: String) {
        let address = address
        guard let url = URL(string: address) else { return }
        let request = URLRequest(url: url)
        
        browserWebView.load(request)
    }
    
    //MARK: - Settings keyboard
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            bottomScrollConstraint.constant = 0
        } else {
            bottomScrollConstraint.constant = keyboardScreenEndFrame.height + 10
        }
//        mainView.needsUpdateConstraints()
//        webView.needsUpdateConstraints()
//        browserWebView.needsUpdateConstraints()
        view.needsUpdateConstraints()
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: - Extensions

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
}

