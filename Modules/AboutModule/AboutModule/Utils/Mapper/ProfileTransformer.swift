//
//  ProfileTransformer.swift
//  AboutModule
//
//  Created by Intan Nurjanah on 10/05/22.
//

import UIKit
import CoreModule

public struct ProfileTransformer: EntityMapper {
    
    public typealias Entity = ProfileEntity
    public typealias Domain = ProfileModel
    
    public init() { }
    
    public func transformDomainToEntity(domain: ProfileModel) -> ProfileEntity {
        return ProfileEntity(profilePicture: domain.profilePicture?.pngData(), fullName: domain.fullName ?? "-", username: domain.username ?? "-", email: domain.email ?? "-", about: domain.about ?? "-")
    }
    
    public func transformEntityToDomain(entity: ProfileEntity) -> ProfileModel {
        let model = ProfileModel(fullName: entity.fullName ?? "-", username: entity.username ?? "-", email: entity.email ?? "-", about: entity.about ?? "-")
        if let imgData = entity.profilePicture {
            model.profilePicture = UIImage(data: imgData)
        }
        return model
    }
    
}
