import UIKit

final class URLTextField: UITextField {

    func addStyleTextField(_ urlTextField: UITextField) {
        
        urlTextField.leftViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let imageSearch = UIImage(systemName: "magnifyingglass")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        imageView.image = imageSearch
        urlTextField.leftView = imageView
        urlTextField.layer.masksToBounds = true
        urlTextField.layer.cornerRadius = 10
        urlTextField.layer.borderWidth = 1.0
        urlTextField.layer.borderColor = UIColor.black.cgColor
        
        urlTextField.clearButtonMode = .unlessEditing
    }
}
