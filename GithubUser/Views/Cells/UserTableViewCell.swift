//
//  UserTableViewCell.swift
//  GithubUser
//

import UIKit
import Kingfisher
import Reusable
import RxSwift

final class UserTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet private var userImage: UIImageView!
    @IBOutlet private var userName: UILabel!
    @IBOutlet private var userUrl: UILabel!
    @IBOutlet private var favoriteButton: UIButton!
    
    // MARK: - Properties
    private var viewModel: UserTableListType!
    private let disposeBag = DisposeBag()
    var addFavoriteCallback: ((Int) -> ())?
    
    // MARK: - Configure
    func configure(_ viewModel: UserTableListType) {
      self.viewModel = viewModel
      bindInputs()
      bindOutputs()
    }
    
    func bindInputs() {
        
    }
    
    func bindOutputs() {
        userName.text = viewModel.outputs.name
        userUrl.text = viewModel.outputs.url
        userImage.kf.setImage(with: viewModel.outputs.imageUrl,
                              placeholder: nil,
                              options: [.backgroundDecode]) { _ in }
    }
    
    func checkFavoriteStatus(_ list: [Int]) {
        favoriteButton.isSelected = list.contains(where: { $0 == viewModel.outputs.userId })
    }
    
    @IBAction private func addFavoriteAction(_ sender: UIButton) {
        addFavoriteCallback?(viewModel.outputs.userId)
        
    }
}
