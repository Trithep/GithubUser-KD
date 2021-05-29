//
//  GithubUserTests.swift
//  GithubUserTests
//
//  Created by Trithep Thumrongluck on 26/5/2564 BE.
//

import XCTest
import Domain
import RxSwift
import SceneCore
import Platform
import Networking
import FBSnapshotTestCase
@testable import GithubUser

class UserFavoriteTests: FBSnapshotTestCase {
    
    var vc: MainViewController!
    var provider: UseCaseProviderDomain!
    var coordinator: SceneCoordinator!

    override func setUp() {
        super.setUp()
//        recordMode = true
        provider = UseCaseProvider(network: URLSessionNetwork(base: URL(string: "https://api.github.com")!, environment: .local))
        coordinator = SceneCoordinator(window: UIWindow(frame: UIScreen.main.bounds))
        let viewModel = MainViewModel(coordinator: coordinator, provider: provider)
        let scene = MainScene.main(viewModel: viewModel)
        vc = scene.viewController as? MainViewController
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testUserFoundInFavoriteList_then_checkFavorite() {
        
        FBSnapshotVerifyView(vc.view)
        
        let json = jsonDataGitHubUser(userId: 1)
        let favoriteUsers: [Int] = [1]
        
        do {
            let user = try JSONDecoder().decode(User.self, from: json)
            let result = favoriteUsers.contains(where: { $0 == user.userId })
            let sut = UserTableCellViewModel(user: user)
            let isFavoriteSelected = sut.checkFavoriteUser(favoriteUsers)
            
            XCTAssertTrue(result)
            XCTAssertTrue(isFavoriteSelected)
            XCTAssertEqual(1, user.userId)
        } catch {
            XCTFail("Cannot parse object")
        }
    }
    
    func testUserNotFoundInFavoriteList_then_unCheckFavorite() {
        
        FBSnapshotVerifyView(vc.view)
        
        let json = jsonDataGitHubUser(userId: 2)
        let favoriteUsers: [Int] = [1]
        
        do {
            let user = try JSONDecoder().decode(User.self, from: json)
            let result = favoriteUsers.contains(where: { $0 == user.userId })
            let sut = UserTableCellViewModel(user: user)
            let isFavoriteSelected = sut.checkFavoriteUser(favoriteUsers)
            
            XCTAssertFalse(result)
            XCTAssertFalse(isFavoriteSelected)
            XCTAssertNotEqual(1, user.userId)
        } catch {
            XCTFail("Cannot parse object")
        }
    }

}

private extension UserFavoriteTests {
    
    func jsonDataGitHubUser(userId: Int) -> Data {
        let json = """
          {
            "login": "mojombo",
            "id": \(userId),
            "node_id": "MDQ6VXNlcjE=",
            "avatar_url": "https://avatars.githubusercontent.com/u/1?v=4",
            "gravatar_id": "",
            "url": "https://api.github.com/users/mojombo",
            "html_url": "https://github.com/mojombo",
            "followers_url": "https://api.github.com/users/mojombo/followers",
            "following_url": "https://api.github.com/users/mojombo/following{/other_user}",
            "gists_url": "https://api.github.com/users/mojombo/gists{/gist_id}",
            "starred_url": "https://api.github.com/users/mojombo/starred{/owner}{/repo}",
            "subscriptions_url": "https://api.github.com/users/mojombo/subscriptions",
            "organizations_url": "https://api.github.com/users/mojombo/orgs",
            "repos_url": "https://api.github.com/users/mojombo/repos",
            "events_url": "https://api.github.com/users/mojombo/events{/privacy}",
            "received_events_url": "https://api.github.com/users/mojombo/received_events",
            "type": "User",
            "site_admin": false
          }
        """
        return json.data(using: .utf8)!
    }
}

