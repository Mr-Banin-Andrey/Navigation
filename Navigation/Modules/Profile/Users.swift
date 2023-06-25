

import Foundation

struct Users {
    let userDebug = UserReleaseOrTest(login: "Test",
                         fullName: "Голубь разработчик",
                         status: "не баг, а фича",
                         userPhoto: "admin")
    
    let userRelease = UserReleaseOrTest(login: "Larus",
                           fullName: "Турецкая чайка",
                           status: "хочу рыбки",
                           userPhoto: "чайка")
}


class ReleaseOrTest {

#if DEBUG
    let user = TestUserService(user: Users().userDebug).checkLogin(login: Users().userDebug)!
#else
    let user = CurrentUserService(user: Users().userRelease).checkLogin(login: Users().userRelease)!
#endif

}
