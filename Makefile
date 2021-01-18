PATH := $(CURDIR)/hack/bin:$(PATH)

generate: hack/bin/go-bindata-assetfs
generate: hack/bin/go-bindata
generate: hack/bin/goimports
generate: hack/bin/stringer
generate:
	GO111MODULE=on go generate ./...
.PHONY: generate

generate-clean:
	rm -f go-fuzz/bindata*
	grep -r -l '^// Code generated .* DO NOT EDIT\.$$' | xargs rm -f
.PHONY: generate-clean

hack/bin/%: hack/src/%/go.mod hack/src/%/pin.go
	cd $(<D) && GO111MODULE=on go build -o $(abspath $@) $$(sed -En 's,^import "(.*/$*)"$$,\1,p' pin.go)
