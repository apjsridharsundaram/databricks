package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestDirectoryModule(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("dir")

	config := common.ModuleTestConfig{
		ModuleName:      "directory",
		TestDescription: "Tests Databricks workspace directory module",
		RequiredVars: map[string]interface{}{
			"path": "/Shared/" + uniqueID,
		},
		OptionalVars: map[string]interface{}{
			"delete_recursive": true,
		},
		ExpectedOutputs: []string{
			"id",
			"path",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestDirectoryModuleWithObjectId(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("dir-obj")

	config := common.ModuleTestConfig{
		ModuleName:      "directory",
		TestDescription: "Tests Databricks directory module output object_id",
		RequiredVars: map[string]interface{}{
			"path": "/Shared/" + uniqueID,
		},
		ExpectedOutputs: []string{
			"id",
			"path",
			"object_id",
		},
	}

	common.TestModuleWithConfig(t, config)
}

