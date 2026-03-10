package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestRepoModule(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("repo")

	config := common.ModuleTestConfig{
		ModuleName:      "repo",
		TestDescription: "Tests Databricks repo (Git integration) module",
		RequiredVars: map[string]interface{}{
			"url": "https://github.com/databricks/terraform-provider-databricks.git",
		},
		OptionalVars: map[string]interface{}{
			"path":   "/Repos/test/" + uniqueID,
			"branch": "main",
		},
		ExpectedOutputs: []string{
			"id",
			"path",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestRepoModuleWithTag(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("repo-tag")

	config := common.ModuleTestConfig{
		ModuleName:      "repo",
		TestDescription: "Tests Databricks repo module with tag",
		RequiredVars: map[string]interface{}{
			"url": "https://github.com/databricks/terraform-provider-databricks.git",
		},
		OptionalVars: map[string]interface{}{
			"path": "/Repos/test/" + uniqueID,
			"tag":  "v1.0.0",
		},
		ExpectedOutputs: []string{
			"id",
			"path",
		},
	}

	common.TestModuleWithConfig(t, config)
}

