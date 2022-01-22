import {UserServiceClient} from '../../pb/protobuf/user/user_pb_service';
import {GetRequest, GetResponse} from '../../pb/protobuf/user/user_pb'
import "reflect-metadata";
import {Query, Resolver} from "type-graphql";

@Resolver()
class User {
    @Query(() => String, {description: "Example thing to query"})
    async get(): Promise<GetResponse|null> {
        const client = new UserServiceClient('localhost:50051')
        return new Promise((resolve, reject) => {
            const req = new GetRequest()
            req.setId("1")
            client.get(req, (err, user) => {
                if (err) {
                    reject(err)
                }
                resolve(user)
            })
        })
    }
}

export default User