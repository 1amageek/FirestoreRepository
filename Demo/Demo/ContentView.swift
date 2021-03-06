//
//  ContentView.swift
//  Demo
//
//  Created by nori on 2021/02/18.
//

import SwiftUI
import Combine
import FirebaseFirestore
import FirestoreRepository


class Repository {

    var userID: String

    init(userID: String) {
        self.userID = userID
    }

    func usersPublisher() -> AnyPublisher<[User]?, Never> {
        return Firestore.firestore()
            .collection("users")
            .publisher(as: User.self)
            .assertNoFailure()
            .eraseToAnyPublisher()
    }

    func itemPublisher() -> AnyPublisher<Item?, Never> {
        return Firestore.firestore()
            .collection("users")
            .document("kk")
            .publisher(as: Item.self)
            .assertNoFailure()
            .eraseToAnyPublisher()
    }

    func a() {
        usersPublisher()
            .compactMap({ $0 })
            .flatMap { users in
                users.map { user in
                    Future<Item?, Never> { promise in
                        itemPublisher().sink { item in
                            promise(.success(item))
                        }
                    }

                }
            }

//            .flatMap({ users in
//                Publishers.MergeMany(users.map({ _ in BPublisher() }))
//            })
//            .flatMap({ _ in BPublisher() })

//        Firestore.firestore()
//            .collection("users")
//            .publisher(as: User.self)
//            .assertNoFailure()
//            .eraseToAnyPublisher()
    }
}

class Interactor: ObservableObject {

    var cancelables: [AnyCancellable] = []

    var repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }

//    @DocumentRepository<User> var reference: Reference
//
//    init(reference: Reference) {
//        self._reference = DocumentRepository(reference)
//    }
}

struct User: Codable {
    var item: Item?
}

struct Item: Codable { }

struct ContentView: View {

    @EnvironmentObject var interactor: Interactor

    @State var data: [User] = []

    @State var user: User?

    var body: some View {

        Button(action: {

//            self.interactor.repository.doc

        }, label: {
            Text("Hello, world!")
                .padding()
        })
        .onAppear {

            interactor.repository.publisher.sink { user in
                print(user)
            }.store(in: &interactor.cancelables)

//            interactor.$repository.sink { _ in
//
//            } receiveValue: { user in
//                self.user = user
//            }


//            interactor.repository.publisher.sink { _ in
//
//            } receiveValue: { user in
//                self.user = user
//            }.store(in: &self.interactor.cancelables)

//            interactor.documentRef.get(source: .default)

//            interactor.collectionRef.get(source: .cache).sink { collection in
//                self.data = collection
//            }

//            interactor.repository.usersPublisher.sink { error in
//
//            } receiveValue: { users in
            //                self.data = users ?? []
            //            }.store(in: &interactor.cancelables)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Interactor(repository: Repository(userID: "aa")))
//            .environmentObject(
//                Interactor(
//                    repository: DocumentRepository(Firestore.firestore().document("")) { $0.get() }
//                ))
    }
}
