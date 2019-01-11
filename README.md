# tfe-atlas-backend
This is a guide on HOW to crete terraform project with **remote state** in Terraform.
This can be quite usefull if you have group of people in your organization. 
Follow the instructions below

## Files
- `main.tf` - terraform configuration file 


## Requirements
- Terraform installed. If you do not have Terraform installed on your computer, install it from [here](https://learn.hashicorp.com/terraform/getting-started/install.html)
- Registration to [TFE](https://app.terraform.io) (recomended is to use user, the same as github)


## Tasks to do after registration to TFE
- You need to crete [organization](https://www.terraform.io/docs/enterprise/getting-started/access.html#creating-an-organization)
- Generate [token](https://www.terraform.io/docs/enterprise/users-teams-organizations/users.html#api-tokens)

## Instructions
- Create your own github repository (in my case **tfe-atlas-backend**)
- Clone it to your computer: **git clone git@github.com:your_github_organization/name_of your_repo.git**
- Change to repo directory: **cd name_of_your_repo**
- Create new branch named `setup`: **git checkout -b setup**
```
gberchev@BerchevPC tfe-atlas-backend (master) $ git checkout -b setup
Switched to a new branch 'setup'

```
- Create **main.tf** file with following content:
```
resource "null_resource" "helloWorld" {
    provisioner "local-exec" {
        command = "echo hello world"
    }
}
```
- Run **terraform init** in order to download needed plugins
- Run **terraform apply** in order to create the new resource described in main.tf file
- Type: **git status**, and you are going to see:
```
gberchev@BerchevPC tfe-atlas-backend (setup) $ git status 
On branch setup
Untracked files:
  (use "git add <file>..." to include in what will be committed)

	.terraform/
	main.tf
	terraform.tfstate

nothing added to commit but untracked files present (use "git add" to track)
```
- Create new workspace in your organization in TFE:
  - Click on **Workspaces**
  - Click on **New Workspace**
  - Type **Name** (I typed the same as repo name)
  - For **Source** choose **None**
  - Click **Create Workspace**
  
- Create file that ends on **.env** (name does not matters. In my case **georgiman.env**) with following content (replace the value of ATLAS_TOKEN with the token generated in **Tasks to do after registration to TFE** section):
```
export ATLAS_TOKEN=xxxxxxxx.atlasv1.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```
- Type **source your_file.env**
- Edit **main.tf** as follows:
```
terraform {
  backend "atlas" {
    name    = "your_organization/name_of_your_repo"
  }
}

resource "null_resource" "helloWorld" {
  provisioner "local-exec" {
    command = "echo hello world"
  }
}
```
- Type **terraform init** and when prompted for answer, type **yes** in order to copy the state to your workspace.

- Create empty file named **.gitignore** and add to it the following:
```
.terraform/
your_file.env
terraform.tfstate
terraform.tfstate.backup
```
- Now directory **.terraform/, terraform.tfstate, terraform.tfstate.backup and your_file.env** file will excluded from the repo. This is a good practice, these files contains a sensitive information
- Type **git status** and if everything is OK, you will see:
```
gberchev@BerchevPC tfe-atlas-backend (setup) $ git status 
On branch setup
Untracked files:
  (use "git add <file>..." to include in what will be committed)

	.gitignore
	main.tf

nothing added to commit but untracked files present (use "git add" to track)

```
- Now you can use **git add .** and **git commit -m "add files"** to add these files to your local repo:
```
gberchev@BerchevPC terraform-local-backend (setup) $ git commit -m "add  files"
[setup 23a0c39] add  files
 2 files changed, 8 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 main.tf
```
- Type: **git push origin setup** in order to upload changes to your github repo.
```
gberchev@BerchevPC terraform-local-backend (setup) $ git push origin setup 
Counting objects: 4, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (4/4), 460 bytes | 460.00 KiB/s, done.
Total 4 (delta 0), reused 0 (delta 0)
remote: 
remote: Create a pull request for 'setup' on GitHub by visiting:
remote:      https://github.com/berchev/terraform-local-backend/pull/new/setup
remote: 
To github.com:berchev/terraform-local-backend.git
 * [new branch]      setup -> setup
```
- Now go to github site and click on the green button **compare & pull request**
- Click on **Create pull request**
- Click on **Merge pull request**
- Click on **Confirm merge**

You are ready! Now your repo should look like more or less like mine.