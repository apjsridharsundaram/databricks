package test

import (
	"fmt"
	"testing"

	common "github.com/cititerraform/common"
)

func TestMountModule(t *testing.T) {
	defaults := common.GetTestDefaults()
	bucketName := defaults.S3BucketName

	uniqueID := common.GenerateUniqueTestID("mount")

	config := common.ModuleTestConfig{
		ModuleName:      "mount",
		TestDescription: "Tests Databricks mount module",
		RequiredVars: map[string]interface{}{
			"name": uniqueID,
		},
		OptionalVars: map[string]interface{}{
			"uri": fmt.Sprintf("s3://%s/path/", bucketName),
		},
		ExpectedOutputs: []string{
			"id",
			"name",
			"source",
		},
		SkipDestroy: true, // Mount operations can be complex
	}

	common.TestModuleWithConfig(t, config)
}

func TestMountModuleWithInstanceProfile(t *testing.T) {
	defaults := common.GetTestDefaults()
	bucketName := defaults.S3BucketName
	instanceProfile := defaults.InstanceProfile

	uniqueID := common.GenerateUniqueTestID("mount-iam")

	config := common.ModuleTestConfig{
		ModuleName:      "mount",
		TestDescription: "Tests Databricks mount module with instance profile",
		RequiredVars: map[string]interface{}{
			"name": uniqueID,
		},
		OptionalVars: map[string]interface{}{
			"s3_config": map[string]interface{}{
				"bucket_name":      bucketName,
				"instance_profile": instanceProfile,
			},
		},
		ExpectedOutputs: []string{
			"id",
			"name",
			"source",
		},
		SkipDestroy: true,
	}

	common.TestModuleWithConfig(t, config)
}

