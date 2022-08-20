import UIKit
import WebKit

class ViewController: UIViewController {
    
    
    //MARK: - Constants
    
    private var browserWebView = WKWebView()
    private var previousURL:String? = nil
    private var currentURL = String()
    
    //MARK: - Outlets
    
    @IBOutlet weak var bottomScrollConstraint: NSLayoutConstraint!
    @IBOutlet weak var webScrollView: UIScrollView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var webView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var yandexButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
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
        if !yandexButton.isSelected {
            openURLlink(address: "http://yandex.ru")
            yandexButton.isSelected = true
            backButton.isHidden = false
        }
        hideKeyboard()
        searchTextField.text = nil
    }
    
    @IBAction func youtubeButtonPressed() {
        openURLlink(address: "http://youtube.com")
        hideKeyboard()
        searchTextField.text = nil
    }
    
    @IBAction func backButtonPressed() {
        if previousURL != nil {
            openURLlink(address: previousURL ?? "http://yandex.ru")
        }
        hideKeyboard()
    }
    
    //MARK: - Functions
    
    private func openWebBrowser() {
        browserWebView = WKWebView(frame: webView.frame)
        webView.addSubview(browserWebView)
    }
    
    private func openURLlink(address: String) {
        let address = address
        if searchTextField.text != nil {
            guard let url = URL(string: address) else { return }
            let request = URLRequest(url: url)
            previousURL = currentURL
            currentURL = address
            browserWebView.load(request)
        }

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
            bottomScrollConstraint.constant = keyboardScreenEndFrame.height - 20
        }
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

