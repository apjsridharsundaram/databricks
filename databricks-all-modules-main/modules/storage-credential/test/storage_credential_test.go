package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestStorageCredentialModule(t *testing.T) {
	defaults := common.GetTestDefaults()
	roleARN := defaults.RoleARN

	uniqueID := common.GenerateUniqueTestID("storage-cred")

	config := common.ModuleTestConfig{
		ModuleName:      "storage-credential",
		TestDescription: "Tests Databricks storage credential module",
		RequiredVars: map[string]interface{}{
			"name": uniqueID,
			"aws_iam_role": map[string]interface{}{
				"role_arn": roleARN,
			},
		},
		OptionalVars: map[string]interface{}{
			"comment":       "Test storage credential",
			"force_destroy": true,
		},
		ExpectedOutputs: []string{
			"id",
			"name",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestStorageCredentialModuleWithOwner(t *testing.T) {
	defaults := common.GetTestDefaults()
	roleARN := defaults.RoleARN

	uniqueID := common.GenerateUniqueTestID("storage-cred-owner")

	config := common.ModuleTestConfig{
		ModuleName:      "storage-credential",
		TestDescription: "Tests Databricks storage credential with owner",
		RequiredVars: map[string]interface{}{
			"name": uniqueID,
			"aws_iam_role": map[string]interface{}{
				"role_arn": roleARN,
			},
		},
		OptionalVars: map[string]interface{}{
			"comment":       "Storage credential with owner",
			"owner":         "account users",
			"force_destroy": true,
		},
		ExpectedOutputs: []string{
			"id",
			"name",
		},
	}

	common.TestModuleWithConfig(t, config)
}

