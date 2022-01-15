package user

import (
	"context"

	pb "github.com/linzhengn/graphql-bff-grpc-server/grpc-server/pb/user"
)

type server struct {
}

func (s server) Get(ctx context.Context, request *pb.GetRequest) (*pb.GetResponse, error) {
	return &pb.GetResponse{Id: request.Id, Name: "hello"}, nil
}

func NerServer() pb.UserServiceServer {
	return &server{}
}
