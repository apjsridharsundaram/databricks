package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestMWSStorageConfigurationModule(t *testing.T) {
	defaults := common.GetTestDefaults()
	accountID := defaults.AccountID
	bucketName := defaults.S3BucketName

	uniqueID := common.GenerateUniqueTestID("mws-storage")

	config := common.ModuleTestConfig{
		ModuleName:      "mws-storage-configuration",
		TestDescription: "Tests Databricks MWS storage configuration module",
		RequiredVars: map[string]interface{}{
			"account_id":                 accountID,
			"storage_configuration_name": uniqueID,
			"bucket_name":                bucketName,
		},
		ExpectedOutputs: []string{
			"id",
			"storage_configuration_id",
			"storage_configuration_name",
		},
		SkipDestroy: true, // Account-level resources
	}

	common.TestModuleWithConfig(t, config)
}

func TestMWSStorageConfigurationModuleWithKMS(t *testing.T) {
	defaults := common.GetTestDefaults()
	accountID := defaults.AccountID
	bucketName := defaults.S3BucketName

	uniqueID := common.GenerateUniqueTestID("mws-storage-kms")

	config := common.ModuleTestConfig{
		ModuleName:      "mws-storage-configuration",
		TestDescription: "Tests Databricks MWS storage configuration with KMS encryption",
		RequiredVars: map[string]interface{}{
			"account_id":                 accountID,
			"storage_configuration_name": uniqueID,
			"bucket_name":                bucketName,
		},
		ExpectedOutputs: []string{
			"id",
			"storage_configuration_id",
			"storage_configuration_name",
		},
		SkipDestroy: true,
	}

	common.TestModuleWithConfig(t, config)
}

