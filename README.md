# Demo.SpaceGame

My own spin on [Tailspin's Space game](https://github.com/MicrosoftDocs/mslearn-tailspin-spacegame-web), with the addition of CI/CD.

The Space Game website is a .NET Core app written in C# that's deployed to Azure App Services, and a SQL Server backend that's deployed to Azure SQL. 

# CI/CD

[![Build Status](https://dev.azure.com/MSFT-MarcusFelling/Demo/_apis/build/status/TailSpin.SpaceGame.Pipeline?repoName=MarcusFelling%2FDemo.SpaceGame&branchName=master)](https://dev.azure.com/MSFT-MarcusFelling/Demo/_build/latest?definitionId=77&repoName=MarcusFelling%2FDemo.SpaceGame&branchName=master)

1. The main branch is set up with a [branch protection rule](https://docs.github.com/en/github/administering-a-repository/managing-a-branch-protection-rule#:~:text=You%20can%20create%20a%20branch,merged%20into%20the%20protected%20branch.) that requires TailSpin.SpaceGame.Pipeline. This means the topic branch that is targeting main, will need to successfully make it through the entirety of the pipeline before the PR can be completed and merged into main.
2. The build stage of the pipeline ensures all projects successfully compile and unit tests pass. 
3. The pipeline will then add a comment to your PR with the URL to a new Azure Web App containing your changes, that can be used for exploratory testing or remote debugging.
3. Meanwhile, the pipeline will execute UI and load tests in a testing environment. 
4. If all tests are successful, the pipeline will wait for manual approval before deploying to production. 
5. After the production deployment is complete, a final stage will run to clean up the development environment, then the PR can be completed.

Note: If DB schema changes containing CREATE, ALTER, or DELETES are detected, a manual review will be required.

![image](https://user-images.githubusercontent.com/6855361/108082923-2c618480-7038-11eb-928c-0728610a8349.png)


