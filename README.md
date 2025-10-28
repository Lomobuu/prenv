# prenv

NOTES FOR THIS ENVIRONMENT:

1. Remember to add oidc auth.
2. public repo for use of environments
3. management RG (resource group) for the storage account backend should already be created and Service account must have access
4. service account must have SUBSCRIPTION CONTRIBUTOR to create new RGs for new PR

# FLOW CHART / WORKFLOW
1. Create management RG + give perms and set up auth & Secrets
2. Create all branches if not already done(main, test, dev) - note terraform may run, just cancel
3. Manually run the "bootstrap terraform backend" for the Dev branch and dev environment. This will start up the storage account & container creation for the Dev environment
4. Pull request to test branch and run the "bootstrap terraform backend" for the test branch and test env. this boostraps the tfstate-test container. you can also now run the "Terraform Deployment". REMEMBER TO CHOOSE BOTH BRANCH AND ENV!!! (this will create new RG and test environment from terraform.)
5. Pull request from test to main. now the PR is open and you can see the backend and terraform run will be triggered. Now a new PR environment is created which you can test in isolation. 
6. Lastly close the PR and the PR destroy cicd will run.


NOTE:
- Choose branch first when selecting a terraform test run, as the environment will change.

