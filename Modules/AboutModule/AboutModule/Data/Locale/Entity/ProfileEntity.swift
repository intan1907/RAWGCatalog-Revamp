//
//  ProfileEntity.swift
//  AboutModule
//
//  Created by Intan Nurjanah on 02/04/22.
//

import Foundation
import UIKit

public class ProfileEntity: Codable {
    
    var profilePicture: Data?
    var fullName: String?
    var username: String?
    var email: String?
    var about: String?
    
    public init(profilePicture: Data? = nil, fullName: String? = nil, username: String? = nil, email: String? = nil, about: String? = nil) {
        self.profilePicture = profilePicture
        self.fullName = fullName
        self.username = username
        self.email = email
        self.about = about
    }
    
    public static var defaultProfile: ProfileEntity {
        let pp = UIImage(named: "profile_photo_intan")?.pngData()
        return ProfileEntity(
            profilePicture: pp,
            fullName: "Intan Nurjanah",
            username: "intan3951",
            email: "intan3951@gmail.com",
            about: "Intan Nurjanah adalah iOS Developer di PT GITS Indonesia. Karirnya dimulai pada tahun 2015 setelah lulus SMK. Pada tahun 2016, ia berhenti bekerja untuk melanjutkan pendidikan di Teknik Informatika ITB. Intan Nurjanah bergabung dengan Dicoding sejak 8 Desember 2018. Pada tahun 2021, ia kembali bekerja di PT GITS Indonesia sebagai iOS Developer."
        )
    }
    
}
