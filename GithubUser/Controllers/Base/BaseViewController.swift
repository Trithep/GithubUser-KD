//
//  BaseViewController.swift
//  GithubUser
//
import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

class BaseViewController<ViewModel>: UIViewController, UIGestureRecognizerDelegate {

    let bag = DisposeBag()
    var viewModel: ViewModel!

    override func loadView() {
        super.loadView()
        setupView()
        bindOutput(viewModel: viewModel)
        bindInput(viewModel: viewModel)
        view.accessibilityLabel = String(describing: self.classForCoder)

    }

    func bindViewModel(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    func setupView() {

    }

    func bindInput(viewModel: ViewModel) {

    }

    func bindOutput(viewModel: ViewModel) {

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    deinit {
        print("deinit: \(String(describing: self))")
    }
}

extension UIViewController {
    @objc func showSpinner(_ title: String = "") {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            let spinnerActivity = MBProgressHUD.showAdded(to: strongSelf.view, animated: true)
            spinnerActivity.contentColor = .white
            spinnerActivity.bezelView.backgroundColor = .black
            spinnerActivity.bezelView.alpha = 0.8
            
            if !title.isEmpty {
                spinnerActivity.label.text = title
            }
        }
    }
    
    func hideSpinner() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: strongSelf.view, animated: true)
        }
    }
    
}
