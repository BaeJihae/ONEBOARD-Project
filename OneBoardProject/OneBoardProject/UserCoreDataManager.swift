//
//  UserCoreDataManager.swift
//  OneBoardProject
//
//  Created by 배지해 on 4/25/24.
//

import Foundation
import CoreData
import UIKit

struct UserCoreDataManager {
    
    // PersistentContainer에 접근
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    func setUserData(userName: String, userID: String, userPassword: String) {
        guard let context = self.persistentContainer?.viewContext else {return}
        
        let userInform = Users(context: context)
        
        userInform.userName = userName
        userInform.userID = userID
        userInform.userPassword = userPassword
        
        try? context.save()
    }
    
    func getUserData() -> [Users]? {
        guard let context = self.persistentContainer?.viewContext else { return [] }
        
        let request = Users.fetchRequest()
        let user = try? context.fetch(request)
        
        return user
    }
}
