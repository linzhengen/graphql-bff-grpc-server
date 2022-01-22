# Choose the output directory
OUTPUT ?= ./go

# Choose the target language.
LANGUAGE ?= go

# Choose grpc plugin
GRPCPLUGIN ?= $(shell go env GOPATH)/bin/protoc-gen-go-grpc
PROTOC_GEN_TS_PATH ?= ./graphql-bff/node_modules/.bin/protoc-gen-ts

# Choose the proto include directory.
PROTOINCLUDE ?= ./submodule/protobuf

# Choose protoc binary
PROTOC ?= protoc

# Compile the entire repository
#
# NOTE: if "protoc" command is not in the PATH, you need to modify this file.
#

FLAGS+= --proto_path=.:$(PROTOINCLUDE)
FLAGS+= --go_out=./grpc-server/pb --go-grpc_out=./grpc-server/pb --go-grpc_opt require_unimplemented_servers=false
FLAGS+= --js_out="import_style=commonjs,binary:./graphql-bff/src/pb"
FLAGS+= --ts_out="service=grpc-web:./graphql-bff/src/pb"
FLAGS+=	--plugin=protoc-gen-grpc=$(GRPCPLUGIN)
#FLAGS+= --plugin="protoc-gen-ts=${PROTOC_GEN_TS_PATH}"

SUFFIX:= pb.go

DEPS:= $(shell find ./protobuf  -type f -name '*.proto' | sed "s/proto$$/$(SUFFIX)/")

all: clean $(DEPS)

%.$(SUFFIX):  %.proto
	mkdir -p ./grpc-server/pb ./graphql-bff/src/pb
	$(PROTOC) $(FLAGS) $*.proto

clean:
	rm -rf ./grpc-server/pb ./graphql-bff/src/pb

evans:
	@hash evans > /dev/null 2>&1; if [ $$? -ne 0 ]; then \
		go install github.com/ktr0731/evans@latest; \
	fi
	evans --host localhost --port 8000 --reflection

init:
	git submodule --quiet update --init --recursive
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest