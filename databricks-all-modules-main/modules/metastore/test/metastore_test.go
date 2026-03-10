package test

import (
	"fmt"
	"testing"

	common "github.com/cititerraform/common"
)

func TestMetastoreModule(t *testing.T) {
	defaults := common.GetTestDefaults()
	bucketName := defaults.S3BucketName

	uniqueID := common.GenerateUniqueTestID("metastore")

	storageRoot := fmt.Sprintf("s3://%s/", bucketName)

	config := common.ModuleTestConfig{
		ModuleName:      "metastore",
		TestDescription: "Tests Databricks Unity Catalog metastore module",
		RequiredVars: map[string]interface{}{
			"name":         uniqueID,
			"storage_root": storageRoot,
			"region":       defaults.AWSRegion,
		},
		OptionalVars: map[string]interface{}{
			"force_destroy": true,
		},
		ExpectedOutputs: []string{
			"id",
			"metastore_id",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestMetastoreModuleWithOwner(t *testing.T) {
	defaults := common.GetTestDefaults()
	bucketName := defaults.S3BucketName

	uniqueID := common.GenerateUniqueTestID("metastore-owner")

	storageRoot := fmt.Sprintf("s3://%s/", bucketName)

	config := common.ModuleTestConfig{
		ModuleName:      "metastore",
		TestDescription: "Tests Databricks metastore module with owner",
		RequiredVars: map[string]interface{}{
			"name":         uniqueID,
			"storage_root": storageRoot,
			"region":       defaults.AWSRegion,
		},
		OptionalVars: map[string]interface{}{
			"owner":         "account users",
			"force_destroy": true,
		},
		ExpectedOutputs: []string{
			"id",
			"metastore_id",
		},
	}

	common.TestModuleWithConfig(t, config)
}

