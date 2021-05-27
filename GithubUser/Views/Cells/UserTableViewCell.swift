//
//  UserTableViewCell.swift
//  GithubUser
//

import UIKit
import Kingfisher
import Reusable

final class UserTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet private var userImage: UIImageView!
    @IBOutlet private var userName: UILabel!
    @IBOutlet private var userUrl: UILabel!
    
    // MARK: - Properties
    private var viewModel: UserTableListType!
    
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
        userImage.kf.setImage(with: viewModel.outputs.imageUrl, placeholder: nil, options: [.backgroundDecode]) { _ in }
    }
}
