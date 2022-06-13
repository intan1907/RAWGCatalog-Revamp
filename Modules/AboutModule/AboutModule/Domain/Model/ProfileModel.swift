//
//  ProfileModel.swift
//  AboutModule
//
//  Created by Intan Nurjanah on 04/10/21.
//

import Foundation
import UIKit

public class ProfileModel {
    
    public var profilePicture: UIImage?
    public var fullName: String?
    public var username: String?
    public var email: String?
    public var about: String?
    
    public init(profilePicture: UIImage? = nil, fullName: String? = nil, username: String? = nil, email: String? = nil, about: String? = nil) {
        self.profilePicture = profilePicture
        self.fullName = fullName
        self.username = username
        self.email = email
        self.about = about
    }
    
}
