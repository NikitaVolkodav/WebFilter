//
//  ViewController.swift
//  WebFilter
//
//  Created by Nikita Volkodav on 21.05.2023.
//

import UIKit
import WebKit

final class MainViewController: UIViewController {
    
    private let webView = WKWebView()
    private let toolbar = UIToolbar()
    
    private var urlTextField = URLTextField()
    
    private var backButtonItem: UIBarButtonItem!
    private var forwadButtonItem: UIBarButtonItem!
    private var bookFilterButtonItem: UIBarButtonItem!
    private var addFilterButtonItem: UIBarButtonItem!
    
    private let alertService = AlertService()
    private let filterCacheService = FilterCacheService()
    private var filtersModel = FiltersModel()
    
    private var dataReloadDelegate: DataReloadDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDelegats()
        changeColorViewAndAddTitle()
        view.addSubview(urlTextField)
        addConstraintsTextField()
        view.addSubview(webView)
        addConstraintsWebView()
        urlTextField.addStyleTextField(self.urlTextField)
        view.addSubview(toolbar)
        addStyleAndActionButtonItem()
        addToolbarItemAndChangeColor()
        addConstraintsToolBar()
        loadRequest()
    }
    
    @objc private func backAction() {
        guard webView.canGoBack else { return }
        webView.goBack()
    }
    
    @objc private func forwadAction() {
        guard webView.canGoForward else { return }
        webView.goForward()
    }
    
    @objc private func addFilter() {
        alertService.addFilterAlert(from: self, delegate: self)
    }
    
    @objc private func openFilterVC() {
        let filterVC = FilterViewController()
        navigationController?.pushViewController(filterVC, animated: true)
    }
    
    private func addDelegats() {
        webView.navigationDelegate = self
        urlTextField.delegate = self
    }
    
    private func changeColorViewAndAddTitle() {
        view.backgroundColor = .systemBackground
        title = "WebFilter"
    }
    
    private func addConstraintsTextField() {
        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            urlTextField.heightAnchor.constraint(equalToConstant: 40),
            urlTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            urlTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            urlTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func addConstraintsWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: 10),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func addConstraintsToolBar() {
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: webView.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func addToolbarItemAndChangeColor() {
        toolbar.tintColor = .black
        toolbar.backgroundColor = .systemBackground
        toolbar.items = [backButtonItem, forwadButtonItem, bookFilterButtonItem, addFilterButtonItem]
    }
    
    private func addStyleAndActionButtonItem() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButtonItem = UIBarButtonItem(customView: backButton)
        backButtonItem.customView?.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        let forwardButton = UIButton(type: .system)
        forwardButton.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        forwardButton.addTarget(self, action: #selector(forwadAction), for: .touchUpInside)
        forwardButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        forwadButtonItem = UIBarButtonItem(customView: forwardButton)
        forwadButtonItem.customView?.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        let bookFilterButton = UIButton(type: .system)
        bookFilterButton.setImage(UIImage(systemName: "book"), for: .normal)
        bookFilterButton.addTarget(self, action: #selector(openFilterVC), for: .touchUpInside)
        bookFilterButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        bookFilterButtonItem = UIBarButtonItem(customView: bookFilterButton)
        bookFilterButtonItem.customView?.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        let addFilterButton = UIButton(type: .system)
        addFilterButton.setImage(UIImage(systemName: "plus.rectangle"), for: .normal)
        addFilterButton.addTarget(self, action: #selector(addFilter), for: .touchUpInside)
        addFilterButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        addFilterButtonItem = UIBarButtonItem(customView: addFilterButton)
        addFilterButtonItem.customView?.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func loadRequest() {
        guard let url = URL(string: "https://www.google.com") else { return }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
}

extension MainViewController: FilterDelegate {
    
    func wasAddFilter(_ newFilter: String) {
        filtersModel.filters = filterCacheService.getFilters()
        filtersModel.filters.append(newFilter)
        filterCacheService.saveFilters(filtersModel.filters)
        dataReloadDelegate?.reloadData()
    }
}

extension MainViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url?.absoluteString else { return decisionHandler(.allow) }
        
        if filterCacheService.getFilters().contains(where: url.contains ) {
            alertService.showErrorAlert(from: self)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        urlTextField.text = url.absoluteString
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let urlString = textField.text, let url = URL(string: urlString) else { return true }
        let request = URLRequest(url: url)
        webView.load(request)
        
        return true
    }
}
