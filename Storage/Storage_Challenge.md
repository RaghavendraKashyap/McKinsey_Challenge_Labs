## Challenge 12: Contoso Company Data Migration and Archiving

### Estimated duration: 2 Hours

### **Contoso Environment:** 

1. The Contoso environment consists of an Azure **subscription** with **contributor** permissions and a pre-provisioned resource group.

1. To access the Azure portal, open a private/incognito window in your browser and navigate to **[Azure Portal](https://portal.azure.com)**.

1. On the **Sign in to Microsoft Azure** tab you will see a login screen, enter the following email/username and then click on **Next**. 
   * Email/Username: <inject key="AzureAdUserEmail"></inject>
   
     ![](media/email1.png "Enter Email")
     
1. Now enter the following password and click on **Sign in**.
   * Password: <inject key="AzureAdUserPassword"></inject>
   
     ![](media/password2.png "Enter Password")
     
1. If you see the pop-up **Stay Signed in?**, click No.

1. If you see the pop-up **You have free Azure Advisor recommendations!**, close the window to continue the lab.

1. If a **Welcome to Microsoft Azure** popup window appears, click **Maybe Later** to skip the tour.
   
1. Now you will see Azure Portal Dashboard, click on **Resource groups** from the Navigate panel to see the resource groups.

    ![](media/select-rg.png "Resource groups")
   
1. Confirm you have a resource group **Challenge12-<inject key="DeploymentID" enableCopy="false"/>** present as shown in the below screenshot. You need to use the **Challenge12-<inject key="DeploymentID" enableCopy="false"/>** resource group throughout this challenge.

    ![](media/challenge12-rg.png "Resource groups")

### **Level:** Advanced 

### **Challenge Objective:**

#### Requirements:

Contoso Company has a large amount of data that needs to be archived to Azure Blob Storage. Contoso Company needs to migrate its data from an on-premises storage solution to Azure.

#### Challenge Tasks:

1. Create and configure a storage account with **Standard LRS** and generate shared access signature tokens.

1. Configure stored access policies, and manage access keys to enable data migration.

1. Once the data is migrated, your challenge is to configure the storage tiers and lifecycle management policies to optimize the cost of data storage which must be encrypted.

## Validation

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
 
- Hit the Validate button for the corresponding task. You will receive a success message. 
- If not, carefully read the error message and retry the step, following the instructions in the lab guide.
- If you need any assistance, please contact us at labs-support@spektrasystems.com. We are available 24/7 to help you out.

  <validation step="4fca3d08-34ae-4c97-b5c1-8c1eb12f3d0a" />
  
---
  <validation step="587c3f26-fd03-4ece-89d7-5a3cf3f2e57b" />

## Question:

<question source="Question.md" />

<br>

<question source="Question2.md" />

<br>

<question source="Question3.md" />

<br>

### Success Criteria:

1. Create an Azure Blob Storage account and generate SAS tokens to enable secure access to the storage account.

1. Configure stored access policies to control the types of operations that can be performed on the storage account.

1. Perform sample data migration using AzCopy.

1. Configure storage tiers to store the data most cost-effectively with lifecycle management policies enabled to automatically move the data to a lower-cost storage tier or delete it.

1. Configure storage encryption to secure the data stored in Azure.

### Lab Validation using Validation tab

1. After completing the challenge, you need to visit the **Lab Validation (1)** tab and click on the **VALIDATE (2)** button under Actions to perform the validation steps. Verify that you have met the success criteria of the challenge. 

    ![](media/challenge12-v1.png "Validation")

1. If the validation status displays **Success** for all the validation steps, **congratulations!** This means that you have successfully completed the challenge. 

     ![](media/challenge12-v2.png "Validation")
     
1. If the validation status displays **Fail**, **don't worry!** This could mean that you did not perform the challenge correctly.

     ![](media/challenge12-v3.png "Validation")

1. Hover your mouse over the `i` **(1)** icon to see the error message and determine the root cause of the failure. Based on the error message, revisit the challenge as necessary, and redo the validation by clicking on the **VALIDATE (3)** button again.
      
     ![](media/challenge12-v4.png "Validation") 

1. If you are still having trouble, you can reach out to the support team via `labs-support@spektrasystems.com` for further assistance. The support team is available to help you to troubleshoot and resolve any technical issues or validation issues that may arise while the lab environment is live.
