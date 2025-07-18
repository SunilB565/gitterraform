# gitterraform

Clone this Repo-

Step 1 : Run terraform init, plan, and apply only for main.tf file available in the root directory to create the s3 backend with the statefile. This is should be created only once. 

Step 2 : Make Sure to replace the Bucket Name.

Step 3 : Add VPC CIDR block and Subnet CIDR block properly. 

Step 4 : Add image 1 and Image 2 URI properly. 

Step 5 :  ADD "main" in line 6 and line 9  in https://github.com/SunilB565/gitterraform/blob/c2080f7768fc76152fbacbb4d5c3fb281faa6f3a/.github/workflows/terraform.yml#L6  this will trigger the pipeline and start
