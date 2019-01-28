.PHONY: help build upload/s3

help:
	@awk -F ':|##' '/^[^\t].+?:.*?##/ { printf "\033[36m%-22s\033[0m %s\n", $$1, $$NF }' $(MAKEFILE_LIST)

### global
CYAN    := \033[96m
RED     := \033[95m
NC      := \033[0m

AWS_DEFAULT_REGION := ap-northeast-1
AWS_REGION         := $(AWS_DEFAULT_REGION)

export AWS_DEFAULT_REGION
export AWS_REGION

build: require_image upload/s3 ## build
	@echo "$(CYAN)running codebuild for packer...$(NC)"
	@aws codebuild start-build \
		--project-name codebuild-packer \
		--environment-variables-override name=IMAGE,value=$(notdir $(image)),type=PLAINTEXT
	@echo "$(CYAN)put this build queue in CodeBuild!!$(NC)"

upload/s3:
	@aws s3 sync images/ s3://codebuild-packer/images --delete

## required
# 要求するターゲットはここで設定
.PHONY: require_*

# pathのformat
image := $(realpath $(IMAGE))


require_image: err1 = $(shell echo "$(RED)you must set a argument IMAGE=xxxxx$(NC)")
require_image: err2 = $(shell echo "$(RED)ex: make build IMAGE=images/amazon-linux.json$(NC)")
require_image:
ifeq ($(image),)
# errorは\nが使えないので、nという改行を定義した変数を作る
define n


endef
	$(error "$n$n$(err1)$n$(err2)$n$n")
endif