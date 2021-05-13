import Foundation
@testable import PushNotifications

struct TestObjects {

    struct Client {

        private static let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        private static let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        static let shared = PushNotifications(instanceId: instanceId, secretKey: secretKey)
        static let emptyInstanceId = PushNotifications(instanceId: "", secretKey: secretKey)
        static let emptySecretKey = PushNotifications(instanceId: instanceId, secretKey: "")
    }

    struct Interests {

        static let emptyArray = [String]()

        static let emptyString = ""

        static let tooLong = ["""
        kjfioiowejfiofjeijifjwiejifwejiojfiowejifwjiofejifwejiejfiojioewjiofjiowefeewfinii\
        enwvinvinwkjfioiowejfiofjeijifjwiejifwejiojfiowejifwjiofejifwejiejfiojioewjiofjiow\
        efeewfiniienwvinvinw
        """]

        static let tooMany = [String](repeating: "Interest", count: 101)

        static let validArray = ["pizza",
                                 "vegan-pizza"]
    }

    struct Publish {
        static let publishRequest = [
            "apns": [
                "aps": [
                    "alert": "hi"
                ]
            ]
        ]
    }

    struct UserIDs {

        static let emptyArray = [String]()

        static let emptyString = ""

        static let tooLong = """
        askdsakdjlksajkldjkajdksjkdjkjkjdkajksjkljkajkdsjkajkdjkoiwqjijiofiowenfioneiveniow\
        nvionioeniovnioenwinvioenioniwenvioiwniveiniowenviwniwvnienoiwnvionioeniovnioenwinv\
        ioenioniwenvioiwniveiniowenviwniwvnienoiwnvionioeniovnioenwinvioenioniwenvioiwnivei\
        niowenviwniwvnienoin
        """

        static let tooMany = [String](repeating: validId, count: 1000)

        static let validArray = ["jonathan",
                                 "jordan",
                                 "luís",
                                 "luka",
                                 "mina"]

        static let validId = "aaa"
    }
}
