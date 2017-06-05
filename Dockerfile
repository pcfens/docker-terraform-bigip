FROM golang:1.8.3-alpine as build

ADD https://releases.hashicorp.com/terraform/0.9.6/terraform_0.9.6_linux_amd64.zip /tmp/terraform.zip

RUN apk add --no-cache git unzip \
    && go get -d github.com/DealerDotCom/terraform-provider-bigip/ \
    && cd /go/src/github.com/DealerDotCom/terraform-provider-bigip/ \
    && rm -rf vendor/github.com/hashicorp/terraform \
    && go get -d github.com/hashicorp/terraform \
    && go build \
    && unzip /tmp/terraform.zip -d /usr/local/bin/ \
    && cp terraform-provider-bigip /usr/local/bin/.

FROM alpine:3.6

COPY --from=build /usr/local/bin/terraform /usr/local/bin/.
COPY --from=build /usr/local/bin/terraform-provider-bigip /usr/local/bin/.
COPY example.tf /usr/local/share/terraform/example.tf
