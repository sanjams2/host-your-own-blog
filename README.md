# HYOB (Host Your Own Blog)

## Overview
Contains scripts/templates necessary for hosting your own blog; where hosting can be anything from owning your own hardware to leasing it from a cloud provider.

## Details 
This is inspired from https://news.ycombinator.com/item?id=19947068

## Usage
### AWS + Hugo
Run:
```bash
aws cloudformation create-stack \
	--stack-name self-hosted-blog \
	--template-body file://<(curl -s https://raw.githubusercontent.com/jsanders67/host-your-own-blog/frameworks/hugo/aws/templates/singleserver.yml) \
	--parameters \
		ParameterKey=KeyName,ParameterValue=<YOUR KEYHERE> \
		ParameterKey=RepositoryUrl,ParameterValue=<YOU BLOG GIT URL HER>.git && \
aws cloudformation wait  stack-create-complete \
	--stack-name self-hosted-blog && \
aws cloudformation describe-stacks \
	--stack-name self-hosted-blog \
	--output text \
	--query "Stacks[0].Outputs[?OutputKey=='InstanceIPAddress'].OutputValue"
```

The ip address outputted can be pasted into a browser and your blog will appear. Viola!

See:
* [Hugo](https://gohugo.io/)