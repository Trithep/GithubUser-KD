//
//  UserRepoTableViewCell.swift
//  GithubUser
//
import UIKit
import Kingfisher
import Reusable
import RxSwift

final class UserRepoTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet private var userName: UILabel!
    @IBOutlet private var userDescription: UILabel!
    @IBOutlet private var language: UILabel!
    @IBOutlet private var fork: UILabel!
    
    // MARK: - Properties
    private var viewModel: UserRepoTableListType!
    private let disposeBag = DisposeBag()
    var addFavoriteCallback: ((Int) -> ())?
    
    // MARK: - Configure
    func configure(_ viewModel: UserRepoTableListType) {
      self.viewModel = viewModel
      bindInputs()
      bindOutputs()
    }
    
    func bindInputs() {
        
    }
    
    func bindOutputs() {
        userName.text = viewModel.outputs.name
        userDescription.text = viewModel.outputs.description
        language.text = viewModel.outputs.language
        fork.text = viewModel.outputs.fork
    }
}
