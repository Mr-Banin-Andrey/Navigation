

import Foundation

struct ProfilePost {
    let author: String
    let description: String
    let photoPost: String
    let likes: Int
    let views: Int
    
    init(author: String, description: String, photoPost: String, likes: Int, views: Int) {
        self.author = author
        self.description = description
        self.photoPost = photoPost
        self.likes = likes
        self.views = views
    }
    
    init(likePostCoreDataModel: LikePostCoreDataModel) {
        self.author = likePostCoreDataModel.author ?? ""
        self.description = likePostCoreDataModel.descriptionPost ?? ""
        self.photoPost = likePostCoreDataModel.photoPost ?? ""
        self.likes = Int(likePostCoreDataModel.likes)
        self.views = Int(likePostCoreDataModel.views)
    }
}

