import {UserServiceClient} from '../../pb/protobuf/user/user_pb_service';
import { GetRequest } from '../../pb/protobuf/user/user_pb'

// todo: user class
const client = new UserServiceClient('localhost:50051')
const req = new GetRequest()
req.setId("1")
client.get(req, (err, user) => {
    // todo
})